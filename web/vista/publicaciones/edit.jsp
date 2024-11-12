<%@page import="entidades.Publicaciones"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Mis Publicaciones</title>
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
                    <div class="text-gray-900 dark:text-gray-100">
                        <h1 class="text-2xl font-bold mb-6">Tus Publicaciones</h1>
                        <!-- Grid de publicaciones -->
                        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                            <c:forEach var="publicacion" items="${publicaciones}">
                                <div class="bg-white shadow-lg rounded-lg overflow-hidden" id="publicacion-${publicacion.id}">
                                    <div class="relative">
                                        <img src="http://localhost:8080/ChacrasSJ/ImageLoaderServlet?imageName=${publicacion.imagen}" class="w-full h-48 object-cover">
                                        <div class="bg-gray-800 text-white text-center p-2 font-semibold absolute bottom-0 w-full">
                                            ${publicacion.titulo}
                                        </div>
                                    </div>
                                    <div class="p-4">
                                        <p class="text-gray-700">${publicacion.contenido}</p>
                                        <div class="flex justify-between mt-4 space-x-2">
                                            <a href="${pageContext.request.contextPath}/showPublicacion?id=${publicacion.id}" class="px-4 py-2 btn-custom text-white rounded shadow-md transition duration-300 ease-in-out">Editar</a>
                                            <form method="post" action="${pageContext.request.contextPath}/deletePublicacion" class="inline-block" onsubmit="eliminarPublicacion(event, ${publicacion.id})">
                                                <button type="submit" class="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600 shadow-md transition duration-300 ease-in-out">Eliminar</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
<script>
    function eliminarPublicacion(event, publicacionId) {
        event.preventDefault();
        if (confirm('¿Estás seguro de que deseas eliminar esta publicación?')) {
            fetch('${pageContext.request.contextPath}/deletePublicacion?id=' + publicacionId, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' }
            }).then(response => {
                if (response.ok) {
                    document.getElementById('publicacion-' + publicacionId).remove();
                    alert('Publicación eliminada con éxito.');
                } else {
                    response.text().then(errorMessage => alert('Error al eliminar la publicación: ' + errorMessage));
                }
            });
        }
    }
</script>
