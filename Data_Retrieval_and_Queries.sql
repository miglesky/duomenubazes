
SELECT 
    M.Specializacija,  -- Mokytojo specializacija, grupuojame pagal j�
    COUNT(DISTINCT MP.MokinioID) AS Mokiniai_Skaicius,  -- Skai�iuojame mokini� skai�i� pagal specializacij� (COUNT)
    AVG(DATEDIFF(YEAR, Mokiniai.GimimoData, GETDATE())) AS Vidutinis_Mokinio_Amzius,  -- Apskai�iuojame vidutin� mokini� am�i� ( AVG)
    SUM(CASE WHEN Pamokos.MokytojoID = M.MokytojoID THEN 1 ELSE 0 END) AS Pamokos_Skaicius,  -- Skai�iuojame pamok� skai�i� pagal mokytojo specializacij�  SUM)
    Pamokos.Pavadinimas,  -- Pamokos pavadinimas, grupuojame pagal j�
    AVG(DATEDIFF(YEAR, Mokiniai.GimimoData, GETDATE())) AS Vidutinis_Mokinio_Amzius_Pamokoje  -- Vidutiniai mokini� am�iai pagal pamokas
FROM 
    Mokytojai M
JOIN 
    Pamokos ON M.MokytojoID = Pamokos.MokytojoID  -- Sujungiame mokytojus su pamokomis
JOIN 
    MokiniuPamokos MP ON Pamokos.PamokosID = MP.PamokosID  -- Sujungiame mokinius su pamokomis
JOIN 
    Mokiniai ON MP.MokinioID = Mokiniai.MokinioID  -- Sujungiame mokinius su id
GROUP BY 
    M.Specializacija, Pamokos.Pavadinimas  -- Grupavimas pagal mokytojo specializacij� ir pamokos pavadinim�
ORDER BY 
    Pamokos.Pavadinimas ASC, Vidutinis_Mokinio_Amzius DESC  -- R��iavimas pagal pamokos pavadinim� did�jimo tvarka ir vidutin� am�i� ma��jimo tvarka
OFFSET 0 ROWS  -- Puslapio strukt�ros prad�ia, prad�sime nuo pirmo �ra�o
FETCH NEXT 10 ROWS ONLY;  -- Imame tik 10 �ra�� (puslapio dydis)


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

