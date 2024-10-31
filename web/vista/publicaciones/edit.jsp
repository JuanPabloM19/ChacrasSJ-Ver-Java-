<%@page import="entidades.Publicaciones"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Publicaciones</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body class="bg-gray-100">
    <!-- Navbar -->
    <jsp:include page="/vista/layouts/navbar.jsp" />
    <!-- Contenedor principal -->
    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <!-- Mostrar mensaje de éxito si existe -->
            <%
                String successMessage = (String) session.getAttribute("success");
                if (successMessage != null) {
            %>
                <div class="bg-green-400 text-gray-800 font-extrabold p-4 rounded-lg mb-6 text-center">
                    <%= successMessage %>
                </div>
                <%
                    session.removeAttribute("success"); // Limpiar el mensaje después de mostrarlo
                }
            %>

            <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg p-6">
                <div class="text-gray-900 dark:text-gray-100">
                    <!-- Botón para crear una nueva publicación -->
                    <div class="text-right mb-4">
                        <a href="create.jsp" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                            Crear publicación
                        </a>
                    </div>

                    <!-- Grid de publicaciones -->
                    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                        <!-- Iterar sobre las publicaciones -->
                        <%
                            List<Publicaciones> publicaciones = (List<Publicaciones>) request.getAttribute("publicaciones");
                            if (publicaciones != null && !publicaciones.isEmpty()) {
                                for (Publicaciones publicacion : publicaciones) {
                        %>
                                    <div class="bg-white shadow-lg rounded-lg overflow-hidden">
                                        <div class="relative">
                                            <img src="data:image/jpeg;base64,<%= publicacion.getImagen() %>" alt="Imagen de la Publicación" class="w-full h-48 object-cover">
                                            <div class="bg-gray-800 text-white text-center p-2 font-semibold absolute bottom-0 w-full">
                                                <%= publicacion.getTitulo() %>
                                            </div>
                                        </div>
                                        <div class="p-4">
                                            <p class="text-gray-700">
                                                <%= publicacion.getContenido() %>
                                            </p>

                                            <div class="flex justify-between mt-4">
                                                <!-- Botones de ver, editar, eliminar -->
                                                <a href="showPublicacion?id=<%= publicacion.getId() %>" class="text-blue-500 hover:text-blue-700">
                                                    Ver
                                                </a>
                                                <a href="editPublicacion?id=<%= publicacion.getId() %>" class="text-yellow-500 hover:text-yellow-700">
                                                    Editar
                                                </a>
                                                <form method="post" action="deletePublicacion" class="inline-block">
                                                    <input type="hidden" name="id" value="<%= publicacion.getId() %>">
                                                    <button type="submit" class="text-red-500 hover:text-red-700">
                                                        Eliminar
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                        <%
                                }
                            } else {
                        %>
                            <div class="col-span-4 text-center">
                                <p class="text-gray-600 bg-gray-200 p-4 rounded-lg">
                                    No hay publicaciones
                                </p>
                            </div>
                        <%
                            }
                        %>
                    </div>

                    <!-- Paginación (esto debería ser gestionado en tu controlador) -->
                    <div class="mt-10 text-center">
                        <nav>
                            <!-- Aquí iría el código de paginación -->
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
