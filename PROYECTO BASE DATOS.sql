-- PROYECTO #13 BASE DE DATOS 
-- INTEGRANTES: JUAN SEBASTIAN CARVAJAL CARDENAS
			-- RICHARD NICOLAS CUADRADO SANCHEZ
            -- NAREN STIVEN CIPAGAUTA ESTUPIÑAN


CREATE DATABASE IF NOT EXISTS BandApp;
USE BandApp;

-- Crear la tabla Integrantes
CREATE TABLE IF NOT EXISTS Integrantes (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255) NOT NULL,
    Instrumento VARCHAR(50) NOT NULL,
    Foto VARCHAR(255) NOT NULL,
    Seguidores INT,
    Conciertos INT,
    Ganancias DECIMAL(10,2),
    DonaCaridad BOOLEAN,
    GeneroFavorito VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Conciertos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Ganancia DECIMAL(10,2) CHECK (Ganancia >= 10000 AND Ganancia <= 100000),
    IntegranteID INT,
    FOREIGN KEY (IntegranteID) REFERENCES Integrantes(ID)
);

-- DATOS EJEMPLO
-- Insertar integrantes
INSERT INTO Integrantes (Nombre, Instrumento, Foto, Seguidores, Conciertos, Ganancias, DonaCaridad, GeneroFavorito)
VALUES
    ('Integrante1', 'Guitarra', '/ruta/foto1.jpg', 10000, 5, 50000, TRUE, 'Rock'),
    ('Integrante2', 'Batería', '/ruta/foto2.jpg', 8000, 8, 70000, FALSE, 'Pop'),
    ('Integrante3', 'Bajo', '/ruta/foto3.jpg', 12000, 3, 30000, TRUE, 'Jazz'),
    ('Integrante4', 'Teclado', '/ruta/foto4.jpg', 15000, 6, 60000, FALSE, 'Tropical');

-- Insertar conciertos
INSERT INTO Conciertos (Ganancia, IntegranteID)
VALUES
    (15000, 1),
    (20000, 2),
    (30000, 3),
    (25000, 4);

DELIMITER //

-- Eliminar el procedimiento almacenado existente
DROP PROCEDURE IF EXISTS BandAppMenu;

-- Crear el nuevo procedimiento almacenado
CREATE PROCEDURE BandAppMenu()
BEGIN
    DECLARE choice INT;

    BandAppMenuLoop: LOOP
        -- Mostrar opciones del menú
        SELECT '1. Visualizar la información de los integrantes' AS MenuOption;
        SELECT '2. Modificar un integrante' AS MenuOption;
        SELECT '3. Consultar la cantidad de integrantes que donan a caridad' AS MenuOption;
        SELECT '4. Consultar el integrante con más seguidores' AS MenuOption;
        SELECT '5. Consultar la cantidad de integrantes que tienen un género favorito dado' AS MenuOption;
        SELECT '6. Consultar el porcentaje de ganancias de un integrante con respecto a la banda' AS MenuOption;
        SELECT '0. Salir' AS MenuOption;

        -- Pedir al usuario que elija una opción
        SELECT 'Ingrese el número de la opción deseada:' INTO choice;
        SET choice = IFNULL(choice, -1);

        -- Ejecutar la opción seleccionada
        CASE choice
            WHEN 1 THEN
                SELECT * FROM Integrantes;
            WHEN 2 THEN
                -- Aquí puedes pedir más información al usuario para modificar un integrante
                UPDATE Integrantes SET Seguidores = 12000 WHERE ID = 1;
            WHEN 3 THEN
                SELECT COUNT(*) FROM Integrantes WHERE DonaCaridad = TRUE;
            WHEN 4 THEN
                SELECT * FROM Integrantes ORDER BY Seguidores DESC LIMIT 1;
            WHEN 5 THEN
                -- Aquí puedes pedir más información al usuario para consultar un género específico
                SELECT COUNT(*) FROM Integrantes WHERE GeneroFavorito = 'Rock';
            WHEN 6 THEN
                SELECT Nombre, (Ganancias / (SELECT SUM(Ganancia) FROM Conciertos)) * 100 AS PorcentajeGanancias
                FROM Integrantes;
            WHEN 0 THEN
                LEAVE BandAppMenuLoop;
            ELSE
                SELECT 'Opción no válida. Inténtelo de nuevo.';
        END CASE;
    END LOOP BandAppMenuLoop;
END //

DELIMITER ;

-- Llamar al procedimiento para iniciar el menú
CALL BandAppMenu;
