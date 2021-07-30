CREATE DATABASE PizzeriaMenu

CREATE TABLE Pizza (
	[Codice] [INT] IDENTITY(10, 1) NOT NULL, --PRIMARY KEY
	[Nome] [VARCHAR](30) NOT NULL,
	[Prezzo] [DECIMAL](4,2) NOT NULL,
	CONSTRAINT [PK_Pizza] PRIMARY KEY (Codice),
	CONSTRAINT [UQ_Nome] UNIQUE(Nome),
);

CREATE TABLE Ingrediente (
	[Codice] [INT] IDENTITY(1, 1) NOT NULL, --PRIMARY KEY
	[Nome] [VARCHAR](30) NOT NULL,
	[Costo] [DECIMAL](4,2) NOT NULL,
	[ScorteMagazzino] [INTEGER] NOT NULL,
	CONSTRAINT [PK_Ingrediente] PRIMARY KEY (Codice),
	CONSTRAINT [UQ_Nome_i] UNIQUE(Nome),
);

CREATE TABLE PizzaIngrediente (
	[CodicePizza] [INT] NOT NULL,
	[CodiceIngrediente] [INT] NOT NULL,
	CONSTRAINT [FK_Pizza] FOREIGN KEY (CodicePizza) 
	REFERENCES Pizza(Codice),
	CONSTRAINT [FK_Ingrediente] FOREIGN KEY (CodiceIngrediente) 
	REFERENCES Ingrediente(Codice),
);

ALTER TABLE [Pizza]
WITH CHECK ADD CONSTRAINT [PrezzoPos]
CHECK ([Prezzo] > 0)

ALTER TABLE [Ingrediente]
WITH CHECK ADD CONSTRAINT [CostoPos]
CHECK ([Costo] > 0)

CREATE INDEX Pizza_NDX
ON Pizza (Nome ASC);

CREATE INDEX Ingrediente_NDX
ON Ingrediente (Codice ASC);

--INSERT
--INSERT INTO Ingrediente VALUES('Pomodoro', 3, 10)
--INSERT INTO Ingrediente VALUES('Mozzarella', 3.50, 10)
--INSERT INTO Ingrediente VALUES('Mozzarella di bufala', 4, 11)
--INSERT INTO Ingrediente VALUES('Spinata piccante', 3, 10)
--INSERT INTO Ingrediente VALUES('Funghi', 4, 10)
--INSERT INTO Ingrediente VALUES('Carciofi', 3, 11)
--INSERT INTO Ingrediente VALUES('Cotto', 6, 5)
--INSERT INTO Ingrediente VALUES('Olive', 2, 10)
--INSERT INTO Ingrediente VALUES('Funghi porcini', 4.55, 4)
--INSERT INTO Ingrediente VALUES('Stracchino', 7, 7)
--INSERT INTO Ingrediente VALUES('Speck', 6.40, 6)
--INSERT INTO Ingrediente VALUES('Rucola', 2, 2)
--INSERT INTO Ingrediente VALUES('Grana', 8, 10)
--INSERT INTO Ingrediente VALUES('Verdure di stagione', 3, 1)
--INSERT INTO Ingrediente VALUES('Patate', 2, 15)
--INSERT INTO Ingrediente VALUES('Salsiccia', 6, 5)
--INSERT INTO Ingrediente VALUES('Pomodorini', 3, 20)
--INSERT INTO Ingrediente VALUES('Ricotta', 5.5, 10)
--INSERT INTO Ingrediente VALUES('Provola', 8, 10)
--INSERT INTO Ingrediente VALUES('Gorgonzola', 8.5, 10)
--INSERT INTO Ingrediente VALUES('Grana', 9, 5)
--INSERT INTO Ingrediente VALUES('Pomodoro fresco', 3, 10)
--INSERT INTO Ingrediente VALUES('Basilico', 1, 8)
--INSERT INTO Ingrediente VALUES('Breasaola', 3, 10)
--INSERT INTO Ingrediente VALUES('Rucola', 3, 10)

SELECT * FROM Ingrediente

-- STORED PROCEDURE
CREATE PROCEDURE [InserimentoPizza] @Nome VARCHAR(30), @Prezzo DECIMAL
AS
BEGIN 
INSERT INTO Pizza (Nome, Prezzo) VALUES (@Nome, @Prezzo)
END

--EXECUTE [InserimentoPizza] @Nome = 'MARGHERITA', @Prezzo = 5
--EXECUTE [InserimentoPizza] @Nome = 'BUFALA', @Prezzo = 7
--EXECUTE [InserimentoPizza] @Nome = 'DIAVOLA', @Prezzo = 6
--EXECUTE [InserimentoPizza] @Nome = 'QUATTRO STAGIONI', @Prezzo = 6.50
--EXECUTE [InserimentoPizza] @Nome = 'PORCINI', @Prezzo = 7
--EXECUTE [InserimentoPizza] @Nome = 'DIONISO', @Prezzo = 8
--EXECUTE [InserimentoPizza] @Nome = 'ORTOLANA', @Prezzo = 8
--EXECUTE [InserimentoPizza] @Nome = 'PATATE E SALSICCIA', @Prezzo = 6
--EXECUTE [InserimentoPizza] @Nome = 'POMODORINI', @Prezzo = 6
--EXECUTE [InserimentoPizza] @Nome = 'QUATTRO FORMAGGI', @Prezzo = 7.50
--EXECUTE [InserimentoPizza] @Nome = 'CAPRESE', @Prezzo = 7.50
--EXECUTE [InserimentoPizza] @Nome = 'ZEUS', @Prezzo = 7.50

SELECT * FROM Pizza
SELECT * FROM Ingrediente

CREATE PROCEDURE [AssegnazioneIngredientePizza] @CodicePizza INT, @CodiceIngrediente INT
AS
BEGIN 
INSERT INTO PizzaIngrediente (CodicePizza, CodiceIngrediente) VALUES (@CodicePizza, @CodiceIngrediente)
END

--EXECUTE [AssegnazioneIngredientePizza] @CodicePizza = 10, @CodiceIngrediente = 1
--EXECUTE [AssegnazioneIngredientePizza] @CodicePizza = 10, @CodiceIngrediente = 2

--EXECUTE [AssegnazioneIngredientePizza] @CodicePizza = 11, @CodiceIngrediente = 1
--EXECUTE [AssegnazioneIngredientePizza] @CodicePizza = 11, @CodiceIngrediente = 3

--EXECUTE [AssegnazioneIngredientePizza] @CodicePizza = 21, @CodiceIngrediente = 2
--EXECUTE [AssegnazioneIngredientePizza] @CodicePizza = 21, @CodiceIngrediente = 24
--EXECUTE [AssegnazioneIngredientePizza] @CodicePizza = 21, @CodiceIngrediente = 12

SELECT * FROM PizzaIngrediente

CREATE PROCEDURE [EliminazioneIngredientePizza] @CodicePizza INT, @CodiceIngrediente INT
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

	 DELETE FROM PizzaIngrediente WHERE (CodicePizza = @CodicePizza AND 
										 CodiceIngrediente = @CodiceIngrediente)

	 IF @@ERROR > 0
		ROLLBACK TRANSACTION

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SELECT ERROR_LINE(), ERROR_MESSAGE()
		ROLLBACK TRANSACTION 
	END CATCH
END

--EXECUTE [AssegnazioneIngredientePizza] @CodicePizza = 10, @CodiceIngrediente = 3
--EXECUTE [EliminazioneIngredientePizza] @CodicePizza = 10, @CodiceIngrediente = 3

CREATE PROCEDURE[ModificaPrezzo101] @CodiceIngrediente INT
AS
BEGIN 

	UPDATE Pizza SET Prezzo = prezzo + (prezzo/100 * 10) WHERE Codice IN (
	SELECT pi.CodicePizza
	from PizzaIngrediente as pi
	JOIN Pizza p
	ON p.Codice = pi.CodicePizza
	WHERE pi.CodiceIngrediente = @CodiceIngrediente
	)
end

EXECUTE [ModificaPrezzo101]  @CodiceIngrediente = 3

select * from pizza

--function
CREATE FUNCTION Listino_Pizze_Alfabeto()
RETURNS TABLE
AS
RETURN 
SELECT p.Codice, p.Nome, p.Prezzo
FROM Pizza p

SELECT *
FROM dbo.Listino_Pizze_Alfabeto() as func
ORDER BY func.Nome ASC

CREATE FUNCTION Listino_Pizze_Con_Ingrediente(@CodiceIngrediente int)
RETURNS TABLE
AS
RETURN 
SELECT p.Nome, p.Prezzo
FROM Pizza as p
JOIN PizzaIngrediente as pi
ON p.Codice = pi.CodicePizza
WHERE pi.CodiceIngrediente = @CodiceIngrediente

SELECT *
FROM dbo.Listino_Pizze_Con_Ingrediente(4)

--EXECUTE [AssegnazioneIngredientePizza] @CodicePizza = 12, @CodiceIngrediente = 1
--EXECUTE [AssegnazioneIngredientePizza] @CodicePizza = 12, @CodiceIngrediente = 2
--EXECUTE [AssegnazioneIngredientePizza] @CodicePizza = 12, @CodiceIngrediente = 4

CREATE FUNCTION Listino_Pizze_Senza_Ingrediente_fin(@CodiceIngrediente int)
RETURNS TABLE
AS
RETURN 
SELECT distinct p.Nome, p.Prezzo
FROM Pizza as p
WHERE p.Nome not in
(SELECT p.Nome
FROM Pizza as p
JOIN PizzaIngrediente as pi
ON p.Codice = pi.CodicePizza
WHERE pi.CodiceIngrediente = @CodiceIngrediente)

SELECT *
FROM dbo.Listino_Pizze_Senza_Ingrediente_fin(1)

CREATE FUNCTION Calcolo_Pizze_Con_Ingrediente(@CodiceIngrediente int)
RETURNS INT
AS
BEGIN
DECLARE @result int
SELECT @result = count(*)
FROM Pizza as p
JOIN PizzaIngrediente as pi
ON p.Codice = pi.CodicePizza
WHERE pi.CodiceIngrediente = @CodiceIngrediente
RETURN @result
END

SELECT  dbo.Calcolo_Pizze_Con_Ingrediente(3) as value

CREATE FUNCTION Calcolo_Pizze_Senza_Ingrediente(@CodiceIngrediente int)
RETURNS INT
AS
BEGIN
DECLARE @result int
SELECT @result = count(*)
FROM Pizza as p
WHERE p.Nome not in
(SELECT p.Nome
FROM Pizza as p
JOIN PizzaIngrediente as pi
ON p.Codice = pi.CodicePizza
WHERE pi.CodiceIngrediente = @CodiceIngrediente)
RETURN @result
END

SELECT  dbo.Calcolo_Pizze_Senza_Ingrediente(1) as value

CREATE FUNCTION Calcolo_Ingredienti(@CodicePizza int)
RETURNS INT
AS
BEGIN
DECLARE @result int
SELECT @result = count(*)
FROM Pizza as p
JOIN PizzaIngrediente as pi
ON p.Codice = pi.CodicePizza
WHERE p.Codice = @CodicePizza
RETURN @result
END

SELECT  dbo.Calcolo_Ingredienti(12) as value

--view
CREATE VIEW [MenuCompleto2] AS (
	SELECT p.Nome, p.Prezzo, STRING_AGG(i.Nome, ',') as Ingredienti
	FROM Pizza as p
	left JOIN PizzaIngrediente as pi
	ON p.Codice = pi.CodicePizza
	left JOIN Ingrediente AS i
	ON pi.CodiceIngrediente = i.Codice
	group by p.Nome, p.Prezzo
);


SELECT * 
FROM MenuCompleto2



