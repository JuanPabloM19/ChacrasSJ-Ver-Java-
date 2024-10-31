/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package sessions;

import entidades.PersonalAccessTokens;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

/**
 *
 * @author Juan Pablo
 */
@Stateless
public class PersonalAccessTokensFacade extends AbstractFacade<PersonalAccessTokens> {

    @PersistenceContext(unitName = "ChacrasSJPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public PersonalAccessTokensFacade() {
        super(PersonalAccessTokens.class);
    }
    
}
