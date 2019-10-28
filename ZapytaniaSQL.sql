--zapytania 
--1 
--Pobieramy wszystkie product backlogi dla danego produktu (ograniczaj�c po
--ID_produktu z tabeli faktu) i sprawdzamy czas wraz z aktualizacjami
--backlog�w liczba zada� i tym samym z�o�ono�� projektu si� zwi�ksza na
--podstawie miary Liczba_zada�
--PB1 to ten nowszy
select PB1.ID_Poczatek , PB2.ID_Poczatek , P.nazwa from Product_backlog as PB1
join Produkt as P on PB1.ID_product=P.ID_produkt
join Product_backlog as PB2 on PB2.ID_product=P.ID_produkt
where PB1.ID_Product_Backlog!= PB2.ID_Product_Backlog
and PB1.ID_Poczatek > PB2.ID_Poczatek
and PB1.liczba_zadan>PB2.liczba_zadan

--2. 
--Sektor gospodarczy pobieramy z tabeli DIM_Firma. Nast�pnie sprawdzamy
--czy zdarzy�o si� przekroczenie obj�to�ci planowanej dla sprintu [Tabela
--FACT_Sprint] gdzie procent wykonania musia�by by� wi�kszy ni� 100

select F.Sektor_Gospodarki , S.ID_Sprint from Sprint as S
join [dbo].[Product_Backlog] as PB on S.[ID_Product_Backlog]=PB.ID_Product_Backlog
join [dbo].[Firma] as F on F.ID_Firma = PB.ID_Firmy 
where [Rzeczywista_objetosc]>[Planowana_objetosc]
or [Procent_wykonania]>100
--3.
--Filtrujemy sprinty po Scrummasterach korzystaj�c z ID_Scrum_Master,,
--nast�pnie dla ka�dego z nich wyznaczamy �redni� liczb� b��d�w na wdro�enie
--ze wszystkich przeprowadzonych przez nich sprint�w, sortujemy ich po
--�redniej rosn�co i wy�wietlamy 3 pozycje.

select TOP(3) l.Imie_i_nazwisko ,l.Numer_pracownika ,AVG(s.Liczba_bledow_na_wdrozenie) as [srednia liczba bledow na wdrozenie]  from [dbo].[Sprint] as s
join [dbo].[Ludzie] as l on s.ID_Scrum_Master=l.ID_Osoby
group by  l.Imie_i_nazwisko ,l.Numer_pracownika
order by  AVG(s.Liczba_bledow_na_wdrozenie)

--4. Filtrujemy zadania po ich typie korzystaj�c z tabeli wymiar�w Typ oraz
--ID_typu w tabeli faktu i wybieramy tylko te typu frontendowego, a nast�pnie
--na podstawie r�nicy mi�dzy estymowanym a rzeczywistym czasem
--wykonania kazdego zadania wyliczamy ich �redni�.

select AVG(W.[Estymacja_zadania]-W.[Czas_wykonania]), W.ID_Zadania from [dbo].[Wykonanie_zadania] as W
join Typ as T on T.ID_Typu=W.ID_Typ
where T.Typ = 'Fortend'
group by W.ID_Zadania

--5. Filtrujemy zadania po ich typie korzystaj�c z tabeli wymiar�w Typ oraz
--ID_typu w tabeli faktu, dla typ�w frontendowego i backendowego obliczamy
--�redni� z ro�nicy rzeczywistego oraz estymowanego czasu wykonania i je
--por�wnujemy
select AVG(W.[Estymacja_zadania]-W.[Czas_wykonania]),T.Typ from [dbo].[Wykonanie_zadania] as W
join Typ as T on T.ID_Typu=W.ID_Typ
group by T.Typ

--Podaj mi zale�no�� profitu z zako�czonych produkt�w w danym miesi�cu w
--por�wnaniu do zesz�ego roku.(3)
--6. Dat� oraz profit pobieramy z tabeli FACT Product Backlog.
--Podaj mi pracownika, kt�ry wykona� najwi�ksz� ilo�� commit�w wg miesi�cy
--(4)
select max(W1.Liczba_committow) as [max  number of commits] , D.Rok ,D.Miesiac,L.Imie_i_nazwisko from  [dbo].[Ludzie] as L
join [dbo].[Wykonanie_zadania] as W1 on L.ID_Osoby=W1.ID_osoby
join [dbo].[Sprint] as S on S.ID_Sprint=W1.ID_Sprintu
join [dbo].[Data] as D on D.ID_Daty = S.ID_Poczatek
group by D.Rok ,D.Miesiac ,L.Imie_i_nazwisko 

--7.
create view B as
select sum(PB.Profit) as Profit_suma , D.Rok , D.Miesiac from Product_Backlog as PB
join Data as D on D.ID_Daty = PB.ID_Poczatek
group by D.Rok , D.Miesiac
select * from B as C
join B as A on C.Rok  = A.Rok AND A.Miesiac = C.Miesiac-1 

--8. Sumujemy status �nie wykonany� z tabeli wymiaru DIM_Status na przeci�ciu
--z tabel� DIM_Typ
select COUNT(*) as [ile zadan nie zostalo wykonanych] from [dbo].[Wykonanie_zadania] as W
join [dbo].[Status] as T on T.ID_Status = W.ID_Status
where T.Status = 'Nieukonczone'

--9. Sumujemy profit z Tabeli FACT_Product_Backlog oraz dzielimy go na liczb�
--dni mi�dzy pocz�tkiem a zako�czeniem Product Backlogu.
SELECT TOP(3) P.nazwa, (PB.Profit/((DATEDIFF(DD,D1.Data ,D2.Data )))) as 'Profit na dzien'  from Product_backlog as PB
join Produkt as P on PB.ID_product=P.ID_produkt
join Data as D1 on PB.ID_Poczatek=D1.ID_Daty
join Data as D2 on PB.ID_Koniec=D2.ID_Daty
where PB.ID_Koniec is not null
--group by P.nazwa
order by 'Profit na dzien'


--10.Sektor Gospodarki znajdziemy w tabeli DIM_Firma a koszty produkt�w w
--FACT Product Backlog.
SELECT SUM(PB.Profit) as profit, F.Sektor_Gospodarki as Sektor_Gospodarki from Product_Backlog as PB
join [dbo].[Firma] as F on F.ID_Firma = PB.ID_Firmy 
where ID_Koniec is not null
group by F.Sektor_Gospodarki
