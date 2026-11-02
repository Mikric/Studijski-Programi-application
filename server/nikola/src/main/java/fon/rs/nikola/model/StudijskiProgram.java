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
@Table(name = "studijski_program")
@Getter
@Setter
public class StudijskiProgram {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String naziv;

    @Column(nullable = false)
    private Integer trajanjeGodina;

    @Column(nullable = false)
    private Integer ukupnoEspb; 
}
