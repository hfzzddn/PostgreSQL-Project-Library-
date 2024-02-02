# SQL-Server-Project-Library-

INTRODUCTION
I decide to undertake this project because I wanted to showcase what i have learn in Datacamp online course specifically in T-SQL language. I use SQL(Structured Query Language) Server Management Studio as my platfrom. SQL allow users to create and manage database for storage and data management.

ABOUT THE DATASET
Name of Dataset : Book Recommendation Dataset
Dataset source : https://www.kaggle.com/datasets/arashnic/book-recommendation-dataset?select=Users.csv
Content
The Book-Crossing dataset comprises 3 files.

**Users**
Contains the users. Note that user IDs (User-ID) have been anonymized and map to integers. Demographic data is provided (Location, Age) if available. Otherwise, these fields contain NULL-values.
**Books**
Books are identified by their respective ISBN. Invalid ISBNs have already been removed from the dataset. Moreover, some content-based information is given (Book-Title, Book-Author, Year-Of-Publication, Publisher), obtained from Amazon Web Services. Note that in case of several authors, only the first is provided. URLs linking to cover images are also given, appearing in three different flavours (Image-URL-S, Image-URL-M, Image-URL-L), i.e., small, medium, large. These URLs point to the Amazon web site.
**Ratings**
Contains the book rating information. Ratings (Book-Rating) are either explicit, expressed on a scale from 1-10 (higher values denoting higher appreciation), or implicit, expressed by 0.
**Acknowledgements**
Collected by Cai-Nicolas Ziegler in a 4-week crawl (August / September 2004) from the Book-Crossing community with kind permission from Ron Hornbaker, CTO of Humankind Systems. Contains 278,858 users (anonymized but with demographic information) providing 1,149,780 ratings (explicit / implicit) about 271,379 books.

**All the Users,Books and Ratings files description were taken directly from https://www.kaggle.com/datasets/arashnic/book-recommendation-dataset?select=Users.csv.**


AFter importing the Users,Books and Ratings files into SQL Server. Some change were made (only on Users and Ratings)




