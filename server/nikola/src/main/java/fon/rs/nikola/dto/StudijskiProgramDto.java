/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

/**
 *
 * @author Asus
 */
@Getter
@Setter
public class StudijskiProgramDto {
    private Long id;

    @NotBlank(message = "Naziv je obavezan")
    private String naziv;

    @NotNull(message = "Trajanje je obavezno")
    @Min(value = 3, message = "Trajanje mora biti 3 ili 4 godine")
    @Max(value = 4, message = "Trajanje mora biti 3 ili 4 godine")
    private Integer trajanjeGodina;

    @NotNull(message = "Ukupno ESPB je obavezno")
    private Integer ukupnoEspb;
}
