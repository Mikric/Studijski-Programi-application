/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.model;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
/**
 *
 * @author Asus
 */
@Entity
@Table(name = "predmet_program")
@Getter
@Setter
public class PredmetProgram {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "predmet_id", nullable = false)
    private Predmet predmet;

    @ManyToOne
    @JoinColumn(name = "studijski_program_id", nullable = false)
    private StudijskiProgram studijskiProgram;

    @ManyToOne
    @JoinColumn(name = "modul_id")
    private Modul modul;

    @Column(nullable = false)
    private Integer espb;

    @Column(nullable = false)
    private Integer godina;

    @Column(nullable = false)
    private Integer semestar;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipPredmeta tip;
}
