# 🏗 Sternschema-Datenmodell (Star Schema Architecture)
### Enterprise Power BI Datenmodellierung nach Ralph Kimball

Dieses Dokument spezifiziert das dimensionale Datenmodell für das **Supermarkt Retail Analytics Dashboard**. Es ist optimiert für maximale DAX-Performance, saubere Filterweitergabe (Filter Propagation) und schnelle Reaktionszeiten in Power BI.

---

## 1. Beziehungsdiagramm (Entity-Relationship-Übersicht)

```mermaid
erDiagram
    dim_datum ||--o{ fct_verkaeufe : "1:n (DatumKey / EinkaufDatum)"
    dim_kunden ||--o{ fct_verkaeufe : "1:n (KundeID)"
    dim_filialen ||--o{ fct_verkaeufe : "1:n (FilialeID)"
    dim_mitarbeiter ||--o{ fct_verkaeufe : "1:n (MitarbeiterID)"
    dim_produkte ||--o{ fct_verkaeufe : "1:n (ProduktID)"

    fct_verkaeufe {
        int EinkaufPositionID PK
        int EinkaufID
        date EinkaufDatum FK
        int KundeID FK
        int FilialeID FK
        int MitarbeiterID FK
        int ProduktID FK
        decimal Menge
        decimal Einzelpreis
        decimal RabattBetrag
        decimal Gesamtbetrag
        decimal Herstellkosten
        decimal Rohertrag
    }

    dim_produkte {
        int ProduktID PK
        string ProduktName
        string KategorieName
        string Einheit
        decimal StandardVerkaufspreis
        decimal StandardHerstellkosten
    }

    dim_kunden {
        int KundeID PK
        string KundenName
        string Stadt
        string PLZ
        string Kundensegment
        date Registrierungsdatum
    }

    dim_filialen {
        int FilialeID PK
        string FilialName
        string Region
        string Bundesland
        decimal VerkaufsflaecheQM
    }

    dim_mitarbeiter {
        int MitarbeiterID PK
        string MitarbeiterName
        string Position
        string Filiale
    }

    dim_datum {
        date Datum PK
        int Jahr
        string Quartal
        int MonatNummer
        string MonatName
        int Kalenderwoche
        string Wochentag
        boolean IstWochenende
    }
```

---

## 2. Modellierungs-Regeln (Best Practices für PL-300 / DA-100)

1. **Reine Stern-Architektur (Kein Schneeflockenschema):**
   * Die Tabelle `Kategorien` wurde direkt in `dim_produkte` denormalisiert. Dadurch entfällt ein unnötiger JOIN im Power BI VertiPaq-Engine-Speicher.
2. **Kardinalität & Filterrichtung:**
   * Alle Beziehungen sind strikt **1:n (Eins-zu-Viele)**.
   * Die Kreuzfilterrichtung ist auf **Einfach (Single)** eingestellt.
   * Filter fließen immer von den Dimensionstabellen zur Faktentabelle `fct_verkaeufe`, niemals umgekehrt.
3. **Ausblenden technischer Fremdschlüssel:**
   * In Power BI werden alle technischen Schlüsselspalten (`ProduktID`, `KundeID`, `FilialeID`) in der Faktentabelle in der Berichtsansicht ausgeblendet (*Hide in report view*).
   * Visualisierungen und Slicer nutzen ausschließlich die Beschriftungen der Dimensionstabellen.
