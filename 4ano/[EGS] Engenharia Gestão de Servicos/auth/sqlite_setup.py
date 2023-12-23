import sqlite3

conn = sqlite3.connect('users.db')
print("Opened database successfully")

conn.execute('CREATE TABLE SocialUser (id INTEGER PRIMARY KEY AUTOINCREMENT, provider_id VARCHAR(80) NOT NULL, provider VARCHAR(80) NOT NULL, email VARCHAR(120) UNIQUE NOT NULL, firstName VARCHAR(80) NOT NULL, lastName VARCHAR(80) NOT NULL, avatar VARCHAR(255))')
print("Table social  created successfully")

conn.execute('CREATE TABLE User ( id INTEGER PRIMARY KEY AUTOINCREMENT, public_id VARCHAR(50) UNIQUE NOT NULL, firstName VARCHAR(50) NOT NULL, lastName VARCHAR(50) NOT NULL, email VARCHAR(50) UNIQUE NOT NULL, password VARCHAR(120) NOT NULL)')
print("Table user created successfully")

conn.close()

# conn = sqlite3.connect('users.db')
# print("Opened database successfully")
# conn.execute('DROP TABLE IF EXISTS SocialUser')
# conn.execute('DROP TABLE IF EXISTS User')
# print("Table dropped successfully")
# conn.close()