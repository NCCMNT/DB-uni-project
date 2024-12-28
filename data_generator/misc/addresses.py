# Lista przykładowych angielskich nazw ulic
import random

import pyodbc

english_streets = [
    "Baker Street", "Elm Street", "Maple Avenue", "Oak Drive", "Pine Road", "Cedar Street",
    "Highland Avenue", "Sunset Boulevard", "Broadway", "King's Road", "Queen's Street", "Victoria Street",
    "Church Lane", "Park Avenue", "Main Street", "Mill Lane", "Greenwich Street", "Hilltop Drive",
    "Rosemary Lane", "Lakeside Drive", "River Road", "Beach Boulevard", "Broad Street", "Crescent Road",
    "Abbey Road", "Willow Lane", "Chestnut Street", "North Avenue", "South Street", "East Road", "West Street",
    "Copper Hill", "Silver Street", "Gold Road", "Kingston Road", "Union Street", "Wellington Avenue",
    "Harrison Road", "Pinecrest Drive", "Maplewood Drive", "Bridge Street", "Park Lane", "Garden Lane",
    "Moss Lane", "Sycamore Street", "Hawthorne Avenue", "Fern Lane", "Sunrise Avenue", "Glencoe Road",
    "St. George's Road", "Portman Square", "Lancaster Road", "Chesterfield Avenue", "Ashford Street",
    "Hampton Road", "Riverside Drive", "Morningside Drive", "Coventry Road", "Bristol Avenue", "Clifton Road",
    "King's Square", "Hillcrest Drive", "Northgate Street", "Southgate Road", "Springfield Road", "Thames Street",
    "Windmill Lane", "Woodsworth Road", "Lakeview Drive", "Shady Grove Lane", "Valley Road", "Windsor Road",
    "Oakwood Street", "Richmond Avenue", "Falcon Road", "Harbor View Road", "Parkwood Drive", "Delaware Avenue",
    "Pinehill Street", "Adams Avenue", "Hillside Road", "Rose Avenue", "Wildflower Lane", "Linden Street",
    "Bayside Road", "Riverfront Drive", "Riverside Boulevard", "Cherry Lane", "Cottonwood Drive", "Hawthorn Street",
    "Silverwood Road", "Mayfair Avenue", "Newport Street", "Cedarwood Drive", "Lakeshore Boulevard",
    "Redwood Lane", "Sunshine Drive", "Forest Drive", "Heritage Road", "Monarch Road", "Seaside Avenue",
    "Rocky Ridge Road", "Cedar Grove Lane", "Sunhill Drive", "Brookside Road", "Lakeview Avenue",
    "Mapleton Drive", "Fairview Street", "Northfield Avenue", "Country Lane", "Larch Lane", "Starview Road",
    "Autumn Street", "Bluebell Lane", "Golden Gate Road", "White Oak Road", "Crystal Springs Road",
    "Mornington Crescent"
]


def generate_postcode():
    return f"{random.randint(10, 99)}-{random.randint(100, 999)}"


# Generowanie 100 losowych nazw ulic z kodami pocztowymi
street_data_english = []
for _ in range(1000):
    street_name = random.choice(english_streets)
    postcode = generate_postcode()
    street_data_english.append({"street_name": street_name, "postcode": postcode})


def fill_addresses(cursor: pyodbc.Cursor):
    clear_addresses(cursor)
    def insert_address(id: int, city: int, name: str, postcode: str):
        sql_insert = f"insert into dbo.Addresses (addressID, cityID, street, zipCode) values ({str(id)}, {str(city)} , '{name.replace("'", "")}', '{postcode}')"
        cursor.execute(sql_insert)

    for i, street in enumerate(street_data_english):
        insert_address(i + 1, random.randint(1, 621), street["street_name"], street["postcode"])

def clear_addresses(cursor: pyodbc.Cursor):
    cursor.execute("delete from dbo.Addresses")
