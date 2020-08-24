use Hadoop;
create table Firma 
(ID_Firma int, 
Nazwa_Frimy nvarchar(50),
Sektor_Gospodarki nvarchar(50)) 
create table Ludzie (ID_Osoby int, Imie_i_nazwisko nvarchar(50), Numer_pracownika int)  ;
create table Typ (ID_Typu int, Typ nvarchar(50))  ;
create table Status (ID_Status int, Status nvarchar(50))  ;
create table Data (ID_Daty int, Data Date, Rok Int, Miesiac int, Dzien int )  ;

create table Produkt (ID_Produkt int, ID_Product_Owner int, nazwa nvarchar(50))  ;

create table Produkt (ID_Produkt int, ID_Product_Owner int, nazwa nvarchar(50), inne MAP<nvarchar(50),nvarchar(50)>) 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
COLLECTION ITEMS TERMINATED BY '#'
MAP KEYS TERMINATED BY '@'
STORED AS TEXTFILE;
LOAD DATA INPATH '/tmp/data/SampleData3.txt' OVERWRITE INTO TABLE Produkt;

create  table Product_Backlog (ID_Product_Backlog int, ID_Product int, ID_Deadline int, ID_Poczatek int, ID_Koniec int, ID_Firmy int, Koszt float, Cena float, Profit float, liczba_zadan int)  ;
create  table Sprint (ID_Sprint int,ID_Product_Backlog int, ID_Poczatek int, ID_Product int, ID_Koniec int, ID_Scrum_Master int, Planowana_objetosc float, Rzeczywista_objetosc float, Procent_wykonania float, Liczba_bledow_na_wdrozenie int, Planowana_liczba_ceremonii int, Finalna_liczba_ceremonii int)  ;
create  table Wykonanie_zadania (ID_Wykonanie_zadania int, ID_Sprintu int, ID_Status int, ID_Zadania int,ID_Typ int, Czas_wykonania float, Estymacja_zadania float, Liczba_committow int, Liczba_zmienionych_plikow int, Liczba_zmienionych_linijek_kodu int)  ;



