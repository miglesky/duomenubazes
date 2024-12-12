-- INNER JOIN uþklausa, sujungiant dvi lenteles: Mokiniai ir Pamokos
SELECT 
    Mokiniai.Vardas AS Mokinys_Vardas, 
    Mokiniai.Pavarde AS Mokinys_Pavarde, 
    Pamokos.Pavadinimas AS Pamoka
FROM 
    Mokiniai
INNER JOIN 
    MokiniuPamokos MP ON Mokiniai.MokinioID = MP.MokinioID  -- Susiejame mokinius su pamokomis per jungiamàjà lentelæ
INNER JOIN 
    Pamokos ON MP.PamokosID = Pamokos.PamokosID;  -- Susiejame pamokas su pamokø áraðais

-- LEFT JOIN uþklausa, sujungiant Mokiniai ir Pamokos lenteles, átraukiant visus mokinius net jei jie neturi pamokø
SELECT 
    Mokiniai.Vardas AS Mokinys_Vardas, 
    Mokiniai.Pavarde AS Mokinys_Pavarde, 
    Pamokos.Pavadinimas AS Pamoka
FROM 
    Mokiniai
LEFT JOIN 
    MokiniuPamokos MP ON Mokiniai.MokinioID = MP.MokinioID  -- Susiejame mokinius su pamokomis
LEFT JOIN 
    Pamokos ON MP.PamokosID = Pamokos.PamokosID;  -- Susiejame pamokas su pamokø áraðais

-- RIGHT JOIN uþklausa, sujungiant Pamokos ir Mokiniai lenteles, átraukiant visas pamokas, net jei jø neturi mokiniai
SELECT 
    Mokiniai.Vardas AS Mokinys_Vardas, 
    Mokiniai.Pavarde AS Mokinys_Pavarde, 
    Pamokos.Pavadinimas AS Pamoka
FROM 
    Pamokos
RIGHT JOIN 
    MokiniuPamokos MP ON Pamokos.PamokosID = MP.PamokosID  -- Susiejame pamokas su mokiniais
RIGHT JOIN 
    Mokiniai ON MP.MokinioID = Mokiniai.MokinioID;  -- Susiejame mokinius su pamokomis

-- Trijø lenteliø sujungimas (Mokiniai, Pamokos ir Mokytojai) naudojant INNER JOIN
SELECT 
    Mokiniai.Vardas AS Mokinys_Vardas, 
    Mokiniai.Pavarde AS Mokinys_Pavarde, 
    Pamokos.Pavadinimas AS Pamoka, 
    Mokytojai.Vardas AS Mokytojas_Vardas, 
    Mokytojai.Pavarde AS Mokytojas_Pavarde
FROM 
    Mokiniai
INNER JOIN 
    MokiniuPamokos MP ON Mokiniai.MokinioID = MP.MokinioID  -- Susiejame mokinius su pamokomis
INNER JOIN 
    Pamokos ON MP.PamokosID = Pamokos.PamokosID  -- Susiejame pamokas su jø pavadinimais
INNER JOIN 
    Mokytojai ON Pamokos.MokytojoID = Mokytojai.MokytojoID;  -- Susiejame pamokas su mokytojais

-- Sukuriame vaizdà (VIEW), sujungiant tris lenteles: Mokiniai, Pamokos ir Mokytojai
CREATE VIEW MokiniaiPamokosMokytojai AS
SELECT 
    Mokiniai.Vardas AS Mokinys_Vardas, 
    Mokiniai.Pavarde AS Mokinys_Pavarde, 
    Pamokos.Pavadinimas AS Pamoka, 
    Mokytojai.Vardas AS Mokytojas_Vardas, 
    Mokytojai.Pavarde AS Mokytojas_Pavarde
FROM 
    Mokiniai
INNER JOIN 
    MokiniuPamokos MP ON Mokiniai.MokinioID = MP.MokinioID  -- Susiejame mokinius su pamokomis
INNER JOIN 
    Pamokos ON MP.PamokosID = Pamokos.PamokosID  -- Susiejame pamokas su jø pavadinimais
INNER JOIN 
    Mokytojai ON Pamokos.MokytojoID = Mokytojai.MokytojoID;  -- Susiejame pamokas su mokytojais

SELECT * FROM MokiniaiPamokosMokytojai;

SELECT * 
FROM MokiniaiPamokosMokytojai
WHERE Pamoka = 'Matematika';
