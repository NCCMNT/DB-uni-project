import json
import pyodbc

# Generate countries first
with open("misc/cities.json", "r", encoding="utf-8") as file:
    data = json.load(file)
    countries = data


def fill_cities(cursor: pyodbc.Cursor):
    clear_cities(cursor)
    cities = []
    cnt = 1
    for i, country in enumerate(countries):
        for city in country["cities"]:
            cities.append((cnt, i + 1, city["city_name"]))
            cnt += 1
    for city in cities:
        insert_city(cursor, city[0], city[1], city[2])

def insert_city(cursor: pyodbc.Cursor, id: int, country_id: int, city_name: str):
    sql_insert = f"insert into dbo.Cities (CityID,CountryID, CityName) values ({str(id)}, {str(country_id)} , '{city_name}')"
    cursor.execute(sql_insert)

def clear_cities(cursor: pyodbc.Cursor):
    cursor.execute("delete from dbo.Cities")