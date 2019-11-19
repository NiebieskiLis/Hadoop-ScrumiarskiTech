--zapytania 
--1 
--pobieramy wszystkie product backlogi dla danego produktu (ograniczając po
--id_produktu z tabeli faktu) i sprawdzamy czas wraz z aktualizacjami
--backlogów liczba zadań i tym samym złożoność projektu się zwiększa na
--podstawie miary liczba_zadań
--pb1 to ten nowszy
select pb1.id_poczatek , pb2.id_poczatek , p.nazwa from product_backlog as pb1
join produkt1 as p on pb1.id_product=p.id_produkt
join product_backlog as pb2 on pb2.id_product=p.id_produkt
where pb1.id_product_backlog!= pb2.id_product_backlog
and pb1.id_poczatek > pb2.id_poczatek
and pb1.liczba_zadan>pb2.liczba_zadan

--2. 
--sektor gospodarczy pobieramy z tabeli dim_firma. następnie sprawdzamy
--czy zdarzyło się przekroczenie objętości planowanej dla sprintu [tabela
--fact_sprint] gdzie procent wykonania musiałby być większy niż 100

select f.sektor_gospodarki , s.id_sprint from sprint as s
join dbo.product_backlog as pb on s.id_product_backlog=pb.id_product_backlog
join dbo.firma as f on f.id_firma = pb.id_firmy 
where rzeczywista_objetosc>planowana_objetosc
or procent_wykonania>100
--3.
--filtrujemy sprinty po scrummasterach korzystając z id_scrum_master,,
--następnie dla każdego z nich wyznaczamy średnią liczbę błędów na wdrożenie
--ze wszystkich przeprowadzonych przez nich sprintów, sortujemy ich po
--średniej rosnąco i wyświetlamy 3 pozycje.

select top(3) l.imie_i_nazwisko ,l.numer_pracownika ,avg(s.liczba_bledow_na_wdrozenie) as [srednia liczba bledow na wdrozenie]  from [dbo].[sprint] as s
join [dbo].[ludzie] as l on s.id_scrum_master=l.id_osoby
group by  l.imie_i_nazwisko ,l.numer_pracownika
order by  avg(s.liczba_bledow_na_wdrozenie)

--4. filtrujemy zadania po ich typie korzystając z tabeli wymiarów typ oraz
--id_typu w tabeli faktu i wybieramy tylko te typu frontendowego, a następnie
--na podstawie różnicy między estymowanym a rzeczywistym czasem
--wykonania kazdego zadania wyliczamy ich średnią.

select avg(wykonanie_zadania.estymacja_zadania-wykonanie_zadania.czas_wykonania), wykonanie_zadania.id_zadania from wykonanie_zadania
join typ on typ.id_typu=wykonanie_zadania.id_typ
where typ.typ = 'fortend'
group by wykonanie_zadania.id_zadania

--5. filtrujemy zadania po ich typie korzystając z tabeli wymiarów typ oraz
--id_typu w tabeli faktu, dla typów frontendowego i backendowego obliczamy
--średnią z rożnicy rzeczywistego oraz estymowanego czasu wykonania i je
--porównujemy
select avg(w.estymacja_zadania-w.czas_wykonania),t.typ from wykonanie_zadania w
join typ t on t.id_typu=w.id_typ
group by t.typ

--podaj mi zależność profitu z zakończonych produktów w danym miesiącu w
--porównaniu do zeszłego roku.(3)
--6. datę oraz profit pobieramy z tabeli fact product backlog.
--podaj mi pracownika, który wykonał największą ilość commitów wg miesięcy
--(4)
create view widok as
  select max(w1.liczba_committow) as max_number_of_commits, d.rok, d.miesiac, l.imie_i_nazwisko
from     ludzie as l  join
                  wykonanie_zadania as w1 on l.id_osoby = w1.id_osoby  join
                  dbo.sprint as s on s.id_sprint = w1.id_sprintu  join
                  dbo.data as d on d.id_daty = s.id_poczatek
group by d.rok, d.miesiac, l.imie_i_nazwisko
  select widok.imie_i_nazwisko ,max_number_of_commits, rok_max.rok , rok_max.miesiac from (select max([max  number of commits]) as maks ,rok,miesiac
  from widok group by  rok,miesiac)  rok_max , widok
  where widok.max_number_of_commits = rok_max.maks and rok_max.miesiac=widok.miesiac and rok_max.rok=widok.rok
                                               
                                               
                                               
select max(w1.liczba_committow) as [max  number of commits] , d.rok ,d.miesiac,l.imie_i_nazwisko from  ludzie as l
join wykonanie_zadania as w1 on l.id_osoby=w1.id_osoby
join sprint as s on s.id_sprint=w1.id_sprintu
join data as d on d.id_daty = s.id_poczatek
group by d.rok ,d.miesiac ,l.imie_i_nazwisko 

--7.
create view b as
select sum(pb.profit) as profit_suma , d.rok , d.miesiac from product_backlog as pb
join data as d on d.id_daty = pb.id_poczatek
group by d.rok , d.miesiac
select * from b as c
join b as a on c.rok  = a.rok and a.miesiac = c.miesiac-1 

--8. sumujemy status “nie wykonany” z tabeli wymiaru dim_status na przecięciu
--z tabelą dim_typ
select count(*) as [ile zadan nie zostalo wykonanych] from [dbo].[wykonanie_zadania] as w
join [dbo].[status] as t on t.id_status = w.id_status
where t.status = 'nieukonczone'

--9. sumujemy profit z tabeli fact_product_backlog oraz dzielimy go na liczbę
--dni między początkiem a zakończeniem product backlogu.
select top(3) p.nazwa, (pb.profit/((datediff(dd,d1.data ,d2.data )))) as 'profit na dzien'  from product_backlog as pb
join produkt1 as p on pb.id_product=p.id_produkt
join data as d1 on pb.id_poczatek=d1.id_daty
join data as d2 on pb.id_koniec=d2.id_daty
where pb.id_koniec is not null
--group by p.nazwa
order by 'profit na dzien'


--10.sektor gospodarki znajdziemy w tabeli dim_firma a koszty produktów w
--fact product backlog.
select sum(pb.profit) as profit, f.sektor_gospodarki as sektor_gospodarki from product_backlog as pb
join [dbo].[firma] as f on f.id_firma = pb.id_firmy 
where id_koniec is not null
group by f.sektor_gospodarki
