-- ================================================================================
-- 01_Data_Model_Architecture / 02_create_views_sql.sql
-- Optimierte Datenbank-Views für den Power BI Datenimport
-- Zieldatenbank: SupermarktV2 (Microsoft SQL Server)
-- ================================================================================
-- BEST PRACTICE FÜR POWER BI:
-- Tabellen sollten niemals direkt roh importiert werden.
-- Views abstrahieren die physische Datenbankstruktur, benennen Spalten
-- fachlich sauber und führen notwendige Vorberechnungen direkt in SQL durch.
-- ================================================================================

USE SupermarktV2;
GO

-- --------------------------------------------------------------------------------
-- 1. Produktdimension (Denormalisiert mit Kategorie)
-- --------------------------------------------------------------------------------
CREATE OR ALTER VIEW dbo.vw_dim_produkte AS
SELECT 
    p.ProduktID,
    p.ProduktName,
    k.KategorieName,
    p.Preis AS StandardPreis,
    p.Lagerbestand,
    -- Kalkulatorische Standardkosten (z.B. 65% des Verkaufspreises für Margenanalyse)
    ROUND(p.Preis * 0.65, 2) AS StandardHerstellkosten
FROM dbo.Produkte p
INNER JOIN dbo.Kategorien k ON p.KategorieID = k.KategorieID;
GO

-- --------------------------------------------------------------------------------
-- 2. Kundendimension (Vollständiger Name, Stadt, Altersgruppe)
-- --------------------------------------------------------------------------------
CREATE OR ALTER VIEW dbo.vw_dim_kunden AS
SELECT 
    k.KundeID,
    k.Vorname + ' ' + k.Nachname AS KundenName,
    k.Stadt,
    k.Geburtsdatum,
    DATEDIFF(year, k.Geburtsdatum, GETDATE()) AS AlterJahre,
    CASE 
        WHEN DATEDIFF(year, k.Geburtsdatum, GETDATE()) < 30 THEN '18-29 Jahre'
        WHEN DATEDIFF(year, k.Geburtsdatum, GETDATE()) BETWEEN 30 AND 49 THEN '30-49 Jahre'
        WHEN DATEDIFF(year, k.Geburtsdatum, GETDATE()) BETWEEN 50 AND 64 THEN '50-64 Jahre'
        ELSE '65+ Jahre'
    END AS Altersgruppe
FROM dbo.Kunden k;
GO

-- --------------------------------------------------------------------------------
-- 3. Mitarbeiterdimension (Filialmitarbeiter / Kassenpersonal)
-- --------------------------------------------------------------------------------
CREATE OR ALTER VIEW dbo.vw_dim_mitarbeiter AS
SELECT 
    m.MitarbeiterID,
    m.Vorname + ' ' + m.Nachname AS MitarbeiterName,
    m.Position
FROM dbo.Mitarbeiter m;
GO

-- --------------------------------------------------------------------------------
-- 4. Faktentabelle Verkäufe (Transaktionen & Bon-Positionen)
-- --------------------------------------------------------------------------------
CREATE OR ALTER VIEW dbo.vw_fct_verkaeufe AS
SELECT 
    pos.PositionID,
    e.EinkaufID,
    e.EinkaufDatum,
    e.KundeID,
    e.MitarbeiterID,
    pos.ProduktID,
    pos.Menge,
    pos.Einzelpreis,
    ROUND(pos.Menge * pos.Einzelpreis, 2) AS Gesamtbetrag,
    -- Kalkulierte Kosten und Rohertrag auf Zeilenebene
    ROUND(pos.Menge * (p.Preis * 0.65), 2) AS Herstellkosten,
    ROUND((pos.Menge * pos.Einzelpreis) - (pos.Menge * (p.Preis * 0.65)), 2) AS Rohertrag
FROM dbo.Einkauf_Positionen pos
INNER JOIN dbo.Einkaeufe e ON pos.EinkaufID = e.EinkaufID
INNER JOIN dbo.Produkte p ON pos.ProduktID = p.ProduktID;
GO
