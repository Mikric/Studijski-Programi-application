<%--
    Document   : lista-programa
    Created on : Aug 4, 2026, 8:20:30 AM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Studijski programi</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    </head>
    <body>
        <div class="page-shell">
            <header class="page-header">
                <div>
                    <p class="eyebrow">Fakultet organizacionih nauka</p>
                    <h1>Studijski programi</h1>
                    <p>Pregled, dodavanje i izmena studijskih programa.</p>
                </div>
                <div class="badge-count">
                    <span id="broj-programa">0</span>
                    <span>ukupno</span>
                </div>
            </header>

            <section class="form-card">
                <h2>Novi program</h2>
                <form id="forma-program">
                    <input type="hidden" id="program-id">
                    <div class="field-group">
                        <label for="naziv">Naziv</label>
                        <input type="text" id="naziv" class="form-input" placeholder="npr. Informacioni sistemi i tehnologije" required>
                    </div>
                    <div class="field-group" style="flex: 0 1 140px;">
                        <label>Trajanje (god.)</label>
                        <div class="radio-group">
                            <label class="radio-option">
                                <input type="radio" name="trajanjeGodina" value="3" required>
                                <span class="radio-dot"></span>
                                <span>3 godine</span>
                            </label>
                            <label class="radio-option">
                                <input type="radio" name="trajanjeGodina" value="4" required>
                                <span class="radio-dot"></span>
                                <span>4 godine</span>
                            </label>
                        </div>
                    </div>
                    <div class="field-group" style="flex: 0 1 160px;">
                        <label for="ukupnoEspb">Ukupno ESPB</label>
                        <input type="number" id="ukupnoEspb" class="form-input" readonly>
                    </div>
                    <div class="field-group form-actions-group" style="flex: 0 0 auto;">
                        <span class="field-spacer">&nbsp;</span>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary" id="dugme-sacuvaj">Dodaj</button>
                            <button type="button" class="btn btn-ghost" id="dugme-otkazi" style="display:none;">Otkazi</button>
                        </div>
                    </div>
                </form>
            </section>

            <div class="search-row">
                <input type="text" id="pretraga-programa" class="form-input" placeholder="Pretrazi po nazivu...">
                <select id="filter-trajanje" class="form-input">
                    <option value="">Sve</option>
                    <option value="3">3 godine</option>
                    <option value="4">4 godine</option>
                </select>
            </div>

            <section class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Naziv</th>
                            <th>Trajanje (god.)</th>
                            <th>Ukupno ESPB</th>
                            <th>Akcije</th>
                        </tr>
                    </thead>
                    <tbody id="tabela-programa">
                    </tbody>
                </table>
            </section>
        </div>

        <script>
        const API_URL = 'http://localhost:8080/api/studijski-programi';
        const CONTEXT_PATH = '<%= request.getContextPath() %>';

        const ESPB_ZA_TRAJANJE = { '3': 180, '4': 240 };

        let sviProgrami = [];

        function azurirajEspbPremaTrajanju() {
            const izabran = document.querySelector('input[name="trajanjeGodina"]:checked');
            const trajanje = izabran ? izabran.value : '';
            document.getElementById('ukupnoEspb').value = ESPB_ZA_TRAJANJE[trajanje] || '';
        }

        function ucitajPrograme() {
            fetch(API_URL)
                .then(response => response.json())
                .then(programi => {
                    sviProgrami = programi;
                    primeniFilterePrograma();
                })
                .catch(error => console.error('Greska pri ucitavanju:', error));
        }

        function primeniFilterePrograma() {
            const upit = document.getElementById('pretraga-programa').value.toLowerCase().trim();
            const trajanje = document.getElementById('filter-trajanje').value;

            const filtrirani = sviProgrami.filter(program => {
                const odgovaraNazivu = !upit || program.naziv.toLowerCase().includes(upit);
                const odgovaraTrajanju = !trajanje || program.trajanjeGodina == trajanje;
                return odgovaraNazivu && odgovaraTrajanju;
            });

            renderujTabeluPrograma(filtrirani);
        }

        function renderujTabeluPrograma(programi) {
            const tabela = document.getElementById('tabela-programa');
            tabela.innerHTML = '';
            document.getElementById('broj-programa').textContent = sviProgrami.length;

            if (programi.length === 0) {
                tabela.innerHTML = '<tr class="empty-row"><td colspan="5">Nema studijskih programa koji odgovaraju pretrazi.</td></tr>';
                return;
            }

            programi.forEach(program => {
                const red = document.createElement('tr');
                red.innerHTML = `
                    <td>${program.id}</td>
                    <td>${program.naziv}</td>
                    <td>${program.trajanjeGodina}</td>
                    <td>${program.ukupnoEspb}</td>
                    <td class="col-actions">
                        <button class="btn btn-sm btn-view dugme-pregled" data-id="${program.id}">Pregled</button>
                        <button class="btn btn-sm btn-view dugme-predmeti" data-id="${program.id}">Predmeti</button>
                        <button class="btn btn-sm btn-edit dugme-izmeni" data-id="${program.id}">Izmeni</button>
                        <button class="btn btn-sm btn-delete dugme-obrisi" data-id="${program.id}">Obrisi</button>
                        <button class="btn btn-sm btn-view dugme-izvoz" data-id="${program.id}">Izvoz PDF</button>
                    </td>
                `;
                tabela.appendChild(red);
            });
            dodajListenereNaDugmad(programi);
        }

        document.getElementById('pretraga-programa').addEventListener('input', primeniFilterePrograma);
        document.getElementById('filter-trajanje').addEventListener('change', primeniFilterePrograma);

        function dodajListenereNaDugmad(programi) {
            document.querySelectorAll('.dugme-pregled').forEach(dugme => {
                dugme.addEventListener('click', () => {
                    const id = dugme.getAttribute('data-id');
                    window.location.href = `${CONTEXT_PATH}/programi/${id}`;
                });
            });
            document.querySelectorAll('.dugme-izmeni').forEach(dugme => {
                dugme.addEventListener('click', () => {
                    const id = dugme.getAttribute('data-id');
                    const program = programi.find(p => p.id == id);
                    popuniFormuZaIzmenu(program);
                });
            });
            document.querySelectorAll('.dugme-obrisi').forEach(dugme => {
                dugme.addEventListener('click', () => {
                    const id = dugme.getAttribute('data-id');
                    obrisiProgram(id);
                });
            });
            document.querySelectorAll('.dugme-predmeti').forEach(dugme => {
                dugme.addEventListener('click', () => {
                    const id = dugme.getAttribute('data-id');
                    window.location.href = `${CONTEXT_PATH}/predmeti?programId=${id}`;
                });
            });
            document.querySelectorAll('.dugme-izvoz').forEach(dugme => {
                dugme.addEventListener('click', () => {
                    const id = dugme.getAttribute('data-id');
                    window.location.href = `http://localhost:8080/api/studijski-programi/${id}/izvoz`;
                });
            });
        }

        function popuniFormuZaIzmenu(program) {
            document.getElementById('program-id').value = program.id;
            document.getElementById('naziv').value = program.naziv;
            const radio = document.querySelector(`input[name="trajanjeGodina"][value="${program.trajanjeGodina}"]`);
            if (radio) { radio.checked = true; }
            document.getElementById('ukupnoEspb').value = program.ukupnoEspb;
            document.getElementById('dugme-sacuvaj').textContent = 'Sacuvaj izmenu';
            document.getElementById('dugme-otkazi').style.display = 'inline-block';
        }

        function resetujFormu() {
            document.getElementById('forma-program').reset();
            document.getElementById('program-id').value = '';
            document.getElementById('dugme-sacuvaj').textContent = 'Dodaj';
            document.getElementById('dugme-otkazi').style.display = 'none';
        }

        function obrisiProgram(id) {
            if (!confirm('Da li sigurno zelis da obrises ovaj program?')) {
                return;
            }
            fetch(`${API_URL}/${id}`, { method: 'DELETE' })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(err => { throw new Error(err.error || 'Greska pri brisanju'); });
                    }
                    ucitajPrograme();
                })
                .catch(error => alert(error.message));
        }

        document.getElementById('forma-program').addEventListener('submit', function(event) {
            event.preventDefault();

            const id = document.getElementById('program-id').value;
            const podaci = {
                naziv: document.getElementById('naziv').value,
                trajanjeGodina: parseInt(document.querySelector('input[name="trajanjeGodina"]:checked').value),
                ukupnoEspb: parseInt(document.getElementById('ukupnoEspb').value)
            };

            const url = id ? `${API_URL}/${id}` : API_URL;
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
                    resetujFormu();
                    ucitajPrograme();
                })
                .catch(error => alert('Greska: ' + error.message));
        });

        document.getElementById('dugme-otkazi').addEventListener('click', resetujFormu);
        document.querySelectorAll('input[name="trajanjeGodina"]').forEach(radio => {
            radio.addEventListener('change', azurirajEspbPremaTrajanju);
        });

        ucitajPrograme();
        </script>
    </body> 
</html>
