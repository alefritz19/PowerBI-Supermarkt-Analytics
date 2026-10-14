// ================================================================================
// transform_supermarkt_data.m - Power Query M-Abfragen für die Tabellenübernahme
// Datenquelle: Microsoft SQL Server (SupermarktV2)
// ================================================================================

// --------------------------------------------------------------------------------
// 1. Abfrage: dim_produkte
// --------------------------------------------------------------------------------
let
    Source = Sql.Database("localhost\SQLEXPRESS", "SupermarktV2"),
    dbo_vw_dim_produkte = Source{[Schema="dbo",Item="vw_dim_produkte"]}[Data],
    TypenAnpassen = Table.TransformColumnTypes(dbo_vw_dim_produkte,{
        {"ProduktID", Int64.Type},
        {"ProduktName", type text},
        {"KategorieName", type text},
        {"StandardPreis", Currency.Type},
        {"Lagerbestand", Int64.Type},
        {"StandardHerstellkosten", Currency.Type}
    })
in
    TypenAnpassen

// --------------------------------------------------------------------------------
// 2. Abfrage: dim_kunden
// --------------------------------------------------------------------------------
let
    Source = Sql.Database("localhost\SQLEXPRESS", "SupermarktV2"),
    dbo_vw_dim_kunden = Source{[Schema="dbo",Item="vw_dim_kunden"]}[Data],
    TypenAnpassen = Table.TransformColumnTypes(dbo_vw_dim_kunden,{
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
// 3. Abfrage: dim_mitarbeiter
// --------------------------------------------------------------------------------
let
    Source = Sql.Database("localhost\SQLEXPRESS", "SupermarktV2"),
    dbo_vw_dim_mitarbeiter = Source{[Schema="dbo",Item="vw_dim_mitarbeiter"]}[Data],
    TypenAnpassen = Table.TransformColumnTypes(dbo_vw_dim_mitarbeiter,{
        {"MitarbeiterID", Int64.Type},
        {"MitarbeiterName", type text},
        {"Position", type text}
    })
in
    TypenAnpassen

// --------------------------------------------------------------------------------
// 4. Abfrage: fct_verkaeufe
// --------------------------------------------------------------------------------
let
    Source = Sql.Database("localhost\SQLEXPRESS", "SupermarktV2"),
    dbo_vw_fct_verkaeufe = Source{[Schema="dbo",Item="vw_fct_verkaeufe"]}[Data],
    TypenAnpassen = Table.TransformColumnTypes(dbo_vw_fct_verkaeufe,{
        {"PositionID", Int64.Type},
        {"EinkaufID", Int64.Type},
        {"EinkaufDatum", type date},
        {"KundeID", Int64.Type},
        {"MitarbeiterID", Int64.Type},
        {"ProduktID", Int64.Type},
        {"Menge", Int64.Type},
        {"Einzelpreis", Currency.Type},
        {"Gesamtbetrag", Currency.Type},
        {"Herstellkosten", Currency.Type},
        {"Rohertrag", Currency.Type}
    })
in
    TypenAnpassen
