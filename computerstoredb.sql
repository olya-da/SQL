/*
https://sql-ex.ru/help/select13.php#db_1

Short database description "Computer firm"

The database scheme consists of four tables:
Product(maker, model, type)
PC(code, model, speed, ram, hd, cd, price)
Laptop(code, model, speed, ram, hd, screen, price)
Printer(code, model, color, type, price)
The Product table contains data on the maker, model number, and type of product ('PC', 'Laptop', or 'Printer'). 
It is assumed that model numbers in the Product table are unique for all makers and product types. 
Each personal computer in the PC table is unambiguously identified by a unique code, and is additionally characterized by its model 
(foreign key referring to the Product table), processor speed (in MHz) – speed field, RAM capacity (in Mb) - ram, 
hard disk drive capacity (in Gb) – hd, CD-ROM speed (e.g, '4x') - cd, and its price. 
The Laptop table is similar to the PC table, except that instead of the CD-ROM speed, it contains the screen size (in inches) – screen. 
For each printer model in the Printer table, its output type (‘y’ for color and ‘n’ for monochrome) – color field, 
printing technology ('Laser', 'Jet', or 'Matrix') – type, and price are specified.*/

--Exercise: 1 (1)

--Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
--Result set: model, speed, hd.

SELECT model, speed, hd
FROM PC
WHERE price < 500

--Exercise: 2 (1)

--List all printer makers. Result set: maker.

SELECT DISTINCT maker
FROM product
WHERE type = 'printer'

--Exercise: 3 (1)

--Find the model number, RAM and screen size of the laptops with prices over $1000.

SELECT model, ram, screen
FROM laptop
WHERE price > 1000

--Exercise: 4 (1)

--Find all records from the Printer table containing data about color printers.

SELECT *
FROM printer
WHERE color = 'y'

--Exercise: 5 (1)

--Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.

SELECT model, speed, hd
FROM pc
WHERE price < 600 AND (cd = '12x' OR cd = '24x')

--Exercise: 6 (2)

--For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. Result set: maker, speed.

SELECT DISTINCT maker, speed
FROM laptop
JOIN product ON laptop.model = product.model
WHERE laptop.hd >= 10

SELECT DISTINCT prod.maker, lap.speed
FROM (SELECT 'laptop' AS type, model, speed
 FROM laptop
 WHERE hd >= 10
 ) AS lap 
INNER JOIN 
 (SELECT maker, model
 FROM product
 ) AS prod ON lap.model = prod.model;

--Exercise: 7 (2)

--Get the models and prices for all commercially available products (of any type) produced by maker B.

SELECT DISTINCT pc.model, price
FROM pc
JOIN product ON pc.model = product.model
WHERE product.maker = 'B'
UNION
SELECT DISTINCT laptop.model, price
FROM laptop
JOIN product ON laptop.model = product.model
WHERE product.maker = 'B'
UNION
SELECT DISTINCT printer.model, price
FROM printer
JOIN product ON printer.model = product.model
WHERE product.maker = 'B'

/*problems with 6 and 7 (both level 2) - another 15 minutes
Feeling: very good on first 5 (level 1), where I produced correct results
        bad on 6 anf 7 (level 2) where the result was correct but I couldn't understand the reason why the checker says it's Wrong
        I read all FAQs and relevant pages and started to stress and got angry because I either didn't understand the concepts desctibed or what is wrong with my solution
        I got more angry and wanted to stop the task when is has become too many new information about joins that I didn't understand and I lost desire to continue
*/

--EXCERCISE 8 (2)

/*Find the makers producing PCs but not laptops.
Help topics:
 Intersect and Except
 IN predicate */

SELECT DISTINCT maker
FROM product
WHERE type = 'pc'
EXCEPT
SELECT DISTINCT maker
FROM product
WHERE type = 'laptop'

--Exercise: 9 (1)

--Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.

SELECT DISTINCT maker
FROM product
JOIN pc on product.model = pc.model
WHERE speed >= 450

--Exercise: 10 (1)

--Find the printer models having the highest price. Result set: model, price.

SELECT model, price
FROM printer 
WHERE price = (
SELECT MAX(price)
FROM printer
)

--Exercise: 11 (1)

--Find out the average speed of PCs.

SELECT AVG(speed)
FROM pc

--Exercise: 12 (1)

--Find out the average speed of the laptops priced over $1000.

SELECT AVG(speed)
FROM laptop
WHERE price > 1000

--Exercise: 13 (1)

--Find out the average speed of the PCs produced by maker A.

SELECT AVG(speed)
FROM pc
JOIN product on product.model = pc.model
WHERE product.maker IN (
SELECT maker 
FROM product
WHERE maker = 'A')


---Exercise: 15 (2)

--Get hard drive capacities that are identical for two or more PCs.
--Result set: hd.

SELECT hd
FROM pc
GROUP BY hd
HAVING COUNT(model) > 1


--Exercise: 16 (2)

--Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
--Result set: model with the bigger number, model with the smaller number, speed, and RAM.

SELECT DISTINCT a.model AS model_1, b.model AS model_2, a.speed, a.ram
FROM pc AS a, pc b
WHERE a.speed = b.speed AND 
 a.ram = b.ram AND
 a.model > b.model


--Exercise: 17 (2)

--Get the laptop models that have a speed smaller than the speed of any PC.
--Result set: type, model, speed.

SELECT DISTINCT 'laptop' AS 'type', model, speed
FROM laptop
WHERE speed < ALL (
SELECT speed
FROM pc)


--Exercise: 18 (2)

--Find the makers of the cheapest color printers.
--Result set: maker, price.

SELECT DISTINCT maker, price
FROM printer
JOIN product ON printer.model = product.model
WHERE color = 'y' AND
        price IN (
                SELECT MIN(price)
                FROM printer
                WHERE color = 'y')


--Exercise: 19 (1)

--For each maker having models in the Laptop table, find out the average screen size of the laptops he produces.
--Result set: maker, average screen size.

SELECT maker, AVG(screen)
FROM product
JOIN laptop on product.model = laptop.model
GROUP BY maker


--Exercise: 20 (2)

--Find the makers producing at least three distinct models of PCs.
--Result set: maker, number of PC models.

SELECT maker, COUNT(DISTINCT model)
FROM product
WHERE type = 'pc'
GROUP BY maker
HAVING COUNT(DISTINCT model) >= 3


--Exercise: 21 (1)

--Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price.

SELECT maker, MAX(price)
FROM product
JOIN pc on product.model = pc.model
GROUP BY maker

--Exercise: 22 (1)

--For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds.
--Result set: speed, average price.

SELECT speed, AVG(price)
FROM pc
WHERE speed > 600
GROUP BY speed

--Exercise: 23 (2)

--Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher.
--Result set: maker

SELECT maker
FROM pc
JOIN product on product.model = pc.model
WHERE speed >= 750
INTERSECT
SELECT maker
FROM laptop
JOIN product on product.model = laptop.model
WHERE speed >= 750

--Exercise: 24 (2)

--List the models of any type having the highest price of all products present in the database.

WITH prices AS (SELECT model, price FROM pc
UNION ALL
SELECT model, price FROM laptop
UNION ALL
SELECT model, price FROM printer)
SELECT DISTINCT model
FROM prices
WHERE price = (SELECT MAX(price) FROM prices)

WITH prices AS (SELECT  top 1 model, price FROM pc order by price DESC
UNION ALL
SELECT top 1 model, price FROM laptop order by price DESC
UNION ALL
SELECT top 1 model, price FROM printer order by price DESC)
SELECT model
FROM prices
WHERE price = (SELECT MAX(price) FROM prices)

--Exercise: 25 (2)

--Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity.
--Result set: maker.

SELECT DISTINCT maker
FROM pc
         JOIN product on product.model = pc.model
WHERE speed IN (SELECT MAX(speed)
                FROM (SELECT * FROM pc WHERE ram = (SELECT MIN(ram) FROM pc)) AS minram)
  AND ram = (SELECT MIN(ram) FROM pc)
  AND maker IN (SELECT maker FROM product WHERE type = 'printer');

--Exercise: 26 (Serge I: 2003-02-14)

--Find out the average price of PCs and laptops produced by maker A.
--Result set: one overall average price for all items.

WITH prices AS (SELECT price, maker
FROM pc
JOIN product on product.model = pc.model
UNION ALL
SELECT price, maker
FROM laptop
JOIN product on product.model = laptop.model)
SELECT AVG(price)
FROM prices
WHERE maker = 'A'

--Exercise: 27 (2)

--Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
--Result set: maker, average HDD capacity.

SELECT maker, AVG(hd)
FROM pc
JOIN product on product.model = pc.model
WHERE maker IN (SELECT maker FROM product WHERE type = 'printer')
GROUP BY maker