**FUNCTION THAT WERE CREATED**

1. Find top average book rating with book read more than 10 times (exclude book rating = 0 )

```sql

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
```

```sql
SELECT * FROM avgbookratings()
```

**Results** 
--only shows top 5

| Title                                 | ISBN        | Rating |
|---------------------------------------|-------------|--------|
| Die unendliche Geschichte Von A bis Z | 3522128001  | 8.07   |
| Harry Potter Und Der Feuerkelch       | 3551551936  | 8.00   |
| Free                                  | 1844262553  | 7.96   |
| Harry Potter y el cÃƒÂ¡liz de fuego   | 8478886451  | 7.88   |
| Der Kleine Hobbit                     | 3423071516  | 7.80   |


2. Find favourite book by each user
   i. Filter only rating > 7
   ii. If there is no rating moret than 7 (assume that user has no favourite book)

   
```sql
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
```

```sql
SELECT * FROM fav_book()
```

**Results**
--only shows top 5

| id  | title                                                                                               | rating |
|-----|-----------------------------------------------------------------------------------------------------|--------|
| 12  | If I'd Known Then What I Know Now Why Not Learn from the Mistakes of Others?  You Can't Afford to Make Them All Yourself | 10     |
| 69  | Tess of the D'Urbervilles (Wordsworth Classics)                                                      | 8      |
| 70  | The Adventures of Drew and Ellie The Magical Dress                                                    | 10     |
| 92  | El Senor De Los Anillos El Retorno Del Rey (Tolkien, J. R. R. Lord of the Rings. 3.)                | 10     |
| 183 | Que Se Mueran Los Feos (Fabula)                                                                      | 9      |


3. Find average of book rating by author
   i. Include only average > 6

```sql
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
```

```sql
SELECT * FROM findbookratingbyauthor('J.K%');
```

**Results**

| book_author   | book_title                                           | avg_rating |
|---------------|------------------------------------------------------|------------|
| J.K. Rowling  | Harry Potter and the Philosopher's Stone             | 9.00       |
| J.K. Rowling  | I El Pres D'askaban                                   | 9.00       |
| J.K. Rowling  | Harry Potter et l'Ordre du PhÃƒÂ©nix (Harry Potter, tome 5) | 7.40       |
| J.K. Rowling  | I La Pedra Filosofal                                  | 7.00       |
