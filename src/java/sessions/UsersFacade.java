/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package sessions;

import entidades.Users;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 *
 * @author Juan Pablo
 */
@Stateless
public class UsersFacade extends AbstractFacade<Users> {

    @PersistenceContext(unitName = "ChacrasSJPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public UsersFacade() {
        super(Users.class);
    }

    public Users findByEmail(String email) {
        try {
            TypedQuery<Users> query = em.createNamedQuery("Users.findByEmail", Users.class);
            query.setParameter("email", email);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    public List<Users> findUsuariosBloqueados() {
        return em.createQuery("SELECT u FROM Users u WHERE u.bloqueado = true", Users.class)
                .getResultList();
    }

    public boolean cambiarContrasena(Long userId, String nuevaContrasena) {
        try {
            Users user = em.find(Users.class, userId);
            if (user != null) {
                user.setPassword(nuevaContrasena);
                em.merge(user);
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void eliminarUsuario(Long id) {
        Users usuario = em.find(Users.class, id);
        if (usuario != null) {
            em.remove(usuario);
            em.flush();  // Sincroniza la eliminación con la base de datos
            em.clear();  // Limpia el contexto de persistencia para evitar usar datos obsoletos
        }
    }

    public List<Users> obtenerTodasLosUsers() {
        em.clear(); // Limpiar el contexto de persistencia antes de obtener los datos
        return em.createQuery("SELECT u FROM Users u", Users.class)
                .setHint("javax.persistence.cache.storeMode", "REFRESH") // Evita usar caché obsoleta
                .getResultList();
    }

}
