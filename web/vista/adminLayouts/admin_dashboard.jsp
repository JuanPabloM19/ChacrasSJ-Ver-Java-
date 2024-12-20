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
            <c:if test="${empty publicaciones}">
                <p>No hay publicaciones disponibles.</p>
            </c:if>
            <table class="table table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>Título</th>
                        <th>Contenido</th>
                        <th>Usuario</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="publicacion" items="${publicaciones}">
                        <tr>
                            <td>${publicacion.titulo}</td>
                            <td>${publicacion.contenido}</td>
                            <td>${publicacion.userId.nombre}</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/eliminarPublicacion" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="${publicacion.id}" />
                                    <button type="submit" class="btn btn-danger">Eliminar</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>
