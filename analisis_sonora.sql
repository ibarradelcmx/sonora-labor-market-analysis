SELECT * FROM enoe_sonora.sdemt;

SELECT AVG(ingocup) AS ingreso_promedio, rama
FROM sdemt
WHERE cve_ent = 26 AND rama != 0 AND ingocup != 0
GROUP BY rama
ORDER BY ingreso_promedio DESC;

## -- Pregunta 1: Ingreso promedio por sector en Sonora
-- Solo personas ocupadas con ingreso reportado
-- Fuente: ENOE Q4 2025, INEGI

SELECT COUNT(*) AS personas, rama 
FROM sdemt 
WHERE cve_ent = 26 AND cve_mun = 30 AND rama != 0
GROUP BY rama  
ORDER BY COUNT(*) DESC;

## Ponle esto arriba de la query:
-- Pregunta 2: Sectores con más empleo en Hermosillo
-- Conteo de personas encuestadas por sector
-- Excluye rama 0 (sin sector asignado)
-- Fuente: ENOE Q4 2025, INEGI


SELECT s.cve_ent, c.nombre_estado,
COUNT(*) AS total_pea,
SUM(CASE WHEN clase2 = 2 THEN 1 ELSE 0 END) AS desocupados,
ROUND(SUM(CASE WHEN clase2 = 2 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS tasa_desempleo
FROM sdemt s 
JOIN cat_estado c ON s.cve_ent = c.cve_ent
WHERE clase1 = 1
GROUP BY s.cve_ent, c.nombre_estado
ORDER BY tasa_desempleo DESC;

-- Pregunta 3: Tasa de desempleo Sonora vs nacional
-- clase1 = 1 filtra solo población económicamente activa (PEA)
-- clase2 = 2 son desocupados
-- Sonora: 2.93% — top 5 nacional
-- Fuente: ENOE Q4 2025, INEGI


SELECT s.cve_mun,c.nombre, AVG(ingocup) AS ingreso_promedio
FROM sdemt s
JOIN cat_municipio c ON s.cve_mun = c.cve_mun
WHERE s.cve_ent = 26 AND s.cve_mun IN (30,18) AND ingocup != 0
GROUP BY s.cve_mun, c.nombre;

-- Pregunta 4: Hermosillo vs Cajeme — ingreso promedio
-- Hermosillo: $14,278 vs Cajeme: $11,330
-- Hermosillo supera a Cajeme por 26% en ingreso promedio
-- Fuente: ENOE Q4 2025, INEGI

CREATE TABLE enoe_sonora.cat_rama (
    rama INT,
    nombre_sector VARCHAR(50)
);

INSERT INTO enoe_sonora.cat_rama VALUES
(1, 'Agricultura'),
(2, 'Industria extractiva'),
(3, 'Manufactura'),
(4, 'Construcción'),
(5, 'Comercio'),
(6, 'Transportes'),
(7, 'Gobierno');


CREATE TABLE enoe_sonora.cat_municipio (
    cve_mun INT,
    nombre VARCHAR(50)
);

INSERT INTO enoe_sonora.cat_municipio VALUES
(30, 'Hermosillo'),
(18, 'Cajeme');

SELECT COUNT(*) AS personas, c.nombre_sector
FROM sdemt s 
JOIN cat_rama c on s.rama = c.rama 
WHERE cve_ent = 26 AND cve_mun = 30 AND s.rama != 0 
GROUP BY s.rama, c.nombre_sector
ORDER BY COUNT(*) DESC;

SELECT AVG(ingocup) AS ingreso_promedio, c.nombre_sector
FROM sdemt s
JOIN cat_rama c ON s.rama = c.rama
WHERE s.cve_ent = 26 AND s.rama != 0 AND s.ingocup != 0
GROUP BY s.rama, c.nombre_sector
ORDER BY ingreso_promedio DESC;

CREATE TABLE enoe_sonora.cat_estado (
    cve_ent INT,
    nombre_estado VARCHAR(50)
);

INSERT INTO enoe_sonora.cat_estado VALUES
(1, 'Aguascalientes'), (2, 'Baja California'),
(3, 'Baja California Sur'), (4, 'Campeche'),
(5, 'Coahuila'), (6, 'Colima'),
(7, 'Chiapas'), (8, 'Chihuahua'),
(9, 'CDMX'), (10, 'Durango'),
(11, 'Guanajuato'), (12, 'Guerrero'),
(13, 'Hidalgo'), (14, 'Jalisco'),
(15, 'Estado de México'), (16, 'Michoacán'),
(17, 'Morelos'), (18, 'Nayarit'),
(19, 'Nuevo León'), (20, 'Oaxaca'),
(21, 'Puebla'), (22, 'Querétaro'),
(23, 'Quintana Roo'), (24, 'San Luis Potosí'),
(25, 'Sinaloa'), (26, 'Sonora'),
(27, 'Tabasco'), (28, 'Tamaulipas'),
(29, 'Tlaxcala'), (30, 'Veracruz'),
(31, 'Yucatán'), (32, 'Zacatecas');
