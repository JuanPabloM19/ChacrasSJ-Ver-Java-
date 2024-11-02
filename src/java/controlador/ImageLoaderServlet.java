package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Base64;

@WebServlet("/imageLoader")
public class ImageLoaderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setHeader("Access-Control-Allow-Origin", "*"); // Permitir todos los orígenes

        String imageName = request.getParameter("image");
        File imageFile = new File("C:/uploads/" + imageName); // Ruta completa a la imagen

        if (!imageFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Imagen no encontrada: " + imageFile.getAbsolutePath());
            return;
        }

        response.setContentType("image/png"); // o image/jpeg si es JPEG
        response.setContentLength((int) imageFile.length());

        try (FileInputStream fis = new FileInputStream(imageFile); ServletOutputStream outputStream = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al cargar la imagen: " + e.getMessage());
        }
    }
}
