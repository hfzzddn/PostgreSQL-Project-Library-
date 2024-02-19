**List of primary key and foreign key**

1.Primary Key on books table

```sql
ALTER TABLE books
ADD CONSTRAINT pk_books PRIMARY KEY (isbn);
```

2. Primary Key on users table

```sql
ALTER TABLE users
ADD CONSTRAINT pk_users PRIMARY KEY (user_id);
```

3.Foreign Key on ratings table

```sql
ALTER TABLE ratings
ADD CONSTRAINT fk_isbn FOREIGN KEY (isbn) REFERENCES books(isbn);

ALTER TABLE ratings
ADD CONSTRAINT fk_userid FOREIGN KEY (user_id) REFERENCES users(user_id);
```
