<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Panel de Administrador - Publicaciones</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body>
        <!-- Navbar -->
        <jsp:include page="/vista/layouts/navbar.jsp" />
        <div class="container mt-5">
            <h2 class="text-2xl font-bold mb-6">Todas las Publicaciones</h2>
            <table class="table table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>Título</th>
                        <th>Contenido</th>
                        <th>Usuario</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="publicacion" items="${publicaciones}">
                        <tr>
                            <td>${publicacion.titulo}</td>
                            <td>${publicacion.contenido}</td>
                            <td>${publicacion.userId.nombre}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>
