import pyodbc

def fill_internships(cursor: pyodbc.Cursor):
    clear_internships(cursor)

    study_ids = get_study_ids(cursor)
    primary_key = 1

    for study_id in study_ids:
        sql_command = f"""
        INSERT into dbo.Internships (InternshipID, StudyID, CycleNo)
        VALUES (?, ?, ?);
        """
        cursor.execute(sql_command, (primary_key, study_id, 1))
        primary_key += 1

        cursor.execute(sql_command, (primary_key, study_id, 2))
        primary_key += 1

def clear_internships(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Internships;"
    cursor.execute(sql_clear)

def get_study_ids(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT StudyID FROM Studies
    ORDER BY 1
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row[0] for row in rows]