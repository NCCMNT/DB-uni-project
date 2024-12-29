import pyodbc
import os
import json
import random
from datetime import datetime, timedelta

def fill_employees(cursor: pyodbc.Cursor):
    clear_employees(cursor)

    NO_ROWS_TO_GENERATE = 500

    current_path = os.path.abspath(__file__)
    current_dir = os.path.dirname(current_path)
    data_dir = "data"
    file_name = "names.json"

    with open(os.path.join(current_dir, data_dir, file_name), 'r') as file:
        data = json.load(file)

    first_names = data["first_names"]
    last_names = data["last_names"]

    addresses_count = get_addresses_count(cursor)

    for primary_key in range(1, NO_ROWS_TO_GENERATE+1):
        first_name = random.choice(first_names)
        last_name = random.choice(last_names)
        birth_date, hire_date = generate_random_birth_and_hire_date()
        address_id = random.randint(1, addresses_count)
        phone = f"{random.randint(0, 999):03}-{random.randint(0, 999):03}-{random.randint(0, 999):03}"

        sql_command = f"""
        INSERT INTO dbo.Employees (EmployeeID, Firstname, Lastname, BirthDate, HireDate, AddressID, Phone)
        VALUES ({primary_key}, '{first_name}', '{last_name}', '{birth_date}', '{hire_date}', {address_id}, '{phone}')
        """

        cursor.execute(sql_command)

def clear_employees(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Employees;"
    cursor.execute(sql_clear)

def get_addresses_count(cursor: pyodbc.Cursor):
    sql_query = "SELECT COUNT(*) FROM dbo.Addresses"
    cursor.execute(sql_query)

    rows = cursor.fetchall()

    return rows[0][0]

def generate_random_birth_and_hire_date(min_age=20, max_age=65):
    """Generate a random birth date based on minimum and maximum age."""
    # Calculate the current date
    today = datetime.now()

    # Calculate the latest possible birth date based on max_age
    latest_birth_date = today - timedelta(days=max_age * 365)

    # Calculate the earliest possible birth date based on min_age
    earliest_birth_date = today - timedelta(days=min_age * 365)

    # Generate a random date between the earliest and latest birth dates
    random_birth_date_int = random.randint(int(latest_birth_date.timestamp()), int(earliest_birth_date.timestamp()))
    birth_date =  datetime.fromtimestamp(random_birth_date_int)

    # Calculate the latest possible hire date based on 18-th birthday
    eighteenth_birthday_date = birth_date + timedelta(days=18 * 365)

    # Generate random hire date
    random_hire_date_int = random.randint(int(eighteenth_birthday_date.timestamp()), int(today.timestamp()))
    hire_date = datetime.fromtimestamp(random_hire_date_int)

    return birth_date.date(), hire_date.date()
