import pyodbc
import random

def fill_stationary_study_meetings(cursor: pyodbc.Cursor):
    clear_stationary_study_meetings(cursor)

    meetings_ids = get_meetings_ids(cursor)
    classrooms_ids = get_classrooms_ids(cursor)

    for meeting_id in meetings_ids:
        if meeting_id % 2 == 0: continue

        classroom_id = random.choice(classrooms_ids)

        sql_command = f"""
        INSERT into dbo.StationaryStudy (StationaryStudyMeetingID, ClassroomID)
        VALUES (?, ?);
        """
        cursor.execute(sql_command, (meeting_id, classroom_id))

def clear_stationary_study_meetings(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.StationaryStudy;"
    cursor.execute(sql_clear)

def get_meetings_ids(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT MeetingID FROM StudiesMeetings
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row[0] for row in rows]

def get_classrooms_ids(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT ClassroomID FROM Classrooms
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row[0] for row in rows]
