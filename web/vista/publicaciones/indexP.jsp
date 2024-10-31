<%@page import="entidades.Publicaciones"%>
<%@page import="jakarta.servlet.jsp.JspWriter"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Publicaciones</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
    </head>
    <body>
        <!-- Navbar -->
        <jsp:include page="/vista/layouts/navbar.jsp" />
        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">

                <!-- Mensaje de éxito -->
                <%
                    String successMessage = (String) session.getAttribute("success");
                    if (successMessage != null) {
                %>
                <div class="max-w-md mx-auto bg-green-400 text-gray-800 font-extrabold p-4 rounded-lg mb-6">
                    <%= successMessage%>
                </div>
                <%
                        session.removeAttribute("success");
                    }
                %>

                <!-- Botón para crear nueva publicación -->
                <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg mb-6">
                    <div class="p-6 text-gray-900 dark:text-gray-100">
                        <div>
                            <a href="create.jsp">
                                <button class="mb-3 bg-blue-500 text-white p-2 rounded-lg transition duration-300 hover:bg-blue-600">Crear publicación</button>
                            </a>
                            <a href="edit.jsp">
                                <button class="mb-3 bg-blue-500 text-white p-2 rounded-lg transition duration-300 hover:bg-blue-600">Editar publicación</button>
                            </a>
                            <!-- Mostrar publicaciones -->
                            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-5">
                                <%
                                    List<Publicaciones> publicaciones = (List<Publicaciones>) request.getAttribute("publicaciones");
                                    if (publicaciones != null && !publicaciones.isEmpty()) {
                                        for (Publicaciones publicacion : publicaciones) {
                                %>
                                <div class="rounded-xl bg-gray-300 shadow p-4 max-w-xs mx-auto">
                                    <div class="group relative">
                                        <img src="data:image/jpeg;base64,<%= publicacion.getImagen()%>" alt="Imagen del Producto" class="max-w-full h-auto rounded-lg">
                                        <div class="bg-gray-700 hover:bg-gray-600 text-white text-center font-semibold p-2 rounded-lg transition duration-300">
                                            <%= publicacion.getTitulo()%>
                                        </div>
                                    </div>
                                    <p class="text-gray-700 bg-gray-300 hover:bg-gray-400 cursor-pointer rounded-md text-center p-2 my-2">
                                        <%= publicacion.getContenido()%>
                                    </p>
                                    <div class="flex justify-evenly p-1">
                                        <a href="verPublicacionServlet?id=<%= publicacion.getId()%>">
                                            <button class="bg-gray-500 text-white p-2 rounded-lg transition duration-300 hover:bg-gray-600">Ver</button>
                                        </a>
                                        <a href="editarPublicacionServlet?id=<%= publicacion.getId()%>">
                                            <button class="bg-gray-500 text-white p-2 rounded-lg transition duration-300 hover:bg-gray-600">Editar</button>
                                        </a>

                                        <!-- Botón para eliminar publicación -->
                                        <form action="eliminarPublicacionServlet" method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="<%= publicacion.getId()%>">
                                            <button type="submit" class="bg-red-500 text-white p-2 rounded-lg transition duration-300 hover:bg-red-600">Eliminar</button>
                                        </form>
                                    </div>
                                </div>
                                <%
                                    }
                                } else {
                                %>
                                <div class="rounded-xl bg-gray-300 shadow p-4">
                                    <p class="text-gray-700 bg-gray-400 rounded-md text-center p-2 my-2 font-semibold">
                                        No hay publicaciones
                                    </p>
                                </div>
                                <% }%>
                            </div>

                            <!-- Paginación (implementarla manualmente o usar un plugin de Java) -->
                            <div class="my-10">
                                <!-- Aquí iría la lógica para mostrar los links de paginación -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
