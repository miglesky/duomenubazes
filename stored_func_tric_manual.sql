-- 1. **SQL Stored Procedure**: Sukuriame saugom� proced�r�, kuri �terpia nauj� mokin� � mokiniu lentel�
CREATE PROCEDURE InsertMokinys
    @Vardas NVARCHAR(50),
    @Pavarde NVARCHAR(50),
    @ElPastas NVARCHAR(100),
    @GimimoData DATE
AS
BEGIN
    -- �terpiame nauj� mokin� � Mokiniai lentel�
    INSERT INTO Mokiniai (Vardas, Pavarde, ElPastas, GimimoData)
    VALUES (@Vardas, @Pavarde, @ElPastas, @GimimoData);
END;
GO

-- Naudojame �i� proced�r�, kad �terptume nauj� mokin�:
EXEC InsertMokinys 'Jurgita', 'Jurgait�', 'jurgita.jurgita@example.com', '2007-07-10';
select *from Mokiniai


-- 2. **SQL Function**: Sukuriame funkcij�, kuri apskai�iuoja mokinio am�i� pagal gimimo dat�
CREATE FUNCTION dbo.CalculateAge (@GimimoData DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;
    
    -- Apskai�iuojame am�i� pagal skirtum� tarp gimimo datos ir dabartin�s datos
    SET @Age = DATEDIFF(YEAR, @GimimoData, GETDATE());
    
    -- Jei gimtadienis dar ne�vyko �iais metais, suma�iname am�i�
    IF (MONTH(@GimimoData) > MONTH(GETDATE())) OR 
       (MONTH(@GimimoData) = MONTH(GETDATE()) AND DAY(@GimimoData) > DAY(GETDATE()))
    BEGIN
        SET @Age = @Age - 1;
    END
    
    -- Gr��iname apskai�iuot� am�i�
    RETURN @Age;
END;
GO

SELECT Vardas, Pavarde, dbo.CalculateAge(GimimoData) AS Am�ius
FROM Mokiniai
WHERE MokinioID = 1;


--kuriam trigerri
-- Sukuriame trigger�, kuris �ra�o pakeitimus � ChangeLog lentel�
CREATE TRIGGER trg_AfterUpdateMokiniai2
ON Mokiniai
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Skiriame stulpelius pagal INSERTED ir DELETED alias
    -- INSERTED turi naujas reik�mes, o DELETED turi senas
    DECLARE @MokinioID INT, @OldPavarde NVARCHAR(50), @NewPavarde NVARCHAR(50);

    -- Pa�ymime sen� ir nauj� pavard� (jei tik pavard� pasikeit�)
    SELECT @MokinioID = i.MokinioID, 
           @OldPavarde = d.Pavarde, 
           @NewPavarde = i.Pavarde
    FROM INSERTED i
    JOIN DELETED d ON i.MokinioID = d.MokinioID
    WHERE i.Pavarde <> d.Pavarde;  -- Tik jei pavard� pasikeit�

    -- Jei pavard� pasikeit�, �ra�ome �� pokyt� � ChangeLog lentel�
    IF @MokinioID IS NOT NULL
    BEGIN
        INSERT INTO ChangeLog (MokinioID, OldValue, NewValue, ChangeDate)
        VALUES (@MokinioID, @OldPavarde, @NewPavarde, GETDATE());
    END;
END;
GO

CREATE TABLE ChangeLog (
    ChangeID INT IDENTITY(1,1) PRIMARY KEY,
    MokinioID INT,
    OldValue NVARCHAR(50),
    NewValue NVARCHAR(50),
    ChangeDate DATETIME
);
-- Atnaujiname mokinio pavard�
UPDATE Mokiniai
SET Pavarde = 'Jonavi�ius'
WHERE MokinioID = 1;

SELECT * FROM ChangeLog;


-- 4. **Manual Transaction**: leid�ia atlikti kelis SQL veiksmus kaip vien� operacij�
BEGIN TRANSACTION;

BEGIN TRY
    -- �terpiame mokin� � Mokiniai lentel�
    INSERT INTO Mokiniai (Vardas, Pavarde, ElPastas, GimimoData)
    VALUES ('Ema', 'Emyt�', 'ema.emyte@example.com', '2006-10-15');

    -- Atnaujiname kito mokinio pavard�
    UPDATE Mokiniai
    SET Pavarde = 'Daili'
    WHERE MokinioID = 2;

    -- Jei abu veiksmai buvo s�kmingi, �vykdome commit
    COMMIT;
END TRY
BEGIN CATCH
    -- Jei �vyko klaida, at�aukiame operacijas
    ROLLBACK;
    -- Parodome klaidos informacij�
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO