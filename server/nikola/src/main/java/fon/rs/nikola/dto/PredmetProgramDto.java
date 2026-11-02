/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.dto;
import fon.rs.nikola.model.TipPredmeta;
import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;
/**
 *
 * @author Asus
 */
@Getter
@Setter
public class PredmetProgramDto {
    private Long id;

    @NotNull(message = "Predmet je obavezan")
    private Long predmetId;

    private String predmetNaziv;
    private String predmetSifra;

    @NotNull(message = "Studijski program je obavezan")
    private Long studijskiProgramId;

    private Long modulId;

    @NotNull(message = "ESPB je obavezan")
    @Min(value = 1, message = "ESPB mora biti veci od 0")
    private Integer espb;

    @NotNull(message = "Godina je obavezna")
    @Min(value = 1, message = "Godina mora biti izmedju 1 i 4")
    @Max(value = 4, message = "Godina mora biti izmedju 1 i 4")
    private Integer godina;

    @NotNull(message = "Semestar je obavezan")
    @Min(value = 1, message = "Semestar mora biti 1 ili 2")
    @Max(value = 2, message = "Semestar mora biti 1 ili 2")
    private Integer semestar;

    @NotNull(message = "Tip predmeta je obavezan")
    private TipPredmeta tip;
}
