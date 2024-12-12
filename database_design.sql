CREATE DATABASE Mokykla_DB;
GO

-- Pasirenkame duomen� baz�
USE Mokykla_DB;
GO

-- Lentel�: Mokiniai
CREATE TABLE Mokiniai (
    MokinioID INT IDENTITY(1,1) PRIMARY KEY,
    Vardas NVARCHAR(50) NOT NULL,
    Pavarde NVARCHAR(50) NOT NULL,
    ElPastas NVARCHAR(100) UNIQUE NOT NULL,
    GimimoData DATE NOT NULL
);

-- Lentel�: Mokytojai
CREATE TABLE Mokytojai (
    MokytojoID INT IDENTITY(1,1) PRIMARY KEY,
    Vardas NVARCHAR(50) NOT NULL,
    Pavarde NVARCHAR(50) NOT NULL,
    Specializacija NVARCHAR(100),
    ElPastas NVARCHAR(100) UNIQUE NOT NULL
);

-- Lentel�: Pamokos
CREATE TABLE Pamokos (
    PamokosID INT IDENTITY(1,1) PRIMARY KEY,
    Pavadinimas NVARCHAR(100) NOT NULL,
    MokytojoID INT NOT NULL,
    FOREIGN KEY (MokytojoID) REFERENCES Mokytojai(MokytojoID)
);

-- Lentel�: Tvarkara��iai
CREATE TABLE Tvarkarastis (
    TvarkarascioID INT IDENTITY(1,1) PRIMARY KEY,
    PamokosID INT NOT NULL,
    Pradzia DATETIME NOT NULL,
    Pabaiga DATETIME NOT NULL,
    KLAS� NVARCHAR(10),
    FOREIGN KEY (PamokosID) REFERENCES Pamokos(PamokosID)
);
-- Lentel�: Jungiamoji lentel� Mokiniai-Pamokos
CREATE TABLE MokiniuPamokos (
    MokinioID INT NOT NULL,
    PamokosID INT NOT NULL,
    PRIMARY KEY (MokinioID, PamokosID),
    FOREIGN KEY (MokinioID) REFERENCES Mokiniai(MokinioID),
    FOREIGN KEY (PamokosID) REFERENCES Pamokos(PamokosID)
);

-- Indeks� k�rimas
CREATE INDEX IDX_Mokiniai_Pavarde ON Mokiniai (Pavarde);
CREATE INDEX IDX_Pamokos_Pavadinimas ON Pamokos (Pavadinimas);
