/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.service;
import fon.rs.nikola.dto.PredmetProgramDto;
import fon.rs.nikola.model.*;
import fon.rs.nikola.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;


/**
 *
 * @author Asus
 */
@Service
@RequiredArgsConstructor
public class PredmetProgramService {
    private final PredmetProgramRepository repository;
    private final PredmetRepository predmetRepository;
    private final StudijskiProgramRepository studijskiProgramRepository;
    private final ModulRepository modulRepository;

    public List<PredmetProgramDto> findAll() {
        return repository.findAll().stream().map(this::toDto).toList();
    }

    public PredmetProgramDto findById(Long id) {
        return toDto(repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Ponuda predmeta koja ima id: " + id + " ne postoji")));
    }

    public PredmetProgramDto create(PredmetProgramDto dto) {
        PredmetProgram entity = new PredmetProgram();
        mapDtoToEntity(dto, entity);
        return toDto(repository.save(entity));
    }

    public PredmetProgramDto update(Long id, PredmetProgramDto dto) {
        PredmetProgram entity = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Ponuda predmeta koja ima id: " + id + " ne postoji"));
        mapDtoToEntity(dto, entity);
        return toDto(repository.save(entity));
    }

    public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                    "Ponuda predmeta koja ima id: " + id + " ne postoji");
        }
        repository.deleteById(id);
    }

    private void mapDtoToEntity(PredmetProgramDto dto, PredmetProgram entity) {
        Predmet predmet = predmetRepository.findById(dto.getPredmetId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Predmet koji ima id: " + dto.getPredmetId() + " ne postoji"));
        entity.setPredmet(predmet);

        StudijskiProgram program = studijskiProgramRepository.findById(dto.getStudijskiProgramId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Studijski program koji ima id: " + dto.getStudijskiProgramId() + " ne postoji"));
        entity.setStudijskiProgram(program);

        if (dto.getModulId() != null) {
            Modul modul = modulRepository.findById(dto.getModulId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                            "Modul koji ima id: " + dto.getModulId() + " ne postoji"));
            entity.setModul(modul);
        } else {
            entity.setModul(null);
        }

        entity.setEspb(dto.getEspb());
        entity.setGodina(dto.getGodina());
        entity.setSemestar(dto.getSemestar());
        entity.setTip(dto.getTip());
    }

    private PredmetProgramDto toDto(PredmetProgram entity) {
        PredmetProgramDto dto = new PredmetProgramDto();
        dto.setId(entity.getId());
        dto.setPredmetId(entity.getPredmet().getId());
        dto.setPredmetNaziv(entity.getPredmet().getNaziv());
        dto.setPredmetSifra(entity.getPredmet().getSifra());
        dto.setStudijskiProgramId(entity.getStudijskiProgram().getId());
        dto.setModulId(entity.getModul() != null ? entity.getModul().getId() : null);
        dto.setEspb(entity.getEspb());
        dto.setGodina(entity.getGodina());
        dto.setSemestar(entity.getSemestar());
        dto.setTip(entity.getTip());
        return dto;
    }
}
