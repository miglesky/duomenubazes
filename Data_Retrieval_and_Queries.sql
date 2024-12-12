
SELECT 
    M.Specializacija,  -- Mokytojo specializacija, grupuojame pagal jà
    COUNT(DISTINCT MP.MokinioID) AS Mokiniai_Skaicius,  -- Skaièiuojame mokiniø skaièiø pagal specializacijà (COUNT)
    AVG(DATEDIFF(YEAR, Mokiniai.GimimoData, GETDATE())) AS Vidutinis_Mokinio_Amzius,  -- Apskaièiuojame vidutiná mokiniø amþiø ( AVG)
    SUM(CASE WHEN Pamokos.MokytojoID = M.MokytojoID THEN 1 ELSE 0 END) AS Pamokos_Skaicius,  -- Skaièiuojame pamokø skaièiø pagal mokytojo specializacijà  SUM)
    Pamokos.Pavadinimas,  -- Pamokos pavadinimas, grupuojame pagal já
    AVG(DATEDIFF(YEAR, Mokiniai.GimimoData, GETDATE())) AS Vidutinis_Mokinio_Amzius_Pamokoje  -- Vidutiniai mokiniø amþiai pagal pamokas
FROM 
    Mokytojai M
JOIN 
    Pamokos ON M.MokytojoID = Pamokos.MokytojoID  -- Sujungiame mokytojus su pamokomis
JOIN 
    MokiniuPamokos MP ON Pamokos.PamokosID = MP.PamokosID  -- Sujungiame mokinius su pamokomis
JOIN 
    Mokiniai ON MP.MokinioID = Mokiniai.MokinioID  -- Sujungiame mokinius su id
GROUP BY 
    M.Specializacija, Pamokos.Pavadinimas  -- Grupavimas pagal mokytojo specializacijà ir pamokos pavadinimà
ORDER BY 
    Pamokos.Pavadinimas ASC, Vidutinis_Mokinio_Amzius DESC  -- Rûðiavimas pagal pamokos pavadinimà didëjimo tvarka ir vidutiná amþiø maþëjimo tvarka
OFFSET 0 ROWS  -- Puslapio struktûros pradþia, pradësime nuo pirmo áraðo
FETCH NEXT 10 ROWS ONLY;  -- Imame tik 10 áraðø (puslapio dydis)


--SELECT 
--    M.Specializacija,
--    Pamokos.Pavadinimas,
--    Mokiniai.Vardas,
--    Mokiniai.Pavarde
--FROM 
--    Mokytojai M
--JOIN 
--    Pamokos ON M.MokytojoID = Pamokos.MokytojoID
--JOIN 
--    MokiniuPamokos MP ON Pamokos.PamokosID = MP.PamokosID
--JOIN 
--    Mokiniai ON MP.MokinioID = Mokiniai.MokinioID
--ORDER BY 
--    M.Specializacija, Pamokos.Pavadinimas;

