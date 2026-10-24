# 🎨 Power BI Dashboard Layout-Spezifikation (4-Seiten Report)
### Konzeptionelle Vorlage für das Supermarkt Analytics Dashboard

Dieses Dokument beschreibt das visuelle Design, die Anordnung der Visuals (Raster-Layout), Filterbereiche und Interaktionen für den 4-seitigen Managementbericht in Power BI Desktop.

---

## 🧭 Seitenübersicht & Navigation

* **Seite 1:** `01_Executive_Overview` — Management-Cockpit & KPI-Karten
* **Seite 2:** `02_Sortiments_und_Margenanalyse` — Pareto-Kurve, ABC-Matrix & Rohertrag
* **Seite 3:** `03_Zeitreihen_und_Trends` — MoM/YoY Zeitreihen, YTD-Verlauf & Saisonalität
* **Seite 4:** `04_Kunden_und_Warenkorbanalyse` — Bonwert, Altersgruppen & Wiederkaufrate

---

## 📄 Seite 1: Management-Cockpit (Executive Overview)

### Kopfzeile (Y: 0 - 80px)
* **Titel:** `[Titel_Executive_Summary]` (Aktualisiert sich automatisch bei Slicer-Auswahl)
* **Globale Slicer (Rechts oben):**
  * Dropdown: `dim_datum[Jahr]`
  * Dropdown: `dim_datum[Quartal]`
  * Dropdown: `vw_dim_produkte[KategorieName]`

### KPI-Kartenleiste (Y: 100 - 200px)
1. **Karte 1: Gesamtumsatz**  
   * Wert: `[Total_Umsatz_Brutto]` (Währungsformat: `#,##0 €`)
   * Subtext / Callout: `[Titel_Umsatz_Trend_Card]` (Dynamische Farbe über `[Farbe_YoY_Trend_Hex]`)
2. **Karte 2: Rohertrag & Marge**  
   * Wert: `[Total_Rohertrag]` | Untertitel: `[Rohertrag_Marge_Pct]`
3. **Karte 3: Kassenbons (Transaktionen)**  
   * Wert: `[Anzahl_Bons]`
4. **Karte 4: Durchschnittsbon (AOV)**  
   * Wert: `[Durchschnitt_Bonwert]`
5. **Karte 5: Aktive Kunden**  
   * Wert: `[Aktive_Kunden]`

### Hauptvisuals (Y: 220 - 700px)
* **Links (60% Breite): Balkendiagramm (Clustered Bar Chart)**
  * Y-Achse: `vw_dim_produkte[KategorieName]`
  * X-Achse: `[Total_Umsatz_Brutto]` und `[Umsatz_Vorjahr_SPLY]` (Vergleich Vorjahr vs. Ist)
* **Rechts oben (40% Breite): Ringdiagramm**
  * Legende: `vw_dim_kunden[Altersgruppe]`
  * Werte: `[Total_Umsatz_Brutto]`
* **Rechts unten (40% Breite): Matrix-Tabelle**
  * Zeilen: `vw_dim_produkte[KategorieName]` ➔ `vw_dim_produkte[ProduktName]`
  * Spalten: `[Total_Menge]`, `[Total_Umsatz_Brutto]`, `[Rohertrag_Marge_Pct]`, `[Umsatz_YoY_Pct]`

---

## 📄 Seite 2: Sortiments- & Margenanalyse (ABC-Pareto)

* **Visual 1 (Oben): Kombiniertes Linien- und Säulendiagramm (Pareto-Diagramm)**
  * X-Achse: `vw_dim_produkte[ProduktName]` (Sortiert nach `[Total_Umsatz_Brutto]` absteigend)
  * Spaltenwerte: `[Total_Umsatz_Brutto]` (Säulen)
  * Zeilenwerte: `[Kumulierter_Umsatz_Anteil_Pct]` (Linie, Sekundärachse bis 100%)
* **Visual 2 (Unten links): Punktdiagramm (Portfolio-Matrix)**
  * X-Achse: `[Total_Umsatz_Brutto]` (Umsatzvolumen)
  * Y-Achse: `[Rohertrag_Marge_Pct]` (Rentabilität)
  * Blasengröße: `[Total_Menge]`
  * Details: `vw_dim_produkte[ProduktName]`
  * Quadranten-Referenzlinien: Durchschnittsumsatz und Mindestmarge (35%)
* **Visual 3 (Unten rechts): Tabelle nach ABC-Klasse**
  * Zeilen: `[ABC_Klasse_Umsatz]`
  * Werte: Anzahl Produkte, Gesamtumsatz, Umsatzanteil %

---

## 📄 Seite 3: Zeitreihen- & Trendanalyse

* **Visual 1 (Oben): Liniendiagramm mit Vorjahresvergleich**
  * X-Achse: `dim_datum[MonatName]` (Sortiert nach `JahrMonatSort`)
  * Linien: `[Total_Umsatz_Brutto]`, `[Umsatz_Vorjahr_SPLY]`, `[Umsatz_Rolling_3M]`
* **Visual 2 (Mitte): Wasserfalldiagramm**
  * Kategorie: `dim_datum[Quartal]`
  * Y-Achse: `[Umsatz_YoY_Diff]` (Zeigt positive und negative Wachstumsbeiträge der Quartale)
* **Visual 3 (Unten): YTD-Verlaufskurve**
  * X-Achse: `dim_datum[Datum]`
  * Werte: `[Umsatz_YTD]` vs. `[Umsatz_YTD_Vorjahr]`

---

## 📄 Seite 4: Kunden- & Warenkorbanalyse

* **Visual 1: KPI-Karten Kundenfokus**
  * `[Wiederkaufrate_Pct]` (Mehrfachkäufer-Anteil)
  * `[Artikel_Pro_Bon]` (Warenkorbgröße)
  * `[Umsatz_Pro_Kunde]`
* **Visual 2: Gestapeltes Säulendiagramm**
  * X-Achse: `vw_dim_kunden[Stadt]`
  * Y-Achse: `[Total_Umsatz_Brutto]`
  * Legende: `vw_dim_produkte[KategorieName]`
* **Visual 3: Detailtabelle mit Drillthrough**
  * Detaillierte Bon-Übersicht für tiefergehende Analysen
