<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <!-- Información de perfil -->
        <div class="p-4 sm:p-8 bg-white dark:bg-gray-800 shadow sm:rounded-lg">
            <div class="max-w-xl">
                <section>
                    <header>
                        <h2 class="text-lg font-medium text-gray-900 dark:text-gray-100">Información de perfil</h2>
                        <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">Puedes actualizar tu nombre y correo aquí.</p>
                    </header>

                    <% if ("profile-updated".equals(session.getAttribute("status"))) { %>
                        <p class="text-lg text-green-600 dark:text-gray-400">Datos actualizados.</p>
                    <% } %>

                    <form method="post" action="${pageContext.request.contextPath}/profile/update" class="mt-6 space-y-6">
                        <input type="hidden" name="_csrf" value="${csrfToken}"/>
                        <input type="hidden" name="_method" value="patch"/>

                        <div>
                            <label for="name" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Nombre</label>
                            <input id="name" name="name" type="text" class="mt-1 block w-full border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 dark:focus:border-blue-700 dark:focus:ring-blue-600" value="${user.name}" required autofocus autocomplete="name"/>
                        </div>

                        <div>
                            <label for="documento" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Documento</label>
                            <input id="documento" name="documento" type="text" class="mt-1 block w-full border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 dark:focus:border-blue-700 dark:focus:ring-blue-600" value="${user.documento}" required autocomplete="documento"/>
                        </div>

                        <div>
                            <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Correo</label>
                            <input id="email" name="email" type="email" class="mt-1 block w-full border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 dark:focus:border-blue-700 dark:focus:ring-blue-600" value="${user.email}" required autocomplete="username"/>
                            <p class="text-sm mt-2 text-gray-800 dark:text-gray-200">
                                Tu correo no ha sido verificado.
                                <button form="send-verification" class="underline text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-100 rounded-md">Click aquí para enviar nuevamente la verificación</button>
                            </p>
                        </div>

                        <div class="flex items-center gap-4">
                            <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">Guardar</button>
                            <% if ("profile-updated".equals(session.getAttribute("status"))) { %>
                                <p class="text-sm text-gray-600 dark:text-gray-400">Guardado.</p>
                            <% } %>
                        </div>
                    </form>
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

                    <form method="post" action="${pageContext.request.contextPath}/password/update" class="mt-6 space-y-6">
                        <input type="hidden" name="_csrf" value="${csrfToken}"/>
                        <input type="hidden" name="_method" value="put"/>

                        <div>
                            <label for="update_password_current_password" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Contraseña Actual</label>
                            <input id="update_password_current_password" name="current_password" type="password" class="mt-1 block w-full border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 dark:focus:border-blue-700 dark:focus:ring-blue-600" autocomplete="current-password"/>
                        </div>

                        <div>
                            <label for="update_password_password" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Nueva contraseña</label>
                            <input id="update_password_password" name="password" type="password" class="mt-1 block w-full border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 dark:focus:border-blue-700 dark:focus:ring-blue-600" autocomplete="new-password"/>
                        </div>

                        <div>
                            <label for="update_password_password_confirmation" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Repetir contraseña</label>
                            <input id="update_password_password_confirmation" name="password_confirmation" type="password" class="mt-1 block w-full border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 dark:focus:border-blue-700 dark:focus:ring-blue-600" autocomplete="new-password"/>
                        </div>

                        <div class="flex items-center gap-4">
                            <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">Guardar</button>
                            <% if ("password-updated".equals(session.getAttribute("status"))) { %>
                                <p class="text-sm text-gray-600 dark:text-gray-400">Guardado.</p>
                            <% } %>
                        </div>
                    </form>
                </section>
            </div>
        </div>

        <!-- Eliminar cuenta -->
        <div class="p-4 sm:p-8 bg-white dark:bg-gray-800 shadow sm:rounded-lg">
            <div class="max-w-xl">
                <section>
                    <header>
                        <h2 class="text-lg font-medium text-gray-900 dark:text-gray-100">Eliminar cuenta</h2>
                        <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">Una vez que se elimine su cuenta, todos sus recursos y datos se eliminarán permanentemente. Antes de eliminar su cuenta, descargue cualquier dato o información que desee conservar.</p>
                    </header>

                    <button type="button" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700" onclick="document.getElementById('confirm-user-deletion').style.display='block'">Eliminar cuenta</button>

                    <div id="confirm-user-deletion" style="display:none;" class="bg-gray-100 p-6 rounded-md mt-4">
                        <form method="post" action="${pageContext.request.contextPath}/profile/destroy">
                            <input type="hidden" name="_csrf" value="${csrfToken}"/>
                            <input type="hidden" name="_method" value="delete"/>

                            <h2 class="text-lg font-medium text-gray-900 dark:text-gray-100">¿Estás seguro que deseas eliminarla?</h2>
                            <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">Una vez que se elimine su cuenta, todos sus recursos y datos se eliminarán permanentemente. Ingrese su contraseña para confirmar que desea eliminar permanentemente su cuenta.</p>

                            <div class="mt-6">
                                <label for="password" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Contraseña</label>
                                <input id="password" name="password" type="password" class="mt-1 block w-full border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 dark:focus:border-blue-700 dark:focus:ring-blue-600" required autocomplete="current-password"/>
                            </div>

                            <div class="flex items-center justify-end mt-6">
                                <button type="submit" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700">Eliminar cuenta</button>
                            </div>
                        </form>
                    </div>
                </section>
            </div>
        </div>
    </div>

    <script>
        // Opcional: Script para mostrar y ocultar el formulario de eliminación
        function toggleDeletion() {
            const deletionDiv = document.getElementById('confirm-user-deletion');
            deletionDiv.style.display = deletionDiv.style.display === 'none' ? 'block' : 'none';
        }
    </script>
</body>
</html>