import sqlite3

conn = sqlite3.connect('users.db')
print("Opened database successfully")

conn.execute('DROP TABLE IF EXISTS SocialUser')
conn.execute('DROP TABLE IF EXISTS User')
print("Tables dropped successfully")
conn.close()
