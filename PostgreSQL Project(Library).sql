-- import books csv (done)
--import ratings csv (done)
--import users csv (done)

--data cleaning
--find duplicate

--set isbn to upper case
/*
UPDATE books
SET isbn = UPPER(isbn);

WITH find_dup AS (
SELECT *,
       ROW_NUMBER()OVER (PARTITION BY isbn ORDER BY isbn) AS row_num
FROM books)

SELECT * FROM find_dup WHERE row_num > 1;

CREATE TABLE temp_books (
isbn varchar(20),
book_title varchar(300),
book_author varchar(300),
year_publish int,
publisher varchar(250));

INSERT INTO temp_books(isbn,book_title,book_author,year_publish,publisher)
SELECT DISTINCT isbn,book_title,book_author,year_publish,publisher
FROM books;

--check duplicate 

WITH find_dup AS (
SELECT *,
       ROW_NUMBER()OVER (PARTITION BY isbn ORDER BY isbn) AS row_num
FROM temp_books)

SELECT * FROM find_dup WHERE row_num > 1;

--one more duplicate left
--we will delete the duplicate

DELETE FROM temp_books 
WHERE book_title = 'Key of Light (Key Trilogy (Paperback))';

--check duplicate (no duplicate)

--we will delete books table and rename temp_books 

SELECT * FROM books ORDER BY year_publish DESC;

--there are few data in year_publish column that does make any sense.
-- there are some data show year_publish in 2030.
-- we will remove the row where year_publish >= 2024.
-- however the data remove will be insert into new table call books_deleted.
--we use CREATE TRIGGER 

CREATE TABLE book_deleted (
isbn varchar(20),
book_title varchar(300),
book_author varchar(300),
year_publish int,
publisher varchar(250));

CREATE FUNCTION store_deleted_record ()
RETURNS TRIGGER 
AS $$
BEGIN
     INSERT INTO book_deleted(isbn,book_title,book_author,year_publish,publisher)
	 VALUES (OLD.isbn,OLD.book_title,OLD.book_author,OLD.year_publish,OLD.publisher);
	 RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER deleted_books
AFTER DELETE
ON books
FOR EACH ROW
EXECUTE FUNCTION store_deleted_record();

DELETE FROM books
WHERE year_publish >= 2024;

SELECT * FROM book_deleted;-- the deleted data are in this table;

--In order to establish relationship between table, we use primary key and foreihn key
--We will set primary key on books(isbn) and users table(user_id) and foregin key on ratings table(isbnb,user_id)
--The value of foreign key must exist in primary key table.
--So we create temp_ratings table to store filtered ratings value as below.

CREATE TABLE temp_ratings (
user_id INT,
isbn varchar(20),
book_ratings INT); 

INSERT INTO temp_ratings(user_id,isbn,book_ratings)
SELECT * FROM ratings
WHERE isbn IN(SELECT isbn FROM books)
AND
      user_id IN (SELECT user_id FROM users);

--Drop the ratings table
--rename temp_ratings as ratings
--Begin to assign primary key and foreign key to the selected columns

ALTER TABLE books
ADD CONSTRAINT pk_books PRIMARY KEY (isbn);

ALTER TABLE users
ADD CONSTRAINT pk_users PRIMARY KEY (user_id);

ALTER TABLE ratings
ADD CONSTRAINT fk_isbn FOREIGN KEY (isbn) REFERENCES books(isbn);

ALTER TABLE ratings
ADD CONSTRAINT fk_userid FOREIGN KEY (user_id) REFERENCES users(user_id);

--test constraint using inner join

SELECT * FROM books b
INNER JOIN ratings r
USING(isbn)
INNER JOIN users u
USING(user_id)
LIMIT 100;

--create trigger to prevent table ratings deletion 

CREATE FUNCTION prevent_ratingsdel()
RETURNS TRIGGER AS $$
BEGIN
	RAISE EXCEPTION 'Deletion of ratings table are not allowed.';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER stop_ratingsdel
BEFORE DELETE
ON ratings
FOR EACH ROW
EXECUTE FUNCTION prevent_ratingsdel();

--isbn = 000104687X
-- try to delete isbn 

DELETE FROM ratings WHERE isbn = '000104687X';

--find top avg book rating with book read more than 10 times
-- excluding book ratings equal to 0
--we use create function

CREATE OR REPLACE FUNCTION avgbookratings()
RETURNS TABLE (book_title varchar(300),isbn_code varchar(20), avg_ratings NUMERIC)
AS $$
BEGIN
RETURN QUERY
WITH isbnF AS (
				SELECT isbn, COUNT(*)
				FROM ratings
	            WHERE book_ratings > 0
				GROUP BY 1
				HAVING COUNT(*) > 9)
				
SELECT b.book_title,
       r.isbn, 
	   ROUND(AVG(r.book_ratings),2) :: NUMERIC AS avg_ratings
FROM ratings r
INNER JOIN books b
ON r.isbn = b.isbn
WHERE r.isbn IN (SELECT isbn FROM isbnF)
GROUP BY b.book_title,r.isbn
ORDER BY avg_ratings DESC;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM avgbookratings();

--find top rating books by each user

CREATE OR REPLACE FUNCTION fav_book ()
RETURNS TABLE (id INT, title varchar(300),rating INT)
AS $$
BEGIN
RETURN QUERY
WITH top AS (
SELECT user_id,
       isbn,
	   book_ratings,
       ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY book_ratings DESC) AS book_rank
FROM ratings)

SELECT t.user_id,b.book_title,t.book_ratings
FROM books b
INNER JOIN top t
USING(isbn)
WHERE book_rank = 1
AND
      t.book_ratings > 7;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM fav_book() LIMIT 5;

-- we filter only row number 1 and rating >7
-- those with rating < 8(assume there were no fav book for that user id)

SELECT b.book_author,
       b.book_title,
	   ROUND(AVG(r.book_ratings :: NUMERIC),2) AS Average_Rating
FROM books b
INNER JOIN ratings r
USING(isbn)
WHERE b.book_author LIKE 'J. K.%'
AND
      b.
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5;

CREATE OR REPLACE FUNCTION findbookratingbyauthor ( para1 varchar(300))
RETURNS TABLE (book_author varchar(300),
			   book_title varchar(300),
			   avg_rating NUMERIC)
AS $$
BEGIN
    RETURN QUERY
	SELECT 	b.book_author,
       		b.book_title, 
	   		ROUND(AVG(r.book_ratings :: NUMERIC),2) AS avg_rating
	FROM books b
	INNER JOIN ratings r
	USING(isbn)
	WHERE b.book_author LIKE para1
	GROUP BY 1,2
	HAVING ROUND(AVG(r.book_ratings :: NUMERIC),2) > 6
	ORDER BY 3 DESC;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM findbookratingbyauthor('J.K%');


SELECT publisher, COUNT(*) Num_of_books
FROM books
GROUP BY 1
ORDER BY 2 DESC;

SELECT b.book_title, r.book_ratings
FROM books b
INNER JOIN ratings r
USING(isbn)
WHERE r.book_ratings = 10;

SELECT UPPER(publisher), ROUND(AVG(book_ratings),2) AS average_ratings
FROM books
INNER JOIN ratings
USING(isbn)
WHERE book_ratings > 0
GROUP BY 1
ORDER BY 1;

SELECT COUNT(CASE WHEN age > 5 AND age < 29 THEN 1 END) AS "'6-28'",
       COUNT(CASE WHEN age > 28 AND age < 52 THEN 1 END) AS "'29-51'",
	   COUNT(CASE WHEN age > 51 AND age < 75 THEN 1 END) AS "'52-74'",
	   COUNT(CASE WHEN age > 74 AND age < 98 THEN 1 END) AS "'75-97'",
	   COUNT(CASE WHEN age > 97 AND age < 117 THEN 1 END) AS "'98-116'"
FROM users;

SELECT 
    CASE 
        WHEN u.age > 5 AND u.age < 29 THEN '6-28'
        WHEN u.age > 28 AND u.age < 52 THEN '29-51'
        WHEN u.age > 51 AND u.age < 75 THEN '52-74'
        WHEN u.age > 74 AND u.age < 98 THEN '75-97'
        WHEN u.age > 97 AND u.age < 117 THEN '98-116'
    END AS age_group,
    COUNT(r.user_id) AS user_count
FROM 
    ratings r
INNER JOIN 
    users u
ON 
    r.user_id = u.user_id
GROUP BY 
    age_group;


SELECT 
    CASE 
        WHEN u.age > 5 AND u.age < 29 THEN '6-28'
        WHEN u.age > 28 AND u.age < 52 THEN '29-51'
        WHEN u.age > 51 AND u.age < 75 THEN '52-74'
        WHEN u.age > 74 AND u.age < 98 THEN '75-97'
        WHEN u.age > 97 AND u.age < 117 THEN '98-116'
    END AS age_group,
    ROUND(AVG(r.book_ratings),4) AS avg_rating
FROM 
    ratings r
INNER JOIN 
    users u
ON 
    r.user_id = u.user_id
WHERE r.book_ratings > 0
GROUP BY 
    age_group
ORDER BY age_group ASC;

SELECT year_publish,COUNT(*) AS book_per_year 
FROM books
WHERE year_publish > 0
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--implicit rating
SELECT b.book_title,r.isbn, COUNT(*) AS user_count
FROM ratings r
INNER JOIN books b
USING(isbn)
WHERE r.book_ratings = 0
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5;*/



