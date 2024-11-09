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

    private static final String IMAGE_DIRECTORY = "D:\\ChacrasSJNETBEANS\\ChacrasSJ\\web\\cargaIMG\\uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener el nombre de la imagen desde el parámetro de la solicitud
        String imageName = request.getParameter("imageName");

        // Construir la ruta completa de la imagen
        File imageFile = new File(IMAGE_DIRECTORY, imageName);

        if (imageFile.exists() && imageFile.isFile()) {
            response.setContentType("image/jpeg");
            Files.copy(imageFile.toPath(), response.getOutputStream());
            response.getOutputStream().flush();
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "La imagen no fue encontrada en el servidor.");
        }
    }
}
