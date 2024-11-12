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
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.time.format.DateTimeParseException;
import java.util.Collections;
import java.util.Date;

@WebServlet(name = "Manejador",
        loadOnStartup = 1,
        urlPatterns = {
            "/CrearPublicacion",
            "/buscar",
            "/Login",
            "/Register",
            "/AceptarCuentas",
            "/Logout",
            "/deletePublicacion",
            "/showPublicacion",
            "/resetPassword",
            "/adminDashboard",
            "/eliminarPublicacion",
            "/eliminarUsuario",
            "/adminUsers",
            "/editarPubliAdmin"
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
        getServletContext().setAttribute("publicaciones", publicacionesF.findAll());
        getServletContext().setAttribute("usuarios", usersF.findAll());
    }

    @PersistenceContext
    private EntityManager em;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, jakarta.transaction.NotSupportedException, jakarta.transaction.RollbackException {
        String pathUsuario = request.getServletPath();
        String url = null;

        try {
            switch (pathUsuario) {

                case "/resetPassword":
                    Long userId = (Long) request.getSession().getAttribute("usuarioId");
                    String currentPassword = request.getParameter("current_password");
                    String newPassword = request.getParameter("new_password");
                    String confirmPassword = request.getParameter("confirm_password");

                    Users user = usersF.find(userId);

                    if (user == null) {
                        request.getSession().setAttribute("error", "Usuario no encontrado.");
                    } else if (!user.getPassword().equals(currentPassword)) {
                        request.getSession().setAttribute("error", "La contraseña actual no es correcta.");
                    } else if (!newPassword.equals(confirmPassword)) {
                        request.getSession().setAttribute("error", "Las contraseñas no coinciden.");
                    } else {
                        if (usersF.cambiarContrasena(userId, newPassword)) {
                            request.getSession().setAttribute("message", "Contraseña actualizada correctamente.");
                        } else {
                            request.getSession().setAttribute("error", "Error al cambiar la contraseña.");
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/vista/layouts/profile.jsp");
                    return;

                case "/Logout":
                    HttpSession session = request.getSession(false);
                    if (session != null) {
                        session.invalidate();
                    }
                    request.getRequestDispatcher("/vista/layouts/welcome.jsp").forward(request, response);
                    break;

                case "/adminDashboard":
                    List<Publicaciones> todasPublicaciones = publicacionesF.obtenerTodasLasPublicaciones();
                    request.setAttribute("publicaciones", todasPublicaciones);
                    request.getRequestDispatcher("/vista/adminLayouts/admin_dashboard.jsp").forward(request, response);
                    break;

                case "/eliminarPublicacion":
                    try {
                        Long publicacionId = Long.parseLong(request.getParameter("id"));
                        publicacionesF.eliminarPublicacion(publicacionId);

                        // Recargar las publicaciones después de eliminar
                        List<Publicaciones> publicacionesActualizadas = publicacionesF.obtenerTodasLasPublicaciones();
                        request.setAttribute("publicaciones", publicacionesActualizadas);
                        request.setAttribute("mensaje", "Publicación eliminada exitosamente.");
                        request.getRequestDispatcher("/vista/adminLayouts/admin_dashboard.jsp").forward(request, response);
                    } catch (Exception e) {
                        // Si hay un error, mostrar un mensaje de error
                        request.setAttribute("error", "Hubo un problema al eliminar la publicación.");
                        request.getRequestDispatcher("/vista/adminLayouts/admin_dashboard.jsp").forward(request, response);
                    }
                    break;

                case "/adminUsers":
                    List<Users> todosU = usersF.obtenerTodasLosUsers();
                    request.setAttribute("usuarios", todosU);
                    request.getRequestDispatcher("/vista/adminLayouts/admin_usuarios.jsp").forward(request, response);
                    break;

                case "/eliminarUsuario":
                    try {
                        Long usuarioId = Long.parseLong(request.getParameter("id"));
                        usersF.eliminarUsuario(usuarioId);

                        // Actualizar la lista de usuarios después de eliminar
                        List<Users> usuariosActualizados = usersF.obtenerTodasLosUsers();

                        // Actualizar la sesión con la lista de usuarios
                        request.getSession().setAttribute("usuarios", usuariosActualizados);
                        request.setAttribute("mensaje", "Usuario eliminado exitosamente.");
                        request.getRequestDispatcher("/vista/adminLayouts/admin_usuarios.jsp").forward(request, response);
                    } catch (Exception e) {
                        request.setAttribute("error", "Hubo un problema al eliminar el usuario.");
                        request.getRequestDispatcher("/vista/adminLayouts/admin_usuarios.jsp").forward(request, response);
                    }
                    break;

                case "/showPublicacion":
                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        Long id = Long.parseLong(request.getParameter("id"));
                        Publicaciones publicacion = publicacionesF.obtenerPublicacionPorId(id);

                        String titulo = request.getParameter("titulo");
                        String contenido = request.getParameter("contenido");
                        String imagen = publicacion.getImagen();

                        try {
                            Part imagenPart = request.getPart("imagen");
                            if (imagenPart != null && imagenPart.getSize() > 0) {
                                String nombreImagen = Paths.get(imagenPart.getSubmittedFileName()).getFileName().toString();

                                String rutaBase = "C:/uploads";
                                File uploads = new File(rutaBase);

                                if (!uploads.exists()) {
                                    uploads.mkdirs();
                                }
                                File file = new File(uploads, nombreImagen);
                                try (InputStream input = imagenPart.getInputStream(); FileOutputStream output = new FileOutputStream(file)) {
                                    byte[] buffer = new byte[1024];
                                    int bytesRead;
                                    while ((bytesRead = input.read(buffer)) != -1) {
                                        output.write(buffer, 0, bytesRead);
                                    }
                                }
                                imagen = nombreImagen;
                            }

                            publicacion.setTitulo(titulo);
                            publicacion.setContenido(contenido);
                            publicacion.setImagen(imagen);
                            publicacion.setUpdatedAt(new Date());

                            publicacionesF.edit(publicacion);

                            // Actualiza la lista de publicaciones en la sesión después de editar la publicación
                            Users usuarioLogin = (Users) request.getSession().getAttribute("user");
                            List<Publicaciones> publicacionesActualizadas = publicacionesF.obtenerPublicacionesPorUsuario(usuarioLogin.getId());
                            request.getSession().setAttribute("publicaciones", publicacionesActualizadas);
                            
                            response.sendRedirect(request.getContextPath() + "/vista/publicaciones/edit.jsp");
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

                    List<Publicaciones> publicacionesActualizadas = publicacionesF.obtenerTodasLasPublicaciones();
                    session.setAttribute("publicaciones", publicacionesActualizadas);

                case "/buscar":
                    String termino = request.getParameter("titulo");
                    List<Publicaciones> resultadosBusqueda;

                    if (termino != null && !termino.trim().isEmpty()) {
                        resultadosBusqueda = publicacionesF.buscarPublicaciones(termino);
                    } else {
                        resultadosBusqueda = publicacionesF.findAll();
                    }

                    request.setAttribute("publicaciones", resultadosBusqueda);
                    request.setAttribute("termino", termino);
                    url = "/vista/layouts/welcome.jsp";
                    break;

                case "/CrearPublicacion":
                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        Long usuarioId = (Long) request.getSession().getAttribute("usuarioId");

                        if (usuarioId == null) {
                            request.setAttribute("error", "Debes estar autenticado para crear una publicación.");
                            String ruta = "/vista/publicaciones/create.jsp";
                            request.getRequestDispatcher(ruta).forward(request, response);
                            return;
                        }

                        String titulo = request.getParameter("titulo");
                        String contenido = request.getParameter("contenido");
                        String imagen = "";

                        try {
                            Part imagenPart = request.getPart("imagen");
                            if (imagenPart != null && imagenPart.getSize() > 0) {
                                String nombreImagen = Paths.get(imagenPart.getSubmittedFileName()).getFileName().toString();

                                String rutaBase = "C:/uploads";
                                File uploads = new File(rutaBase);

                                if (!uploads.exists()) {
                                    boolean dirCreated = uploads.mkdirs();
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
                                imagen = nombreImagen;
                            }

                            Publicaciones nuevaPublicacion = new Publicaciones();
                            nuevaPublicacion.setTitulo(titulo);
                            nuevaPublicacion.setContenido(contenido);
                            nuevaPublicacion.setImagen(imagen);
                            nuevaPublicacion.setCreatedAt(new Date());
                            nuevaPublicacion.setUpdatedAt(new Date());

                            Users usuario = usersF.find(usuarioId);
                            nuevaPublicacion.setUserId(usuario);
                            publicacionesF.create(nuevaPublicacion);

                            // Obtener todas las publicaciones del usuario desde la base de datos
                            List<Publicaciones> publicacionesUsuario = publicacionesF.obtenerPublicacionesPorUsuario(usuarioId);
                            request.getSession().setAttribute("publicaciones", publicacionesUsuario);

                            url = request.getContextPath() + "/vista/publicaciones/edit.jsp";
                            response.sendRedirect(url);
                            return;

                        } catch (jakarta.validation.ConstraintViolationException e) {
                            e.printStackTrace();
                            request.setAttribute("error", "Hubo un problema al guardar la publicación. Revise los datos ingresados.");
                            url = "/vista/publicaciones/create.jsp";
                            request.getRequestDispatcher(url).forward(request, response);
                        }
                    }
                    break;

                case "/Login":
                    String emailLogin = request.getParameter("email");
                    String passwordLogin = request.getParameter("password");

                    // Validar que el correo y la contraseña no estén vacíos
                    if (emailLogin != null && !emailLogin.isEmpty() && passwordLogin != null && !passwordLogin.isEmpty()) {
                        Users usuarioLogin = usersF.findByEmail(emailLogin);

                        if (usuarioLogin != null && usuarioLogin.getPassword().equals(passwordLogin)) {
                            request.getSession().setAttribute("nombre", usuarioLogin.getNombre());
                            request.getSession().setAttribute("email", usuarioLogin.getEmail());
                            request.getSession().setAttribute("usuarioId", usuarioLogin.getId());
                            request.getSession().setAttribute("es_administrador", usuarioLogin.getEsAdministrador());
                            request.getSession().setAttribute("bloqueado", usuarioLogin.getBloqueado());
                            request.getSession().setAttribute("es_publicador", usuarioLogin.getEsPublicador());
                            request.getSession().setAttribute("user", usuarioLogin);

                            // Cargar publicaciones según el tipo de usuario
                            if (usuarioLogin.getEsAdministrador()) {
                                List<Publicaciones> publicacionesAdmin = publicacionesF.obtenerTodasLasPublicaciones();
                                request.getSession().setAttribute("publicaciones", publicacionesAdmin);
                            }
                            List<Publicaciones> publicacionesUsuario = publicacionesF.obtenerPublicacionesPorUsuario(usuarioLogin.getId());
                            request.getSession().setAttribute("publicacionesUsuario", publicacionesUsuario);

                            url = "/vista/layouts/dashboard.jsp";
                        } else {
                            request.setAttribute("error", "Credenciales incorrectas.");
                            url = "/vista/auth/login.jsp";
                        }
                    } else {
                        request.setAttribute("error", "Por favor, completa todos los campos.");
                        url = "/vista/auth/login.jsp";
                    }
                    break;

                case "/Register":
                    String nombre = request.getParameter("nombre");
                    String documentoStr = request.getParameter("documento");
                    String ubicacion = request.getParameter("ubicacion");
                    String numero_W = request.getParameter("numero_W");
                    String emailForm = request.getParameter("email");
                    String password = request.getParameter("password");
                    String password_confirmation = request.getParameter("password_confirmation");

                    if (!password.equals(password_confirmation)) {
                        request.setAttribute("error", "Las contraseñas no coinciden.");
                        url = "/vista/auth/register.jsp";
                        break;
                    }
                    int documento;
                    try {
                        documento = Integer.parseInt(documentoStr);
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "El documento debe ser un número válido.");
                        url = "/vista/auth/register.jsp";
                        break;
                    }
                    // Crear un nuevo usuario
                    Users nuevoUsuario = new Users();
                    nuevoUsuario.setNombre(nombre);
                    nuevoUsuario.setDocumento(documento);
                    nuevoUsuario.setUbicacion(ubicacion);
                    nuevoUsuario.setNumeroW(numero_W);
                    nuevoUsuario.setEmail(emailForm);
                    nuevoUsuario.setPassword(password);
                    nuevoUsuario.setBloqueado(true); // 
                    nuevoUsuario.setEsPublicador(false);
                    try {
                        usersF.create(nuevoUsuario);
                        // Iniciar sesión después del registro
                        request.getSession().setAttribute("usuario", nuevoUsuario);
                        url = "/vista/auth/login.jsp";
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error", "Hubo un problema al registrar el usuario.");
                        url = "/vista/auth/register.jsp";
                    }
                    break;

                case "/AceptarCuentas":
                    Long usuarioIdAdmin3 = (Long) request.getSession().getAttribute("usuarioId");
                    Users usuarioAdmin3 = em.find(Users.class, usuarioIdAdmin3);

                    if (usuarioAdmin3 != null && usuarioAdmin3.getEsAdministrador()) {
                        String usuarioIdStr = request.getParameter("usuarioId");
                        try {
                            Long usuarioId2 = Long.parseLong(usuarioIdStr);
                            Users usuario2 = em.find(Users.class, usuarioId2);
                            if (usuario2 != null) {
                                usuario2.setBloqueado(false);
                                usuario2.setEsPublicador(true);
                                usersF.edit(usuario2);
                                response.setStatus(HttpServletResponse.SC_OK);
                                response.getWriter().write("Usuario aceptado exitosamente.");
                            } else {
                                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                                response.getWriter().write("Usuario no encontrado.");
                            }
                        } catch (NumberFormatException e) {
                            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                            response.getWriter().write("ID de usuario inválido.");
                        }
                    } else {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        response.getWriter().write("No tiene permisos de administrador.");
                    }
                    break;

                case "/editarPubliAdmin":
                    try {
                        Long usuarioId = (Long) request.getSession().getAttribute("usuarioId");
                        if (usuarioId == null) {
                            throw new Exception("El usuario no está logueado.");
                        }
                        // Filtrar las publicaciones del administrador logueado
                        List<Publicaciones> publicacionesAdmin = publicacionesF.obtenerPublicacionesPorUsuario(usuarioId);

                        request.setAttribute("publicaciones", publicacionesAdmin);
                        request.getRequestDispatcher("/vista/adminLayouts/lista_publicaciones.jsp").forward(request, response);
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error", "Hubo un error al cargar las publicaciones.");
                        request.getRequestDispatcher("/vista/adminLayouts/admin_dashboard.jsp").forward(request, response);
                    }
                    break;

                default:
                    url = "/vista/error.jsp";
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
