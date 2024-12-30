import pyodbc

def fill_study_semesters(cursor: pyodbc.Cursor):
    clear_study_semesters(cursor)

    study_ids = get_study_ids(cursor)
    semesters = get_semesters(cursor)
    primary_key = 0

    for study_id in study_ids:
        for semester_no in semesters:

            sql_command = f"""
            INSERT into dbo.StudySemesters (StudySemesterID, StudyID, SemesterNo)
            VALUES (?, ?, ?);
            """

            cursor.execute(sql_command, (primary_key + 1, study_id, semester_no))
            primary_key += 1

def clear_study_semesters(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.StudySemesters;"
    cursor.execute(sql_clear)

def get_study_ids(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT StudyID FROM Studies
    ORDER BY 1
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row[0] for row in rows]

def get_semesters(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT SemesterNo FROM Semesters
    ORDER BY 1
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row[0] for row in rows]