/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.controller;
import fon.rs.nikola.dto.PredmetProgramDto;
import fon.rs.nikola.service.PredmetProgramService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
/**
 *
 * @author Asus
 */
@RestController
@RequestMapping("/api/predmet-program")
@RequiredArgsConstructor
public class PredmetProgramController {
    private final PredmetProgramService service;

    @GetMapping
    public ResponseEntity<List<PredmetProgramDto>> findAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<PredmetProgramDto> findById(@PathVariable Long id) {
        return ResponseEntity.ok(service.findById(id));
    }

    @PostMapping
    public ResponseEntity<PredmetProgramDto> create(@Valid @RequestBody PredmetProgramDto dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<PredmetProgramDto> update(@PathVariable Long id, @Valid @RequestBody PredmetProgramDto dto) {
        return ResponseEntity.ok(service.update(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
