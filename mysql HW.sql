USE sakila;

-- 1a. Display the first and last names of all actors from the table actor
SELECT * FROM sakila.actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT CONCAT(first_name, ' ', last_name) AS Actor_Name
FROM actor
;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe'
;

-- 2b. Find all actors whose last name contain the letters GEN:

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%Gen%'
;

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%Ll%'
;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China')
;

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.

ALTER TABLE actor
ADD COLUMN `middle_name` VARCHAR(50) NOT NULL AFTER `first_name`
;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.

ALTER TABLE actor
MODIFY middle_name BLOB 
;

-- 3c. Now delete the middle_name column.

ALTER TABLE actor 
DROP COLUMN middle_name
;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(*) AS num
FROM actor
GROUP BY last_name
ORDER BY COUNT(*) DESC
;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT last_name, 
COUNT(*) Counts
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >=2
;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

UPDATE actor
SET first_name = REPLACE(first_name, 'GROUCHO','HARPO')
;

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)

UPDATE actor
SET first_name = REPLACE (first_name, 'HARPO', 'GROUCHO')
WHERE actor_id =172
;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it? 

SELECT `table_schema` 
FROM `information_schema`.`tables` 
WHERE `table_name` = 'address'
;

SHOW CREATE TABLE address
;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT staff.address_ID, staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON address.address_ID=staff.address_ID
;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. 

SELECT staff.staff_ID, staff.first_name, staff.last_name, payment.amount, payment.payment_date
FROM staff
INNER JOIN payment ON payment.staff_ID=staff.staff_ID
;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT film_actor.actor_ID, film.film_ID, film.title
FROM film
INNER JOIN film_actor ON film_actor.film_ID=film.film_ID
;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT *
FROM inventory
WHERE film_id = 439
;

SELECT COUNT(*)
FROM inventory
WHERE film_ID = 439
;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT payment.customer_ID, customer.last_name, customer.first_name, payment.amount
FROM customer
JOIN payment ON payment.customer_ID=customer.customer_ID
ORDER BY last_name
;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. 
SELECT title
FROM film
WHERE title LIKE 'K%' or title like 'Q%'
;

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
SELECT actor_id
FROM film_actor
WHERE film_id IN
(
SELECT film_id
FROM film
WHERE title LIKE 'Alone Trip' -- LIKE is for strings 
)
);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.



-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

SELECT category_id
FROM category
WHERE name = 'family'
(
SELECT film_id
FROM film_category
WHERE category_id = 8
(
SELECT title, film_id
FROM film
ON film.film_Id = film_category.film_id
)
);

-- 7e. Display the most frequently rented movies in descending order.

SELECT film_id, COUNT(*) AS magnitude
FROM inventory
GROUP BY film_id
ORDER BY magnitude DESC
;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, SUM(amount) AS Gross
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city_id, country.country
FROM store
JOIN address
ON (store.address_id = address.address_id)
JOIN city
ON (city.country_id = country.country_id)
JOIN country
ON country.country_id = country
;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT p.payment_id, SUM(amount) AS Gross
FROM payment p
JOIN category
ON (category.category_id = film_category.category_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN rental r
ON (r.rental_id = p.rental_id)
GROUP BY p.payment_id
ORDER BY magnitude DESC
LIMIT 5

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW total_sales AS
SELECT p.payment_id, SUM(amount) AS Gross
FROM payment p
JOIN category
ON (category.category_id = film_category.category_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN rental r
ON (r.rental_id = p.rental_id)
GROUP BY p.payment_id
ORDER BY magnitude DESC
LIMIT 5

-- 8b. How would you display the view that you created in 8a?

CREATE VIEW total_sales AS

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW total_sales;



