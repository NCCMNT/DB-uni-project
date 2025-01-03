import pyodbc
import random

def fill_online_study_meetings(cursor: pyodbc.Cursor):
    clear_online_study_meetings(cursor)

    meetings_ids = get_meetings_ids(cursor)

    for meeting_id in meetings_ids:
        if meeting_id % 2 == 1: continue

        link = generate_link('online-study')

        sql_command = f"""
        INSERT into dbo.OnlineStudy (OnlineStudyMeetingID, MeetingLink)
        VALUES (?, ?);
        """
        cursor.execute(sql_command, (meeting_id, link))

def clear_online_study_meetings(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.OnlineStudy;"
    cursor.execute(sql_clear)

def get_meetings_ids(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT MeetingID FROM StudiesMeetings
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row[0] for row in rows]

def generate_link(section, length=16):
    link = f"https://skibidischool.pl/{section}/"
    for _ in range(length):
        link += random.choice("abcdefghijklmnopqrstuvwxyz1234567890")
    return link