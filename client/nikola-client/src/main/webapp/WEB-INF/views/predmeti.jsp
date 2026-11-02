<%-- 
    Document   : predmeti
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Predmeti</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    </head>
    <body>
        <div class="page-shell page-predmeti">
            <header class="page-header">
                <div>
                    <p class="eyebrow">Fakultet organizacionih nauka</p>
                    <h1>Predmeti</h1>
                    <p>Dodavanje predmeta na studijski program i modul.</p>
                </div>
            </header>

            <section class="form-card">
                <h2>Kontekst</h2>
                <div class="context-row">
                    <div class="field-group">
                        <label for="select-program">Studijski program</label>
                        <select id="select-program" class="form-input"></select>
                    </div>
                    <div class="field-group">
                        <label for="select-modul">Modul (opciono)</label>
                        <select id="select-modul" class="form-input">
                            <option value="">Bez modula</option>
                        </select>
                    </div>
                </div>
            </section>

            <section class="toggle-row">
                <button type="button" class="btn btn-ghost" id="tab-postojeci">Dodaj postojeci</button>
                <button type="button" class="btn btn-ghost" id="tab-novi">Dodaj novi</button>
            </section>

            <section class="form-card" id="panel-postojeci" style="display:none;">
                <h2>Sifarnik predmeta</h2>
                <input type="text" id="pretraga-predmeta" class="form-input" placeholder="Pretrazi po nazivu ili sifri..." style="margin-bottom: 16px;">
                <div class="table-card" style="box-shadow:none; border-color: var(--border);">
                    <table>
                        <thead>
                            <tr>
                                <th>Naziv</th>
                                <th>Sifra</th>
                                <th>Akcija</th>
                            </tr>
                        </thead>
                        <tbody id="tabela-svi-predmeti"></tbody>
                    </table>
                </div>
            </section>

            <section class="form-card" id="panel-novi" style="display:none;">
                <h2>Predmet na programu</h2>
                <form id="forma-predmet">
                    <input type="hidden" id="predmet-id">
                    <input type="hidden" id="ponuda-id">
                    <div class="field-group">
                        <label for="predmet-naziv">Naziv</label>
                        <input type="text" id="predmet-naziv" class="form-input" placeholder="npr. Baze podataka" required>
                    </div>
                    <div class="field-group" style="flex: 0 1 140px;">
                        <label for="predmet-sifra">Sifra</label>
                        <input type="text" id="predmet-sifra" class="form-input" placeholder="npr. BP101" required>
                    </div>
                    <div class="field-group" style="flex: 0 1 100px;">
                        <label for="predmet-espb">ESPB</label>
                        <input type="number" id="predmet-espb" class="form-input" min="1" max="30" required>
                    </div>
                    <div class="field-group" style="flex: 0 1 100px;">
                        <label for="predmet-godina">Godina</label>
                        <input type="number" id="predmet-godina" class="form-input" min="1" max="4" required>
                    </div>
                    <div class="field-group" style="flex: 0 1 100px;">
                        <label for="predmet-semestar">Semestar</label>
                        <input type="number" id="predmet-semestar" class="form-input" min="1" max="2" required>
                    </div>
                    <div class="field-group" style="flex: 0 1 220px;">
                        <label>Tip</label>
                        <div class="radio-group" style="flex-direction: row;">
                            <label class="radio-option">
                                <input type="radio" name="predmet-tip" value="OBAVEZAN" checked>
                                <span class="radio-dot"></span>
                                <span>Obavezan</span>
                            </label>
                            <label class="radio-option">
                                <input type="radio" name="predmet-tip" value="IZBORNI">
                                <span class="radio-dot"></span>
                                <span>Izborni</span>
                            </label>
                        </div>
                    </div>

                    <div class="field-group" id="wrap-izborna-pozicija" style="display:none; flex: 1 1 260px;">
                        <label for="select-pozicija">Izborna pozicija</label>
                        <select id="select-pozicija" class="form-input"></select>

                        <div class="inline-subform" id="inline-nova-pozicija" style="display:none;">
                            <div class="field-group">
                                <label for="nova-pozicija-naziv">Naziv nove pozicije</label>
                                <input type="text" id="nova-pozicija-naziv" class="form-input" placeholder="npr. Izborni blok A">
                            </div>
                            <div class="field-group">
                                <label for="nova-pozicija-broj">Broj predmeta za izbor</label>
                                <input type="number" id="nova-pozicija-broj" class="form-input" min="1">
                            </div>
                        </div>
                    </div>

                    <div class="field-group form-actions-group" style="flex: 0 0 auto;">
                        <span class="field-spacer">&nbsp;</span>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary" id="dugme-sacuvaj-predmet">Sacuvaj predmet</button>
                            <button type="button" class="btn btn-ghost" id="dugme-otkazi-predmet" style="display:none;">Otkazi</button>
                        </div>
                    </div>
                </form>
            </section>

            <div class="search-row">
                <input type="text" id="pretraga-predmeta-programa" class="form-input" placeholder="Pretrazi obavezne i izborne predmete po nazivu ili sifri...">
            </div>

            <p class="section-label">Obavezni predmeti</p>
            <section class="table-card" style="margin-bottom: 32px;">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th><th>Naziv</th><th>Sifra</th><th>ESPB</th><th>God./Sem.</th><th>Modul</th><th>Akcije</th>
                        </tr>
                    </thead>
                    <tbody id="tabela-obavezni"></tbody>
                </table>
            </section>

            <p class="section-label">Izborni predmeti</p>
            <section class="table-card" style="margin-bottom: 32px;">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th><th>Naziv</th><th>Sifra</th><th>ESPB</th><th>God./Sem.</th><th>Modul</th><th>Izborna pozicija</th><th>Akcije</th>
                        </tr>
                    </thead>
                    <tbody id="tabela-izborni"></tbody>
                </table>
            </section>

            <p class="section-label">Izborne pozicije</p>
            <section class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th>Naziv</th><th>Broj predmeta za izbor</th><th>Broj predmeta u poziciji</th><th>Akcije</th>
                        </tr>
                    </thead>
                    <tbody id="tabela-pozicije"></tbody>
                </table>
            </section>
        </div>

        <script>
        const INITIAL_PROGRAM_ID = <%= request.getAttribute("initialProgramId") == null ? "null" : request.getAttribute("initialProgramId") %>;
        const API_PROGRAMI = 'http://localhost:8080/api/studijski-programi';
        const API_MODULI = 'http://localhost:8080/api/moduli';
        const API_PREDMETI = 'http://localhost:8080/api/predmeti';
        const API_PONUDE = 'http://localhost:8080/api/predmet-program';
        const API_POZICIJE = 'http://localhost:8080/api/izborne-pozicije';

        let sviProgrami = [];
        let ponudeTrenutnogPrograma = [];   // PredmetProgramDto niz za trenutni program
        let moduliTrenutnogPrograma = [];
        let pozicijeTrenutnogPrograma = [];

        function trenutniProgramId() {
            const v = document.getElementById('select-program').value;
            return v ? parseInt(v) : null;
        }
        function trenutniModulId() {
            const v = document.getElementById('select-modul').value;
            return v ? parseInt(v) : null;
        }

        // ---------- Ucitavanje selektora ----------

        function ucitajProgramSelect() {
            fetch(API_PROGRAMI)
                .then(r => r.json())
                .then(programi => {
                    sviProgrami = programi;
                    const select = document.getElementById('select-program');
                    select.innerHTML = programi.map(p => `<option value="${p.id}">${p.naziv}</option>`).join('');
                    if (INITIAL_PROGRAM_ID && programi.some(p => p.id === INITIAL_PROGRAM_ID)) {
                        select.value = INITIAL_PROGRAM_ID;
                    }
                    onProgramChange();
                })
                .catch(error => console.error('Greska pri ucitavanju programa:', error));
        }

        function onProgramChange() {
            Promise.all([ucitajModulSelect(), ucitajPozicijeSelect()])
                .then(() => {
                    renderujTabeluPozicija();
                    ucitajPonudeZaProgram();
                });
        }

        function ucitajModulSelect() {
            return fetch(API_MODULI)
                .then(r => r.json())
                .then(sviModuli => {
                    moduliTrenutnogPrograma = sviModuli.filter(m => m.studijskiProgramId === trenutniProgramId());
                    const select = document.getElementById('select-modul');
                    select.innerHTML = '<option value="">Bez modula</option>' +
                        moduliTrenutnogPrograma.map(m => `<option value="${m.id}">${m.naziv}</option>`).join('');
                })
                .catch(error => console.error('Greska pri ucitavanju modula:', error));
        }

        function ucitajPozicijeSelect() {
            return fetch(API_POZICIJE)
                .then(r => r.json())
                .then(svePozicije => {
                    pozicijeTrenutnogPrograma = svePozicije.filter(p => p.studijskiProgramId === trenutniProgramId());
                    const select = document.getElementById('select-pozicija');
                    select.innerHTML = pozicijeTrenutnogPrograma.map(p => `<option value="${p.id}">${p.naziv}</option>`).join('') +
                        '<option value="__nova__">+ Napravi novu poziciju</option>';
                    azurirajPrikazNovePozicije();
                })
                .catch(error => console.error('Greska pri ucitavanju pozicija:', error));
        }

        document.getElementById('select-program').addEventListener('change', onProgramChange);

        // ---------- Tabovi ----------

        function prikaziTab(tab) {
            document.getElementById('panel-postojeci').style.display = tab === 'postojeci' ? 'block' : 'none';
            document.getElementById('panel-novi').style.display = tab === 'novi' ? 'block' : 'none';
            postaviStilTaba('tab-postojeci', tab === 'postojeci');
            postaviStilTaba('tab-novi', tab === 'novi');
        }
        function postaviStilTaba(id, aktivan) {
            const dugme = document.getElementById(id);
            dugme.classList.toggle('btn-primary', aktivan);
            dugme.classList.toggle('btn-ghost', !aktivan);
        }
        document.getElementById('tab-postojeci').addEventListener('click', () => {
            prikaziTab('postojeci');
            ucitajSifarnikZaPretragu();
        });
        document.getElementById('tab-novi').addEventListener('click', () => prikaziTab('novi'));

        // ---------- ESPB: ogranicenje 1-30 ----------

        document.getElementById('predmet-espb').addEventListener('input', function() {
            if (this.value === '') return;
            const vrednost = parseInt(this.value);
            if (vrednost > 30) this.value = 30;
            if (vrednost < 1) this.value = 1;
        });

        // ---------- Tip predmeta -> prikaz izborne pozicije ----------

        document.querySelectorAll('input[name="predmet-tip"]').forEach(radio => {
            radio.addEventListener('change', () => {
                const izabranTip = document.querySelector('input[name="predmet-tip"]:checked').value;
                document.getElementById('wrap-izborna-pozicija').style.display = izabranTip === 'IZBORNI' ? 'flex' : 'none';
                if (izabranTip === 'IZBORNI') {
                    azurirajPrikazNovePozicije();
                } else {
                    sakrijIOcistiNovuPoziciju();
                }
            });
        });

        function azurirajPrikazNovePozicije() {
            const select = document.getElementById('select-pozicija');
            document.getElementById('inline-nova-pozicija').style.display = select.value === '__nova__' ? 'flex' : 'none';
        }

        function sakrijIOcistiNovuPoziciju() {
            document.getElementById('inline-nova-pozicija').style.display = 'none';
            document.getElementById('nova-pozicija-naziv').value = '';
            document.getElementById('nova-pozicija-broj').value = '';
        }

        document.getElementById('select-pozicija').addEventListener('change', azurirajPrikazNovePozicije);

        // ---------- Sifarnik (za "Dodaj postojeci") ----------

        function ucitajSifarnikZaPretragu() {
            fetch(API_PREDMETI)
                .then(r => r.json())
                .then(sviPredmeti => {
                    // Izbaci predmete koji vec imaju ponudu na trenutnom programu
                    const idsVecNaProgramu = new Set(ponudeTrenutnogPrograma.map(pp => pp.predmetId));
                    const dostupni = sviPredmeti.filter(p => !idsVecNaProgramu.has(p.id));

                    renderujSifarnik(dostupni);
                    document.getElementById('pretraga-predmeta').oninput = function() {
                        const upit = this.value.toLowerCase();
                        renderujSifarnik(dostupni.filter(p =>
                            p.naziv.toLowerCase().includes(upit) || p.sifra.toLowerCase().includes(upit)
                        ));
                    };
                })
                .catch(error => console.error('Greska pri ucitavanju sifarnika:', error));
        }

        function renderujSifarnik(predmeti) {
            const tabela = document.getElementById('tabela-svi-predmeti');
            tabela.innerHTML = '';
            if (predmeti.length === 0) {
                tabela.innerHTML = '<tr class="empty-row"><td colspan="3">Nema rezultata.</td></tr>';
                return;
            }
            predmeti.forEach(predmet => {
                const red = document.createElement('tr');
                red.innerHTML = `
                    <td>${predmet.naziv}</td>
                    <td>${predmet.sifra}</td>
                    <td><button type="button" class="btn btn-sm btn-view dugme-izaberi" data-id="${predmet.id}">Izaberi</button></td>
                `;
                tabela.appendChild(red);
            });
            document.querySelectorAll('.dugme-izaberi').forEach(dugme => {
                dugme.addEventListener('click', () => {
                    const predmet = predmeti.find(p => p.id == dugme.getAttribute('data-id'));
                    izaberiPostojeciPredmet(predmet);
                });
            });
        }

        function izaberiPostojeciPredmet(predmet) {
            resetujFormuPredmeta();
            document.getElementById('predmet-id').value = predmet.id;
            document.getElementById('predmet-naziv').value = predmet.naziv;
            document.getElementById('predmet-sifra').value = predmet.sifra;
            document.getElementById('predmet-naziv').readOnly = true;
            document.getElementById('predmet-sifra').readOnly = true;
            prikaziTab('novi');
        }

        // ---------- Cuvanje predmeta + ponude ----------

        document.getElementById('forma-predmet').addEventListener('submit', function(event) {
            event.preventDefault();

            const predmetIdPolje = document.getElementById('predmet-id').value;
            const ponudaId = document.getElementById('ponuda-id').value;
            const staraPozicija = ponudaId ? pozicijaZaPonudu(parseInt(ponudaId)) : null;

            const tip = document.querySelector('input[name="predmet-tip"]:checked').value;
            const espb = parseInt(document.getElementById('predmet-espb').value);
            const godina = parseInt(document.getElementById('predmet-godina').value);
            const semestar = parseInt(document.getElementById('predmet-semestar').value);

            // 1. Osiguraj da Predmet (sifarnik) postoji - ako nema predmet-id, napravi ga
            const predmetPromise = predmetIdPolje
                ? Promise.resolve(parseInt(predmetIdPolje))
                : posaljiJson(API_PREDMETI, 'POST', {
                    naziv: document.getElementById('predmet-naziv').value,
                    sifra: document.getElementById('predmet-sifra').value
                  }).then(noviPredmet => noviPredmet.id);

            predmetPromise.then(predmetId => {
                const ponudaPodaci = {
                    predmetId: predmetId,
                    studijskiProgramId: trenutniProgramId(),
                    modulId: trenutniModulId(),
                    espb: espb,
                    godina: godina,
                    semestar: semestar,
                    tip: tip
                };

                const sacuvajPonuduPromise = ponudaId
                    ? posaljiJson(`${API_PONUDE}/${ponudaId}`, 'PUT', ponudaPodaci)
                    : posaljiJson(API_PONUDE, 'POST', ponudaPodaci);

                if (tip === 'OBAVEZAN') {
                    return sacuvajPonuduPromise
                        .then(sacuvanaPonuda => staraPozicija ? ukloniIzPozicijaApi(staraPozicija, sacuvanaPonuda.id) : null)
                        .then(() => zavrsiCuvanje());
                }

                // Izborni - osiguraj poziciju i povezi
                const pozicijaVrednost = document.getElementById('select-pozicija').value;

                if (pozicijaVrednost === '__nova__') {
                    const novaPozicija = {
                        naziv: document.getElementById('nova-pozicija-naziv').value,
                        brojPredmetaZaIzbor: parseInt(document.getElementById('nova-pozicija-broj').value),
                        studijskiProgramId: trenutniProgramId(),
                        ponudeIds: []
                    };
                    return sacuvajPonuduPromise
                        .then(sacuvanaPonuda => posaljiJson(API_POZICIJE, 'POST', novaPozicija)
                            .then(kreiranaPozicija => povezniPonuduSaPozicijom(kreiranaPozicija, sacuvanaPonuda.id))
                            .then(() => sacuvanaPonuda))
                        .then(sacuvanaPonuda => staraPozicija ? ukloniIzPozicijaApi(staraPozicija, sacuvanaPonuda.id) : null)
                        .then(() => zavrsiCuvanje());
                } else {
                    const izabranaPozicija = pozicijeTrenutnogPrograma.find(p => p.id == pozicijaVrednost);
                    return sacuvajPonuduPromise
                        .then(sacuvanaPonuda => {
                            if (staraPozicija && staraPozicija.id === izabranaPozicija.id) {
                                return null;
                            }
                            const uklanjanje = staraPozicija ? ukloniIzPozicijaApi(staraPozicija, sacuvanaPonuda.id) : Promise.resolve();
                            return uklanjanje.then(() => povezniPonuduSaPozicijom(izabranaPozicija, sacuvanaPonuda.id));
                        })
                        .then(() => zavrsiCuvanje());
                }
            }).catch(error => alert('Greska: ' + error.message));
        });

        function povezniPonuduSaPozicijom(pozicija, ponudaId) {
            const novePonudeIds = (pozicija.ponudeIds || []).slice();
            if (!novePonudeIds.includes(ponudaId)) {
                novePonudeIds.push(ponudaId);
            }
            const azuriranaPozicija = {
                naziv: pozicija.naziv,
                brojPredmetaZaIzbor: pozicija.brojPredmetaZaIzbor,
                studijskiProgramId: pozicija.studijskiProgramId,
                ponudeIds: novePonudeIds
            };
            return posaljiJson(`${API_POZICIJE}/${pozicija.id}`, 'PUT', azuriranaPozicija);
        }

        function ukloniIzPozicijaApi(pozicija, ponudaId) {
            const azuriranaPozicija = {
                naziv: pozicija.naziv,
                brojPredmetaZaIzbor: pozicija.brojPredmetaZaIzbor,
                studijskiProgramId: pozicija.studijskiProgramId,
                ponudeIds: (pozicija.ponudeIds || []).filter(id => id !== ponudaId)
            };
            return posaljiJson(`${API_POZICIJE}/${pozicija.id}`, 'PUT', azuriranaPozicija);
        }

        function posaljiJson(url, metoda, telo) {
            return fetch(url, {
                method: metoda,
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(telo)
            }).then(response => {
                if (!response.ok) {
                    return response.json().then(err => { throw new Error(JSON.stringify(err)); });
                }
                return response.json();
            });
        }

        function zavrsiCuvanje() {
            resetujFormuPredmeta();
            ucitajPozicijeSelect().then(() => {
                renderujTabeluPozicija();
                ucitajPonudeZaProgram();
            });
        }

        // ---------- Tabele: Obavezni / Izborni predmeti trenutnog programa ----------

        function ucitajPonudeZaProgram() {
            fetch(API_PONUDE)
                .then(r => r.json())
                .then(svePonude => {
                    ponudeTrenutnogPrograma = svePonude.filter(pp => pp.studijskiProgramId === trenutniProgramId());
                    primeniPretraguPredmetaPrograma();
                })
                .catch(error => console.error('Greska pri ucitavanju predmeta programa:', error));
        }

        function primeniPretraguPredmetaPrograma() {
            const upit = document.getElementById('pretraga-predmeta-programa').value.toLowerCase().trim();
            const filtrirane = !upit ? ponudeTrenutnogPrograma : ponudeTrenutnogPrograma.filter(pp =>
                pp.predmetNaziv.toLowerCase().includes(upit) || pp.predmetSifra.toLowerCase().includes(upit)
            );
            renderujTabelu('tabela-obavezni', filtrirane.filter(pp => pp.tip === 'OBAVEZAN'), false);
            renderujTabelu('tabela-izborni', filtrirane.filter(pp => pp.tip === 'IZBORNI'), true);
        }

        document.getElementById('pretraga-predmeta-programa').addEventListener('input', primeniPretraguPredmetaPrograma);

        function nazivModula(modulId) {
            const modul = moduliTrenutnogPrograma.find(m => m.id === modulId);
            return modul ? modul.naziv : '-';
        }

        function pozicijaZaPonudu(ponudaId) {
            return pozicijeTrenutnogPrograma.find(p => (p.ponudeIds || []).includes(ponudaId));
        }

        function renderujTabelu(idTabele, ponude, izborni) {
            const tabela = document.getElementById(idTabele);
            tabela.innerHTML = '';
            const brojKolona = izborni ? 8 : 7;
            if (ponude.length === 0) {
                tabela.innerHTML = `<tr class="empty-row"><td colspan="${brojKolona}">Nema predmeta.</td></tr>`;
                return;
            }
            ponude.forEach(ponuda => {
                const pozicijaPonude = izborni ? pozicijaZaPonudu(ponuda.id) : null;
                const red = document.createElement('tr');
                red.innerHTML = `
                    <td>${ponuda.id}</td>
                    <td>${ponuda.predmetNaziv}</td>
                    <td>${ponuda.predmetSifra}</td>
                    <td>${ponuda.espb}</td>
                    <td>${ponuda.godina}/${ponuda.semestar}</td>
                    <td>${nazivModula(ponuda.modulId)}</td>
                    ${izborni ? `<td><span class="badge-pozicija">${pozicijaPonude ? pozicijaPonude.naziv : '-'}</span></td>` : ''}
                    <td class="col-actions">
                        <button type="button" class="btn btn-sm btn-edit dugme-izmeni-ponudu" data-id="${ponuda.id}">Izmeni</button>
                        ${pozicijaPonude ? `<button type="button" class="btn btn-sm btn-edit dugme-prebaci-obavezne" data-id="${ponuda.id}">Prebaci u obavezne</button>` : ''}
                        <button type="button" class="btn btn-sm btn-delete dugme-obrisi-ponudu" data-id="${ponuda.id}">Obrisi</button>
                    </td>
                `;
                tabela.appendChild(red);
            });
            tabela.querySelectorAll('.dugme-izmeni-ponudu').forEach(dugme => {
                dugme.addEventListener('click', () => zapocniIzmenuPonude(dugme.getAttribute('data-id')));
            });
            tabela.querySelectorAll('.dugme-obrisi-ponudu').forEach(dugme => {
                dugme.addEventListener('click', () => obrisiPonudu(dugme.getAttribute('data-id')));
            });
            tabela.querySelectorAll('.dugme-prebaci-obavezne').forEach(dugme => {
                dugme.addEventListener('click', () => prebaciPonuduUObavezne(dugme.getAttribute('data-id')));
            });
        }

        function zapocniIzmenuPonude(idStr) {
            const id = parseInt(idStr);
            const ponuda = ponudeTrenutnogPrograma.find(pp => pp.id === id);
            if (!ponuda) return;

            document.getElementById('ponuda-id').value = ponuda.id;
            document.getElementById('predmet-id').value = ponuda.predmetId;
            document.getElementById('predmet-naziv').value = ponuda.predmetNaziv;
            document.getElementById('predmet-sifra').value = ponuda.predmetSifra;
            document.getElementById('predmet-naziv').readOnly = true;
            document.getElementById('predmet-sifra').readOnly = true;
            document.getElementById('predmet-espb').value = ponuda.espb;
            document.getElementById('predmet-godina').value = ponuda.godina;
            document.getElementById('predmet-semestar').value = ponuda.semestar;
            document.querySelector(`input[name="predmet-tip"][value="${ponuda.tip}"]`).checked = true;
            document.getElementById('wrap-izborna-pozicija').style.display = ponuda.tip === 'IZBORNI' ? 'flex' : 'none';
            sakrijIOcistiNovuPoziciju();

            if (ponuda.tip === 'IZBORNI') {
                const pozicija = pozicijaZaPonudu(ponuda.id);
                if (pozicija) {
                    document.getElementById('select-pozicija').value = pozicija.id;
                }
            }

            document.getElementById('dugme-sacuvaj-predmet').textContent = 'Sacuvaj izmenu';
            document.getElementById('dugme-otkazi-predmet').style.display = 'inline-block';

            prikaziTab('novi');
        }

        function resetujFormuPredmeta() {
            document.getElementById('forma-predmet').reset();
            document.getElementById('predmet-id').value = '';
            document.getElementById('ponuda-id').value = '';
            document.getElementById('predmet-naziv').readOnly = false;
            document.getElementById('predmet-sifra').readOnly = false;
            document.getElementById('wrap-izborna-pozicija').style.display = 'none';
            sakrijIOcistiNovuPoziciju();
            document.getElementById('dugme-sacuvaj-predmet').textContent = 'Sacuvaj predmet';
            document.getElementById('dugme-otkazi-predmet').style.display = 'none';
        }

        document.getElementById('dugme-otkazi-predmet').addEventListener('click', resetujFormuPredmeta);

        function prebaciPonuduUObavezne(ponudaIdStr) {
            const ponudaId = parseInt(ponudaIdStr);
            const pozicija = pozicijaZaPonudu(ponudaId);
            const ponuda = ponudeTrenutnogPrograma.find(pp => pp.id === ponudaId);
            if (!pozicija || !ponuda) return;
            if (!confirm(`Prebaciti ovaj predmet u obavezne? Bice uklonjen iz pozicije "${pozicija.naziv}" i njegov tip ce postati OBAVEZAN.`)) {
                return;
            }
            const azuriranaPozicija = {
                naziv: pozicija.naziv,
                brojPredmetaZaIzbor: pozicija.brojPredmetaZaIzbor,
                studijskiProgramId: pozicija.studijskiProgramId,
                ponudeIds: (pozicija.ponudeIds || []).filter(id => id !== ponudaId)
            };
            const azuriranaPonuda = {
                predmetId: ponuda.predmetId,
                studijskiProgramId: ponuda.studijskiProgramId,
                modulId: ponuda.modulId,
                espb: ponuda.espb,
                godina: ponuda.godina,
                semestar: ponuda.semestar,
                tip: 'OBAVEZAN'
            };
            posaljiJson(`${API_POZICIJE}/${pozicija.id}`, 'PUT', azuriranaPozicija)
                .then(() => posaljiJson(`${API_PONUDE}/${ponudaId}`, 'PUT', azuriranaPonuda))
                .then(() => ucitajPozicijeSelect())
                .then(() => {
                    renderujTabeluPozicija();
                    ucitajPonudeZaProgram();
                })
                .catch(error => alert('Greska: ' + error.message));
        }

        function obrisiPonudu(id) {
            if (!confirm('Da li sigurno zelis da obrises ovaj predmet sa programa? (Predmet ostaje u sifarniku.)')) return;
            fetch(`${API_PONUDE}/${id}`, { method: 'DELETE' })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(err => { throw new Error(err.error || 'Greska pri brisanju'); });
                    }
                    ucitajPonudeZaProgram();
                })
                .catch(error => alert(error.message));
        }

        // ---------- Tabela: Izborne pozicije ----------

        function renderujTabeluPozicija() {
            const tabela = document.getElementById('tabela-pozicije');
            tabela.innerHTML = '';
            if (pozicijeTrenutnogPrograma.length === 0) {
                tabela.innerHTML = '<tr class="empty-row"><td colspan="4">Nema izbornih pozicija.</td></tr>';
                return;
            }
            pozicijeTrenutnogPrograma.forEach(pozicija => {
                const red = document.createElement('tr');
                red.innerHTML = `
                    <td>${pozicija.naziv}</td>
                    <td>${pozicija.brojPredmetaZaIzbor}</td>
                    <td>${(pozicija.ponudeIds || []).length}</td>
                    <td class="col-actions">
                        <button type="button" class="btn btn-sm btn-edit dugme-izmeni-poziciju" data-id="${pozicija.id}">Izmeni</button>
                        <button type="button" class="btn btn-sm btn-delete dugme-obrisi-poziciju" data-id="${pozicija.id}">Obrisi</button>
                    </td>
                `;
                tabela.appendChild(red);
            });
            tabela.querySelectorAll('.dugme-izmeni-poziciju').forEach(dugme => {
                dugme.addEventListener('click', () => zapocniIzmenuPozicije(dugme.getAttribute('data-id')));
            });
            tabela.querySelectorAll('.dugme-obrisi-poziciju').forEach(dugme => {
                dugme.addEventListener('click', () => obrisiPoziciju(dugme.getAttribute('data-id')));
            });
        }

        function zapocniIzmenuPozicije(idStr) {
            const id = parseInt(idStr);
            const pozicija = pozicijeTrenutnogPrograma.find(p => p.id === id);
            if (!pozicija) return;

            const redovi = document.querySelectorAll('#tabela-pozicije tr');
            const red = [...redovi].find(tr => {
                const dugme = tr.querySelector('[data-id]');
                return dugme && parseInt(dugme.getAttribute('data-id')) === id;
            });
            if (!red) return;

            red.innerHTML = `
                <td><input type="text" class="form-input" id="izmena-poz-naziv-${id}" value="${pozicija.naziv}"></td>
                <td><input type="number" class="form-input" id="izmena-poz-broj-${id}" value="${pozicija.brojPredmetaZaIzbor}" min="1"></td>
                <td>${(pozicija.ponudeIds || []).length}</td>
                <td class="col-actions">
                    <button type="button" class="btn btn-sm btn-primary dugme-sacuvaj-poziciju" data-id="${id}">Sacuvaj</button>
                    <button type="button" class="btn btn-sm btn-ghost dugme-otkazi-izmenu-poz" data-id="${id}">Otkazi</button>
                </td>
            `;
            red.querySelector('.dugme-sacuvaj-poziciju').addEventListener('click', () => sacuvajIzmenuPozicije(id));
            red.querySelector('.dugme-otkazi-izmenu-poz').addEventListener('click', () => renderujTabeluPozicija());
        }

        function sacuvajIzmenuPozicije(id) {
            const pozicija = pozicijeTrenutnogPrograma.find(p => p.id === id);
            const noviNaziv = document.getElementById(`izmena-poz-naziv-${id}`).value.trim();
            const noviBroj = parseInt(document.getElementById(`izmena-poz-broj-${id}`).value);

            if (!noviNaziv || !noviBroj || noviBroj < 1) {
                alert('Naziv i broj predmeta za izbor su obavezni.');
                return;
            }

            const azurirana = {
                naziv: noviNaziv,
                brojPredmetaZaIzbor: noviBroj,
                studijskiProgramId: pozicija.studijskiProgramId,
                ponudeIds: pozicija.ponudeIds || []
            };
            posaljiJson(`${API_POZICIJE}/${id}`, 'PUT', azurirana)
                .then(() => ucitajPozicijeSelect())
                .then(() => {
                    renderujTabeluPozicija();
                    primeniPretraguPredmetaPrograma();
                })
                .catch(error => alert('Greska: ' + error.message));
        }

        function obrisiPoziciju(idStr) {
            const id = parseInt(idStr);
            const pozicija = pozicijeTrenutnogPrograma.find(p => p.id === id);
            if (!pozicija) return;

            const povezaneIds = (pozicija.ponudeIds || []).slice();
            const brojPredmeta = povezaneIds.length;
            const poruka = brojPredmeta > 0
                ? `Ova izborna pozicija ima ${brojPredmeta} povezanih predmeta. Brisanjem pozicije ti predmeti ostaju u programu, ali ce njihov tip postati OBAVEZAN. Da li zelis da nastavis?`
                : 'Da li sigurno zelis da obrises ovu izbornu poziciju?';
            if (!confirm(poruka)) return;

            const ispraznjena = {
                naziv: pozicija.naziv,
                brojPredmetaZaIzbor: pozicija.brojPredmetaZaIzbor,
                studijskiProgramId: pozicija.studijskiProgramId,
                ponudeIds: []
            };
            const prebaciPonudeUObavezne = () => Promise.all(povezaneIds.map(ponudaId => {
                const ponuda = ponudeTrenutnogPrograma.find(pp => pp.id === ponudaId);
                if (!ponuda) return Promise.resolve();
                const azuriranaPonuda = {
                    predmetId: ponuda.predmetId,
                    studijskiProgramId: ponuda.studijskiProgramId,
                    modulId: ponuda.modulId,
                    espb: ponuda.espb,
                    godina: ponuda.godina,
                    semestar: ponuda.semestar,
                    tip: 'OBAVEZAN'
                };
                return posaljiJson(`${API_PONUDE}/${ponudaId}`, 'PUT', azuriranaPonuda);
            }));
            prebaciPonudeUObavezne()
                .then(() => posaljiJson(`${API_POZICIJE}/${id}`, 'PUT', ispraznjena))
                .then(() => fetch(`${API_POZICIJE}/${id}`, { method: 'DELETE' }))
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(err => { throw new Error(err.error || 'Greska pri brisanju'); });
                    }
                    return ucitajPozicijeSelect();
                })
                .then(() => {
                    renderujTabeluPozicija();
                    ucitajPonudeZaProgram();
                })
                .catch(error => alert('Greska: ' + error.message));
        }

        ucitajProgramSelect();
        </script>
    </body>
</html>
