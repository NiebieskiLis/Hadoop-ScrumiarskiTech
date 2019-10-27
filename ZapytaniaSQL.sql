--zapytania 
--1 
--Pobieramy wszystkie product backlogi dla danego produktu (ograniczaj¹c po
--ID_produktu z tabeli faktu) i sprawdzamy czas wraz z aktualizacjami
--backlogów liczba zadañ i tym samym z³o¿onoœæ projektu siê zwiêksza na
--podstawie miary Liczba_zadañ
--PB1 to ten nowszy
select PB1.ID_Poczatek , PB2.ID_Poczatek , P.nazwa from Product_backlog as PB1
join Produkt as P on PB1.ID_product=P.ID_produkt
join Product_backlog as PB2 on PB2.ID_product=P.ID_produkt
where PB1.ID_Product_Backlog!= PB2.ID_Product_Backlog
and PB1.ID_Poczatek > PB2.ID_Poczatek
and PB1.liczba_zadan>PB2.liczba_zadan

