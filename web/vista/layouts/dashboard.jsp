<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificar si la sesión contiene el nombre del usuario
    String nombre = (String) session.getAttribute("nombre");
    if (nombre == null || nombre.isEmpty()) {
        response.sendRedirect("login.jsp"); // Redirigir al login si no está autenticado
    }
    String email = (String) session.getAttribute("email");
    Boolean esAdministrador = (Boolean) session.getAttribute("es_administrador");

    // Obtener el estado de bloqueado
    Boolean bloqueado = (Boolean) session.getAttribute("bloqueado");

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
        <!-- Agregar los enlaces a tus archivos CSS aquí -->
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
            <h1 class="text-2xl font-semibold text-gray-800">Bienvenido, <%= nombre%> al Panel de Navegación</h1>
            <!-- Verificar si el usuario está bloqueado -->
            <c:choose>
                <c:when test="${bloqueado}">
                    <p class="mt-4 text-red-500">
                        Debes esperar la aprobación del administrador para publicar. Serás aprobado en un plazo de 24 horas.
                    </p>
                </c:when>
                <c:otherwise>
                    <p class="mt-4">Aquí puedes gestionar tus publicaciones y configuraciones.</p>
                    <!-- Aquí pones el contenido de gestión de publicaciones solo si no está bloqueado -->
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