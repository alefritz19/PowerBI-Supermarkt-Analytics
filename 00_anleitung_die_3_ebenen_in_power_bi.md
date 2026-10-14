# 🧭 Power BI Anleitung: Das 3-Ebenen-Prinzip (Учёт 3 этажей)
### Praktischer Leitfaden: Wo welcher Code und welches Design in Power BI Desktop platziert wird
### Практическая инструкция: куда какой код и какой файл вставлять в Power BI Desktop

---

## 🇩🇪 Zusammenfassung auf Deutsch: Das 3-Ebenen-Modell

In Microsoft Power BI Desktop gibt es **drei getrennte Ebenen (Stockwerke)**. Jede Datei aus dem Projekt gehört genau auf ihre eigene Ebene:

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

## 🇷🇺 Подробное руководство на русском языке: «Учёт 3 этажей»

### 🟢 ЭТАЖ 1: Загрузка и трансформация данных (Язык M / Power Query)
**Что сюда относится:** файл `fx_DateTable_German.m` и скрипты `transform_supermarkt_data.m`.

Язык **M** работает **только внутри редактора Power Query**, а не на главном экране.

#### Пошаговые действия:
1. В главном окне Power BI на верхней ленте нажми кнопку **«Daten transformieren»** *(Transform Data)*.
2. Откроется отдельное окно редактора Power Query.
3. В меню нажми: **«Neue Quelle»** *(New Source)* ➔ **«Leere Abfrage»** *(Blank Query)*.
4. Вверху нажми кнопку **«Erweiterter Editor»** *(Advanced Editor)*.
5. Полностью сотри текст по умолчанию и вставь M-код из файла `fx_DateTable_German.m`.
6. Назови запрос слева: `dim_datum`.
7. Нажми кнопку **«Schließen & übernehmen»** *(Close & Apply)* в левом верхнем углу.

---

### 🔵 ЭТАЖ 2: Формулы и математика (Язык DAX & Модель данных)
**Что сюда относится:** все файлы из папки `03_DAX_Measures_Library/` (`*.dax`).

Язык **DAX** живет в основном окне Power BI и отвечает за бизнес-логику и вычисления.

#### Пошаговые действия:
* **Способ 1 (Через строку формул на ленте):**
  1. В панели таблиц справа выдели таблицу (лучше создать отдельную пустую таблицу `_Measures`).
  2. На главной ленте вверху нажми **«Neues Measure»** *(New Measure)*.
  3. В появившуюся строку формул вставь DAX-код (например: `Total_Umsatz = SUM(fct_verkaeufe[Gesamtbetrag])`) и нажми Enter.
* **Способ 2 (Через новую вкладку слева):**
  1. На левой вертикальной полосе Power BI выбери 4-ю иконку снизу — **«DAX-Abfrageansicht»** *(DAX Query View)*.
  2. Там можно пакетно просматривать, тестировать и определять меры.

#### Настройка связей (Звездная схема):
* На левой панели нажми 3-ю иконку — **«Modellansicht»** *(Model View)*.
* Соедини мышкой:
  * `dim_datum[Datum]` ➔ `fct_verkaeufe[EinkaufDatum]`
  * `dim_kunden[KundeID]` ➔ `fct_verkaeufe[KundeID]`
  * `dim_produkte[ProduktID]` ➔ `fct_verkaeufe[ProduktID]`
  * `dim_mitarbeiter[MitarbeiterID]` ➔ `fct_verkaeufe[MitarbeiterID]`
* Убедись, что связи имеют вид **1:n (Eins-zu-Viele)** с направлением фильтрации **«Einfach» (Single)**.

---

### 🟣 ЭТАЖ 3: Визуализация и Дизайн Дашборда (Report Canvas / Холст)
**Что сюда относится:** файлы `corporate_theme.json` и спецификация `dashboard_layout_specification.md`.

Сам дашборд не пишется текстом программы — он **собирается визуально мышкой** на белом листе (1-я иконка слева — **Berichtsansicht / Report View**).

#### 1. Как применить цветовую тему (`corporate_theme.json`):
1. В верхнем горизонтальном меню перейди во вкладку **«Ansicht»** *(View)*.
2. В блоке тем нажми стрелочку вниз, чтобы раскрыть палитру тем.
3. Внизу выпадающего списка нажми: **«Design suchen»** *(Browse for themes)*.
4. Выбери файл `corporate_theme.json` из папки `04_Report_Design_and_Mockups`.
5. Готово! Все шрифты, карточки и палитра графиков мгновенно станут профессиональными.

#### 2. Как расставлять графики по инструкции (`dashboard_layout_specification.md`):
Файл `dashboard_layout_specification.md` — это твой архитектурный план:
* Из панели **«Visualisierungen»** справа выбираешь тип графика (карточка KPI, линейный график, гистограмма, матрица).
* Из панели **«Daten»** перетаскиваешь в график нужные DAX-меры (созданные на Этаже 2).
* Расставляешь их по сетке:
  - **Верхняя полоса:** ключевые карточки KPI со стрелками роста (▲ / ▼).
  - **Центр:** графики трендов во времени и структура категорий.
  - **Низ:** детальная таблица-матрица с возможностью проваливаться в детали.

---

## 📋 Сводная шпаргалка: Куда нести каждый файл из проекта

| Файл из шаблона | Какой это этаж | Куда нажимать в Power BI Desktop |
| :--- | :--- | :--- |
| **`fx_DateTable_German.m`** | **Этаж 1 (Power Query)** | Верхнее меню ➔ *Daten transformieren* ➔ *Neue Quelle* ➔ *Erweiterter Editor* |
| **`transform_supermarkt_data.m`** | **Этаж 1 (Power Query)** | Редактор Power Query ➔ настройки источника SQL Server |
| **`01_star_schema_design.md`** | **Этаж 2 (Модель)** | Левая панель, 3-я иконка (*Modellansicht*) ➔ протянуть связи 1:n мышкой |
| **`*.dax` (все формулы)** | **Этаж 2 (DAX)** | Верхняя кнопка *Neues Measure* или 4-я иконка слева (*DAX Query View*) |
| **`corporate_theme.json`** | **Этаж 3 (Дизайн)** | Верхнее меню ➔ вкладка *Ansicht* ➔ раскрыть темы ➔ *Design suchen* |
| **`dashboard_layout_specification.md`** | **Этаж 3 (Дизайн)** | Читать как чертеж: на белом листе отчета расставлять карточки и диаграммы |
