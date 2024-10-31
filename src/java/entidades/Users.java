/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entidades;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.persistence.UniqueConstraint;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author Juan Pablo
 */
@Entity
@Table(name = "users", catalog = "bdchacras", schema = "", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"email"})})
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Users.findAll", query = "SELECT u FROM Users u"),
    @NamedQuery(name = "Users.findById", query = "SELECT u FROM Users u WHERE u.id = :id"),
    @NamedQuery(name = "Users.findByNombre", query = "SELECT u FROM Users u WHERE u.nombre = :nombre"),
    @NamedQuery(name = "Users.findByDocumento", query = "SELECT u FROM Users u WHERE u.documento = :documento"),
    @NamedQuery(name = "Users.findByNumeroW", query = "SELECT u FROM Users u WHERE u.numeroW = :numeroW"),
    @NamedQuery(name = "Users.findByUbicacion", query = "SELECT u FROM Users u WHERE u.ubicacion = :ubicacion"),
    @NamedQuery(name = "Users.findByEmail", query = "SELECT u FROM Users u WHERE u.email = :email"),
    @NamedQuery(name = "Users.findByEmailVerifiedAt", query = "SELECT u FROM Users u WHERE u.emailVerifiedAt = :emailVerifiedAt"),
    @NamedQuery(name = "Users.findByPassword", query = "SELECT u FROM Users u WHERE u.password = :password"),
    @NamedQuery(name = "Users.findByRememberToken", query = "SELECT u FROM Users u WHERE u.rememberToken = :rememberToken"),
    @NamedQuery(name = "Users.findByBloqueado", query = "SELECT u FROM Users u WHERE u.bloqueado = :bloqueado"),
    @NamedQuery(name = "Users.findByEsAdministrador", query = "SELECT u FROM Users u WHERE u.esAdministrador = :esAdministrador"),
    @NamedQuery(name = "Users.findByEsPublicador", query = "SELECT u FROM Users u WHERE u.esPublicador = :esPublicador"),
    @NamedQuery(name = "Users.findByCreatedAt", query = "SELECT u FROM Users u WHERE u.createdAt = :createdAt"),
    @NamedQuery(name = "Users.findByDeletedAt", query = "SELECT u FROM Users u WHERE u.deletedAt = :deletedAt"),
    @NamedQuery(name = "Users.findByUpdatedAt", query = "SELECT u FROM Users u WHERE u.updatedAt = :updatedAt")})
public class Users implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id", nullable = false)
    private Long id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "nombre", nullable = false, length = 255)
    private String nombre;
    @Basic(optional = false)
    @NotNull
    @Column(name = "documento", nullable = false)
    private int documento;
    @Size(max = 255)
    @Column(name = "numero_W", length = 255)
    private String numeroW;
    @Size(max = 255)
    @Column(name = "ubicacion", length = 255)
    private String ubicacion;
    // @Pattern(regexp="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", message="Invalid email")//if the field contains email address consider using this annotation to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "email", nullable = false, length = 255)
    private String email;
    @Column(name = "email_verified_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date emailVerifiedAt;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "password", nullable = false, length = 255)
    private String password;
    @Size(max = 100)
    @Column(name = "remember_token", length = 100)
    private String rememberToken;
    @Lob
    @Size(max = 65535)
    @Column(name = "mensaje", length = 65535)
    private String mensaje;
    @Basic(optional = false)
    @NotNull
    @Column(name = "bloqueado", nullable = false)
    private boolean bloqueado;
    @Basic(optional = false)
    @NotNull
    @Column(name = "es_administrador", nullable = false)
    private boolean esAdministrador;
    @Basic(optional = false)
    @NotNull
    @Column(name = "es_publicador", nullable = false)
    private boolean esPublicador;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "deleted_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date deletedAt;
    @Column(name = "updated_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "userId")
    private Collection<Publicaciones> publicacionesCollection;

    public Users() {
    }

    public Users(Long id) {
        this.id = id;
    }

    public Users(Long id, String nombre, int documento, String email, String password, boolean bloqueado, boolean esAdministrador, boolean esPublicador) {
        this.id = id;
        this.nombre = nombre;
        this.documento = documento;
        this.email = email;
        this.password = password;
        this.bloqueado = bloqueado;
        this.esAdministrador = esAdministrador;
        this.esPublicador = esPublicador;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getDocumento() {
        return documento;
    }

    public void setDocumento(int documento) {
        this.documento = documento;
    }

    public String getNumeroW() {
        return numeroW;
    }

    public void setNumeroW(String numeroW) {
        this.numeroW = numeroW;
    }

    public String getUbicacion() {
        return ubicacion;
    }

    public void setUbicacion(String ubicacion) {
        this.ubicacion = ubicacion;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Date getEmailVerifiedAt() {
        return emailVerifiedAt;
    }

    public void setEmailVerifiedAt(Date emailVerifiedAt) {
        this.emailVerifiedAt = emailVerifiedAt;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRememberToken() {
        return rememberToken;
    }

    public void setRememberToken(String rememberToken) {
        this.rememberToken = rememberToken;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public boolean getBloqueado() {
        return bloqueado;
    }

    public void setBloqueado(boolean bloqueado) {
        this.bloqueado = bloqueado;
    }

    public boolean getEsAdministrador() {
        return esAdministrador;
    }

    public void setEsAdministrador(boolean esAdministrador) {
        this.esAdministrador = esAdministrador;
    }

    public boolean getEsPublicador() {
        return esPublicador;
    }

    public void setEsPublicador(boolean esPublicador) {
        this.esPublicador = esPublicador;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(Date deletedAt) {
        this.deletedAt = deletedAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    @XmlTransient
    public Collection<Publicaciones> getPublicacionesCollection() {
        return publicacionesCollection;
    }

    public void setPublicacionesCollection(Collection<Publicaciones> publicacionesCollection) {
        this.publicacionesCollection = publicacionesCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Users)) {
            return false;
        }
        Users other = (Users) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entidades.Users[ id=" + id + " ]";
    }

}
