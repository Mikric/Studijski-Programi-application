/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.service;

import fon.rs.nikola.dto.ModulDto;
import fon.rs.nikola.model.Modul;
import fon.rs.nikola.model.StudijskiProgram;
import fon.rs.nikola.repository.ModulRepository;
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
public class ModulService {
    private final ModulRepository repository;
    private final StudijskiProgramRepository studijskiProgramRepository;
    
    public List<ModulDto> findAll() {
        return repository.findAll().stream()
                .map(this::toDto)
                .toList();
    }
    
    public ModulDto findById(Long id) {
        Modul entity = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Modul koji ima id: " + id + " ne postoji"));
        return toDto(entity);
    }
    
    public ModulDto create(ModulDto dto) {
        Modul entity = new Modul();
        entity.setNaziv(dto.getNaziv());
        entity.setStudijskiProgram(findStudijskiProgram(dto.getStudijskiProgramId()));
        Modul saved = repository.save(entity);
        return toDto(saved);
    }
    
    public ModulDto update(Long id, ModulDto dto) {
        Modul entity = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Modul kojima ima id: " + id + " ne postoji"));
        entity.setNaziv(dto.getNaziv());
        entity.setStudijskiProgram(findStudijskiProgram(dto.getStudijskiProgramId()));
        Modul saved = repository.save(entity);
        return toDto(saved);
    }
    
    public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                    "Modul kojima ima id: " + id + " ne postoji");
        }
        repository.deleteById(id);
    }
    
    private StudijskiProgram findStudijskiProgram(Long id) {
        return studijskiProgramRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Studijski program koji ima id: " + id + " ne postoji"));
    }
    
    private ModulDto toDto(Modul entity) {
        ModulDto dto = new ModulDto();
        dto.setId(entity.getId());
        dto.setNaziv(entity.getNaziv());
        dto.setStudijskiProgramId(entity.getStudijskiProgram().getId());
        return dto;
    }
}
