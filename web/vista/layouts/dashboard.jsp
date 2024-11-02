<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
    // Verificar si la sesión contiene el nombre del usuario
    String nombre = (String) session.getAttribute("nombre");
    if (nombre == null || nombre.isEmpty()) {
        response.sendRedirect("login.jsp"); // Redirigir al login si no está autenticado
    }

    String email = (String) session.getAttribute("email");
    Boolean esAdministrador = (Boolean) session.getAttribute("es_administrador");
    Boolean bloqueado = (Boolean) session.getAttribute("bloqueado");
    Boolean esPublicador = (Boolean) session.getAttribute("es_publicador");

    // Verificar si el valor de bloqueado está correctamente definido
    if (bloqueado == null) {
        bloqueado = true; // Si no se encuentra, por defecto está bloqueado
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Panel de Navegación</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/estilo.css">
        <style>
            #dropdownMenu {
                transition: opacity 0.3s ease;
            }
        </style>
    </head>
    <body>
        <!-- Navbar -->
        <jsp:include page="/vista/layouts/navbar.jsp" />

        <!-- Contenido del panel -->
        <div class="max-w-7xl mx-auto p-6">
            <h1 class="text-2xl font-semibold text-gray-800">Bienvenido, <%= nombre %> al Panel de Navegación</h1>
            <c:choose>
                <c:when test="${bloqueado && !esPublicador}">
                    <p class="mt-4 text-red-500">
                        Debes esperar la aprobación del administrador para publicar. Serás aprobado en un plazo de 24 a 48 horas.
                    </p>
                </c:when>
                <c:otherwise>
                    <p class="mt-4">Aquí puedes gestionar tus publicaciones y configuraciones.</p>
                    <!-- Aquí puedes añadir más contenido que solo los usuarios no bloqueados deberían ver -->
                </c:otherwise>
            </c:choose>
        </div>

        <!-- JavaScript para manejar el dropdown y el menú móvil -->
        <script>
            function toggleDropdown() {
                var dropdownMenu = document.getElementById('dropdownMenu');
                dropdownMenu.classList.toggle('hidden');
                dropdownMenu.classList.toggle('opacity-0');
                dropdownMenu.classList.toggle('opacity-100');
            }

            function toggleMobileMenu() {
                var mobileMenu = document.getElementById('mobileMenu');
                mobileMenu.classList.toggle('hidden');
            }
        </script>
    </body>
</html>
