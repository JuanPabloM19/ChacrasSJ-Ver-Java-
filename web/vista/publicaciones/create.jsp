<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<% 
    Long usuarioId = (Long) session.getAttribute("usuarioId");
    if (usuarioId == null) {
        out.println("<p style='color:red;'>Debes estar autenticado para crear una publicación.</p>");
    } else {
        out.println("<p style='color:green;'>ID de usuario: " + usuarioId + "</p>");
    }
%>

<html>
    <head>
        <title>Crear nueva publicación</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body>
        <!-- Navbar -->
        <jsp:include page="/vista/layouts/navbar.jsp" />
        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6 text-gray-900 dark:text-gray-100">
                        <h2 class="font-semibold text-xl leading-tight">Crear nueva publicación</h2>
                        <form method="post" action="${pageContext.request.contextPath}/CrearPublicacion" enctype="multipart/form-data">
                            <!-- Título -->
                            <div>
                                <label for="titulo" class="block font-medium text-gray-700">Título</label>
                                <input id="titulo" class="block mt-1 w-full" type="text" name="titulo" required autofocus />
                            </div>

                            <!-- Contenido -->
                            <div class="mt-4">
                                <label for="contenido" class="block font-medium text-gray-700">Contenido</label>
                                <input id="contenido" class="block mt-1 w-full" type="text" name="contenido" required />
                            </div>

                            <div class="flex items-center justify-end mt-4">
                                <button type="submit" class="ml-4 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">Guardar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
