/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Asus
 */
@Entity
@Table(name = "izborna_pozicija")
@Getter
@Setter
public class IzbornaPozicija {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String naziv;   

    @Column(nullable = false)
    private Integer brojPredmetaZaIzbor;

    @ManyToOne
    @JoinColumn(name = "studijski_program_id", nullable = false)
    private StudijskiProgram studijskiProgram;

    @ManyToMany
    @JoinTable(
        name = "izborna_pozicija_ponuda",
        joinColumns = @JoinColumn(name = "izborna_pozicija_id"),
        inverseJoinColumns = @JoinColumn(name = "predmet_program_id")
    )
    private Set<PredmetProgram> ponude = new HashSet<>();
}
