package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@WebServlet("/ImageLoaderServlet")
public class ImageLoaderServlet extends HttpServlet {

    // Ruta base para las imágenes
    private static final String IMAGE_DIRECTORY = "D:\\ChacrasSJNETBEANS\\ChacrasSJ\\web\\cargaIMG\\uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener el nombre de la imagen desde el parámetro de la solicitud
        String imageName = request.getParameter("imageName");

        // Construir la ruta completa de la imagen
        File imageFile = new File(IMAGE_DIRECTORY, imageName);

        // Verificar si el archivo existe y es un archivo válido
        if (imageFile.exists() && imageFile.isFile()) {
            // Configurar el tipo de contenido de respuesta según el tipo de archivo
            response.setContentType("image/jpeg");

            // Copiar el archivo en el flujo de salida de la respuesta
            Files.copy(imageFile.toPath(), response.getOutputStream());

            // Asegurar que el flujo de salida se vacía completamente
            response.getOutputStream().flush();
        } else {
            // Enviar un error 404 si la imagen no se encuentra
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "La imagen no fue encontrada en el servidor.");
        }
    }
}
