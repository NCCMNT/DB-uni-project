import pyodbc
import random

def fill_final_exams(cursor: pyodbc.Cursor):
    clear_final_exams(cursor)

    study_student_ids = get_study_student_ids(cursor)
    grade_ids = get_grade_ids(cursor)

    for study_id, student_id in study_student_ids:
        
        grade_id = random.choice(grade_ids)

        sql_command = f"""
        INSERT into dbo.FinalExams (StudyID, StudentID, GradeID)
        VALUES (?, ?, ?);
        """
        cursor.execute(sql_command, (study_id, student_id, grade_id))

def clear_final_exams(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.FinalExams;"
    cursor.execute(sql_clear)

def get_study_student_ids(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT s.StudyID, st.StudentID FROM Studies as s
    INNER JOIN Students AS st ON st.StudyID = s.StudyID
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row for row in rows]

def get_grade_ids(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT GradeID FROM Grades
    ORDER BY 1
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row[0] for row in rows]