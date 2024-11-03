<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Perfil</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body class="bg-gray-100 dark:bg-gray-900">
        <!-- Navbar -->
        <jsp:include page="/vista/layouts/navbar.jsp" />

        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 py-12 space-y-6">
            <!-- Mensaje de éxito o error -->
            <c:if test="${not empty sessionScope.message}">
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative" role="alert">
                    <strong class="font-bold">Éxito:</strong>
                    <span class="block sm:inline">${sessionScope.message}</span>
                    <c:remove var="message" scope="session"/>
                </div>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
                    <strong class="font-bold">Error:</strong>
                    <span class="block sm:inline">${sessionScope.error}</span>
                    <c:remove var="error" scope="session"/>
                </div>
            </c:if>
            <!-- Información de perfil -->
            <div class="p-4 sm:p-8 bg-white dark:bg-gray-800 shadow sm:rounded-lg">
                <div class="max-w-xl">
                    <section>
                        <header>
                            <h2 class="text-lg font-medium text-gray-900 dark:text-gray-100">Información de perfil</h2>
                            <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">Información de usuario registrada en el sistema.</p>
                        </header>

                        <div class="mt-6 space-y-6">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Nombre</label>
                                <p class="mt-1 block w-full border border-gray-300 dark:border-gray-600 rounded-md shadow-sm px-3 py-2 bg-gray-100 dark:bg-gray-700 text-gray-900 dark:text-gray-100">${user.nombre}</p>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Documento</label>
                                <p class="mt-1 block w-full border border-gray-300 dark:border-gray-600 rounded-md shadow-sm px-3 py-2 bg-gray-100 dark:bg-gray-700 text-gray-900 dark:text-gray-100">${user.documento}</p>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Correo</label>
                                <p class="mt-1 block w-full border border-gray-300 dark:border-gray-600 rounded-md shadow-sm px-3 py-2 bg-gray-100 dark:bg-gray-700 text-gray-900 dark:text-gray-100">${user.email}</p>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">WhatsApp</label>
                                <p class="mt-1 block w-full border border-gray-300 dark:border-gray-600 rounded-md shadow-sm px-3 py-2 bg-gray-100 dark:bg-gray-700 text-gray-900 dark:text-gray-100">${user.numeroW}</p>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
            <!-- Cambiar contraseña -->
            <div class="p-4 sm:p-8 bg-white dark:bg-gray-800 shadow sm:rounded-lg">
                <div class="max-w-xl">
                    <section>
                        <header>
                            <h2 class="text-lg font-medium text-gray-900 dark:text-gray-100">Cambiar contraseña</h2>
                            <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">Puedes cambiar tu contraseña aquí para agregarle más seguridad.</p>
                        </header>

                        <form method="post" action="${pageContext.request.contextPath}/resetPassword" class="mt-6 space-y-6">
                            <input type="hidden" name="_csrf" value="${csrfToken}"/>

                            <!-- Campo de contraseña actual con ícono de ojo -->
                            <div>
                                <label for="current_password" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Contraseña Actual</label>
                                <div class="relative">
                                    <input id="current_password" name="current_password" type="password" class="mt-1 block w-full border-gray-300 dark:border-gray-600 rounded-md shadow-sm pr-10" value="${user.password}" required />
                                    <button type="button" onclick="togglePasswordVisibility('current_password')" class="absolute inset-y-0 right-0 px-3 flex items-center text-gray-500 dark:text-gray-400">
                                        <svg id="icon_current_password" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                                        <path d="M10 3a7 7 0 00-7 7 7 7 0 007 7 7 7 0 007-7 7 7 0 00-7-7zm0 2a5 5 0 110 10 5 5 0 010-10z"/>
                                        <path d="M10 6a4 4 0 100 8 4 4 0 000-8z"/>
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <!-- Campo de nueva contraseña con ícono de ojo -->
                            <div>
                                <label for="new_password" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Nueva contraseña</label>
                                <div class="relative">
                                    <input id="new_password" name="new_password" type="password" class="mt-1 block w-full border-gray-300 dark:border-gray-600 rounded-md shadow-sm pr-10" required />
                                    <button type="button" onclick="togglePasswordVisibility('new_password')" class="absolute inset-y-0 right-0 px-3 flex items-center text-gray-500 dark:text-gray-400">
                                        <svg id="icon_new_password" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                                        <path d="M10 3a7 7 0 00-7 7 7 7 0 007 7 7 7 0 007-7 7 7 0 00-7-7zm0 2a5 5 0 110 10 5 5 0 010-10z"/>
                                        <path d="M10 6a4 4 0 100 8 4 4 0 000-8z"/>
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <!-- Campo de confirmación de contraseña con ícono de ojo -->
                            <div>
                                <label for="confirm_password" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Repetir contraseña</label>
                                <div class="relative">
                                    <input id="confirm_password" name="confirm_password" type="password" class="mt-1 block w-full border-gray-300 dark:border-gray-600 rounded-md shadow-sm pr-10" required />
                                    <button type="button" onclick="togglePasswordVisibility('confirm_password')" class="absolute inset-y-0 right-0 px-3 flex items-center text-gray-500 dark:text-gray-400">
                                        <svg id="icon_confirm_password" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                                        <path d="M10 3a7 7 0 00-7 7 7 7 0 007 7 7 7 0 007-7 7 7 0 00-7-7zm0 2a5 5 0 110 10 5 5 0 010-10z"/>
                                        <path d="M10 6a4 4 0 100 8 4 4 0 000-8z"/>
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <div class="flex items-center gap-4">
                                <button type="submit" class="px-4 py-2 btn-custom2 text-white rounded-md">Guardar</button>
                            </div>
                        </form>
                    </section>
                </div>
            </div>
        </div>
    </body>
</html>
<script>
    // Función para alternar la visibilidad de la contraseña y cambiar el icono
    function togglePasswordVisibility(fieldId) {
        const passwordField = document.getElementById(fieldId);
        const icon = document.getElementById("icon_" + fieldId);

        if (passwordField.type === "password") {
            passwordField.type = "text";
            icon.setAttribute("d", "M10 5a7 7 0 000 10 7 7 0 0010-7 7 7 0 00-10-7z");
        } else {
            passwordField.type = "password";
            icon.setAttribute("d", "M10 3a7 7 0 00-7 7 7 7 0 007 7 7 7 0 007-7 7 7 0 00-7-7zm0 2a5 5 0 110 10 5 5 0 010-10z");
        }
    }
</script>
<script>
    document.querySelector('form').addEventListener('submit', function (e) {
        var newPassword = document.getElementById('new_password').value;
        var confirmPassword = document.getElementById('confirm_password').value;
        if (newPassword !== confirmPassword) {
            alert('Las contraseñas no coinciden.');
            e.preventDefault();  // Detener el envío del formulario
        }
    });
</script>

