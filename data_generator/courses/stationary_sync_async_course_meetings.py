import random
import pyodbc
import pandas


def fill_stationary_sync_async_course_meetings(cursor: pyodbc.Cursor):
    clear_stationary_sync_async_course_meetings(cursor)

    course_meetings_count = get_table_rows_count(cursor, "CoursesMeetings")

    get_course_meetings_sql_query = """
    SELECT
        CourseID,
        MeetingID,
        LimitOfParticipants
    FROM CoursesMeetings
    """

    course_meetings_df = query_to_data_frame(cursor, get_course_meetings_sql_query)

    get_classroom_id_with_capacity_sql_query = """
    SELECT
        ClassroomID,
        Capacity
    FROM Classrooms
    """

    classrooms_df = query_to_data_frame(cursor, get_classroom_id_with_capacity_sql_query)

    prev_course_id = None

    for course_meeting_id in range(1, course_meetings_count + 1):
        limit_of_participants = list(course_meetings_df[course_meetings_df["MeetingID"] == course_meeting_id]["LimitOfParticipants"])[0]
        course_id = list(course_meetings_df[course_meetings_df["MeetingID"] == course_meeting_id]["CourseID"])[0]

        if not pandas.isna(limit_of_participants):
            if prev_course_id != course_id:
                add_stationary_meeting(cursor, course_meeting_id, classrooms_df, limit_of_participants)
            elif random.randint(1, 10) <= 5:
                add_stationary_meeting(cursor, course_meeting_id, classrooms_df, limit_of_participants)
            elif random.randint(1, 10) <= 5:
                add_sync_meeting(cursor, course_meeting_id)
            else:
                add_async_meeting(cursor, course_meeting_id)
        else:
            meeting_type = random.randint(1, 10)

            if meeting_type <= 5:
                add_sync_meeting(cursor, course_meeting_id)
            else:
                add_async_meeting(cursor, course_meeting_id)

        prev_course_id = course_id

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

def query_to_data_frame(cursor: pyodbc.Cursor, query: str):
    cursor.execute(query)
    return pandas.DataFrame.from_records(cursor.fetchall(), columns=[col[0] for col in cursor.description])

def add_stationary_meeting(cursor: pyodbc.Cursor, meeting_id: int, classrooms_df: pandas.DataFrame, limit_of_participants: int):
    classrooms_choice_list = list(classrooms_df[classrooms_df["Capacity"] >= limit_of_participants]["ClassroomID"])
    classroom_id = random.choice(classrooms_choice_list)

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
