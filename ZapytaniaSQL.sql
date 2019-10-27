--zapytania 
--1 
--Pobieramy wszystkie product backlogi dla danego produktu (ograniczając po
--ID_produktu z tabeli faktu) i sprawdzamy czas wraz z aktualizacjami
--backlogów liczba zadań i tym samym złożoność projektu się zwiększa na
--podstawie miary Liczba_zadań
select PB1.ID_Poczatek , PB2.ID_Poczatek from Product_backlog as PB1
join Produkt as P on PB1.ID_product=P.ID_produkt
join Product_backlog as PB2 on PB2.ID_product=P.ID_produkt
where PB1.ID_Product_Backlog!= PB2.ID_Product_Backlog
