import pyodbc

def fill_grades(cursor: pyodbc.Cursor):
    clear_grades(cursor)

    grades = ['2.0', '3.0', '3.5', '4.0', '4.5', '5.0']

    for primary_key, grade in enumerate(grades):
        grade_value = float(grade)
        sql_command = f"""
        INSERT into dbo.Grades (GradeID, GradeValue)
        VALUES (?, ?);
        """
        cursor.execute(sql_command, (primary_key + 1, grade_value))

def clear_grades(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Grades;"
    cursor.execute(sql_clear)