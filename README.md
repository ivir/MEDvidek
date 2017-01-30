# MEDvídek

## Autor
Jan Mareš - jan.mares (a-t) manast.eu

## Popis
Dílo je tvořeno ve volném čase primárně pro vnitřní účely NKÚ (Nejvyššího kontrolního úřadu).
Přidávaná funkčnost a funkcionalita je přizpůsobována vnitřním procesům a přes snahu o zobecnění
 zde může dojít k nesouladu. Neváhejte mě upozornit a pokusím se napravit.

Řešení slouží pro zpracování (processing) vyúčtování mobilních služeb společnosti O2,
 jejich interní přeúčtování pro jednotlivé zaměstnance
 a vygenerování potřebných výstupů pro účely SAP a další procesy.

Primárním účelem je zjednodušení a zrychlení zpracování, což se povedlo 
i přes ponechání části manuální činnosti (ošetření výjimek).

**V současnosti řešení nepovažuji za vhodné pro nasazení. Funguje, ale neposkytuje odpovídající
zpětnou odezvu, chybí dokumentace a uživatelské rozhraní není zcela předěláno.**

##Architektura řešení

Řešení je rozčleněno na dvě části

###1. Obecný processing

Na základě předaného receptu ve formátu YAML jsou postupně
volány jednotlivé moduly, kterým jsou předávána data, která
modul zpracuje.

#### Dostupné moduly
* Načtení O2 XML souhrného vyúčtování
* Import/Export CSV/SSV souborů
* Načtení přílohy z e-mailů
* Import/Export JSON
* Generování výstupu pomocí ERB do HTML a následně PDF
* Manipulace s daty (filtrace, agregace) a podpora proměnných

###2. Webový portál

Portál ošetřuje nahrání dat na server, tvorbu receptu a
jeho vyvolání.

Web/Builder - základní strohá verze poskytující možnost manipulace
bez výraznějšího ošetření vstupů (vše ve stylu All-in-One).

Web/Portal - refactoring původní verze, aby byla graficky přívětivější vůči
neznalým uživatelům s možností uložiště na serveru.


Co je v plánu realizovat
- Doplnění systému pro informování zaměstnanců o nedoplatku a audit souhlasu.
- Vytvoření modulu pro napojení na LDAP pro získání informací
- Refactoring CSV modulu (ošetření středníku u SSV v textu bunky)
- Administrace portálu
- kontejnerizace (LXC)
- Unit testy (* nejisté v závislosti na volném čase)

## LICENCE
Základ řešení bylo vytvořeno v rámci diplomové práce a tedy v zemích
 chránící zdrojový kod nebo pro binární podobu je nutné pro licenci nutné kontaktovat
 FIT ČVUT (FIT CTU).
 
 Portál je nadstavbou, která je volně k užití za předpokladu neporušení licencí užitých knihoven.
 
 ## Využité externí knihovny / Závislosti
 
 ### Processing
 * Dentaku
 * nokogiri
 * yaml
 * pdfkit
 * wkhtmltopdf
 
 ### Portal/Builder
 * Padrino
 * jQuery
 * Bootstrap
 * json-to-table
 * JS skript pro uložení souboru