/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.service;

import fon.rs.nikola.dto.IzbornaPozicijaDto;
import fon.rs.nikola.model.IzbornaPozicija;
import fon.rs.nikola.model.PredmetProgram;
import fon.rs.nikola.model.StudijskiProgram;
import fon.rs.nikola.repository.IzbornaPozicijaRepository;
import fon.rs.nikola.repository.PredmetProgramRepository;
import fon.rs.nikola.repository.StudijskiProgramRepository;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
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
public class IzbornaPozicijaService {
    private final IzbornaPozicijaRepository repository;
    private final StudijskiProgramRepository studijskiProgramRepository;
    private final PredmetProgramRepository predmetProgramRepository;

    public List<IzbornaPozicijaDto> findAll() {
        return repository.findAll().stream().map(this::toDto).toList();
    }

    public IzbornaPozicijaDto findById(Long id) {
        return toDto(repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Izborna pozicija koja ima id: " + id + " ne postoji")));
    }

    public IzbornaPozicijaDto create(IzbornaPozicijaDto dto) {
        IzbornaPozicija entity = new IzbornaPozicija();
        mapDtoToEntity(dto, entity);
        return toDto(repository.save(entity));
    }

    public IzbornaPozicijaDto update(Long id, IzbornaPozicijaDto dto) {
        IzbornaPozicija entity = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Izborna pozicija koja ima id: " + id + " ne postoji"));
        mapDtoToEntity(dto, entity);
        return toDto(repository.save(entity));
    }

    public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                    "Izborna pozicija koja ima id: " + id + " ne postoji");
        }
        repository.deleteById(id);
    }

    private void mapDtoToEntity(IzbornaPozicijaDto dto, IzbornaPozicija entity) {
        entity.setNaziv(dto.getNaziv());
        entity.setBrojPredmetaZaIzbor(dto.getBrojPredmetaZaIzbor());

        StudijskiProgram program = studijskiProgramRepository.findById(dto.getStudijskiProgramId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Studijski program koji ima id: " + dto.getStudijskiProgramId() + " ne postoji"));
        entity.setStudijskiProgram(program);

        Set<PredmetProgram> ponude = new HashSet<>();
        if (dto.getPonudeIds() != null) {
            for (Long ponudaId : dto.getPonudeIds()) {
                PredmetProgram ponuda = predmetProgramRepository.findById(ponudaId)
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                                "Ponuda predmeta koja ima id: " + ponudaId + " ne postoji"));
                ponude.add(ponuda);
            }
        }
        entity.setPonude(ponude);
    }

    private IzbornaPozicijaDto toDto(IzbornaPozicija entity) {
        IzbornaPozicijaDto dto = new IzbornaPozicijaDto();
        dto.setId(entity.getId());
        dto.setNaziv(entity.getNaziv());
        dto.setBrojPredmetaZaIzbor(entity.getBrojPredmetaZaIzbor());
        dto.setStudijskiProgramId(entity.getStudijskiProgram().getId());
        dto.setPonudeIds(entity.getPonude().stream()
                .map(PredmetProgram::getId)
                .collect(Collectors.toSet()));
        return dto;
    }
}
