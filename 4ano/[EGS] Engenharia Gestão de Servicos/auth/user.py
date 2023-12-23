import sqlite3 as sql

def create_user(public_id, firstName, lastName, email, password):
    try:
        with sql.connect("users.db") as con:
            cur = con.cursor()
            cur.execute("INSERT INTO User (public_id, firstName, lastName, email, password) VALUES (?,?,?,?,?)", (public_id, firstName, lastName, email, password))
            con.commit()
            success = True
    except:
        con.rollback()
        success = False
    finally:
        con.close()
        return success
    
def get_user(email):
    try:
        with sql.connect("users.db") as con:
            cur = con.cursor()
            cur.execute("SELECT * FROM User WHERE email = ?", (email,))
            user = cur.fetchone()
            if not user:
                return None
            return user
    except:
        con.rollback()
        return None
    finally:
        con.close()

def get_user_by_id(public_id):
    try:
        with sql.connect("users.db") as con:
            cur = con.cursor()
            cur.execute("SELECT * FROM User WHERE public_id = ?", (public_id,))
            user = cur.fetchone()
            if not user:
                return None
            return user
    except:
        con.rollback()
        return None
    finally:
        con.close()


def create_social_user(provider_id, provider, email, firstName, lastName, avatar):
    try:
        with sql.connect("users.db") as con:
            cur = con.cursor()
            cur.execute("INSERT INTO SocialUser (provider_id, provider, email, firstName, lastName, avatar) VALUES (?,?,?,?,?,?)", (provider_id, provider, email, firstName, lastName, avatar))
            con.commit()
            success = True
    except:
        con.rollback()
        success = False
    finally:
        con.close()
        return success
    
def get_social_user(provider_id, provider):
    try:
        with sql.connect("users.db") as con:
            cur = con.cursor()
            cur.execute("SELECT * FROM SocialUser WHERE provider_id = ? AND provider = ?", (provider_id, provider))
            user = cur.fetchone()
            if not user:
                return None
            return user
    except:
        con.rollback()
        return None
    finally:
        con.close()

def get_social_user_by_id(provider_id):
    try:
        with sql.connect("users.db") as con:
            cur = con.cursor()
            cur.execute("SELECT * FROM SocialUser WHERE provider_id = ?", (provider_id,))
            user = cur.fetchone()
            if not user:
                return None
            return user
    except:
        con.rollback()
        return None
    finally:
        con.close()