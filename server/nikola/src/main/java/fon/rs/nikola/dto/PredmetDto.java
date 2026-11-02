/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.dto;

import fon.rs.nikola.model.TipPredmeta;
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
public class PredmetDto {
    private Long id;

    @NotBlank(message = "Naziv je obavezan")
    private String naziv;

    @NotBlank(message = "Sifra je obavezna")
    private String sifra;
}
