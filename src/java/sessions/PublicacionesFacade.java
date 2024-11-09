/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package sessions;

import entidades.Publicaciones;
import entidades.Users;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.validation.ConstraintViolationException;
import java.util.List;

/**
 *
 * @author Juan Pablo
 */
@Stateless
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
            em.persist(publicacion);
        } catch (Exception e) {
            System.err.println("Error persisting publication: " + e.getMessage());
            throw e;
        }
    }

    public List<Publicaciones> findUltimasPublicaciones() {
        TypedQuery<Publicaciones> query = em.createQuery("SELECT p FROM Publicaciones p", Publicaciones.class);
        query.setMaxResults(10); 
        return query.getResultList();
    }

    public List<Publicaciones> buscarPublicaciones(String termino) {
        TypedQuery<Publicaciones> query = em.createQuery("SELECT p FROM Publicaciones p WHERE p.titulo LIKE :termino", Publicaciones.class);
        query.setParameter("termino", "%" + termino + "%");
        return query.getResultList();
    }

    public List<Publicaciones> obtenerTodasLasPublicaciones() {
        return em.createQuery("SELECT p FROM Publicaciones p", Publicaciones.class).getResultList();
    }

    public List<Publicaciones> findAllPublicaciones() {
        return em.createNamedQuery("Publicaciones.findAll", Publicaciones.class).getResultList();
    }

    public void create(Publicaciones publicaciones) {
        try {
            Users user = em.find(Users.class, publicaciones.getUserId().getId());
            publicaciones.setUserId(user);
            em.persist(publicaciones);
        } catch (ConstraintViolationException e) {
        } catch (Exception e) {
        }
    }

    public List<Publicaciones> obtenerPublicacionesPorUsuario(Long userId) {
        TypedQuery<Publicaciones> query = em.createQuery(
                "SELECT p FROM Publicaciones p WHERE p.userId.id = :userId", Publicaciones.class);
        query.setParameter("userId", userId);
        return query.getResultList();
    }

    public void eliminarPublicacion(Long id) {
        Publicaciones publicacion = em.find(Publicaciones.class, id);
        if (publicacion != null) {
            em.remove(publicacion);
        }
    }

    public Publicaciones obtenerPublicacionPorId(Long id) {
        return em.find(Publicaciones.class, id);
    }

    public void edit(Publicaciones publicacion) {
        if (publicacion == null) {
            throw new IllegalArgumentException("La publicación no puede ser nula");
        }
        try {
            em.merge(publicacion);
        } catch (Exception e) {
            System.err.println("Error updating publication: " + e.getMessage());
            throw e;
        }
    }
}
