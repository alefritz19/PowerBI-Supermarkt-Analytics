// ================================================================================
// fx_DateTable_German.m - Power Query M-Funktion für eine dynamische Datumstabelle
// Standardisiert nach DIN / ISO 8601 für den deutschen Markt
// ================================================================================
// ANLEITUNG:
// 1. In Power BI Desktop: 'Daten transformieren' (Power Query Editor öffnen).
// 2. 'Neue Quelle' -> 'Leere Abfrage'.
// 3. 'Erweiterter Editor' öffnen und diesen Code einfügen.
// 4. Abfrage umbenennen in: 'dim_datum' (oder als Funktion 'fx_DateTable').
// ================================================================================

let
    // Parameter: Start- und Enddatum dynamisch festlegen
    StartDate = #date(2023, 1, 1),
    EndDate = #date(2026, 12, 31),
    
    // Tageliste generieren
    DayCount = Duration.Days(Duration.From(EndDate - StartDate)) + 1,
    Source = List.Dates(StartDate, DayCount, #duration(1, 0, 0, 0)),
    
    // In Tabelle konvertieren
    TableFromList = Table.FromList(Source, Splitter.SplitByNothing(), {"Datum"}, null, ExtraValues.Error),
    ChangedType = Table.TransformColumnTypes(TableFromList, {{"Datum", type date}}),
    
    // Kalenderspalten berechnen (Deutsche Lokalisierung "de-DE")
    AddYear = Table.AddColumn(ChangedType, "Jahr", each Date.Year([Datum]), Int64.Type),
    AddQuarter = Table.AddColumn(AddYear, "Quartal", each "Q" & Text.From(Date.QuarterOfYear([Datum])), type text),
    AddQuarterYear = Table.AddColumn(AddQuarter, "QuartalJahr", each "Q" & Text.From(Date.QuarterOfYear([Datum])) & " " & Text.From(Date.Year([Datum])), type text),
    AddMonthNum = Table.AddColumn(AddQuarterYear, "MonatNummer", each Date.Month([Datum]), Int64.Type),
    AddMonthName = Table.AddColumn(AddMonthNum, "MonatName", each Date.MonthName([Datum], "de-DE"), type text),
    AddMonthShort = Table.AddColumn(AddMonthName, "MonatKurz", each Text.Start(Date.MonthName([Datum], "de-DE"), 3), type text),
    AddYearMonthSort = Table.AddColumn(AddMonthShort, "JahrMonatSort", each Date.Year([Datum]) * 100 + Date.Month([Datum]), Int64.Type),
    // ISO-8601-Kalenderwoche: Date.WeekOfYear ist NICHT ISO (dort ist die Woche mit dem 1. Januar immer KW 1).
    // ISO: Die KW gehört zu dem Jahr, in dem ihr Donnerstag liegt (z. B. 01.01.2027 = KW 53).
    AddWeekOfYear = Table.AddColumn(AddYearMonthSort, "Kalenderwoche", each
        let
            Donnerstag = Date.AddDays([Datum], 3 - Date.DayOfWeek([Datum], Day.Monday))
        in
            Number.RoundDown((Date.DayOfYear(Donnerstag) - 1) / 7) + 1, Int64.Type),
    AddDayOfWeek = Table.AddColumn(AddWeekOfYear, "WochentagNummer", each Date.DayOfWeek([Datum], Day.Monday) + 1, Int64.Type),
    AddDayName = Table.AddColumn(AddDayOfWeek, "WochentagName", each Date.DayOfWeekName([Datum], "de-DE"), type text),
    AddIsWeekend = Table.AddColumn(AddDayName, "IstWochenende", each if Date.DayOfWeek([Datum], Day.Monday) >= 5 then true else false, type logical),
    AddIsCurrentMonth = Table.AddColumn(AddIsWeekend, "IstAktuellerMonat", each if Date.Year([Datum]) = Date.Year(DateTime.Date(DateTime.LocalNow())) and Date.Month([Datum]) = Date.Month(DateTime.Date(DateTime.LocalNow())) then true else false, type logical)
in
    AddIsCurrentMonth
