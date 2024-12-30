import pyodbc

def fill_semesters(cursor: pyodbc.Cursor):
    clear_semesters(cursor)

    for primary_key in range(7):
        sql_command = f"""
        INSERT into dbo.Semesters (SemesterNo)
        VALUES (?);
        """
        cursor.execute(sql_command, (primary_key + 1))

def clear_semesters(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Semesters;"
    cursor.execute(sql_clear)