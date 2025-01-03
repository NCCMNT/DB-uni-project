import pyodbc
import os
import json
import random
import bcrypt
import string

def fill_users(cursor: pyodbc.Cursor):
    clear_users(cursor)

    NO_ROWS_TO_GENERATE = 8500

    current_path = os.path.abspath(__file__)
    current_dir = os.path.dirname(current_path)
    data_dir = "data"
    file_name = "names.json"

    with open(os.path.join(current_dir, data_dir, file_name), 'r') as file:
        data = json.load(file)

    first_names = data["first_names"]
    last_names = data["last_names"]

    addresses_count = get_addresses_count(cursor)

    for user_id in range(1, NO_ROWS_TO_GENERATE + 1):
        first_name = random.choice(first_names)
        last_name = random.choice(last_names)
        email = generate_email(user_id, first_name, last_name)
        password = generate_random_password(random.randint(5, 20))
        hashed_password = hash_password(password)
        phone = f"{random.randint(0, 999):03}-{random.randint(0, 999):03}-{random.randint(0, 999):03}"
        address_id = random.randint(1, addresses_count)

        sql_command = f"""
        INSERT INTO dbo.Users (UserID, Firstname, Lastname, Email, Password, Phone, AddressID)
        VALUES ({user_id}, '{first_name}', '{last_name}', '{email}', '{hashed_password}', '{phone}', {address_id})
        """

        cursor.execute(sql_command)

def clear_users(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Users;"
    cursor.execute(sql_clear)

def get_users_count(cursor: pyodbc.Cursor):
    sql_query = "SELECT COUNT(*) FROM dbo.Users"
    cursor.execute(sql_query)

    return cursor.fetchval()

def get_addresses_count(cursor: pyodbc.Cursor):
    sql_query = "SELECT COUNT(*) FROM dbo.Addresses"
    cursor.execute(sql_query)

    rows = cursor.fetchall()

    return rows[0][0]

def generate_email(user_id: int, first_name: str, last_name: str):
    email_domains = [
        "gmail.com",
        "yahoo.com",
        "hotmail.com",
        "aol.com",
        "outlook.com",
        "mail.com",
        "live.com",
        "yandex.ru",
        "gmx.de",
        "web.de",
        "icloud.com",
        "qq.com",
        "zoho.com",
        "protonmail.com",
        "fastmail.com",
        "tutanota.com",
        "sbcglobal.net",
        "comcast.net",
        "verizon.net",
        "att.net"
    ]

    first_name_characters = random.randint(2, len(first_name))
    last_name_characters = random.randint(2, len(last_name))

    email_part1 = first_name[:first_name_characters].lower()
    email_part2 = last_name[:last_name_characters].lower()

    email = f"{email_part1}.{email_part2}{user_id}@{random.choice(email_domains)}"

    return email

def generate_random_password(length: int):
    characters = string.ascii_letters + string.digits + string.punctuation
    password = ''.join(random.choice(characters) for _ in range(length))

    return password

def hash_password(password: str):
    salt = bcrypt.gensalt()
    hashed_password = str(bcrypt.hashpw(password.encode('utf-8'), salt))

    return hashed_password.replace("'", "''").replace("\\", "\\\\").replace("\"", "\\\"")
