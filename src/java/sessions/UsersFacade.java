package sessions;

import entidades.Users;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;

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
            return null; // Devuelve null si no se encuentra el usuario
        }
    }

    public List<Users> findUsuariosNoAceptados() {
        return em.createQuery("SELECT u FROM Users u WHERE u.aceptado = false", Users.class).getResultList();
    }

    public List<Users> findUsuariosBloqueados() {
        return em.createQuery("SELECT u FROM Users u WHERE u.bloqueado = true", Users.class)
                .getResultList();
    }

}
