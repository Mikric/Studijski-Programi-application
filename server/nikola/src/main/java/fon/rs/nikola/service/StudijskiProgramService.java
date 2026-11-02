/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.service;

import fon.rs.nikola.dto.StudijskiProgramDto;
import fon.rs.nikola.model.StudijskiProgram;
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
public class StudijskiProgramService {
    private final StudijskiProgramRepository repository;
    
    public List<StudijskiProgramDto> findAll() {
        return repository.findAll().stream()
                .map(this::toDto)
                .toList();
    }
    
    public StudijskiProgramDto findById(Long id) {
        StudijskiProgram entity = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Studijski program koji ima id:  " + id + " ne postoji"));
        return toDto(entity);
    }
    
    public StudijskiProgramDto create(StudijskiProgramDto dto) {
        StudijskiProgram entity = new StudijskiProgram();
        entity.setNaziv(dto.getNaziv());
        entity.setTrajanjeGodina(dto.getTrajanjeGodina());
        entity.setUkupnoEspb(dto.getUkupnoEspb());
        StudijskiProgram saved = repository.save(entity);
        return toDto(saved);
    }
    
    public StudijskiProgramDto update(Long id, StudijskiProgramDto dto) {
        StudijskiProgram entity = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Studijski program koji ima id:  " + id + " ne postoji"));
        entity.setNaziv(dto.getNaziv());
        entity.setTrajanjeGodina(dto.getTrajanjeGodina());
        entity.setUkupnoEspb(dto.getUkupnoEspb());
        StudijskiProgram saved = repository.save(entity);
        return toDto(saved);
    }
    
     public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                    "Studijski program koji ima id:  " + id + " ne postoji");
        }
        repository.deleteById(id);
    }
    
    private StudijskiProgramDto toDto(StudijskiProgram entity) {
        StudijskiProgramDto dto = new StudijskiProgramDto();
        dto.setId(entity.getId());
        dto.setNaziv(entity.getNaziv());
        dto.setTrajanjeGodina(entity.getTrajanjeGodina());
        dto.setUkupnoEspb(entity.getUkupnoEspb());
        return dto;
    }
}
