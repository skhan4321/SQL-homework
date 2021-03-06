
SET SQL_SAFE_UPDATES = 0;
USE sakila;

SHOW TABLES;
-- 1A
SELECT first_name, last_name 
FROM actor;
-- 1B
SELECT concat(first_name, ' ' , last_name) 
AS ActorName 
FROM actor; 
-- 2A
SELECT first_name, last_name, actor_id FROM actor 
WHERE first_name = "JOE";
-- 2 B 
SELECT last_name FROM actor 
WHERE last_name 
LIKE "%GEN%";
-- 2C
SELECT last_name, first_name FROM actor WHERE last_name LIKE "%LI%" ORDER BY last_name;
-- 2D
SELECT country, country_id FROM country WHERE country IN ("Afghanistan", "Bangladesh", "China");
-- 3A
ALTER TABLE actor ADD Description BLOB not null;
SELECT * FROM actor;
-- 3B
ALTER TABLE actor DROP COLUMN Description;
-- 4A
SELECT COUNT(last_name), last_name FROM actor
GROUP BY last_name;
-- 4B
SELECT COUNT(last_name), last_name FROM actor 
GROUP BY last_name
HAVING COUNT(last_name)>1;
-- 4C
SELECT first_name FROM actor WHERE first_name = "GROUCHO";
UPDATE actor 
SET first_name = REPLACE (first_name, "GROUCHO", "HARPO") 
WHERE first_name = "GROUCHO";
SELECT first_name FROM actor WHERE first_name = "HARPO";
UPDATE actor 
SET first_name = REPLACE (first_name, "HARPO", "GROUCHO") 
WHERE first_name = "HARPO";
-- 5A
SHOW CREATE TABLE address;
-- 6A
SELECT staff.first_name, staff.last_name, address.address 
FROM address 
INNER JOIN staff 
ON staff.address_id=address.address_id;
-- 6B
SELECT sum(payment.amount), staff.staff_id, staff.first_name from payment 
INNER JOIN staff on staff.staff_id = payment.staff_id
WHERE payment_date between "2005-08-01" and "2005-08-31"
GROUP BY staff.staff_id;
-- 6c
SELECT film.title, COUNT(film_actor.actor_id) AS ` number of actors` 
FROM film
INNER JOIN film_actor ON 
film.film_id=film_actor.film_id
GROUP BY film.title;
-- 6 d
SELECT count(inventory_id) 
FROM inventory
WHERE film_id 
IN 
(SELECT film_id FROM film WHERE title = "Hunchback Impossible");
-- 6e
SELECT customer.customer_id, customer.last_name, customer.first_name, SUM(payment.amount) AS `Total Amount Paid `
FROM customer 
INNER JOIN payment ON 
customer.customer_id=payment.customer_id 
GROUP BY customer.last_name;
-- 7 a
SELECT title FROM film
WHERE title LIKE 'Q%'OR title LIKE 'K%' 
AND language_id 
IN ( SELECT language_id FROM `language` WHERE `name` = "English");
-- 7b
SELECT last_name, first_name 
FROM actor
WHERE actor_id IN 
(
SELECT actor_id 
FROM film_actor 
WHERE film_id IN
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
)
);

-- 7 c
SELECT customer.email, customer.first_name, customer.last_name, country.country
FROM customer
INNER JOIN (address 
INNER JOIN (city INNER JOIN country
ON city.country_id = country.country_id)
ON address.city_id = city.city_id)
ON address.address_id = customer.address_id
WHERE country = 'Canada';

-- 7 d
SELECT title 
FROM film
WHERE film_id 
IN (SELECT film_id FROM film_category WHERE category_id 
IN ( SELECT category_id FROM category WHERE `name` = 'family')
);

-- 7 e
SELECT COUNT(film.title) as 'rentals', film.title
FROM rental
INNER JOIN 
(film INNER JOIN inventory
ON
inventory.film_id=film.film_id)
ON 
inventory.inventory_id=rental.inventory_id
GROUP BY film.title
ORDER BY count(film.title) DESC;

-- 7f 
SELECT * FROM sales_by_store;

-- 7 g
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN 
(address INNER JOIN
(city INNER JOIN country
ON
country.country_id=city.country_id)
ON
city.city_id = address.city_id)
ON
store.address_id=address.address_id;

-- 7 h
SELECT category.name, sum(payment.amount)
FROM category
INNER JOIN 
(film_category INNER JOIN
(inventory INNER JOIN
(rental INNER JOIN payment
ON
rental.rental_id = payment.rental_id)
ON
inventory.inventory_id=rental.inventory_id)
ON
inventory.film_id=film_category.film_id)
ON
category.category_id=film_category.category_id
GROUP BY name
ORDER BY SUM(amount) DESC
LIMIT 5;

-- 8 a
CREATE VIEW top_5__by_genre AS
SELECT category.name, sum(payment.amount)
FROM category
INNER JOIN 
(film_category INNER JOIN
(inventory INNER JOIN
(rental INNER JOIN payment
ON
rental.rental_id = payment.rental_id)
ON
inventory.inventory_id=rental.inventory_id)
ON
inventory.film_id=film_category.film_id)
ON
category.category_id=film_category.category_id
GROUP BY name
ORDER BY SUM(amount) DESC
LIMIT 5;

-- 8 b
SELECT * FROM top_5__by_genre

-- 8 c 
DROP VIEW top_5__by_genre