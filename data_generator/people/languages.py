import pyodbc

def fill_languages(cursor: pyodbc.Cursor):
    clear_languages(cursor)

    languages = [
        "English",
        "Spanish",
        "Chinese",
        "Hindi",
        "Arabic",
        "Bengali",
        "Portuguese",
        "Russian",
        "Japanese",
        "German",
        "French",
        "Italian",
        "Korean",
        "Turkish",
        "Vietnamese",
        "Thai",
        "Hungarian",
        "Dutch",
        "Swedish",
        "Finnish"
    ]

    for primary_key, language in enumerate(languages):
        sql_command = f"""
        INSERT into dbo.Languages (LanguageID, LanguageName)
        VALUES ({primary_key + 1}, '{language}');
        """
        cursor.execute(sql_command)

def clear_languages(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Languages;"
    cursor.execute(sql_clear)
