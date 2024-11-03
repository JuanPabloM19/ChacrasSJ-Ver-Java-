<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body class="bg-gray-100 p-6">
    <div class="max-w-md mx-auto bg-white p-8 rounded-lg shadow-md">
        <h2 class="text-2xl font-bold text-center">Registro</h2>

        <form method="POST" action="${pageContext.request.contextPath}/Register">
            <!-- Nombre -->
            <div class="mt-4">
                <label for="nombre" class="block text-sm font-medium text-gray-700">Nombre</label>
                <input id="nombre" class="block mt-1 w-full border-gray-300 rounded-md shadow-sm" type="text" name="nombre" required autofocus autocomplete="nombre" value="<%= request.getParameter("nombre") != null ? request.getParameter("nombre") : "" %>" />
            </div>

            <!-- Documento -->
            <div class="mt-4">
                <label for="documento" class="block text-sm font-medium text-gray-700">Documento</label>
                <input id="documento" class="block mt-1 w-full border-gray-300 rounded-md shadow-sm" type="text" name="documento" required value="<%= request.getParameter("documento") != null ? request.getParameter("documento") : "" %>" />
            </div>

            <!-- Domicilio -->
            <div class="mt-4">
                <label for="ubicacion" class="block text-sm font-medium text-gray-700">Domicilio</label>
                <input id="ubicacion" class="block mt-1 w-full border-gray-300 rounded-md shadow-sm" type="text" name="ubicacion" required value="<%= request.getParameter("ubicacion") != null ? request.getParameter("ubicacion") : "" %>" />
            </div>

            <!-- Número de Teléfono -->
            <div class="mt-4">
                <label for="numero_W" class="block text-sm font-medium text-gray-700">Número de teléfono (Whatsapp)</label>
                <input id="numero_W" class="block mt-1 w-full border-gray-300 rounded-md shadow-sm" type="text" name="numero_W" required value="<%= request.getParameter("numero_W") != null ? request.getParameter("numero_W") : "" %>" />
            </div>

            <!-- Email -->
            <div class="mt-4">
                <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
                <input id="email" class="block mt-1 w-full border-gray-300 rounded-md shadow-sm" type="email" name="email" required value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" />
            </div>

            <!-- Password -->
            <div class="mt-4">
                <label for="password" class="block text-sm font-medium text-gray-700">Clave</label>
                <input id="password" class="block mt-1 w-full border-gray-300 rounded-md shadow-sm" type="password" name="password" required autocomplete="new-password" />
            </div>

            <!-- Confirmar Password -->
            <div class="mt-4">
                <label for="password_confirmation" class="block text-sm font-medium text-gray-700">Confirmar clave</label>
                <input id="password_confirmation" class="block mt-1 w-full border-gray-300 rounded-md shadow-sm" type="password" name="password_confirmation" required autocomplete="new-password" />
            </div>

            <!-- Botón de Envío -->
            <div class="flex items-center justify-end mt-4">
                <a class="underline text-sm text-gray-600 hover:text-gray-900" href="${pageContext.request.contextPath}/vista/auth/login.jsp">
                    ¿Ya estaba registrado?
                </a>
                <button type="submit" class="ml-4 btn-custom2 text-white px-4 py-2 rounded">
                    Registrarse
                </button>
            </div>
        </form>
    </div>
</body>
</html>
