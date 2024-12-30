import random
import pyodbc

def fill_stationary_sync_async_course_meetings(cursor: pyodbc.Cursor):
    clear_stationary_sync_async_course_meetings(cursor)

    course_meetings_count = get_table_rows_count(cursor, "CoursesMeetings")

    function_pointers_list = [add_stationary_meeting, add_sync_meeting, add_async_meeting]

    for course_id in range(1, course_meetings_count + 1):
        function_to_call = random.choice(function_pointers_list)

        function_to_call(cursor, course_id)

def clear_stationary_sync_async_course_meetings(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.StationaryCourse;"
    cursor.execute(sql_clear)

    sql_clear = "DELETE FROM dbo.OnlineSyncCourse;"
    cursor.execute(sql_clear)

    sql_clear = "DELETE FROM dbo.OnlineAsyncCourse;"
    cursor.execute(sql_clear)

def get_table_rows_count(cursor: pyodbc.Cursor, table_name: str):
    sql_query = f"SELECT COUNT(*) FROM {table_name}"
    cursor.execute(sql_query)

    return cursor.fetchval()

def add_stationary_meeting(cursor: pyodbc.Cursor, meeting_id: int):
    classrooms_count = get_table_rows_count(cursor, "Classrooms")
    classroom_id: int = random.randint(1, classrooms_count + 1)

    sql_command = f"""
    INSERT INTO dbo.StationaryCourse (StationaryCourseMeetingID, ClassroomID)
    VALUES ({meeting_id}, {classroom_id});
    """

    cursor.execute(sql_command)

def add_sync_meeting(cursor: pyodbc.Cursor, meeting_id: int):
    meeting_link = generate_link("courses/meeting/sync")

    sql_command = f"""
    INSERT INTO dbo.OnlineSyncCourse (OnlineSyncCourseMeetingID, MeetingLink)
    VALUES ({meeting_id}, '{meeting_link}');
    """

    cursor.execute(sql_command)

def add_async_meeting(cursor: pyodbc.Cursor, meeting_id: int):
    recording_link = generate_link("courses/recording")

    sql_command = f"""
    INSERT INTO dbo.OnlineAsyncCourse (OnlineAsyncCourseMeetingID, RecordingLink)
    VALUES ({meeting_id}, '{recording_link}');
    """

    cursor.execute(sql_command)

def generate_link(section, length=16):
    link = f"https://skibidischool.pl/{section}/"
    for _ in range(length):
        link += random.choice("abcdefghijklmnopqrstuvwxyz1234567890")
    return link
