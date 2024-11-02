<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="entidades.Publicaciones"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ page import="java.nio.file.Files, java.util.Base64, java.io.File" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<!DOCTYPE html>
<html lang="${pageContext.request.locale.language}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>ChacrasSJ</title>

        <!-- Fonts and CSS -->
        <link rel="preconnect" href="https://fonts.bunny.net">
        <link href="https://fonts.bunny.net/css?family=figtree:400,600&display=swap" rel="stylesheet" />

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-........" crossorigin="anonymous" referrerpolicy="no-referrer" />

        <!-- Glide.js -->
        <script src="https://cdn.jsdelivr.net/npm/@glidejs/glide@3.4.1/dist/glide.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@glidejs/glide@3.4.1/dist/css/glide.core.min.css">

        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body class="antialiased bg-gray-100 dark:bg-gray-900">
        <div class="relative flex flex-col min-h-screen">
            <header class="bg-white shadow">
                <div class="max-w-7xl mx-auto p-4 flex justify-between items-center">
                    <div class="logo-container">
                        <div class="log">
                            <a href="${pageContext.request.contextPath}/index">
                                <img src="${pageContext.request.contextPath}/imagen/logopr.svg" class="block h-9 w-auto" alt="Logo"/>
                            </a>
                        </div>
                    </div>
                    <div class="flex items-center space-x-4"> <!-- Añadir espaciado entre los enlaces -->
                        <% if (session.getAttribute("user") != null) {%>
                        <a href="<%= request.getContextPath()%>/dashboard" class="font-semibold text-gray-600 hover:text-gray-900">Inicio</a>
                        <% } else { %>
                        <a href="${pageContext.request.contextPath}/auth/login.jsp" class="inline-block bg-transparent font-semibold text-gray-600 hover:bg-orange-500 hover:text-gray-900 py-2 px-4 border border-white rounded-lg transition-colors duration-300">Iniciar Sesión</a>
                        <a href="${pageContext.request.contextPath}/auth/register.jsp" class="inline-block bg-transparent font-semibold text-gray-600 hover:bg-orange-500 hover:text-gray-900 py-2 px-4 border border-white rounded-lg transition-colors duration-300">Registrarse</a>
                        <% }%>
                    </div>
                </div>
            </header>

            <main class="flex-grow">
                <div class="max-w-7xl mx-auto p-6 lg:p-8 mt-6">
                    <div class="center-content">
                        <!-- Glide Carousel -->
                        <div class="glide">
                            <div class="glide__track" data-glide-el="track">
                                <div class="glide__slides">
                                    <div class="glide__slide">
                                        <img src="${pageContext.request.contextPath}/imagen/img1.png" alt="Banner 1" class="w-full" />
                                    </div>
                                    <div class="glide__slide">
                                        <img src="${pageContext.request.contextPath}/imagen/img2.png" alt="Banner 2" class="w-full" />
                                    </div>
                                    <div class="glide__slide">
                                        <img src="${pageContext.request.contextPath}/imagen/img3.png" alt="Banner 3" class="w-full" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <form action="<%= request.getContextPath()%>/buscar" method="GET" class="flex items-center border rounded-lg overflow-hidden mb-8 mt-6">
                        <input type="text" name="nombre" placeholder="Buscar..." class="px-4 py-2 flex-1 outline-none">
                        <button type="submit" class="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4">Buscar</button>
                    </form>

                    <% String termino = request.getParameter("termino");
                        if (termino != null && !termino.isEmpty()) {%>
                    <h2 class="text-xl font-semibold mb-4">Resultados de la búsqueda para "<%= termino%>"</h2>
                    <% } %>

                    <% List<?> publicaciones = (List<?>) request.getAttribute("publicaciones");
                        if (publicaciones != null && !publicaciones.isEmpty()) { %>
                    <h1 class="grande">Todas las Publicaciones</h1>
                    <%-- Iterar sobre las publicaciones para mostrar cada una con su imagen --%>
                    <div class="grid sm:grid-cols-1 md:grid-cols-3 lg:grid-cols-3 xl:grid-cols-3 gap-5">
                        <% for (Object obj : publicaciones) {
                                Publicaciones publicacion = (Publicaciones) obj;%>
                        <div class="min-h-max flex items-center justify-center">
                            <div class="container mx-auto text-center">
                                <div class="max-w-sm mx-auto mb-8 bg-white rounded-lg overflow-hidden shadow-md">
                                    <%-- Mostrar la imagen en formato Base64 --%>
                                    <img src="<%= request.getContextPath()%>/images/Lechugaitaliana.png" alt="Imagen de Prueba">
                                    <div class="p-4">
                                        <div class="text-gray-900 font-bold text-xl mb-2"><%= publicacion.getTitulo().substring(0, Math.min(50, publicacion.getTitulo().length()))%></div>
                                        <p class="text-gray-700 text-base"><%= publicacion.getContenido().substring(0, Math.min(150, publicacion.getContenido().length()))%></p>
                                        <p class="text-sm text-gray-900 leading-none">Publicado por: <%= publicacion.getUserId().getNombre()%></p>
                                        <div class="flex justify-center mt-4 space-x-4">
                                            <% if (publicacion.getUserId().getNumeroW() != null) {%>
                                            <a href="https://api.whatsapp.com/send?phone=<%= publicacion.getUserId().getNumeroW()%>" target="_blank" class="inline-block bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded-full">
                                                <i class="fab fa-whatsapp"></i> WhatsApp
                                            </a>
                                            <% } %>
                                            <% if (publicacion.getUserId().getUbicacion() != null) {%>
                                            <a href="https://www.google.com/maps/search/?api=1&query=<%= URLEncoder.encode(publicacion.getUserId().getUbicacion(), "UTF-8")%>" target="_blank" class="inline-block bg-orange-500 hover:bg-orange-600 text-white font-bold py-2 px-4 rounded-full">
                                                <i class="fas fa-map-marked"></i> Ver Ubicación
                                            </a>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>

                    <% }%>
                </div>
            </main>

            <footer class="bg-white shadow mt-10">
                <div class="max-w-7xl mx-auto p-4">
                    <div class="text-center text-gray-600">
                        <p>&copy; 2024 ChacrasSJ. Todos los derechos reservados.</p>
                    </div>
                </div>
            </footer>
        </div>

        <script>
            // Inicializar Glide.js
            new Glide('.glide').mount();
        </script>
    </body>
</html>
