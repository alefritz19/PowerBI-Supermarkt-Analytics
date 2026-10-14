# 🎨 Power BI Dashboard Layout-Spezifikation (4-Seiten Report)
### Konzeptionelle Vorlage für das Supermarkt Analytics Dashboard

Dieses Dokument beschreibt das visuelle Design, die Anordnung der Visuals (Grid-Layout), Filterpanele und Interaktionen für den 4-seitigen Managementbericht in Power BI Desktop.

---

## 🧭 Seitenübersicht & Navigation

* **Seite 1:** `01_Executive_Overview` — High-Level Management Cockpit & KPI Cards
* **Seite 2:** `02_Sortiments_und_Margenanalyse` — Pareto-Kurve, ABC-Matrix & Rohertrag
* **Seite 3:** `03_Zeitreihen_und_Trends` — MoM/YoY Zeitreihen, YTD-Verlauf & Saisonalität
* **Seite 4:** `04_Kunden_und_Warenkorbanalyse` — Bonwert, Altersgruppen & Wiederkaufrate

---

## 📄 Seite 1: Executive Overview (Management Cockpit)

### Kopfzeile (Header / Y: 0 - 80px)
* **Titel:** `[Dynamischer_Berichtstitel]` (Aktualisiert sich automatisch bei Slicer-Auswahl)
* **Globale Slicer (Rechts oben):**
  * Dropdown: `dim_datum[Jahr]`
  * Dropdown: `dim_datum[Quartal]`
  * Dropdown: `dim_produkte[KategorieName]`

### KPI-Kartenleiste (Top Cards / Y: 100 - 200px)
1. **Karte 1: Gesamtumsatz**  
   * Wert: `[Total_Umsatz]` (Währungsformat: `#,##0 €`)
   * Subtext / Callout: `[Umsatz_YoY_Indikator_Text]` (Dynamische Farbe über `[KPI_Farbe_Bedingt]`)
2. **Karte 2: Rohertrag & Marge**  
   * Wert: `[Total_Rohertrag]` | Untertitel: `[Rohertragsmarge_Pct]`
3. **Karte 3: Kassenbons (Transaktionen)**  
   * Wert: `[Anzahl_Bons]`
4. **Karte 4: Durchschnittsbon (AOV)**  
   * Wert: `[Durchschnittsbon_AOV]`
5. **Karte 5: Aktive Kunden**  
   * Wert: `[Aktive_Kunden]`

### Hauptvisuals (Body / Y: 220 - 700px)
* **Links (60% Breite): Balkendiagramm (Clustered Bar Chart)**
  * Y-Achse: `dim_produkte[KategorieName]`
  * X-Achse: `[Total_Umsatz]` und `[Umsatz_Vorjahr]` (Vergleich Vorjahr vs. Ist)
* **Rechts oben (40% Breite): Donut Chart**
  * Legende: `dim_kunden[Altersgruppe]`
  * Werte: `[Total_Umsatz]`
* **Rechts unten (40% Breite): Matrix-Tabelle**
  * Zeilen: `dim_produkte[KategorieName]` ➔ `dim_produkte[ProduktName]`
  * Spalten: `[Total_Menge]`, `[Total_Umsatz]`, `[Rohertragsmarge_Pct]`, `[Umsatz_YoY_Wachstum_Pct]`

---

## 📄 Seite 2: Sortiments- & Margenanalyse (ABC-Pareto)

* **Visual 1 (Oben): Kombiniertes Linien- und Säulendiagramm (Pareto Chart)**
  * X-Achse: `dim_produkte[ProduktName]` (Sortiert nach `[Total_Umsatz]` absteigend)
  * Spaltenwerte: `[Total_Umsatz]` (Säulen)
  * Zeilenwerte: `[Kumulierter_Anteil_Pct]` (Linie, Sekundärachse bis 100%)
* **Visual 2 (Unten links): Streudiagramm (Scatter Plot: Portfolio Matrix)**
  * X-Achse: `[Total_Umsatz]` (Umsatzvolumen)
  * Y-Achse: `[Rohertragsmarge_Pct]` (Rentabilität)
  * Blasengröße: `[Total_Menge]`
  * Details: `dim_produkte[ProduktName]`
  * Quadranten-Referenzlinien: Durchschnittsumsatz und Mindestmarge (35%)
* **Visual 3 (Unten rechts): Tabelle nach ABC-Klasse**
  * Zeilen: `[ABC_Klassifizierung]`
  * Werte: Anzahl Produkte, Gesamtumsatz, Umsatzanteil %

---

## 📄 Seite 3: Zeitreihen- & Trendanalyse

* **Visual 1 (Oben): Liniendiagramm mit Vorjahresvergleich**
  * X-Achse: `dim_datum[MonatName]` (Sortiert nach `JahrMonatSort`)
  * Linien: `[Total_Umsatz]`, `[Umsatz_Vorjahr]`, `[Umsatz_Rolling_3M_Avg]`
* **Visual 2 (Mitte): Wasserfall-Diagramm (Waterfall Chart)**
  * Kategorie: `dim_datum[Quartal]`
  * Y-Achse: `[Umsatz_YoY_Wachstum_Absolut]` (Zeigt positive und negative Wachstumsbeiträge der Quartale)
* **Visual 3 (Unten): YTD-Verlaufskurve**
  * X-Achse: `dim_datum[Datum]`
  * Werte: `[Umsatz_YTD]` vs. `[Umsatz_YTD_Vorjahr]`

---

## 📄 Seite 4: Kunden- & Warenkorbanalyse

* **Visual 1: KPI-Karten Kundenfokus**
  * `[Wiederkaufrate_Pct]` (Mehrfachkäufer-Anteil)
  * `[Artikel_pro_Bon]` (Warenkorbgröße)
  * `[Umsatz_pro_Kunde]`
* **Visual 2: Gestapeltes Säulendiagramm**
  * X-Achse: `dim_kunden[Stadt]`
  * Y-Achse: `[Total_Umsatz]`
  * Legende: `dim_produkte[KategorieName]`
* **Visual 3: Detail-Tabelle mit Drillthrough-Fähigkeit**
  * Detaillierte Bon-Übersicht für tiefergehende Analysen
