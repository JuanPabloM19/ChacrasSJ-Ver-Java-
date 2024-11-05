<%@page import="jakarta.persistence.Persistence"%>
<%@page import="jakarta.persistence.EntityManager"%>
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
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> <!-- Importar la biblioteca de funciones -->

<%
    EntityManager em = Persistence.createEntityManagerFactory("ChacrasSJPU").createEntityManager();
    List<Publicaciones> listaPublicaciones = em.createQuery("SELECT p FROM Publicaciones p", Publicaciones.class).getResultList();
    request.setAttribute("listaPublicaciones", listaPublicaciones);
%>

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
                            <a href="${pageContext.request.contextPath}/vista/layouts/welcome.jsp">
                                <img src="${pageContext.request.contextPath}/imagen/logopr.svg" class="block h-9 w-auto" alt="Logo"/>
                            </a>
                        </div>
                    </div>
                    <div class="flex items-center space-x-4"> <!-- Añadir espaciado entre los enlaces -->
                        <% if (session.getAttribute("user") != null) {%>
                        <a href="<%= request.getContextPath()%>/dashboard" class="font-semibold text-gray-600 hover:text-gray-900">Inicio</a>
                        <% } else { %>
                        <a href="${pageContext.request.contextPath}/vista/auth/login.jsp" class="inline-block bg-transparent font-semibold text-gray-600 hover:bg-orange-500 hover:text-gray-900 py-2 px-4 border border-white rounded-lg transition-colors duration-300">Iniciar Sesión</a>
                        <a href="${pageContext.request.contextPath}/vista/auth/register.jsp" class="inline-block bg-transparent font-semibold text-gray-600 hover:bg-orange-500 hover:text-gray-900 py-2 px-4 border border-white rounded-lg transition-colors duration-300">Registrarse</a>
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

                    <form class="flex items-center border rounded-lg overflow-hidden mb-8 mt-6">
                        <input type="text" name="nombre" id="searchInput" placeholder="Buscar..." 
                               class="px-4 py-2 flex-1 outline-none" onkeyup="searchPublications()">
                    </form>

                    <h2 class="text-xl font-semibold mb-4" id="searchResultsTitle"></h2>
                    <div id="searchResults"></div>

                    <h1 class="text-2xl font-semibold mb-6">Todas las Publicaciones</h1>
                    <div class="grid sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                        <c:forEach var="publicacion" items="${listaPublicaciones}">
                            <div class="bg-white rounded-lg overflow-hidden shadow-lg">
                                <!-- Usar el servlet para cargar la imagen -->
                                <img class="w-full h-32 object-cover" 
                                     src="http://localhost:8080/ChacrasSJ/ImageLoaderServlet?imageName=${publicacion.imagen}" 
                                     alt="Imagen de ${publicacion.titulo}">
                                <div class="p-4">
                                    <h3 class="text-xl font-bold text-gray-900 mb-2">
                                        ${fn:length(publicacion.titulo) > 50 ? publicacion.titulo.substring(0, 50) : publicacion.titulo}
                                    </h3>
                                    <p class="text-gray-700">
                                        ${fn:length(publicacion.contenido) > 150 ? publicacion.contenido.substring(0, 150) + '...' : publicacion.contenido}
                                    </p>
                                    <p class="text-sm text-gray-900 mt-2">Publicado por: ${publicacion.userId.nombre}</p>
                                    <div class="flex justify-center mt-4 space-x-4">
                                        <c:if test="${publicacion.userId.numeroW != null}">
                                            <a href="https://api.whatsapp.com/send?phone=${publicacion.userId.numeroW}" 
                                               target="_blank" 
                                               class="inline-block bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded-full">
                                                <i class="fab fa-whatsapp"></i> WhatsApp
                                            </a>
                                        </c:if>
                                        <c:if test="${publicacion.userId.ubicacion != null}">
                                            <a href="https://www.google.com/maps/search/?api=1&query=${fn:escapeXml(publicacion.userId.ubicacion)}" 
                                               target="_blank" 
                                               class="inline-block bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded-full">
                                                <i class="fas fa-map-marked"></i> Ver Ubicación
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

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
