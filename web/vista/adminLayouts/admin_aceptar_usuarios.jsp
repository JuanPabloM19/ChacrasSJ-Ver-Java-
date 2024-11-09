<%@page import="java.util.List"%>
<%@page import="jakarta.persistence.Persistence"%>
<%@page import="jakarta.persistence.EntityManager"%>
<%@page import="entidades.Users"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
    EntityManager em = Persistence.createEntityManagerFactory("ChacrasSJPU").createEntityManager();
    List<Users> usuariosBloqueados = em.createQuery("SELECT u FROM Users u WHERE u.bloqueado = true", Users.class).getResultList();
    request.setAttribute("cuentasPendientes", usuariosBloqueados);
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Panel de Administrador - Aceptar Nuevas Cuentas</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/estilo.css">

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            function aceptarUsuario(usuarioId) {
                $.post("${pageContext.request.contextPath}/AceptarCuentas", {usuarioId: usuarioId, accion: "aceptar"})
                        .done(function (response) {
                            console.log("Respuesta del servidor: ", response);
                            window.location.reload();
                        })
                        .fail(function (xhr, status, error) {
                            console.error("Error al aceptar el usuario: " + xhr.status + " - " + xhr.responseText);
                        });
            }
        </script>
    </head>
    <body>
        <!-- Navbar -->
        <jsp:include page="/vista/layouts/navbar.jsp" />
        <div class="container mt-5">
            <h2 class="text-2xl font-bold mb-6">Usuarios Pendientes de Aceptación</h2>
            <table class="table table-bordered table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>Nombre</th>
                        <th>Email</th>
                        <th>Documento</th>
                        <th>Domicilio</th>
                        <th>Whatsapp</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="cuenta" items="${cuentasPendientes}">
                        <tr>
                            <td>${cuenta.nombre}</td>
                            <td>${cuenta.email}</td>
                            <td>${cuenta.documento}</td>
                            <td>${cuenta.ubicacion}</td>
                            <td>${cuenta.numeroW}</td>
                            <td>
                                <button type="button" class="btn btn-custom2" onclick="aceptarUsuario(${cuenta.id})">Aceptar</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>