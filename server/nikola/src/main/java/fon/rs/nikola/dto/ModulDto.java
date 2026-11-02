/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.dto;

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
public class ModulDto {
    private Long id;
    @NotBlank(message = "Naziv je obavezan")
    private String naziv;

    @NotNull(message = "Studijski program je obavezan")
    private Long studijskiProgramId;
}
