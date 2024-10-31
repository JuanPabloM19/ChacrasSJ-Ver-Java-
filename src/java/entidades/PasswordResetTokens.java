/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entidades;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author Juan Pablo
 */
@Entity
@Table(name = "password_reset_tokens", catalog = "bdchacras", schema = "")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "PasswordResetTokens.findAll", query = "SELECT p FROM PasswordResetTokens p"),
    @NamedQuery(name = "PasswordResetTokens.findByEmail", query = "SELECT p FROM PasswordResetTokens p WHERE p.email = :email"),
    @NamedQuery(name = "PasswordResetTokens.findByToken", query = "SELECT p FROM PasswordResetTokens p WHERE p.token = :token"),
    @NamedQuery(name = "PasswordResetTokens.findByCreatedAt", query = "SELECT p FROM PasswordResetTokens p WHERE p.createdAt = :createdAt")})
public class PasswordResetTokens implements Serializable {

    private static final long serialVersionUID = 1L;
    // @Pattern(regexp="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", message="Invalid email")//if the field contains email address consider using this annotation to enforce field validation
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "email", nullable = false, length = 255)
    private String email;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "token", nullable = false, length = 255)
    private String token;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    public PasswordResetTokens() {
    }

    public PasswordResetTokens(String email) {
        this.email = email;
    }

    public PasswordResetTokens(String email, String token) {
        this.email = email;
        this.token = token;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (email != null ? email.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof PasswordResetTokens)) {
            return false;
        }
        PasswordResetTokens other = (PasswordResetTokens) object;
        if ((this.email == null && other.email != null) || (this.email != null && !this.email.equals(other.email))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entidades.PasswordResetTokens[ email=" + email + " ]";
    }
    
}
