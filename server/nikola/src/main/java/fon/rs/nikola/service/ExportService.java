/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package fon.rs.nikola.service;

import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import fon.rs.nikola.model.IzbornaPozicija;
import fon.rs.nikola.model.Modul;
import fon.rs.nikola.model.Predmet;
import fon.rs.nikola.model.PredmetProgram;
import fon.rs.nikola.model.StudijskiProgram;
import fon.rs.nikola.model.TipPredmeta;
import fon.rs.nikola.repository.IzbornaPozicijaRepository;
import fon.rs.nikola.repository.ModulRepository;
import fon.rs.nikola.repository.PredmetProgramRepository;
import fon.rs.nikola.repository.PredmetRepository;
import fon.rs.nikola.repository.StudijskiProgramRepository;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.util.List;
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
public class ExportService {
    private final StudijskiProgramRepository studijskiProgramRepository;
    private final ModulRepository modulRepository;
    private final PredmetProgramRepository predmetProgramRepository;
    private final IzbornaPozicijaRepository izbornaPozicijaRepository;

    public byte[] izvezitProgramUPdf(Long programId) {
        StudijskiProgram program = studijskiProgramRepository.findById(programId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Studijski program koji ima id: " + programId + " ne postoji"));

        List<Modul> moduli = modulRepository.findAll().stream()
                .filter(m -> m.getStudijskiProgram().getId().equals(programId))
                .collect(Collectors.toList());

        // sada filtriramo PONUDE (PredmetProgram), ne gole Predmet-e
        List<PredmetProgram> ponude = predmetProgramRepository.findAll().stream()
                .filter(pp -> pp.getStudijskiProgram().getId().equals(programId))
                .collect(Collectors.toList());

        List<IzbornaPozicija> pozicije = izbornaPozicijaRepository.findAll().stream()
                .filter(iz -> iz.getStudijskiProgram().getId().equals(programId))
                .collect(Collectors.toList());

        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            Document document = new Document();
            PdfWriter.getInstance(document, baos);
            document.open();

            Font naslovFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 20);
            Font sekcijaFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 11);

            document.add(new Paragraph(program.getNaziv(), naslovFont));
            document.add(new Paragraph("Trajanje: " + program.getTrajanjeGodina()
                    + " godine    Ukupno ESPB: " + program.getUkupnoEspb(), normalFont));
            document.add(Chunk.NEWLINE);

            document.add(new Paragraph("Moduli", sekcijaFont));
            if (moduli.isEmpty()) {
                document.add(new Paragraph("Nema modula.", normalFont));
            } else {
                for (Modul m : moduli) {
                    document.add(new Paragraph("- " + m.getNaziv(), normalFont));
                }
            }
            document.add(Chunk.NEWLINE);

            document.add(new Paragraph("ESPB po godinama", sekcijaFont));
            for (int godina = 1; godina <= 4; godina++) {
                final int g = godina;
                int suma = ponude.stream()
                        .filter(pp -> pp.getGodina() == g)
                        .mapToInt(PredmetProgram::getEspb)
                        .sum();
                if (suma > 0) {
                    document.add(new Paragraph(godina + ". godina: " + suma + " ESPB", normalFont));
                }
            }
            document.add(Chunk.NEWLINE);

            document.add(new Paragraph("Obavezni predmeti", sekcijaFont));
            List<PredmetProgram> obavezni = ponude.stream()
                    .filter(pp -> pp.getTip() == TipPredmeta.OBAVEZAN)
                    .collect(Collectors.toList());
            document.add(napraviTabeluPredmeta(obavezni, false, pozicije));
            document.add(Chunk.NEWLINE);

            document.add(new Paragraph("Izborni predmeti", sekcijaFont));
            List<PredmetProgram> izborni = ponude.stream()
                    .filter(pp -> pp.getTip() == TipPredmeta.IZBORNI)
                    .collect(Collectors.toList());
            document.add(napraviTabeluPredmeta(izborni, true, pozicije));
            document.add(Chunk.NEWLINE);

            document.add(new Paragraph("Izborne pozicije", sekcijaFont));
            if (pozicije.isEmpty()) {
                document.add(new Paragraph("Nema izbornih pozicija.", normalFont));
            } else {
                for (IzbornaPozicija poz : pozicije) {
                    String predmetiTeksti = poz.getPonude().stream()
                            .map(pp -> pp.getPredmet().getNaziv())
                            .collect(Collectors.joining(", "));
                    document.add(new Paragraph(poz.getNaziv() + " (bira se "
                            + poz.getBrojPredmetaZaIzbor() + "): "
                            + (predmetiTeksti.isEmpty() ? "nema predmeta" : predmetiTeksti), normalFont));
                }
            }

            document.close();
            return baos.toByteArray();

        } catch (DocumentException e) {
            throw new RuntimeException("Greska pri generisanju PDF-a", e);
        }
    }

    private PdfPTable napraviTabeluPredmeta(List<PredmetProgram> lista, boolean izborni, List<IzbornaPozicija> pozicije) {
        int brojKolona = izborni ? 6 : 5;
        PdfPTable tabela = new PdfPTable(brojKolona);
        tabela.setWidthPercentage(100);
        tabela.setSpacingBefore(8f);
        tabela.setSpacingAfter(12f);

        dodajZaglavlje(tabela, "Naziv");
        dodajZaglavlje(tabela, "Sifra");
        dodajZaglavlje(tabela, "ESPB");
        dodajZaglavlje(tabela, "God./Sem.");
        dodajZaglavlje(tabela, "Modul");
        if (izborni) {
            dodajZaglavlje(tabela, "Izborna pozicija");
        }

        if (lista.isEmpty()) {
            PdfPCell prazno = new PdfPCell(new Phrase("Nema predmeta."));
            prazno.setColspan(brojKolona);
            tabela.addCell(prazno);
        }

        for (PredmetProgram pp : lista) {
            tabela.addCell(pp.getPredmet().getNaziv());
            tabela.addCell(pp.getPredmet().getSifra());
            tabela.addCell(String.valueOf(pp.getEspb()));
            tabela.addCell(pp.getGodina() + "/" + pp.getSemestar());
            tabela.addCell(pp.getModul() != null ? pp.getModul().getNaziv() : "-");
            if (izborni) {
                String nazivPozicije = pozicije.stream()
                        .filter(poz -> poz.getPonude().contains(pp))
                        .map(IzbornaPozicija::getNaziv)
                        .findFirst()
                        .orElse("-");
                tabela.addCell(nazivPozicije);
            }
        }
        return tabela;
    }

    private void dodajZaglavlje(PdfPTable tabela, String tekst) {
        PdfPCell celija = new PdfPCell(new Phrase(tekst));
        celija.setBackgroundColor(new Color(230, 230, 230));
        tabela.addCell(celija);
    }

}
