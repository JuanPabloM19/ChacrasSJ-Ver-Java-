/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package sessions;

import entidades.Publicaciones;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.ejb.TransactionManagement;
import jakarta.ejb.TransactionManagementType;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;
import java.util.List;

/**
 *
 * @author Juan Pablo
 */
@Stateless
@TransactionManagement(TransactionManagementType.CONTAINER)
public class PublicacionesFacade extends AbstractFacade<Publicaciones> {

    @PersistenceContext(unitName = "ChacrasSJPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public PublicacionesFacade() {
        super(Publicaciones.class);
    }

    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void createPublicacionF(Publicaciones publicacion) {
        if (publicacion == null) {
            throw new IllegalArgumentException("La publicación no puede ser nula");
        }
        try {
            em.persist(publicacion); // Persistir la publicación
        } catch (Exception e) {
            System.err.println("Error persisting publication: " + e.getMessage());
            throw e; // Propagar la excepción
        }
    }

    // Método para obtener las últimas publicaciones
    public List<Publicaciones> findUltimasPublicaciones() {
        TypedQuery<Publicaciones> query = em.createQuery("SELECT p FROM Publicaciones p", Publicaciones.class);
        query.setMaxResults(10); // Limitar a las últimas 10 publicaciones
        return query.getResultList();
    }

    // Método para buscar publicaciones por título o contenido
    public List<Publicaciones> buscarPublicaciones(String termino) {
        TypedQuery<Publicaciones> query = em.createQuery(
                "SELECT p FROM Publicaciones p WHERE LOWER(p.titulo) LIKE LOWER(CONCAT('%', :termino, '%')) OR LOWER(p.contenido) LIKE LOWER(CONCAT('%', :termino, '%'))", Publicaciones.class);
        query.setParameter("termino", termino);
        return query.getResultList();
    }

    // Método para obtener todas las publicaciones
    public List<Publicaciones> obtenerTodasLasPublicaciones() {
        return em.createQuery("SELECT p FROM Publicaciones p", Publicaciones.class).getResultList();
    }

    public List<Publicaciones> findAllPublicaciones() {
        return em.createNamedQuery("Publicaciones.findAll", Publicaciones.class).getResultList();
    }

}
