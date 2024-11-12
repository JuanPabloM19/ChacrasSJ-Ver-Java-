<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Iniciar Sesión</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body class="bg-gray-100 p-6">
        <div class="max-w-md mx-auto bg-white p-8 rounded-lg shadow-md">
            <h2 class="text-2xl font-bold text-center">Iniciar Sesión</h2>
            <form method="POST" action="${pageContext.request.contextPath}/Login">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> <!-- Token CSRF -->

                <!-- Email Address -->
                <div class="mt-4">
                    <label for="email" class="block text-sm font-medium text-gray-700">Correo</label>
                    <input id="email" class="block mt-1 w-full border-gray-300 rounded-md shadow-sm" type="email" name="email" required autofocus autocomplete="username" value="<%= request.getParameter("email") != null ? request.getParameter("email") : ""%>" />
                </div>

                <!-- Password -->
                <div class="mt-4">
                    <label for="password" class="block text-sm font-medium text-gray-700">Contraseña</label>
                    <input id="password" class="block mt-1 w-full border-gray-300 rounded-md shadow-sm" type="password" name="password" required autocomplete="current-password" />
                </div>

                <!-- Remember Me -->
                <div class="block mt-4">
                    <label for="remember_me" class="inline-flex items-center">
                        <input id="remember_me" type="checkbox" name="remember" class="rounded border-gray-300 text-blue-600 shadow-sm focus:ring-blue-500" />
                        <span class="ms-2 text-sm text-gray-600">Recordarme</span>
                    </label>
                </div>

                <div class="flex items-center justify-end mt-4">
                    <a class="underline text-sm text-gray-600 hover:text-gray-900">
                        ¿Olvidó su contraseña?
                    </a>

                    <button type="submit" class="ml-4 btn-custom text-white px-4 py-2 rounded">Iniciar Sesión</button>
                </div>
            </form>
        </div>
    </body>
</html>
