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

2. 

