import pyodbc
import random

def fill_study_attandance(cursor: pyodbc.Cursor):
    clear_study_attandance(cursor)

    students_meetings_ids = get_students_meetings_ids_pairs(cursor)
    n = len(students_meetings_ids)
    i = 1

    for student_id, meeting_id in students_meetings_ids:

        chance = random.randint(1,100)
        if chance <= 8: continue

        sql_command = f"""
        INSERT into dbo.StudyAttandance (StudyMeetingID, StudentID)
        VALUES (?, ?);
        """
        cursor.execute(sql_command, (meeting_id, student_id))
        print(f"{round(100 * i/n, 2)}%", end='\r')
        i += 1

def clear_study_attandance(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.StudyAttandance;"
    cursor.execute(sql_clear)

def get_students_meetings_ids_pairs(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT s.StudentID, m.MeetingID FROM Students AS s
    INNER JOIN Studies AS stud ON stud.StudyID = s.StudyID
    INNER JOIN StudySemesters AS ssem ON ssem.StudyID = s.StudyID
    INNER JOIN StudyMeetups AS sm on ssem.StudySemesterID = sm.StudySemesterID
    INNER JOIN StudiesMeetings AS m on sm.StudyMeetupID = m.StudyMeetupID
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row for row in rows]