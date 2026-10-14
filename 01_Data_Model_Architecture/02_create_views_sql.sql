-- ================================================================================
-- 01_Data_Model_Architecture / 02_create_views_sql.sql
-- Optimierte Datenbank-Views & Fakten für den Power BI Datenimport
-- Zieldatenbank: SupermarktDWH (Microsoft SQL Server 2022)
-- Fiktives Unternehmen: FrischMarkt GmbH
-- ================================================================================
-- BEST PRACTICE FÜR ENTERPRISE POWER BI:
-- Tabellen sollten niemals direkt als unstrukturierte Rohdaten importiert werden.
-- Views und Dimensionen im 'dwh'-Schema abstrahieren die physische Datenbank,
-- benennen Spalten nach Standard-Business-Semantik und ermöglichen 
-- performante 1:n-Sternschema-Beziehungen mit einfacher Filterrichtung.
-- ================================================================================

USE SupermarktDWH;
GO

-- --------------------------------------------------------------------------------
-- 1. Produktdimension (Denormalisiert mit Kategorien, Preisen und Spannen)
-- --------------------------------------------------------------------------------
CREATE OR ALTER VIEW dwh.vw_dim_produkte AS
SELECT 
    p.ProduktID,
    p.EAN,
    p.ProduktName,
    k.KategorieID,
    k.KategorieName,
    k.Warenbereich,
    k.IstFrischware,
    p.Marke,
    p.IstEigenmarke,
    p.Saisonprofil,
    p.MwStSatz,
    ph.VK_Brutto AS StandardVerkaufspreis,
    ph.EK_Netto  AS StandardHerstellkosten,
    ROUND((ph.VK_Brutto / (1 + p.MwStSatz)) - ph.EK_Netto, 2) AS StandardDeckungsbeitragNetto
FROM dbo.Produkte p
INNER JOIN dbo.Kategorien k ON p.KategorieID = k.KategorieID
INNER JOIN dbo.Preishistorie ph 
    ON ph.ProduktID = p.ProduktID 
   AND CAST('2026-09-30' AS DATE) BETWEEN ph.GueltigAb AND ph.GueltigBis;
GO

-- --------------------------------------------------------------------------------
-- 2. Kundendimension (Kundenkarte, Segmentierung, Altersgruppen)
-- --------------------------------------------------------------------------------
CREATE OR ALTER VIEW dwh.vw_dim_kunden AS
SELECT 
    k.KundeID,
    k.Kundennummer,
    k.Anrede,
    CONCAT(k.Vorname, ' ', k.Nachname) AS KundenName,
    k.Geschlecht,
    k.Geburtsdatum,
    DATEDIFF(YEAR, k.Geburtsdatum, '2026-09-30') AS AlterJahre,
    CASE 
        WHEN DATEDIFF(YEAR, k.Geburtsdatum, '2026-09-30') < 30 THEN '18-29 Jahre'
        WHEN DATEDIFF(YEAR, k.Geburtsdatum, '2026-09-30') BETWEEN 30 AND 49 THEN '30-49 Jahre'
        WHEN DATEDIFF(YEAR, k.Geburtsdatum, '2026-09-30') BETWEEN 50 AND 64 THEN '50-64 Jahre'
        ELSE '65+ Jahre'
    END AS Altersgruppe,
    k.PLZ,
    k.Stadt,
    k.NewsletterOptIn,
    k.Registrierungsdatum,
    k.StammfilialeID
FROM dbo.Kunden k;
GO

-- --------------------------------------------------------------------------------
-- 3. Filialdimension (Standort, Region, Verkaufsfläche)
-- --------------------------------------------------------------------------------
CREATE OR ALTER VIEW dwh.vw_dim_filialen AS
SELECT 
    FilialeID,
    Filialcode,
    FilialName,
    Strasse,
    PLZ,
    Stadt,
    Bundesland,
    BundeslandKz,
    Region,
    VerkaufsflaecheQM,
    Eroeffnungsdatum
FROM dbo.Filialen;
GO

-- --------------------------------------------------------------------------------
-- 4. Mitarbeiterdimension (Filialmitarbeiter / Kassenpersonal)
-- --------------------------------------------------------------------------------
CREATE OR ALTER VIEW dwh.vw_dim_mitarbeiter AS
SELECT 
    m.MitarbeiterID,
    m.Personalnummer,
    CONCAT(m.Vorname, ' ', m.Nachname) AS MitarbeiterName,
    m.Position,
    m.FilialeID,
    m.Eintrittsdatum
FROM dbo.Mitarbeiter m;
GO

-- --------------------------------------------------------------------------------
-- 5. Aktionsdimension (Marketingkampagnen & Rabatte)
-- --------------------------------------------------------------------------------
CREATE OR ALTER VIEW dwh.vw_dim_aktionen AS
SELECT 
    AktionID,
    AktionName,
    Aktionstyp,
    KategorieID,
    RabattProzent,
    StartDatum,
    EndDatum
FROM dbo.Aktionen;
GO

-- --------------------------------------------------------------------------------
-- 6. Faktentabelle Verkäufe (Zentrale Fakten auf Bonpositions-Ebene)
-- --------------------------------------------------------------------------------
CREATE OR ALTER VIEW dwh.vw_fct_verkaeufe AS
SELECT 
    f.PositionID,
    f.BonID,
    f.DatumKey,
    f.BonDatum,
    f.BonUhrzeit,
    f.FilialeID,
    f.KundeID,
    f.MitarbeiterID,
    f.ProduktID,
    f.AktionID,
    f.Menge,
    f.Einzelpreis,
    f.RabattBetrag,
    f.UmsatzBrutto,
    f.MwStBetrag,
    f.UmsatzNetto,
    f.WareneinsatzNetto,
    f.Deckungsbeitrag AS Rohertrag,
    f.MargeProzent,
    f.Zahlungsart
FROM dwh.fct_verkaeufe f;
GO

-- --------------------------------------------------------------------------------
-- 7. Faktentabelle Warenverlust & Abschreibungen (Shrinkage / Waste)
-- --------------------------------------------------------------------------------
CREATE OR ALTER VIEW dwh.vw_fct_abschreibungen AS
SELECT 
    a.AbschreibungID,
    CONVERT(INT, CONVERT(CHAR(8), a.Datum, 112)) AS DatumKey,
    a.Datum,
    a.FilialeID,
    a.ProduktID,
    a.Menge,
    a.Grund,
    a.EK_Netto,
    a.GesamtverlustNetto AS VerlustNettoEUR
FROM dbo.Abschreibungen a;
GO
