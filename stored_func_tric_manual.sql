-- 1. **SQL Stored Procedure**: Sukuriame saugomà procedûrà, kuri áterpia naujà mokiná á mokiniu lentelæ
CREATE PROCEDURE InsertMokinys
    @Vardas NVARCHAR(50),
    @Pavarde NVARCHAR(50),
    @ElPastas NVARCHAR(100),
    @GimimoData DATE
AS
BEGIN
    -- Áterpiame naujà mokiná á Mokiniai lentelæ
    INSERT INTO Mokiniai (Vardas, Pavarde, ElPastas, GimimoData)
    VALUES (@Vardas, @Pavarde, @ElPastas, @GimimoData);
END;
GO

-- Naudojame ðià procedûrà, kad áterptume naujà mokiná:
EXEC InsertMokinys 'Jurgita', 'Jurgaitë', 'jurgita.jurgita@example.com', '2007-07-10';
select *from Mokiniai


-- 2. **SQL Function**: Sukuriame funkcijà, kuri apskaièiuoja mokinio amþiø pagal gimimo datà
CREATE FUNCTION dbo.CalculateAge (@GimimoData DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;
    
    -- Apskaièiuojame amþiø pagal skirtumà tarp gimimo datos ir dabartinës datos
    SET @Age = DATEDIFF(YEAR, @GimimoData, GETDATE());
    
    -- Jei gimtadienis dar neávyko ðiais metais, sumaþiname amþiø
    IF (MONTH(@GimimoData) > MONTH(GETDATE())) OR 
       (MONTH(@GimimoData) = MONTH(GETDATE()) AND DAY(@GimimoData) > DAY(GETDATE()))
    BEGIN
        SET @Age = @Age - 1;
    END
    
    -- Gràþiname apskaièiuotà amþiø
    RETURN @Age;
END;
GO

SELECT Vardas, Pavarde, dbo.CalculateAge(GimimoData) AS Amþius
FROM Mokiniai
WHERE MokinioID = 1;


--kuriam trigerri
-- Sukuriame triggerá, kuris áraðo pakeitimus á ChangeLog lentelæ
CREATE TRIGGER trg_AfterUpdateMokiniai2
ON Mokiniai
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Skiriame stulpelius pagal INSERTED ir DELETED alias
    -- INSERTED turi naujas reikðmes, o DELETED turi senas
    DECLARE @MokinioID INT, @OldPavarde NVARCHAR(50), @NewPavarde NVARCHAR(50);

    -- Paþymime senà ir naujà pavardæ (jei tik pavardë pasikeitë)
    SELECT @MokinioID = i.MokinioID, 
           @OldPavarde = d.Pavarde, 
           @NewPavarde = i.Pavarde
    FROM INSERTED i
    JOIN DELETED d ON i.MokinioID = d.MokinioID
    WHERE i.Pavarde <> d.Pavarde;  -- Tik jei pavardë pasikeitë

    -- Jei pavardë pasikeitë, áraðome ðá pokytá á ChangeLog lentelæ
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
-- Atnaujiname mokinio pavardæ
UPDATE Mokiniai
SET Pavarde = 'Jonavièius'
WHERE MokinioID = 1;

SELECT * FROM ChangeLog;


-- 4. **Manual Transaction**: leidþia atlikti kelis SQL veiksmus kaip vienà operacijà
BEGIN TRANSACTION;

BEGIN TRY
    -- Áterpiame mokiná á Mokiniai lentelæ
    INSERT INTO Mokiniai (Vardas, Pavarde, ElPastas, GimimoData)
    VALUES ('Ema', 'Emytë', 'ema.emyte@example.com', '2006-10-15');

    -- Atnaujiname kito mokinio pavardæ
    UPDATE Mokiniai
    SET Pavarde = 'Daili'
    WHERE MokinioID = 2;

    -- Jei abu veiksmai buvo sëkmingi, ávykdome commit
    COMMIT;
END TRY
BEGIN CATCH
    -- Jei ávyko klaida, atðaukiame operacijas
    ROLLBACK;
    -- Parodome klaidos informacijà
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO