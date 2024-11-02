<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String nombre = (String) session.getAttribute("nombre");
    String email = (String) session.getAttribute("email");
    Boolean esAdministrador = (Boolean) session.getAttribute("es_administrador");
    Boolean esPublicador = (Boolean) session.getAttribute("es_publicador"); // Nuevo atributo para verificar si es publicador
%>

<nav class="bg-white dark:bg-gray-800 border-b border-gray-100 dark:border-gray-700">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="flex items-center">
                <!-- Logo -->
                <div class="shrink-0 flex items-center">
                    <a href="/">
                        <img src="${pageContext.request.contextPath}/imagen/logopr.svg" class="block h-9 w-auto fill-current" alt="Logo"/>
                    </a>
                </div>

                <!-- Navigation Links -->
                <div class="hidden sm:flex space-x-8 sm:-my-px sm:ml-10">
                    <a href="${pageContext.request.contextPath}/vista/layouts/dashboard.jsp" class="text-gray-900 dark:text-white hover:text-gray-700 dark:hover:text-gray-300 px-3 py-2 rounded-md text-lg font-semibold">
                        Panel
                    </a>

                    <%-- Mostrar Publicación solo si el usuario es publicador --%>
                    <% if (esPublicador != null && esPublicador) { %>
                    <a href="${pageContext.request.contextPath}/vista/publicaciones/indexP.jsp" class="text-gray-900 dark:text-white hover:text-gray-700 dark:hover:text-gray-300 px-3 py-2 rounded-md text-lg font-semibold">
                        Publicación
                    </a>
                    <% } %>

                    <!-- Opciones solo para el admin -->
                    <% if (esAdministrador != null && esAdministrador) { %>
                    <a href="${pageContext.request.contextPath}/vista/adminLayouts/admin_dashboard.jsp" class="text-gray-900 dark:text-white hover:text-gray-700 dark:hover:text-gray-300 px-3 py-2 rounded-md text-lg font-semibold">
                        Ver todas las publicaciones
                    </a>
                    <a href="${pageContext.request.contextPath}/vista/adminLayouts/admin_usuarios.jsp" class="text-gray-900 dark:text-white hover:text-gray-700 dark:hover:text-gray-300 px-3 py-2 rounded-md text-lg font-semibold">
                        Ver todas los usuarios
                    </a>
                    <a href="${pageContext.request.contextPath}/vista/adminLayouts/admin_aceptar_usuarios.jsp" class="text-gray-900 dark:text-white hover:text-gray-700 dark:hover:text-gray-300 px-3 py-2 rounded-md text-lg font-semibold">
                        Gestionar Usuarios
                    </a>
                    <% }%>
                </div>
            </div>

            <!-- User info and dropdown -->
            <div class="hidden sm:flex sm:items-center sm:ml-6">
                <div class="relative">
                    <button onclick="toggleDropdown()" class="inline-flex items-center px-3 py-2 text-sm leading-4 font-medium rounded-md text-gray-500 dark:text-gray-400 bg-white dark:bg-gray-800">
                        <div><%= nombre != null ? nombre : "Usuario"%></div>
                        <svg class="ml-1 h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 111.414 1.414l-4 4a1 1 01-1.414 0l-4-4a1 1 010-1.414z" clip-rule="evenodd"/>
                        </svg>
                    </button>

                    <!-- Dropdown content -->
                    <div id="dropdownMenu" class="hidden absolute right-0 mt-2 w-48 bg-white shadow-lg rounded-md py-1">
                        <a href="${pageContext.request.contextPath}/vista/layouts/profile.jsp" class="block px-4 py-2 text-sm text-gray-700">Perfil</a>
                        <form method="POST" action="${pageContext.request.contextPath}/Logout">
                            <button type="submit" class="block w-full text-left px-4 py-2 text-sm text-gray-700">Cerrar sesión</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Responsive menu -->
            <div class="sm:hidden">
                <button onclick="toggleMobileMenu()" class="text-gray-500 dark:text-gray-400">
                    <svg class="h-6 w-6" stroke="currentColor" fill="none" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
                    </svg>
                </button>
            </div>
        </div>
    </div>

    <!-- Responsive Navigation Menu -->
    <div id="mobileMenu" class="hidden sm:hidden">
        <div class="pt-2 pb-3 space-y-1">
            <a href="dashboard.jsp" class="block px-4 py-2 text-base font-medium text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-gray-900 rounded-md">
                Panel
            </a>

            <%-- Mostrar Publicación solo si el usuario es publicador en el menú móvil --%>
            <% if (esPublicador != null && esPublicador) { %>
            <a href="indexP.jsp" class="block px-4 py-2 text-base font-medium text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-gray-900 rounded-md">
                Publicaciones
            </a>
            <% } %>
        </div>

        <!-- Opciones solo para el admin en el menú móvil -->
        <% if (esAdministrador != null && esAdministrador) { %>
        <div class="pt-4 pb-1 border-t border-gray-200 dark:border-gray-600">
            <div class="mt-3 space-y-1">
                <a href="${pageContext.request.contextPath}/vista/adminLayouts/admin_dashboard.jsp" class="block px-4 py-2 text-base font-medium text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-gray-900 rounded-md">
                    Ver todas las publicaciones
                </a>
                <a href="${pageContext.request.contextPath}/vista/adminLayouts/admin_usuarios.jsp" class="block px-4 py-2 text-base font-medium text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-gray-900 rounded-md">
                    Ver todas los usuarios
                </a>
                <a href="${pageContext.request.contextPath}/vista/adminLayouts/admin_aceptar_usuarios.jsp" class="block px-4 py-2 text-base font-medium text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-gray-900 rounded-md">
                    Gestionar Usuarios
                </a>
            </div>
        </div>
        <% }%>

        <div class="pt-4 pb-1 border-t border-gray-200 dark:border-gray-600">
            <div class="px-4">
                <div class="font-medium text-base"><%= nombre != null ? nombre : "Usuario"%></div>
                <div class="font-medium text-sm text-gray-500"><%= email != null ? email : "email@example.com"%></div>
            </div>
            <div class="mt-3 space-y-1">
                <a href="profile.jsp" class="block px-4 py-2 text-base font-medium text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-gray-900 rounded-md">
                    Perfil
                </a>
                <form method="POST" action="${pageContext.request.contextPath}/Logout">
                    <button type="submit" class="block w-full text-left px-4 py-2 text-base font-medium text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-gray-900">
                        Cerrar sesión
                    </button>
                </form>
            </div>
        </div>
    </div>
</nav>

<script>
    function toggleDropdown() {
        var dropdownMenu = document.getElementById('dropdownMenu');
        dropdownMenu.classList.toggle('hidden');
    }

    function toggleMobileMenu() {
        var mobileMenu = document.getElementById('mobileMenu');
        mobileMenu.classList.toggle('hidden');
    }
</script>
