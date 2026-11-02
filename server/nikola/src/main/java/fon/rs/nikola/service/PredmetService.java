/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.service;

import fon.rs.nikola.dto.PredmetDto;
import fon.rs.nikola.model.Modul;
import fon.rs.nikola.model.Predmet;
import fon.rs.nikola.model.StudijskiProgram;
import fon.rs.nikola.repository.ModulRepository;
import fon.rs.nikola.repository.PredmetRepository;
import fon.rs.nikola.repository.StudijskiProgramRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

/**
 *
 * @author Asus
 */
@Service
@RequiredArgsConstructor
public class PredmetService {
    private final PredmetRepository repository;

    public List<PredmetDto> findAll() {
        return repository.findAll().stream().map(this::toDto).toList();
    }

    public PredmetDto findById(Long id) {
        return toDto(repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Predmet koji ima id: " + id + " ne postoji")));
    }

    public PredmetDto create(PredmetDto dto) {
        Predmet entity = new Predmet();
        entity.setNaziv(dto.getNaziv());
        entity.setSifra(dto.getSifra());
        return toDto(repository.save(entity));
    }

    public PredmetDto update(Long id, PredmetDto dto) {
        Predmet entity = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Predmet koji ima id: " + id + " ne postoji"));
        entity.setNaziv(dto.getNaziv());
        entity.setSifra(dto.getSifra());
        return toDto(repository.save(entity));
    }

    public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                    "Predmet koji ima id: " + id + " ne postoji");
        }
        repository.deleteById(id);
    }

    private PredmetDto toDto(Predmet entity) {
        PredmetDto dto = new PredmetDto();
        dto.setId(entity.getId());
        dto.setNaziv(entity.getNaziv());
        dto.setSifra(entity.getSifra());
        return dto;
    }
}
