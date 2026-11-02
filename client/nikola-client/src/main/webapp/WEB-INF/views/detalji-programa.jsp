<%--
    Document   : detalji-programa
    Created on : Aug 4, 2026
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Detalji studijskog programa</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    </head>
    <body>
        <div class="page-shell">
            <a href="<%= request.getContextPath() %>/programi" class="back-link">Nazad na programe</a>

            <header class="page-header">
                <div>
                    <p class="eyebrow">Fakultet organizacionih nauka</p>
                    <h1 id="naziv-programa">Ucitavanje...</h1>
                    <p>Pregled studijskog programa i njegovih modula.</p>
                </div>
                <div class="badge-count">
                    <span id="broj-moduli">0</span>
                    <span>modula</span>
                </div>
            </header>

            <section class="stats-row">
                <div class="stat-card">
                    <span class="stat-label">Trajanje</span>
                    <span class="stat-value" id="detalji-trajanje">-</span>
                </div>
                <div class="stat-card">
                    <span class="stat-label">Ukupno ESPB</span>
                    <span class="stat-value" id="detalji-espb">-</span>
                </div>
            </section>

            <p class="section-label">ESPB po godini studija</p>
            <section class="stats-row" id="stats-espb-po-godini">
            </section>
            <div id="espb-upozorenje" style="margin-bottom: 32px;"></div>

            <section class="form-card">
                <h2>Dodaj modul</h2>
                <form id="forma-modul">
                    <input type="hidden" id="modul-id">
                    <div class="field-group">
                        <label for="naziv-modula">Naziv modula</label>
                        <input type="text" id="naziv-modula" class="form-input" placeholder="npr. Baze podataka" required>
                    </div>
                    <div class="field-group form-actions-group" style="flex: 0 0 auto;">
                        <span class="field-spacer">&nbsp;</span>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary" id="dugme-dodaj-modul">Dodaj modul</button>
                            <button type="button" class="btn btn-ghost" id="dugme-otkazi-modul" style="display:none;">Otkazi</button>
                        </div>
                    </div>
                </form>
            </section>

            <section class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Naziv modula</th>
                            <th>Akcije</th>
                        </tr>
                    </thead>
                    <tbody id="tabela-moduli">
                    </tbody>
                </table>
            </section>
        </div>

        <script>
        const PROGRAM_ID = '<%= request.getAttribute("programId") %>';
        const API_PROGRAMI = 'http://localhost:8080/api/studijski-programi';
        const API_MODULI = 'http://localhost:8080/api/moduli';
        // PROMENA: ranije je ovde bio API_PREDMETI ('/api/predmeti'), sto vise ne sadrzi
        // studijskiProgramId/godina/espb posle razdvajanja na Predmet (sifarnik) i PredmetProgram (ponuda).
        const API_PREDMET_PROGRAMI = 'http://localhost:8080/api/predmet-program';
        const API_IZBORNE_POZICIJE = 'http://localhost:8080/api/izborne-pozicije';

        let trenutniProgram = null;

        function ucitajProgram() {
            fetch(API_PROGRAMI)
                .then(response => response.json())
                .then(programi => {
                    const program = programi.find(p => p.id == PROGRAM_ID);
                    if (!program) {
                        document.getElementById('naziv-programa').textContent = 'Program nije pronadjen';
                        return;
                    }
                    trenutniProgram = program;
                    document.getElementById('naziv-programa').textContent = program.naziv;
                    document.getElementById('detalji-trajanje').textContent = program.trajanjeGodina + ' god.';
                    document.getElementById('detalji-espb').textContent = program.ukupnoEspb;
                    ucitajEspbPoGodini();
                })
                .catch(error => console.error('Greska pri ucitavanju programa:', error));
        }

        // Pravi mapu: predmetProgramId -> izbornaPozicijaId, na osnovu svih izbornih pozicija.
        // Koristi polje "ponudeIds" iz IzbornaPozicijaDto (Set<Long> id-jeva PredmetProgram ponuda u tom bloku).
        function izgradiMapuPredmetProgramPozicija(svePozicije) {
            const mapa = {};
            svePozicije.forEach(poz => {
                (poz.ponudeIds || []).forEach(ppId => {
                    mapa[ppId] = poz.id;
                });
            });
            return mapa;
        }

        function ucitajEspbPoGodini() {
            if (!trenutniProgram) return;

            Promise.all([
                fetch(API_PREDMET_PROGRAMI).then(r => r.json()),
                fetch(API_IZBORNE_POZICIJE).then(r => r.json())
            ])
                .then(([sviPredmetProgrami, svePozicije]) => {
                    const predmetiPrograma = sviPredmetProgrami.filter(p => p.studijskiProgramId == PROGRAM_ID);
                    const mapaPozicija = izgradiMapuPredmetProgramPozicija(svePozicije);

                    const espbPoGodini = { 1: 0, 2: 0, 3: 0, 4: 0 };
                    const vecUbrojanePozicije = new Set();

                    predmetiPrograma.forEach(p => {
                        if (!espbPoGodini.hasOwnProperty(p.godina)) {
                            return;
                        }

                        if (p.tip === 'IZBORAN') {
                            const pozicijaId = mapaPozicija[p.id];
                            if (pozicijaId != null) {
                                if (vecUbrojanePozicije.has(pozicijaId)) {
                                    // Ovaj izborni blok je vec ubrojan preko drugog predmeta iz iste pozicije - preskoci.
                                    return;
                                }
                                vecUbrojanePozicije.add(pozicijaId);
                            }
                            // Ako izborni predmet nije povezan ni sa jednom pozicijom, tretira se pojedinacno (fallback).
                        }

                        espbPoGodini[p.godina] += p.espb;
                    });

                    const ukupno = espbPoGodini[1] + espbPoGodini[2] + espbPoGodini[3] + espbPoGodini[4];

                    const kontejner = document.getElementById('stats-espb-po-godini');
                    kontejner.innerHTML = [1, 2, 3, 4].map(godina => `
                        <div class="stat-card">
                            <span class="stat-label">${godina}. godina</span>
                            <span class="stat-value">${espbPoGodini[godina]}</span>
                        </div>
                    `).join('') + `
                        <div class="stat-card">
                            <span class="stat-label">Ukupno (izracunato)</span>
                            <span class="stat-value">${ukupno}</span>
                        </div>
                    `;

                    const upozorenje = document.getElementById('espb-upozorenje');
                    if (ukupno !== trenutniProgram.ukupnoEspb) {
                        upozorenje.innerHTML = `<span class="warning-banner">Upozorenje: zbir ESPB predmeta (${ukupno}) se ne poklapa sa ukupno ESPB programa (${trenutniProgram.ukupnoEspb}).</span>`;
                    } else {
                        upozorenje.innerHTML = `<span class="ok-banner">Zbir ESPB predmeta se poklapa sa ukupno ESPB programa.</span>`;
                    }
                })
                .catch(error => console.error('Greska pri racunanju ESPB po godini:', error));
        }

        function ucitajModule() {
            fetch(API_MODULI)
                .then(response => response.json())
                .then(sviModuli => {
                    const moduli = sviModuli.filter(m => m.studijskiProgramId == PROGRAM_ID);
                    const tabela = document.getElementById('tabela-moduli');
                    tabela.innerHTML = '';
                    document.getElementById('broj-moduli').textContent = moduli.length;

                    if (moduli.length === 0) {
                        tabela.innerHTML = '<tr class="empty-row"><td colspan="3">Nema unetih modula.</td></tr>';
                        return;
                    }

                    moduli.forEach(modul => {
                        const red = document.createElement('tr');
                        red.innerHTML = `
                            <td>${modul.id}</td>
                            <td>${modul.naziv}</td>
                            <td class="col-actions">
                                <button class="btn btn-sm btn-edit dugme-izmeni-modul" data-id="${modul.id}">Izmeni</button>
                                <button class="btn btn-sm btn-delete dugme-obrisi-modul" data-id="${modul.id}">Obrisi</button>
                            </td>
                        `;
                        tabela.appendChild(red);
                    });

                    document.querySelectorAll('.dugme-izmeni-modul').forEach(dugme => {
                        dugme.addEventListener('click', () => {
                            const id = dugme.getAttribute('data-id');
                            const modul = moduli.find(m => m.id == id);
                            popuniFormuZaIzmenuModula(modul);
                        });
                    });
                    document.querySelectorAll('.dugme-obrisi-modul').forEach(dugme => {
                        dugme.addEventListener('click', () => {
                            obrisiModul(dugme.getAttribute('data-id'));
                        });
                    });
                })
                .catch(error => console.error('Greska pri ucitavanju modula:', error));
        }

        function popuniFormuZaIzmenuModula(modul) {
            document.getElementById('modul-id').value = modul.id;
            document.getElementById('naziv-modula').value = modul.naziv;
            document.getElementById('dugme-dodaj-modul').textContent = 'Sacuvaj izmenu';
            document.getElementById('dugme-otkazi-modul').style.display = 'inline-block';
        }

        function resetujFormuModula() {
            document.getElementById('forma-modul').reset();
            document.getElementById('modul-id').value = '';
            document.getElementById('dugme-dodaj-modul').textContent = 'Dodaj modul';
            document.getElementById('dugme-otkazi-modul').style.display = 'none';
        }

        function obrisiModul(id) {
            if (!confirm('Da li sigurno zelis da obrises ovaj modul?')) {
                return;
            }
            fetch(`${API_MODULI}/${id}`, { method: 'DELETE' })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(err => { throw new Error(err.error || 'Greska pri brisanju'); });
                    }
                    ucitajModule();
                })
                .catch(error => alert(error.message));
        }

        document.getElementById('forma-modul').addEventListener('submit', function(event) {
            event.preventDefault();

            const id = document.getElementById('modul-id').value;
            const podaci = {
                naziv: document.getElementById('naziv-modula').value,
                studijskiProgramId: parseInt(PROGRAM_ID)
            };

            const url = id ? `${API_MODULI}/${id}` : API_MODULI;
            const metoda = id ? 'PUT' : 'POST';

            fetch(url, {
                method: metoda,
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(podaci)
            })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(err => { throw new Error(JSON.stringify(err)); });
                    }
                    return response.json();
                })
                .then(() => {
                    resetujFormuModula();
                    ucitajModule();
                })
                .catch(error => alert('Greska: ' + error.message));
        });

        document.getElementById('dugme-otkazi-modul').addEventListener('click', resetujFormuModula);

        ucitajProgram();
        ucitajModule();
        </script>
    </body>
</html>
