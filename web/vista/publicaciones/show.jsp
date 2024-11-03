<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="entidades.Publicaciones"%>
<%@page import="java.util.List"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Editar Publicación</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body class="bg-gray-100">
        <!-- Navbar -->
        <jsp:include page="/vista/layouts/navbar.jsp" />
        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg p-6">
                    <h2 class="font-semibold text-xl leading-tight">Editar Publicación</h2>
                    <form action="${pageContext.request.contextPath}/showPublicacion" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="id" value="${publicacion.id}">

                        <div class="mt-4">
                            <label for="titulo" class="block text-sm font-medium text-gray-700">Título</label>
                            <input id="titulo" class="block mt-1 w-full border-gray-300 rounded-md shadow-sm" type="text" name="titulo" required value="${publicacion.titulo}" />
                        </div>

                        <div class="mt-4">
                            <label for="contenido" class="block text-sm font-medium text-gray-700">Contenido</label>
                            <textarea id="contenido" class="block mt-1 w-full border-gray-300 rounded-md shadow-sm" name="contenido" required>${publicacion.contenido}</textarea>
                        </div>

                        <div class="mt-4">
                            <label for="imagen" class="block text-sm font-medium text-gray-700">Imagen</label>
                            <input type="file" name="imagen" accept="image/*" />
                        </div>

                        <button type="submit" class="mt-4 btn-custom2 text-white px-4 py-2 rounded">Actualizar Publicación</button>
                    </form>

                </div>
            </div>
        </div>
    </body>
</html>
