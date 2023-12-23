import sqlite3
import os

# Connect to the database
conn = sqlite3.connect('database.db')

# Create a cursor object
cur = conn.cursor()

# Create the table named reviews with the following columns
# personid : integer
# title : text
# description : text
# rating : integer [1..5]
# reviewid : integer [primary key]
# data : timestamp [default current_timestamp] [auto generated]
cur.execute('''
    CREATE TABLE IF NOT EXISTS reviews (
        personid INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
        reviewid INTEGER PRIMARY KEY,
        data TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
    )
''')

print("-> table created(")
print("\tpersonid : integer")
print("\ttitle : text")
print("\tdescription : text")
print("\trating : integer [1..5]")
print("\treviewid : integer [primary key]")
print("\tdata : timestamp [default current_timestamp] [auto generated] )")
print("-> database created..")
# always i insert a new review, i dont want to insert the reviewid, because it is autoincrement and i dont want to insert the data, because it is a timestamp


# Commit the transaction and close the connection
conn.commit()
conn.close()