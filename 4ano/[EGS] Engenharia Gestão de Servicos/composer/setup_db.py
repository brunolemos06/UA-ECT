import sqlite3

conn = sqlite3.connect('compuser.db')
print("Opened database successfully")

conn.execute('CREATE TABLE compuser (auth_id TEXT PRIMARY KEY, chat_id TEXT UNIQUE, review_id INTEGER, trip_id TEXT UNIQUE)')
print("Table compuser successfully")

conn.close()

# conn = sqlite3.connect('compuser.db')
# print("Opened database successfully")
# conn.execute('DROP TABLE IF EXISTS compuser')
# print("Table dropped successfully")
# conn.close()