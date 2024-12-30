import datetime
import random

import pyodbc

from data_generator.helpers.get_users_by_role import get_users_by_role
from data_generator.helpers.links import generate_link
from data_generator.people.translators import get_languages_count
from data_generator.webinars.webinar_name_gen import random_webinar_name


def fill_webinars(cursor: pyodbc.Cursor):
    clear_webinars(cursor)
    NO_OF_WEBINARS = 750
    FOREIGN_LANGUAGE_PROBABILITY = 0.25
    for i in range(1, NO_OF_WEBINARS + 1):
        webinar = {
            "ID": i,
            "name": random_webinar_name(i - 1),
            "link": generate_link("webinar"),
            "date": datetime.datetime(
                year=random.randint(2025, 2029),
                month=random.randint(1, 12),
                day=random.randint(1, 28),
                hour=random.randint(0, 23),
                minute=0,
            ),
            "price": 10 * random.randint(5, 25),
            "presenter": random.randint(1, len(get_users_by_role(cursor, 5))),
            "translator": random.randint(1, get_languages_count(cursor)) if random.random() < FOREIGN_LANGUAGE_PROBABILITY else 'null',
        }
        insert_webinar(cursor, webinar)
    pass
def insert_webinar(cursor: pyodbc.Cursor, webinar_info: dict):
    sql_insert = (f"insert into dbo.Webinars (WebinarID, WebinarName, RecordingLink, Date, Price, WebinarPresenterID, TranslatorLanguageID)"
                  f" values ({webinar_info['ID']}, '{webinar_info['name']}', '{webinar_info['link']}', '{webinar_info['date']}', {webinar_info['price']}, {webinar_info['presenter']}, {webinar_info['translator']})")
    cursor.execute(sql_insert)

def clear_webinars(cursor: pyodbc.Cursor):
    cursor.execute("delete from dbo.Webinars")

def get_translators(cursor: pyodbc.Cursor):
    cursor.execute("SELECT * FROM dbo.Translators")
    translators = []
    for row in cursor.fetchall():
        translator = {"TranslatorID": row[0], "languageID": row[1], "employeeID": row[2]}
        translators.append(translator)
    return translators

