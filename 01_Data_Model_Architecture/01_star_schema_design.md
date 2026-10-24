# 🏗 Sternschema-Datenmodell
### Power-BI-Datenmodellierung nach Ralph Kimball
### Datengrundlage: FrischMarkt GmbH (`SupermarktDWH`)

Dieses Dokument spezifiziert das dimensionale Datenmodell für das **Supermarkt Retail Analytics Dashboard**. Es ist optimiert für maximale DAX-Performance, saubere Filterweitergabe und schnelle Reaktionszeiten im VertiPaq In-Memory-Speicher von Power BI Desktop und Microsoft Fabric Direct Lake.

---

## 1. Beziehungsdiagramm (Entity-Relationship-Übersicht)

```mermaid
erDiagram
    dim_datum ||--o{ fct_verkaeufe : "1:n (DatumKey / BonDatum)"
    dim_datum ||--o{ fct_abschreibungen : "1:n (DatumKey / Datum)"
    dim_filialen ||--o{ fct_verkaeufe : "1:n (FilialeID)"
    dim_filialen ||--o{ fct_abschreibungen : "1:n (FilialeID)"
    dim_kunden ||--o{ fct_verkaeufe : "1:n (KundeID)"
    dim_mitarbeiter ||--o{ fct_verkaeufe : "1:n (MitarbeiterID)"
    dim_produkte ||--o{ fct_verkaeufe : "1:n (ProduktID)"
    dim_produkte ||--o{ fct_abschreibungen : "1:n (ProduktID)"
    dim_aktionen ||--o{ fct_verkaeufe : "1:n (AktionID)"

    fct_verkaeufe {
        int PositionID PK
        int BonID
        int DatumKey FK
        date BonDatum
        time BonUhrzeit
        int FilialeID FK
        int KundeID FK
        int MitarbeiterID FK
        int ProduktID FK
        int AktionID FK
        smallint Menge
        decimal Einzelpreis
        decimal RabattBetrag
        decimal UmsatzBrutto
        decimal MwStBetrag
        decimal UmsatzNetto
        decimal WareneinsatzNetto
        decimal Rohertrag
        decimal MargeProzent
        string Zahlungsart
    }

    fct_abschreibungen {
        int AbschreibungID PK
        int DatumKey FK
        date Datum
        int FilialeID FK
        int ProduktID FK
        int Menge
        string Grund
        decimal EK_Netto
        decimal VerlustNettoEUR
    }

    dim_produkte {
        int ProduktID PK
        string EAN
        string ProduktName
        int KategorieID
        string KategorieName
        string Warenbereich
        boolean IstFrischware
        string Marke
        boolean IstEigenmarke
        string Saisonprofil
        decimal MwStSatz
        decimal StandardVerkaufspreis
        decimal StandardHerstellkosten
    }

    dim_kunden {
        int KundeID PK
        string Kundennummer
        string Anrede
        string KundenName
        string Geschlecht
        date Geburtsdatum
        int AlterJahre
        string Altersgruppe
        string PLZ
        string Stadt
        boolean NewsletterOptIn
        date Registrierungsdatum
        int StammfilialeID
    }

    dim_filialen {
        int FilialeID PK
        string Filialcode
        string FilialName
        string Strasse
        string PLZ
        string Stadt
        string Bundesland
        string BundeslandKz
        string Region
        int VerkaufsflaecheQM
        date Eroeffnungsdatum
    }

    dim_mitarbeiter {
        int MitarbeiterID PK
        string Personalnummer
        string MitarbeiterName
        string Position
        int FilialeID
        date Eintrittsdatum
    }

    dim_aktionen {
        int AktionID PK
        string AktionName
        string Aktionstyp
        int KategorieID
        decimal RabattProzent
        date StartDatum
        date EndDatum
    }

    dim_datum {
        int DatumKey PK
        date Datum
        smallint Jahr
        tinyint QuartalNr
        string Quartal
        string JahrQuartal
        tinyint MonatNr
        string MonatName
        string MonatKurz
        string JahrMonat
        int JahrMonatNr
        tinyint TagImMonat
        tinyint KW
        smallint ISOJahr
        tinyint WochentagNr
        string WochentagName
        string WochentagKurz
        boolean IstWochenende
        boolean IstFeiertag
        string FeiertagName
        boolean IstVerkaufstag
        string Saison
    }
```

---

## 2. Modellierungsregeln (bewährte Praxis, Prüfungsstoff PL-300)

1. **Reines Sternschema (kein Snowflake-Schema):**
   * Die Tabelle `Kategorien` wurde direkt in `dim_produkte` denormalisiert (`KategorieName`, `Warenbereich`, `IstFrischware`). Dadurch entfällt ein unnötiger JOIN im VertiPaq-Engine-Speicher.
2. **Kardinalität & Filterrichtung:**
   * Alle Beziehungen zwischen Dimensionen und Faktentabellen sind streng **1:n (Eins-zu-Viele)**.
   * Die Kreuzfilterrichtung ist ausnahmslos auf **Einfach (Single)** gesetzt. Die Dimensionen filtern die Fakten, niemals umgekehrt.
3. **Surrogatschlüssel:**
   * Als Datumsschlüssel wird `DatumKey` (Format `JJJJMMTT`, z. B. `20260415`) als Integer verwendet. Dies minimiert den Speicherbedarf im VertiPaq-Columnstore.
4. **Trennung von Fakten und Aggregationen:**
   * Alle quantitativen Basisfelder (`UmsatzBrutto`, `Rohertrag`, `Menge`) verbleiben in der Faktentabelle.
   * Sämtliche weiterführenden Kennzahlen (Margen %, Vorjahresvergleiche, ABC-Ränge) werden dynamisch über **explizite DAX-Measures** berechnet, nicht über berechnete Spalten.
