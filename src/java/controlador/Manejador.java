package controlador;

import entidades.Publicaciones;
import entidades.Users;
import jakarta.ejb.EJB;
import jakarta.mail.internet.ParseException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import sessions.PublicacionesFacade;
import sessions.UsersFacade;
import jakarta.servlet.annotation.MultipartConfig;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.time.format.DateTimeParseException;
import java.util.Date;

@WebServlet(name = "Manejador",
        loadOnStartup = 1,
        urlPatterns = {
            "/CrearPublicacion",
            "/ListarPublicaciones",
            "/AgregarUsuario",
            "/ListarUsuarios",
            "/index", // Ruta para la página principal
            "/buscar",
            "/Login", // Agrega la ruta para login
            "/Register", // Agrega la ruta para registro
            "/Dashboard", // Ruta para el panel de control
            "/AdminPanel", // Nuevo: Panel de administrador para ver publicaciones
            "/AdminListarUsuarios", // Nuevo: Ver listado de usuarios
            "/AceptarCuentas",
            "/Logout",
            "/edit",
            "/deletePublicacion",
            "/showPublicacion"

        }
)
@MultipartConfig
public class Manejador extends HttpServlet {

    @EJB
    private PublicacionesFacade publicacionesF;
    @EJB
    private UsersFacade usersF;

    @Override
    public void init() throws ServletException {
        // Inicializa datos necesarios
        getServletContext().setAttribute("publicaciones", publicacionesF.findAll());
        getServletContext().setAttribute("usuarios", usersF.findAll());
    }

    @PersistenceContext
    private EntityManager em; // Inyecta el EntityManager aquí

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, jakarta.transaction.NotSupportedException, jakarta.transaction.RollbackException {
        String pathUsuario = request.getServletPath();
        String url = null;

        try {
            switch (pathUsuario) {

                case "/index":
                    List<Publicaciones> listadoPublicaciones = publicacionesF.findAll();
                    request.setAttribute("publicaciones", listadoPublicaciones);

                    url = "/index.jsp"; // Ajustar ruta si es necesario
                    break;

                case "/Logout":
                    HttpSession session = request.getSession(false); // Obtener la sesión actual, si existe
                    if (session != null) {
                        session.invalidate(); // Invalidar la sesión
                    }
                    request.getRequestDispatcher("/vista/layouts/welcome.jsp").forward(request, response);
                    break;

                case "/edit":
    session = request.getSession();
    Users usuario = (Users) session.getAttribute("usuario"); // Obtener el usuario completo de sesión
    Long userId = usuario.getId(); // Extraer solo el ID
    List<Publicaciones> publicaciones = publicacionesF.obtenerPublicacionesPorUsuario(userId);
    request.setAttribute("publicaciones", publicaciones);
    request.setAttribute("usuarioId", userId); // Pasar usuarioId para el JSP
    request.getRequestDispatcher("edit.jsp").forward(request, response);
    break;

                // Mostrar una publicación específica para editar
                case "/showPublicacion":
                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        Long id = Long.parseLong(request.getParameter("id"));
                        Publicaciones publicacion = publicacionesF.obtenerPublicacionPorId(id);

                        // Obtener nuevos valores de la solicitud
                        String titulo = request.getParameter("titulo");
                        String contenido = request.getParameter("contenido");
                        String imagen = publicacion.getImagen(); // Mantener la imagen actual en caso de no cargar una nueva

                        try {
                            // Manejo de carga de imagen
                            Part imagenPart = request.getPart("imagen");
                            if (imagenPart != null && imagenPart.getSize() > 0) {
                                String nombreImagen = Paths.get(imagenPart.getSubmittedFileName()).getFileName().toString();

                                // Definir el directorio de carga de imagen
                                String rutaBase = "C:/uploads"; // Puedes definir una ruta fija
                                File uploads = new File(rutaBase);

                                // Crear el directorio si no existe
                                if (!uploads.exists()) {
                                    uploads.mkdirs();
                                }

                                // Guardar la imagen en la carpeta de carga manualmente
                                File file = new File(uploads, nombreImagen);
                                try (InputStream input = imagenPart.getInputStream(); FileOutputStream output = new FileOutputStream(file)) {
                                    byte[] buffer = new byte[1024];
                                    int bytesRead;
                                    while ((bytesRead = input.read(buffer)) != -1) {
                                        output.write(buffer, 0, bytesRead);
                                    }
                                }
                                imagen = nombreImagen; // Usar la nueva imagen cargada
                            }

                            // Actualizar la publicación
                            publicacion.setTitulo(titulo);
                            publicacion.setContenido(contenido);
                            publicacion.setImagen(imagen); // Actualizar la imagen (o mantener la anterior si no se cargó una nueva)
                            publicacion.setUpdatedAt(new Date());

                            publicacionesF.edit(publicacion); // Método que deberías implementar en el facade para actualizar la publicación

                            // Redirigir a la misma página de visualización de la publicación actualizada
                            response.sendRedirect(request.getContextPath() + "/showPublicacion?id=" + publicacion.getId());
                            return;

                        } catch (Exception e) {
                            e.printStackTrace();
                            request.setAttribute("error", "Hubo un problema al actualizar la publicación. " + e.getMessage());
                            request.getRequestDispatcher("/vista/publicaciones/show.jsp").forward(request, response);
                        }
                    } else {
                        Long id = Long.parseLong(request.getParameter("id"));
                        Publicaciones publicacion = publicacionesF.obtenerPublicacionPorId(id);
                        request.setAttribute("publicacion", publicacion);
                        request.getRequestDispatcher("/vista/publicaciones/show.jsp").forward(request, response);
                    }
                    break;

                case "/deletePublicacion":
                    Long idEliminar = Long.parseLong(request.getParameter("id"));
                    publicacionesF.eliminarPublicacion(idEliminar);
                    session = request.getSession();
                    session.setAttribute("success", "Publicación eliminada con éxito.");

                    // Recargar la lista de publicaciones después de eliminar
                    List<Publicaciones> publicacionesActualizadas = publicacionesF.obtenerTodasLasPublicaciones();
                    session.setAttribute("publicaciones", publicacionesActualizadas);

                // Redireccionar a edit.jsp (no es necesario ya que estás usando fetch para eliminar)
                // response.sendRedirect(request.getContextPath() + "/vista/publicaciones/edit.jsp");
                // return;
                case "/buscar":
                    String termino = request.getParameter("nombre");
                    if (termino != null && !termino.trim().isEmpty()) {
                        List<Publicaciones> resultadosBusqueda = publicacionesF.buscarPublicaciones(termino);
                        request.setAttribute("ultimasPublicaciones", resultadosBusqueda);
                    } else {
                        List<Publicaciones> ultimasPublicacionesDefault = publicacionesF.findAll(); // Cargar todas si no hay término
                        request.setAttribute("ultimasPublicaciones", ultimasPublicacionesDefault);
                    }
                    url = "/vista/publicaciones/index.jsp";
                    break;

                case "/CrearPublicacion":
                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        Long usuarioId = (Long) request.getSession().getAttribute("usuarioId");
                        System.out.println("Usuario ID: " + usuarioId); // Log del ID de usuario

                        if (usuarioId == null) {
                            request.setAttribute("error", "Debes estar autenticado para crear una publicación.");
                            String ruta = "/vista/publicaciones/create.jsp";
                            request.getRequestDispatcher(ruta).forward(request, response);
                            return;
                        }

                        String titulo = request.getParameter("titulo");
                        String contenido = request.getParameter("contenido");
                        String imagen = ""; // Inicializamos como vacío
                        System.out.println("Título: " + titulo); // Log del título
                        System.out.println("Contenido: " + contenido); // Log del contenido

                        try {
                            // Manejo de carga de imagen
                            Part imagenPart = request.getPart("imagen");
                            if (imagenPart != null && imagenPart.getSize() > 0) {
                                String nombreImagen = Paths.get(imagenPart.getSubmittedFileName()).getFileName().toString();
                                System.out.println("Nombre de la imagen: " + nombreImagen); // Log del nombre de la imagen

                                // Definir el directorio de carga de imagen
                                String rutaBase = "C:/uploads"; // Puedes definir una ruta fija
                                File uploads = new File(rutaBase);
                                System.out.println("Ruta de carga definida: " + uploads.getAbsolutePath()); // Log de la ruta de carga

                                // Crear el directorio si no existe
                                if (!uploads.exists()) {
                                    boolean dirCreated = uploads.mkdirs();
                                    System.out.println("¿Directorio creado? " + dirCreated); // Log de creación del directorio
                                }

                                // Guardar la imagen en la carpeta de carga manualmente
                                File file = new File(uploads, nombreImagen);
                                System.out.println("Ruta completa para guardar la imagen: " + file.getAbsolutePath()); // Log de la ruta completa

                                try (InputStream input = imagenPart.getInputStream(); FileOutputStream output = new FileOutputStream(file)) {
                                    byte[] buffer = new byte[1024];
                                    int bytesRead;
                                    while ((bytesRead = input.read(buffer)) != -1) {
                                        output.write(buffer, 0, bytesRead);
                                    }
                                }
                                imagen = nombreImagen;
                                System.out.println("Imagen guardada: " + imagen); // Log de la imagen guardada
                            } else {
                                System.out.println("No se ha recibido ninguna imagen o el tamaño es 0."); // Log si no hay imagen
                            }

                            // Crear la publicación y almacenar la ruta de la imagen
                            Publicaciones nuevaPublicacion = new Publicaciones();
                            nuevaPublicacion.setTitulo(titulo);
                            nuevaPublicacion.setContenido(contenido);
                            nuevaPublicacion.setImagen(imagen); // Usar el nombre de la imagen o cadena vacía
                            nuevaPublicacion.setCreatedAt(new Date());
                            nuevaPublicacion.setUpdatedAt(new Date());

                            usuario = usersF.find(usuarioId);
                            nuevaPublicacion.setUserId(usuario);

                            publicacionesF.create(nuevaPublicacion);
                            System.out.println("Publicación creada con éxito."); // Log de éxito

                            // Redirigir al dashboard
                            url = request.getContextPath() + "/vista/layouts/dashboard.jsp";
                            response.sendRedirect(url);
                            return;

                        } catch (jakarta.validation.ConstraintViolationException e) {
                            e.printStackTrace(); // Log de excepción de validación
                            request.setAttribute("error", "Hubo un problema al guardar la publicación. Revise los datos ingresados.");
                            url = "/vista/publicaciones/create.jsp";
                            request.getRequestDispatcher(url).forward(request, response);

                        } catch (Exception e) {
                            e.printStackTrace(); // Log de cualquier otra excepción
                            request.setAttribute("error", "Hubo un problema al guardar la publicación. " + e.getMessage());
                            url = "/vista/publicaciones/create.jsp";
                            request.getRequestDispatcher(url).forward(request, response);
                        }
                    }
                    break;

                case "/ListarPublicaciones":
                    List<Publicaciones> publicacionesList = publicacionesF.findAll();
                    request.setAttribute("publicaciones", publicacionesList);
                    url = "/vista/publicaciones/listarPublicaciones.jsp"; // Ajustar ruta si es necesario
                    break;

                case "/ListarUsuarios":
                    List<Users> listaUsuarios = usersF.findAll();
                    request.setAttribute("usuarios", listaUsuarios);
                    url = "/vista/auth/listarUsuarios.jsp"; // Ajustar ruta si es necesario
                    break;

                case "/Login":
                    String emailLogin = request.getParameter("email");
                    String passwordLogin = request.getParameter("password");

                    // Validar que el correo y la contraseña no estén vacíos
                    if (emailLogin != null && !emailLogin.isEmpty() && passwordLogin != null && !passwordLogin.isEmpty()) {
                        // Intentar encontrar el usuario en la base de datos
                        Users usuarioLogin = usersF.findByEmail(emailLogin);

                        // Validar que el usuario existe y la contraseña coincide
                        if (usuarioLogin != null && usuarioLogin.getPassword().equals(passwordLogin)) {
                            // Guardar el nombre y el email en la sesión
                            request.getSession().setAttribute("nombre", usuarioLogin.getNombre()); // Almacena el nombre
                            request.getSession().setAttribute("email", usuarioLogin.getEmail());
                            request.getSession().setAttribute("usuarioId", usuarioLogin.getId());
                            request.getSession().setAttribute("es_administrador", usuarioLogin.getEsAdministrador());
                            request.getSession().setAttribute("bloqueado", usuarioLogin.getBloqueado());
                            request.getSession().setAttribute("es_publicador", usuarioLogin.getEsPublicador());

                            url = "/vista/layouts/dashboard.jsp"; // Redirige al dashboard
                        } else {
                            request.setAttribute("error", "Credenciales incorrectas.");
                            url = "/vista/auth/login.jsp"; // Vuelve a cargar el formulario de inicio de sesión
                        }
                    } else {
                        request.setAttribute("error", "Por favor, completa todos los campos.");
                        url = "/vista/auth/login.jsp"; // Vuelve a cargar el formulario de inicio de sesión
                    }
                    break;

                case "/Register":
                    // Obtener los parámetros del formulario
                    String nombre = request.getParameter("nombre");
                    String documentoStr = request.getParameter("documento"); // Captura el String
                    String ubicacion = request.getParameter("ubicacion");
                    String numero_W = request.getParameter("numero_W");
                    String emailForm = request.getParameter("email");
                    String password = request.getParameter("password");
                    String password_confirmation = request.getParameter("password_confirmation");

                    // Validar que las contraseñas coincidan
                    if (!password.equals(password_confirmation)) {
                        request.setAttribute("error", "Las contraseñas no coinciden.");
                        url = "/vista/auth/register.jsp"; // Volver a cargar la página con el error
                        break;
                    }

                    // Convertir documento de String a int
                    int documento;
                    try {
                        documento = Integer.parseInt(documentoStr); // Intenta convertir el String a int
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "El documento debe ser un número válido.");
                        url = "/vista/auth/register.jsp"; // Volver a cargar la página con el error
                        break;
                    }

                    // Crear un nuevo usuario
                    Users nuevoUsuario = new Users();
                    nuevoUsuario.setNombre(nombre);
                    nuevoUsuario.setDocumento(documento); // Ahora es un int
                    nuevoUsuario.setUbicacion(ubicacion);
                    nuevoUsuario.setNumeroW(numero_W);
                    nuevoUsuario.setEmail(emailForm);
                    nuevoUsuario.setPassword(password);
                    nuevoUsuario.setBloqueado(true); // El usuario está bloqueado por defecto
                    nuevoUsuario.setEsPublicador(false); // No es publicador por defecto

                    // Validar y persistir el usuario usando el facade
                    try {
                        usersF.create(nuevoUsuario); // Método en UsersFacade para crear el usuario

                        // Iniciar sesión después del registro
                        request.getSession().setAttribute("usuario", nuevoUsuario); // Guarda el usuario en la sesión

                        // Redirigir a la página de login
                        url = "/vista/auth/login.jsp";

                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error", "Hubo un problema al registrar el usuario.");
                        url = "/vista/auth/register.jsp"; // Asegúrate de que rediriges a la página correcta en caso de error
                    }
                    break;

                case "/Dashboard":
                    url = "/vista/layouts/dashboard.jsp"; // Ruta para el panel de control
                    break;

                default:
                    url = "/vista/error.jsp"; // Página de error si no se encuentra la ruta
                    break;

                case "/AdminPanel":
                    Long usuarioIdAdmin = (Long) request.getSession().getAttribute("usuarioId");
                    Users usuarioAdmin = em.find(Users.class, usuarioIdAdmin);

                    if (usuarioAdmin != null && usuarioAdmin.getEsAdministrador()) {
                        List<Publicaciones> todasPublicaciones = publicacionesF.findAll();
                        request.setAttribute("publicaciones", todasPublicaciones);
                        url = "/vista/adminLayouts/admin_dashboard.jsp";
                    } else {
                        request.setAttribute("error", "No tiene permisos de administrador.");
                        url = "/vista/error.jsp";
                    }
                    break;

                case "/AdminListarUsuarios":
                    request.setAttribute("usuario", usersF.findAll());
                    url = "/vista/adminLayouts/admin_usuarios.jsp";
                    break;

                case "/AceptarCuentas":
                    Long usuarioIdAdmin3 = (Long) request.getSession().getAttribute("usuarioId");
                    Users usuarioAdmin3 = em.find(Users.class, usuarioIdAdmin3);

                    if (usuarioAdmin3 != null && usuarioAdmin3.getEsAdministrador()) {
                        String usuarioIdStr = request.getParameter("usuarioId");
                        System.out.println("ID de usuario a aceptar: " + usuarioIdStr); // Mensaje de depuración

                        try {
                            Long usuarioId2 = Long.parseLong(usuarioIdStr);
                            Users usuario2 = em.find(Users.class, usuarioId2);
                            if (usuario2 != null) {
                                usuario2.setBloqueado(false); // Desbloquear el usuario
                                usuario2.setEsPublicador(true); // Hacerlo publicador
                                usersF.edit(usuario2); // Guardar cambios
                                response.setStatus(HttpServletResponse.SC_OK); // Código 200
                                response.getWriter().write("Usuario aceptado exitosamente."); // Respuesta al AJAX
                            } else {
                                response.setStatus(HttpServletResponse.SC_NOT_FOUND); // Código 404
                                response.getWriter().write("Usuario no encontrado.");
                            }
                        } catch (NumberFormatException e) {
                            System.out.println("Error al parsear el ID de usuario: " + e.getMessage());
                            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Código 400
                            response.getWriter().write("ID de usuario inválido.");
                        }
                    } else {
                        System.out.println("El usuario no es administrador o no está autenticado.");
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN); // Código 403 si no es admin
                        response.getWriter().write("No tiene permisos de administrador.");
                    }
                    break;
            }

            request.getRequestDispatcher(url)
                    .forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(Manejador.class
                    .getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Se ha producido un error al procesar la solicitud.");
            request.getRequestDispatcher("/vista/error.jsp").forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);

        } catch (jakarta.transaction.NotSupportedException | jakarta.transaction.RollbackException ex) {
            Logger.getLogger(Manejador.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);

        } catch (jakarta.transaction.NotSupportedException | jakarta.transaction.RollbackException ex) {
            Logger.getLogger(Manejador.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
