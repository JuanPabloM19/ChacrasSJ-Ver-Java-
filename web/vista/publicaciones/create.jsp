<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    Long usuarioId = (Long) session.getAttribute("usuarioId");
    if (usuarioId == null) {
        out.println("<p style='color:red;'>Debes estar autenticado para crear una publicación.</p>");
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
        <jsp:include page="/vista/layouts/navbar.jsp" />
        <div class="py-12">
            <div class="max-w-md mx-auto bg-white p-8 rounded-lg shadow-md">
                <h2 class="text-2xl font-bold text-center">Crear nueva publicación</h2>

                <c:if test="${not empty error}">
                    <p class="text-red-500 text-center mt-2">${error}</p>
                </c:if>

                <form action="${pageContext.request.contextPath}/CrearPublicacion" method="POST" enctype="multipart/form-data" class="mt-4">
                    <!-- Título -->
                    <div class="mt-4">
                        <label for="titulo" class="block text-sm font-medium text-gray-700">Título</label>
                        <input id="titulo" name="titulo" type="text" required placeholder="Título" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm" />
                    </div>

                    <!-- Contenido -->
                    <div class="mt-4">
                        <label for="contenido" class="block text-sm font-medium text-gray-700">Contenido</label>
                        <textarea id="contenido" name="contenido" required placeholder="Contenido" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm h-32"></textarea>
                    </div>

                    <!-- Imagen -->
                    <div class="mt-4">
                        <label for="imagen" class="block text-sm font-medium text-gray-700">Imagen</label>
                        <input id="imagen" name="imagen" type="file" accept="image/*" required class="mt-1 block w-full border-gray-300 rounded-md shadow-sm" />
                    </div>

                    <!-- Botón de Envío -->
                    <div class="flex items-center justify-center mt-6">
                        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition duration-300">
                            Crear Publicación
                        </button>
                    </div>
                </form>

                <!-- Mostrar la imagen después de crear la publicación -->
                <c:if test="${not empty imagen}">
                    <h3 class="mt-4 text-center">Imagen cargada:</h3>
                    <img src="${pageContext.request.contextPath}/cargaIMG/${imagen}" alt="Imagen de la publicación" class="max-w-full h-auto mt-2 mx-auto" />
                </c:if>
            </div>
        </div>
    </body>
</html>
