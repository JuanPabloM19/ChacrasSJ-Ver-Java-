<%@page import="entidades.Publicaciones"%>
<%@page import="jakarta.servlet.jsp.JspWriter"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Publicaciones</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/estilo.css">
    </head>
    <body>
        <!-- Navbar -->
        <jsp:include page="/vista/layouts/navbar.jsp" />
        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">

                <!-- Mensaje de éxito -->
                <%
                    String successMessage = (String) session.getAttribute("success");
                    if (successMessage != null) {
                %>
                <div class="max-w-md mx-auto bg-green-400 text-gray-800 font-extrabold p-4 rounded-lg mb-6">
                    <%= successMessage%>
                </div>
                <%
                        session.removeAttribute("success");
                    }
                %>

                <!-- Botón para crear nueva publicación -->
                <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg mb-6">
                    <div class="p-6 text-gray-900 dark:text-gray-100">
                        <div>
                            <a href="create.jsp">
                                <button class="mb-3 btn-custom p-2 rounded-lg transition duration-300 w-full">Crear publicación</button>
                            </a>
                            <a href="edit.jsp">
                                <button class="mb-3 btn-custom p-2 rounded-lg transition duration-300 w-full">Editar publicación</button>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
