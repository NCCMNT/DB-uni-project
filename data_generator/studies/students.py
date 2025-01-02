import pyodbc
import random

def fill_students(cursor: pyodbc.Cursor):
    clear_students(cursor)

    user_ids = get_user_ids(cursor)
    study_ids = get_study_ids(cursor)
    semesters = get_semesters(cursor)

    checked = set()
    primary_key = 0

    for user_id in user_ids:
        
        study_id = random.choice(study_ids)
        semester_no = random.choice(semesters)

        while (user_id, study_id, semester_no) in checked:
            user_id = random.choice(user_ids)
            semester_no = random.choice(semesters)

        checked.add((user_id, study_id, semester_no))

        sql_command = f"""
        INSERT into dbo.Students (StudentID, UserID, StudyID, SemesterNo)
        VALUES (?, ?, ?, ?);
        """
        cursor.execute(sql_command, (primary_key + 1, user_id, study_id, semester_no))
        primary_key += 1

def clear_students(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Students;"
    cursor.execute(sql_clear)

def get_user_ids(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT u.UserID FROM Users AS u
    INNER JOIN Orders AS o ON o.UserID = u.UserID
    INNER JOIN OrderDetails AS od ON od.OrderID = o.OrderID
    INNER JOIN ServiceTypes AS st ON st.ServiceTypeID = od.ServiceTypeID
    WHERE st.ServiceTypeName = 'Studies'
    ORDER BY 1
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row[0] for row in rows]

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