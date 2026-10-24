# 🧭 Power BI Architektur-Leitfaden: Das 3-Ebenen-Prinzip
### Praktischer Leitfaden: Platzierung von M-Code, DAX-Measures und Report-Design in Power BI Desktop

---

## 🏗️ Das 3-Ebenen-Architekturmodell

In Microsoft Power BI Desktop basiert eine skalierbare und saubere Projektstruktur auf **drei strikt getrennten Ebenen**. Jede Datei und jede Code-Art aus diesem Repository gehört genau auf ihre definierte Ebene:

```
┌─────────────────────────────────────────────────────────────┐
│ EBENE 3: Berichtsansicht (Report Canvas)                   │
│ ➔ Layout, Charts, Slicer & Theme-JSON (Visuelles Design)    │
├─────────────────────────────────────────────────────────────┤
│ EBENE 2: Modell- & DAX-Ebene (Model & Measures)             │
│ ➔ Sternschema-Beziehungen & DAX-Berechnungen (*.dax)        │
├─────────────────────────────────────────────────────────────┤
│ EBENE 1: Power Query Editor (M-Code)                       │
│ ➔ Datenabruf, Transformation & Kalender-Skript (*.m)        │
└─────────────────────────────────────────────────────────────┘
```

---

## 🟢 EBENE 1: Datenaufnahme & Transformation (Power Query / Sprache M)

* **Zugehörige Dateien:** `fx_DateTable_German.m` und `transform_supermarkt_data.m` aus dem Verzeichnis `02_Power_Query_M_Scripts/`.
* **Architektur-Grundsatz:** Die Abfragesprache **M** agiert ausschließlich in der **ETL-Phase (Extract, Transform, Load)** im separaten Power Query Editor. Sie dient der Datenbereinigung, Typisierung und Tabellengenerierung, bevor die Daten in das VertiPaq-In-Memory-Modell geladen werden.

### Schritt-für-Schritt-Anleitung:
1. Im Menüband von Power BI Desktop auf **„Daten transformieren“** (*Transform Data*) klicken.
2. Es öffnet sich das dedizierte Power Query Editor-Fenster.
3. Im Menüband auf **„Neue Quelle“** (*New Source*) ➔ **„Leere Abfrage“** (*Blank Query*) klicken.
4. In der Menüleiste auf **„Erweiterter Editor“** (*Advanced Editor*) klicken.
5. Den Standardcode vollständig durch den M-Code aus der Datei `fx_DateTable_German.m` ersetzen.
6. Die Abfrage im linken Navigationsbereich in `dim_datum` umbenennen.
7. Oben links auf **„Schließen & übernehmen“** (*Close & Apply*) klicken.

---

## 🔵 EBENE 2: Semantisches Modell & Geschäftslogik (Sternschema & DAX)

* **Zugehörige Dateien:** Alle DAX-Dateien aus `03_DAX_Measures_Library/` (`*.dax`) sowie `01_star_schema_design.md`.
* **Architektur-Grundsatz:** **DAX (Data Analysis Expressions)** operiert auf dem bereits geladenen Datenmodell. DAX transformiert keine Tabellenzeilen dauerhaft, sondern berechnet aggregierte Kennzahlen dynamisch im jeweiligen Filterkontext.

### Schritt-für-Schritt-Anleitung:

#### 1. DAX-Measures anlegen:
* **Methode A (Über die Formelleiste):**
  1. Im Datenbereich rechts die Zieltabelle auswählen (Best Practice: Eine dedizierte Kennzahlentabelle `_Measures` anlegen).
  2. Im Menüband auf **„Neues Measure“** (*New Measure*) klicken.
  3. Die DAX-Formel aus der Bibliothek einfügen (z. B. `Total_Umsatz_Brutto = SUM(vw_fct_verkaeufe[UmsatzBrutto])`) und mit der Eingabetaste bestätigen.
* **Methode B (Über die DAX-Abfrageansicht / DAX Query View):**
  1. In der linken vertikalen Navigationsleiste auf das 4. Symbol klicken: **„DAX-Abfrageansicht“**.
  2. Hier können DAX-Formeln im Stapel editiert, formatiert, analysiert und direkt im Datenmodell gespeichert werden.

#### 2. Modellbeziehungen konfigurieren (Sternschema):
1. In der linken Navigationsleiste auf das 3. Symbol klicken: **„Modellansicht“** (*Model View*).
2. Primärschlüssel (1-Seite) per Drag & Drop mit den Fremdschlüsseln (n-Seite) der Faktentabelle verbinden:
   * `dim_datum[Datum]` ➔ `vw_fct_verkaeufe[BonDatum]`
   * `vw_dim_kunden[KundeID]` ➔ `vw_fct_verkaeufe[KundeID]`
   * `vw_dim_produkte[ProduktID]` ➔ `vw_fct_verkaeufe[ProduktID]`
   * `vw_dim_mitarbeiter[MitarbeiterID]` ➔ `vw_fct_verkaeufe[MitarbeiterID]`
   * `vw_dim_filialen[FilialeID]` ➔ `vw_fct_verkaeufe[FilialeID]`
3. Sicherstellen, dass alle Beziehungen die Kardinalität **1:n (Eins-zu-Viele)** und eine **einfache Filterrichtung (Single)** aufweisen.

---

## 🟣 EBENE 3: Visualisierung & Report-Design (Berichtsansicht / Canvas)

* **Zugehörige Dateien:** `corporate_theme.json` und `dashboard_layout_specification.md` aus dem Verzeichnis `04_Report_Design_and_Mockups/`.
* **Architektur-Grundsatz:** Das Frontend des Berichts wird auf der **Berichtsansicht** (1. Symbol links oben) zusammengestellt. Hier werden visuelle Elemente nach Usability-, IBCS- und Corporate-Design-Standards angeordnet.

### Schritt-für-Schritt-Anleitung:

#### 1. Corporate Design Theme importieren (`corporate_theme.json`):
1. Im oberen horizontalen Menüband auf die Registerkarte **„Ansicht“** (*View*) wechseln.
2. Im Bereich **„Designs“** den Dropdown-Pfeil anklicken, um die Design-Galerie zu öffnen.
3. Unten im Menü auf **„Nach Designs suchen“** (*Browse for themes*) klicken.
4. Die Datei `corporate_theme.json` aus dem Verzeichnis `04_Report_Design_and_Mockups/` auswählen.
5. Alle visuellen Standardwerte (Schriftarten, Farben, KPI-Kartenränder und Hintergründe) werden automatisch im gesamten Bericht angewendet.

#### 2. Visuals gemäß Layout-Spezifikation platzieren (`dashboard_layout_specification.md`):
* Die Datei `dashboard_layout_specification.md` definiert das exakte Grid- und Seitenlayout:
  * **Kopfbereich (Header):** Berichts-Titel, Firmenlogo, globale Slicer (Zeitraum, Filiale).
  * **Obere KPI-Leiste:** 4 bis 5 prägnante KPI-Karten mit Trendindikatoren (▲ / ▼) und Vorjahresvergleichen.
  * **Mittelbereich:** Zeitreihendiagramme (Umsatzverlauf) sowie Strukturanalysen (Kategorien, Kundengruppen).
  * **Unterer Bereich:** Detaillierte Matrix mit Drill-Down-Möglichkeiten zur interaktiven Tiefenanalyse.

---

## 📋 Übersicht: Zuordnung der Projektdateien zu den Ebenen

| Projektdatei / Modul | Architekturebene | Pfad & Aktion in Power BI Desktop |
| :--- | :--- | :--- |
| **`fx_DateTable_German.m`** | **Ebene 1 (Power Query)** | Menüband ➔ *Daten transformieren* ➔ *Neue Quelle* ➔ *Erweiterter Editor* |
| **`transform_supermarkt_data.m`** | **Ebene 1 (Power Query)** | Power Query Editor ➔ SQL Server Quellabfragen & Transformationen |
| **`01_star_schema_design.md`** | **Ebene 2 (Modell)** | Linke Leiste: *Modellansicht* (3. Symbol) ➔ 1:n Beziehungen verknüpfen |
| **`*.dax` (Alle Measures)** | **Ebene 2 (DAX)** | Menüband: *Neues Measure* oder linke Leiste: *DAX-Abfrageansicht* (4. Symbol) |
| **`corporate_theme.json`** | **Ebene 3 (Design)** | Menüband: Registerkarte *Ansicht* ➔ *Designs* ➔ *Nach Designs suchen* |
| **`dashboard_layout_specification.md`** | **Ebene 3 (Canvas)** | *Berichtsansicht* (1. Symbol) ➔ Visuals nach Spezifikations-Grid anordnen |
