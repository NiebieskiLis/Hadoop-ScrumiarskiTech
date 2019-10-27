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

--2. 
--Sektor gospodarczy pobieramy z tabeli DIM_Firma. Nastêpnie sprawdzamy
--czy zdarzy³o siê przekroczenie objêtoœci planowanej dla sprintu [Tabela
--FACT_Sprint] gdzie procent wykonania musia³by byæ wiêkszy ni¿ 100

select F.Sektor_Gospodarki , S.ID_Sprint from Sprint as S
join [dbo].[Product_Backlog] as PB on S.[ID_Product_Backlog]=PB.ID_Product_Backlog
join [dbo].[Firma] as F on F.ID_Firma = PB.ID_Firmy 
where [Rzeczywista_objetosc]>[Planowana_objetosc]
or [Procent_wykonania]>100
--3.
--Filtrujemy sprinty po Scrummasterach korzystaj¹c z ID_Scrum_Master,,
--nastêpnie dla ka¿dego z nich wyznaczamy œredni¹ liczbê b³êdów na wdro¿enie
--ze wszystkich przeprowadzonych przez nich sprintów, sortujemy ich po
--œredniej rosn¹co i wyœwietlamy 3 pozycje.

select l.Imie_i_nazwisko ,l.Numer_pracownika ,AVG(s.Liczba_bledow_na_wdrozenie) as [srednia liczba bledow na wdrozenie]  from [dbo].[Sprint] as s
join [dbo].[Ludzie] as l on s.ID_Scrum_Master=l.ID_Osoby
group by  l.Imie_i_nazwisko ,l.Numer_pracownika
order by  AVG(s.Liczba_bledow_na_wdrozenie)

--4. Filtrujemy zadania po ich typie korzystaj¹c z tabeli wymiarów Typ oraz
--ID_typu w tabeli faktu i wybieramy tylko te typu frontendowego, a nastêpnie
--na podstawie ró¿nicy miêdzy estymowanym a rzeczywistym czasem
--wykonania kazdego zadania wyliczamy ich œredni¹.

select AVG(W.[Estymacja_zadania]-W.[Czas_wykonania]), W.ID_Zadania from [dbo].[Wykonanie_zadania] as W
join Typ as T on T.ID_Typu=W.ID_Typ
where T.Typ = 'Fortend'
group by W.ID_Zadania

--5. Filtrujemy zadania po ich typie korzystaj¹c z tabeli wymiarów Typ oraz
--ID_typu w tabeli faktu, dla typów frontendowego i backendowego obliczamy
--œredni¹ z ro¿nicy rzeczywistego oraz estymowanego czasu wykonania i je
--porównujemy
--6. Datê oraz profit pobieramy z tabeli FACT Product Backlog.
--7. Sumujemy iloœæ commitów dla ka¿dego z pracowników oraz dzielimy je w
--stosunku do daty zawartej jako klucz obcy w tabeli FACT Sprint (ID_Koniec)
--8. Sumujemy status “nie wykonany” z tabeli wymiaru DIM_Status na przeciêciu
--z tabel¹ DIM_Typ
select COUNT(*) from [dbo].[Wykonanie_zadania] as W
join [dbo].[Status] as T on T.ID_Status = W.ID_Status
where T.Status = 'Nieukonczone'

--9. Sumujemy profit z Tabeli FACT_Product_Backlog oraz dzielimy go na liczbê
--dni miêdzy pocz¹tkiem a zakoñczeniem Product Backlogu.
--10.Sektor Gospodarki znajdziemy w tabeli DIM_Firma a koszty produktów w
--FACT Product Backlog.
