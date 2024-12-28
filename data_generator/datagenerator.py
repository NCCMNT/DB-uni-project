import pyodbc
import json
import people.languages
import people.roles

path_to_json_file = "database_credentials.json"

with open(path_to_json_file, 'r') as f:
    credentials = json.load(f)

# Database connection parameters
server = credentials["server"]
database = credentials["database"]
username = credentials["username"]
password = credentials["password"]
driver = credentials["driver"]

def main():
    conn = None
    cursor = None

    try:
        # Connect to the database
        conn = pyodbc.connect(
            f'DRIVER={driver};'
            f'SERVER={server};'
            f'DATABASE={database};'
            f'UID={username};'
            f'PWD={password}'
        )

        cursor = conn.cursor()
        print("Successfully connected to the database.")

        people.roles.fill_roles(cursor)
        people.languages.fill_languages(cursor)

        conn.commit()
        print("Test data inserted successfully.")

    except pyodbc.Error as e:
        print(f"Database error: {e}")
    finally:
        # Clean up and close connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()
            print("Database connection closed.")

if __name__ == "__main__":
    main()
