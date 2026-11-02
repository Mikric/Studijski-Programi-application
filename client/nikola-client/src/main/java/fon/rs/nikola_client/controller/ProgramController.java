/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola_client.controller;

import org.springframework.ui.Model;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author Asus
 */
@Controller
public class ProgramController {
    @GetMapping("/programi")
    public String listaPrograma(){
        return "lista-programa";
    }
    @GetMapping("/programi/{id}")
    public String detaljiPrograma(@PathVariable Long id, Model model) {
        model.addAttribute("programId", id);
        return "detalji-programa";
    }
    @GetMapping("/predmeti")
    public String predmeti(@RequestParam(required = false) Long programId, Model model) {
        model.addAttribute("initialProgramId", programId);
        return "predmeti";
    }
}
