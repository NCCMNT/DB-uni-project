import pyodbc

def fill_semesters(cursor: pyodbc.Cursor):
    clear_semesters(cursor)

    NUMBER_OF_SEMESTERS_PER_STUDY = 7

    for primary_key in range(NUMBER_OF_SEMESTERS_PER_STUDY):
        sql_command = f"""
        INSERT into dbo.Semesters (SemesterNo)
        VALUES (?);
        """
        cursor.execute(sql_command, (primary_key + 1))

def clear_semesters(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Semesters;"
    cursor.execute(sql_clear)