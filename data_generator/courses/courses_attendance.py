import pyodbc
import pandas
import random

def fill_courses_attandance(cursor: pyodbc.Cursor):
    clear_courses_attandance(cursor)

    WAS_ON_COURSE_CHANCE_PROCENTAGE = 70

    user_meetings_held_pairs_sql_query = """
    SELECT
        DISTINCT
        cm.MeetingID,
        o.UserID
    FROM OrderDetails AS od
    INNER JOIN ServiceTypes AS st
        ON od.ServiceTypeID = st.ServiceTypeID
    INNER JOIN Orders AS o
        ON o.OrderID = od.OrderID
    INNER JOIN Courses AS c
        ON c.CourseID = od.ServiceID
    INNER JOIN CoursesMeetings AS cm
        ON cm.CourseID = c.CourseID
    WHERE ServiceTypeName = 'Course'
        AND cm.EndDate < GETDATE();
    """

    user_meetings_held_pairs_df = query_to_data_frame(cursor, user_meetings_held_pairs_sql_query)
    user_meetings_held_pairs_list = user_meetings_held_pairs_df.to_records(index = False)

    for meeting_id, user in user_meetings_held_pairs_list:
        if random.randint(1, 100) <= WAS_ON_COURSE_CHANCE_PROCENTAGE:
            sql_command = f"""
            INSERT INTO dbo.CoursesAttendance (CourseMeetingID, UserID)
            VALUES ({meeting_id}, {user});
            """

            cursor.execute(sql_command)

def clear_courses_attandance(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.CoursesAttendance;"
    cursor.execute(sql_clear)

def query_to_data_frame(cursor: pyodbc.Cursor, query: str):
    cursor.execute(query)
    return pandas.DataFrame.from_records(cursor.fetchall(), columns=[col[0] for col in cursor.description])
