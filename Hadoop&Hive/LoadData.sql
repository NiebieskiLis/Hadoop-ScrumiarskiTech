create table Firma (ID_Firma int, Nazwa_Frimy STRING, Sektor_Gospodarki STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
create table Ludzie (ID_Osoby int, Imie_i_nazwisko STRING, Numer_pracownika int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
create table Typ (ID_Typu int, Typ STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
create table Status (ID_Status int, Status STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
create table Data (ID_Daty int, Data Date, Rok Int, Miesiac int, Dzien int ) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;

create table Produkt (ID_Produkt int, ID_Product_Owner int, nazwa STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;

create table Produkt1 (ID_Produkt int, ID_Product_Owner int, nazwa STRING, inne MAP<STRING,STRING>) 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
COLLECTION ITEMS TERMINATED BY '#'
MAP KEYS TERMINATED BY '@'
STORED AS TEXTFILE;
LOAD DATA INPATH '/user/maria_dev/Produkt.txt' OVERWRITE INTO TABLE Produkt1;
LOAD DATA INPATH '/user/maria_dev/Backlog.txt' OVERWRITE INTO TABLE Product_Backlog;
LOAD DATA INPATH '/user/maria_dev/Data.txt' OVERWRITE INTO TABLE Data;
LOAD DATA INPATH '/user/maria_dev/Firma.txt' OVERWRITE INTO TABLE Firma;
LOAD DATA INPATH '/user/maria_dev/Ludzie.txt' OVERWRITE INTO TABLE Ludzie;
LOAD DATA INPATH '/user/maria_dev/sprint2.txt' OVERWRITE INTO TABLE Sprint;
LOAD DATA INPATH '/user/maria_dev/Status.txt' OVERWRITE INTO TABLE Status;
LOAD DATA INPATH '/user/maria_dev/Typ.txt' OVERWRITE INTO TABLE Typ;
LOAD DATA INPATH '/user/maria_dev/Zadania.txt' OVERWRITE INTO TABLE Wykonanie_zadania;



create external table Product_Backlog (ID_Product_Backlog int, ID_Product int, ID_Deadline int, ID_Poczatek int, ID_Koniec int, ID_Firmy int, Koszt double, Cena double, Profit double, liczba_zadan int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
create external table Sprint (ID_Sprint int,ID_Product_Backlog int, ID_Poczatek int, ID_Product int, ID_Koniec int, ID_Scrum_Master int, Planowana_objetosc double, Rzeczywista_objetosc double, Procent_wykonania double, Liczba_bledow_na_wdrozenie int, Planowana_liczba_ceremonii int, Finalna_liczba_ceremonii int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;
create external table Wykonanie_zadania (ID_Wykonanie_zadania int, ID_Sprintu int, ID_Status int, ID_Zadania int,ID_Typ int, Czas_wykonania double, Estymacja_zadania double, Liczba_committow int, Liczba_zmienionych_plikow int, Liczba_zmienionych_linijek_kodu int, ID_Osoby int) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;



