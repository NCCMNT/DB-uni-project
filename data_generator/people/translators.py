import pyodbc
import random

def fill_translators(cursor: pyodbc.Cursor):
    clear_translators(cursor)

    languages_count = get_languages_count(cursor)

    translators_id_list = get_translators_id_list(cursor)

    translator_language_id = 0

    for translator_id in translators_id_list:
        current_translator_max_languages_cnt = random.randint(2, 5)

        picked_languages = set()

        for _ in range(current_translator_max_languages_cnt):
            picked_languages.add(random.randint(1, languages_count))

        for language_id in picked_languages:
            translator_language_id += 1

            sql_command = f"""
            INSERT INTO Translators (TranslatorLanguageID, LanguageID, EmployeeID)
            VALUES ({translator_language_id}, {language_id}, {translator_id})
            """

            cursor.execute(sql_command)

def clear_translators(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Translators;"
    cursor.execute(sql_clear)

def get_languages_count(cursor: pyodbc.Cursor):
    sql_query = "SELECT COUNT(*) FROM dbo.Languages"
    cursor.execute(sql_query)

    rows = cursor.fetchall()

    return rows[0][0]

def get_translators_id_list(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT
        EmployeeID
    FROM Roles
    INNER JOIN EmployeeRoles
        ON Roles.RoleID = EmployeeRoles.RoleID
    WHERE RoleName = 'Translator';
    """
    cursor.execute(sql_query)

    rows = cursor.fetchall()

    return [row[0] for row in rows]
