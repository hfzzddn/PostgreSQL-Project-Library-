# PostgreSQL-Project(Library)

**Author:** Mohamad Hafizzudin Bin Yahya

**Email:** hafizz.yahya777@gmail.com

**LinkedIn:** http://www.linkedin.com/in/mohamad-hafizzuddin

INTRODUCTION

The PostgreSQL Library project is a demonstration of the skills and knowledge that I acquired through the Datacamp online course, particularly in PostgreSQL. By leveraging the tools provided by pgAdmin, this project aims to showcase proficiency in data analysis and database management.

ABOUT THE DATASET

**books Table**
- **isbn**: The unique identifier for each book. Converted to uppercase for consistency.
  - Duplicate are already remove.
  - Distinct Values: 271033.
  - Primary key.
- **book_title**: The title of the book.
- **book_author**: The author of the book.
- **year_publish**: The year the book was published.
  - Range: 1376 - 2021
  - Data with year_publish more than 2021 have been remove and store into table books_deleted.
- **publisher**: The publisher of the book.

**ratings Table**
- **user_id** : The id of each user (not unique).
  - foreign key references to user_id in users table.
- **isbn** : The isbn number of book read by each user_id.
  - foreign key references to isbn in books table.
- **book_ratings** : book_ratings are either explicit, expressed on a scale from 1-10 (higher values denoting higher appreciation), or implicit, expressed by 0.
  

 **users Table**
 - **user_id** : The unique identifier for each user.
   - Distinct Values : 278858.
   - Primary Key.
 - **location** : location by each user.
 - **age** : age of each user range from (0 -244).
   - Contain null value.
   - Age (0-5) and age more than 116 are excluded from analysis.
  
**Dataset:** https://www.kaggle.com/datasets/arashnic/book-recommendation-dataset

**Entity Relationship Diagram**

![ERD library](https://github.com/hfzzddn/SQL-Server-Project-Library-/assets/157438704/c134e811-5f0a-43fb-a62b-54f204777858)

 
