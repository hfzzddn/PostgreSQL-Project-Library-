**LIBRARY**

**Question and Answer**

**Author** : Mohamad Hafizzuddin Bin Yahya

**Email** : hafizz.yahya777@gmail.com

**LinkedIn** :

1. Find top 5 number of book produce by author.

```sql
SELECT book_author, COUNT(*) AS num_of_books 
FROM books
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**Results**

| book_author          | num_of_books |
|----------------------|--------------|
| Agatha Christie      | 631          |
| William Shakespeare  | 566          |
| Stephen King         | 522          |
| Ann M. Martin        | 423          |
| Carolyn Keene        | 372          |

2. Find top 5 year with most book publish.

```sql
SELECT year_publish,COUNT(*) AS book_per_year 
FROM books
WHERE year_publish > 0
GROUP BY 1
ORDER BY 2 DESC;
```

**Results**

| year_publish | book_per_year |
|--------------|---------------|
| 2002         | 17615         |
| 1999         | 17410         |
| 2001         | 17337         |
| 2000         | 17214         |
| 1998         | 15752         |

3. Number of book publish by publisher

```sql
SELECT publisher, COUNT(*) Num_of_books
FROM books
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**Results**

| Publisher        | Num of Books |
|------------------|--------------|
| "Harlequin"      | 7532         |
| "Silhouette"     | 4218         |
| "Pocket"         | 3896         |
| "Ballantine Books"| 3772         |
| "Bantam Books"   | 3640         |

4. Find book title with rating = 10

```sql
SELECT b.book_title, r.book_ratings
FROM books b
INNER JOIN ratings r
USING(isbn)
WHERE r.book_ratings = 10;
```

**Results** -- only shows top 5

| Book Title                                                                                                     | Book Ratings |
|---------------------------------------------------------------------------------------------------------------|--------------|
| "Hidden Prey"                                                                                                 | 10           |
| "Im Zeichen des Drachen."                                                                                     | 10           |
| "Kate's Choice What Love Can Do ; Gwen's Adventure in the Snow  Three Fire-Side Stories to Warm the Heart"   | 10           |
| "The Patriote Proposition (Darmon, 3)"                                                                       | 10           |
| "The Adventures of Drew and Ellie The Magical Dress"                                                          | 10           |


5. Average of book rating by publisher

```sql
SELECT UPPER(publisher), ROUND(AVG(book_ratings),2) AS average_ratings
FROM books
INNER JOIN ratings
USING(isbn)
WHERE book_ratings > 0
GROUP BY 1
ORDER BY 1;
```

**Results** -- only shows top 5

| Upper                                           | Average Ratings |
|-------------------------------------------------|------------------|
| "'K' PUB"                                       | 8.00             |
| "EDITIONS P. TERRAIL"                           | 10.00            |
| "[AMBO"                                         | 7.00             |
| "[DISTRIBUTED BY] FUNDACÃƑÂ£O ORIENTE"          | 7.50             |
| "\\CORVINA\\\""                                 | 8.00             |

6. Count of user by age group range

```sql
SELECT COUNT(CASE WHEN age > 5 AND age < 29 THEN 1 END) AS "'6-28'",
       COUNT(CASE WHEN age > 28 AND age < 52 THEN 1 END) AS "'29-51'",
	   COUNT(CASE WHEN age > 51 AND age < 75 THEN 1 END) AS "'52-74'",
	   COUNT(CASE WHEN age > 74 AND age < 98 THEN 1 END) AS "'75-97'",
	   COUNT(CASE WHEN age > 97 AND age < 117 THEN 1 END) AS "'98-116'"
FROM users;
```

**Results**

| '6-28' | '29-51' | '52-74' | '75-97' | '98-116' |
|--------|---------|---------|---------|----------|
| 65301  | 78425   | 22378   | 705     | 299      |

7. Average of book rating by group age

```sql
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
```

**Results**

-- The null value is the average of age group that not in the range (0-5, > 116)

| Age Group | Average Rating |
|-----------|----------------|
| "29-51"   | 7.6084         |
| "52-74"   | 7.9974         |
| "6-28"    | 7.6904         |
| "75-97"   | 7.4921         |
| "98-116"  | 7.1717         |
|           | 7.3685         |

8. Count number of book rating by book title (book rating = 0)

```sql
SELECT b.book_title,r.isbn, COUNT(*) AS user_count
FROM ratings r
INNER JOIN books b
USING(isbn)
WHERE r.book_ratings = 0
GROUP BY 1,2
ORDER BY 3 DESC;
```

**Results** --only shows top 5

| Book Title                                                     | ISBN        | User Count |
|----------------------------------------------------------------|-------------|------------|
| "A Painted House"                                              | "044023722X" | 366        |
| "Snow Falling on Cedars"                                       | "067976402X" | 358        |
| "The Firm"                                                     | "044021145X" | 321        |
| "Harry Potter and the Sorcerer's Stone (Harry Potter (Paperback))" | "059035342X" | 258        |
| "The No. 1 Ladies' Detective Agency (Today Show Book Club #8)"  | "1400034779" | 248        |


