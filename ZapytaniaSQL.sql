--zapytania 
--1 
--Pobieramy wszystkie product backlogi dla danego produktu (ograniczając po
--ID_produktu z tabeli faktu) i sprawdzamy czas wraz z aktualizacjami
--backlogów liczba zadań i tym samym złożoność projektu się zwiększa na
--podstawie miary Liczba_zadań
--PB1 to ten nowszy
select PB1.ID_Poczatek , PB2.ID_Poczatek , P.nazwa from Product_backlog as PB1
join Produkt1 as P on PB1.ID_product=P.ID_produkt
join Product_backlog as PB2 on PB2.ID_product=P.ID_produkt
where PB1.ID_Product_Backlog!= PB2.ID_Product_Backlog
and PB1.ID_Poczatek > PB2.ID_Poczatek
and PB1.liczba_zadan>PB2.liczba_zadan

--2. 
--Sektor gospodarczy pobieramy z tabeli DIM_Firma. Następnie sprawdzamy
--czy zdarzyło się przekroczenie objętości planowanej dla sprintu [Tabela
--FACT_Sprint] gdzie procent wykonania musiałby być większy niż 100

select F.Sektor_Gospodarki , S.ID_Sprint from sprint as S
join dbo.product_backlog as PB on S.ID_Product_Backlog=PB.ID_Product_Backlog
join dbo.firma as F on F.ID_Firma = PB.ID_Firmy 
where Rzeczywista_objetosc>Planowana_objetosc
or Procent_wykonania>100
--3.
--Filtrujemy sprinty po Scrummasterach korzystając z ID_Scrum_Master,,
--następnie dla każdego z nich wyznaczamy średnią liczbę błędów na wdrożenie
--ze wszystkich przeprowadzonych przez nich sprintów, sortujemy ich po
--średniej rosnąco i wyświetlamy 3 pozycje.

select TOP(3) l.Imie_i_nazwisko ,l.Numer_pracownika ,AVG(s.Liczba_bledow_na_wdrozenie) as [srednia liczba bledow na wdrozenie]  from [dbo].[Sprint] as s
join [dbo].[Ludzie] as l on s.ID_Scrum_Master=l.ID_Osoby
group by  l.Imie_i_nazwisko ,l.Numer_pracownika
order by  AVG(s.Liczba_bledow_na_wdrozenie)

--4. Filtrujemy zadania po ich typie korzystając z tabeli wymiarów Typ oraz
--ID_typu w tabeli faktu i wybieramy tylko te typu frontendowego, a następnie
--na podstawie różnicy między estymowanym a rzeczywistym czasem
--wykonania kazdego zadania wyliczamy ich średnią.

select AVG(wykonanie_zadania.estymacja_zadania-wykonanie_zadania.czas_wykonania), wykonanie_zadania.id_zadania from wykonanie_zadania
join typ on typ.id_typu=wykonanie_zadania.id_typ
where typ.typ = 'Fortend'
group by wykonanie_zadania.id_zadania

--5. Filtrujemy zadania po ich typie korzystając z tabeli wymiarów Typ oraz
--ID_typu w tabeli faktu, dla typów frontendowego i backendowego obliczamy
--średnią z rożnicy rzeczywistego oraz estymowanego czasu wykonania i je
--porównujemy
select AVG(w.estymacja_zadania-w.czas_wykonania),t.typ from wykonanie_zadania w
join typ t on t.id_typu=w.id_typ
group by t.typ

--Podaj mi zależność profitu z zakończonych produktów w danym miesiącu w
--porównaniu do zeszłego roku.(3)
--6. Datę oraz profit pobieramy z tabeli FACT Product Backlog.
--Podaj mi pracownika, który wykonał największą ilość commitów wg miesięcy
--(4)
create view widok as
  SELECT MAX(w1.Liczba_committow) AS max_number_of_commits, d.rok, d.miesiac, l.imie_i_nazwisko
FROM     ludzie AS l  JOIN
                  wykonanie_zadania AS w1 ON l.id_osoby = w1.id_osoby  JOIN
                  dbo.Sprint AS S ON S.ID_Sprint = w1.id_sprintu  JOIN
                  dbo.data AS d ON d.id_daty = s.id_poczatek
GROUP BY d.rok, d.miesiac, l.imie_i_nazwisko
  select widok.Imie_i_nazwisko ,max_number_of_commits, rok_max.rok , rok_max.miesiac from (select max([max  number of commits]) as maks ,rok,miesiac
  from widok group by  rok,miesiac)  rok_max , widok
  where widok.max_number_of_commits = rok_max.maks and rok_max.miesiac=widok.miesiac and rok_max.rok=widok.rok
                                               
                                               
                                               
select max(w1.Liczba_committow) as [max  number of commits] , d.rok ,d.miesiac,l.imie_i_nazwisko from  ludzie as l
join wykonanie_zadania as w1 on l.id_osoby=w1.id_osoby
join sprint as s on s.id_sprint=w1.id_Sprintu
join data as d on d.id_daty = s.id_poczatek
group by d.rok ,d.miesiac ,l.imie_i_nazwisko 

--7.
create view b as
select sum(pb.profit) as profit_suma , d.rok , d.miesiac from product_backlog as pb
join Data as D on D.ID_Daty = PB.id_poczatek
group by D.Rok , D.Miesiac
select * from B as C
join B as A on C.Rok  = A.Rok AND A.Miesiac = C.Miesiac-1 

--8. Sumujemy status “nie wykonany” z tabeli wymiaru DIM_Status na przecięciu
--z tabelą DIM_Typ
select COUNT(*) as [ile zadan nie zostalo wykonanych] from [dbo].[Wykonanie_zadania] as W
join [dbo].[Status] as T on T.ID_Status = W.ID_Status
where T.Status = 'Nieukonczone'

--9. Sumujemy profit z Tabeli FACT_Product_Backlog oraz dzielimy go na liczbę
--dni między początkiem a zakończeniem Product Backlogu.
SELECT TOP(3) P.nazwa, (PB.Profit/((DATEDIFF(DD,D1.Data ,D2.Data )))) as 'Profit na dzien'  from Product_backlog as PB
join Produkt1 as P on PB.ID_product=P.ID_produkt
join Data as D1 on PB.ID_Poczatek=D1.ID_Daty
join Data as D2 on PB.ID_Koniec=D2.ID_Daty
where PB.ID_Koniec is not null
--group by P.nazwa
order by 'Profit na dzien'


--10.Sektor Gospodarki znajdziemy w tabeli DIM_Firma a koszty produktów w
--FACT Product Backlog.
SELECT SUM(PB.Profit) as profit, F.Sektor_Gospodarki as Sektor_Gospodarki from Product_Backlog as PB
join [dbo].[Firma] as F on F.ID_Firma = PB.ID_Firmy 
where ID_Koniec is not null
group by F.Sektor_Gospodarki
