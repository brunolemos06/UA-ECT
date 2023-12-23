import sqlite3 as sql
#FUNCTION TO CREATE INITIAL ENTRY 
def create_entry(auth_id):
    try:
        with sql.connect("compuser.db") as con:
            cur = con.cursor()
            cur.execute("INSERT INTO compuser (auth_id) VALUES (?)", (auth_id))
            con.commit()
            success = True
    except:
        con.rollback()
        success = False
    finally:
        con.close()
        return success

#FUNCTION TO CREATE FULL INITIAL ENTRY
def create_full_entry(auth_id, chat_id, review_id, trip_id):
    #  put all data in db
    try:
        with sql.connect("compuser.db") as con:
            cur = con.cursor()
            cur.execute("INSERT INTO compuser (auth_id, chat_id, review_id, trip_id) VALUES (?,?,?,?)", (auth_id, chat_id, review_id, trip_id))
            con.commit()
            success = True
    except:
        con.rollback()
        success = False
    finally:
        con.close()
        return success

#CHECK IF ENTRY ALREADY EXISTS
def get_entry(auth_id):
    print("GET ENTRY : " + auth_id)
    try:
        with sql.connect("compuser.db") as con:
            cur = con.cursor()
            cur.execute("SELECT * FROM compuser WHERE auth_id = ?", [str(auth_id)])
            entry = cur.fetchone()
            # print(entry)
            if not entry:
                return None
            return entry
    except Exception as e:
    # handle the error
        print("An error occurred:", e)
        con.rollback()
        return None
    finally:
        con.close()


# IF REVIEW_ID ALREADY ON BD RETURNS TRUE ELSE FALSE
def check_free_review_id(review_id):
    # check if review_id is already in db

    try:
        with sql.connect("compuser.db") as con:
            cur = con.cursor()
            cur.execute("SELECT * FROM compuser WHERE review_id = ?", [str(review_id)])
            entry = cur.fetchone()
            # print("ENTRY: "+ entry)
            if not entry:
                return True
            return False
    except Exception as e:
    # handle the error
        print("An error occurred:", e)
        con.rollback()
        return False
    finally:
        con.close()
        
def get_review_id(trip_id):
    # check if review_id is already in db

    try:
        with sql.connect("compuser.db") as con:
            cur = con.cursor()
            cur.execute("SELECT review_id FROM compuser WHERE trip_id = ?", [str(trip_id)])
            entry = cur.fetchone()
            # print("ENTRY: "+ entry)
            if not entry:
                return None
            return entry[0]
    except Exception as e:
    # handle the error
        print("An error occurred:", e)
        con.rollback()
        return None
    finally:
        con.close()