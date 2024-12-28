import json
import pyodbc


with open("misc/cities.json", "r", encoding="utf-8") as file:
    data = json.load(file)
    countries = data

def fill_countries(cursor: pyodbc.Cursor):
    clear_countries(cursor)
    for i, country in enumerate(countries):
        insert_country(cursor, i + 1, country["country_name"])

def insert_country(cursor: pyodbc.Cursor, id: int, country_name: str):
    sql_insert = f"insert into dbo.Countries (CountryID, CountryName) values ({str(id)}, '{country_name}')"
    cursor.execute(sql_insert)

def clear_countries(cursor: pyodbc.Cursor):
    cursor.execute("delete from dbo.Countries")

