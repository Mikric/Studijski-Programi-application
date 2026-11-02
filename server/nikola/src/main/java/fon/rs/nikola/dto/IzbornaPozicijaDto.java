/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.util.Set;
import lombok.Getter;
import lombok.Setter;

/**
 *
 * @author Asus
 */
@Getter
@Setter
public class IzbornaPozicijaDto {
    private Long id;
    @NotBlank(message = "Naziv je obavezan")
    private String naziv;

    @NotNull(message = "Broj predmeta za izbor je obavezan")
    @Min(value = 1, message = "Mora se izabrati bar 1 predmet")
    private Integer brojPredmetaZaIzbor;

    @NotNull(message = "Studijski program je obavezan")
    private Long studijskiProgramId;
    private Set<Long> ponudeIds;
}
