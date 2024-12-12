-- �ra�� �terpimas � lentel� Mokiniai
INSERT INTO Mokiniai (Vardas, Pavarde, ElPastas, GimimoData) VALUES
('Jonas', 'Jonaitis', 'jonas.jonaitis@example.com', '2005-04-20'),
('Ona', 'Onaite', 'ona.onaite@example.com', '2006-06-15'),
('Petras', 'Petraitis', 'petras.petraitis@example.com', '2005-09-10'),
('Greta', 'Gretaite', 'greta.gretaite@example.com', '2005-12-05'),
('Darius', 'Dariukas', 'darius.dariukas@example.com', '2006-01-10'),
('Laura', 'Laurinait�', 'laura.laurinaite@example.com', '2004-11-22'),
('Tomas', 'Tomaitis', 'tomas.tomaitis@example.com', '2005-03-03'),
('Aist�', 'Aistut�', 'aiste.aistute@example.com', '2006-05-17'),
('Karolis', 'Karoliukas', 'karolis.karoliukas@example.com', '2005-09-28'),
('Egl�', 'Eglut�', 'egle.eglute@example.com', '2006-07-09');


-- �ra�� �terpimas � lentel� Mokytojai
INSERT INTO Mokytojai (Vardas, Pavarde, Specializacija, ElPastas) VALUES
('Rasa', 'Rasait�', 'Matematika', 'rasa.rasaite@example.com'),
('Dainius', 'Dainiukas', 'Biologija', 'dainius.dainiukas@example.com'),
('Agn�', 'Agnut�', 'Fizika', 'agne.agnute@example.com'),
('Justinas', 'Justinaitis', 'Informatika', 'justinas.justinaitis@example.com'),
('Simona', 'Simonait�', 'Angl� kalba', 'simona.simonait�@example.com');

-- �ra�� �terpimas � lentel� Pamokos
INSERT INTO Pamokos (Pavadinimas, MokytojoID) VALUES
('Matematika', 1),
('Biologija', 2),
('Fizika', 3),
('Informatika', 4),
('Angl� kalba', 5);

-- �ra�� �terpimas � lentel� Tvarkarastis
INSERT INTO Tvarkarastis (PamokosID, Pradzia, Pabaiga, Klas�) VALUES
(1, '2023-09-01 08:00:00', '2023-09-01 09:30:00', 'A101'),
(2, '2023-09-01 10:00:00', '2023-09-01 11:30:00', 'B202'),
(3, '2023-09-02 08:00:00', '2023-09-02 09:30:00', 'C303'),
(4, '2023-09-02 10:00:00', '2023-09-02 11:30:00', 'D404'),
(5, '2023-09-03 08:00:00', '2023-09-03 09:30:00', 'E505');

-- �ra�� �terpimas � jungiam�j� lentel� MokiniuPamokos
INSERT INTO MokiniuPamokos (MokinioID, PamokosID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 4),
(3, 2),
(3, 5),
(4, 3),
(4, 5),
(5, 1),
(5, 4),
(6, 2),
(6, 5),
(7, 3),
(7, 4),
(8, 1),
(8, 2),
(9, 3),
(9, 5),
(10, 4);

-- Atnaujinimo u�klausos
UPDATE Mokiniai
SET Pavarde = 'Jonavi�ius'
WHERE MokinioID = 1;

UPDATE Pamokos
SET Pavadinimas = 'Biologija 2'
WHERE PamokosID = 2;

-- Trynimo u�klausos
DELETE FROM MokiniuPamokos
WHERE MokinioID = 3 AND PamokosID = 2;

TRUNCATE TABLE Tvarkarastis;


 select *from mokiniai
 select *from pamokos
 select *from MokiniuPamokos