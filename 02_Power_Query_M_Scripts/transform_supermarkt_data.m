// ================================================================================
// transform_supermarkt_data.m - Power Query M-Abfragen für die Tabellenübernahme
// Datenquelle: Microsoft SQL Server (SupermarktDWH, Views im Schema 'dwh')
// Passt zu 01_Data_Model_Architecture/02_create_views_sql.sql und den DAX-Measures.
// (Die frühere Version las die alte Datenbank SupermarktV2 mit anderen Spaltennamen
//  wie EinkaufID/Gesamtbetrag – damit funktionieren die DAX-Measures nicht.)
// ================================================================================

// --------------------------------------------------------------------------------
// 1. Abfrage: vw_dim_produkte
// --------------------------------------------------------------------------------
let
    Source = Sql.Database("localhost\SQLEXPRESS", "SupermarktDWH"),
    dwh_vw_dim_produkte = Source{[Schema="dwh",Item="vw_dim_produkte"]}[Data],
    TypenAnpassen = Table.TransformColumnTypes(dwh_vw_dim_produkte,{
        {"ProduktID", Int64.Type},
        {"ProduktName", type text},
        {"KategorieID", Int64.Type},
        {"KategorieName", type text},
        {"Warenbereich", type text},
        {"StandardVerkaufspreis", Currency.Type},
        {"StandardHerstellkosten", Currency.Type}
    })
in
    TypenAnpassen

// --------------------------------------------------------------------------------
// 2. Abfrage: vw_dim_kunden
// --------------------------------------------------------------------------------
let
    Source = Sql.Database("localhost\SQLEXPRESS", "SupermarktDWH"),
    dwh_vw_dim_kunden = Source{[Schema="dwh",Item="vw_dim_kunden"]}[Data],
    TypenAnpassen = Table.TransformColumnTypes(dwh_vw_dim_kunden,{
        {"KundeID", Int64.Type},
        {"KundenName", type text},
        {"Stadt", type text},
        {"Geburtsdatum", type date},
        {"AlterJahre", Int64.Type},
        {"Altersgruppe", type text}
    })
in
    TypenAnpassen

// --------------------------------------------------------------------------------
// 3. Abfrage: vw_dim_mitarbeiter
// --------------------------------------------------------------------------------
let
    Source = Sql.Database("localhost\SQLEXPRESS", "SupermarktDWH"),
    dwh_vw_dim_mitarbeiter = Source{[Schema="dwh",Item="vw_dim_mitarbeiter"]}[Data],
    TypenAnpassen = Table.TransformColumnTypes(dwh_vw_dim_mitarbeiter,{
        {"MitarbeiterID", Int64.Type},
        {"MitarbeiterName", type text},
        {"Position", type text},
        {"FilialeID", Int64.Type}
    })
in
    TypenAnpassen

// --------------------------------------------------------------------------------
// 4. Abfrage: vw_fct_verkaeufe
// --------------------------------------------------------------------------------
let
    Source = Sql.Database("localhost\SQLEXPRESS", "SupermarktDWH"),
    dwh_vw_fct_verkaeufe = Source{[Schema="dwh",Item="vw_fct_verkaeufe"]}[Data],
    TypenAnpassen = Table.TransformColumnTypes(dwh_vw_fct_verkaeufe,{
        {"PositionID", Int64.Type},
        {"BonID", Int64.Type},
        {"BonDatum", type date},
        {"FilialeID", Int64.Type},
        {"KundeID", Int64.Type},
        {"MitarbeiterID", Int64.Type},
        {"ProduktID", Int64.Type},
        {"Menge", Int64.Type},
        {"Einzelpreis", Currency.Type},
        {"RabattBetrag", Currency.Type},
        {"UmsatzBrutto", Currency.Type},
        {"UmsatzNetto", Currency.Type},
        {"WareneinsatzNetto", Currency.Type},
        {"Rohertrag", Currency.Type}
    })
in
    TypenAnpassen
