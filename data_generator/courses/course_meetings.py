import random
import pyodbc
import pandas
from datetime import datetime, timedelta

def fill_course_meetings(cursor: pyodbc.Cursor):
    clear_course_meetings(cursor)

    get_course_instructors_sql_query = f"""
    SELECT
        Employees.EmployeeID
    FROM dbo.Employees
    INNER JOIN dbo.EmployeeRoles
        ON Employees.EmployeeID = EmployeeRoles.EmployeeID
    INNER JOIN dbo.Roles
        ON Roles.RoleID = EmployeeRoles.RoleID
    WHERE RoleName = 'Course Instructor'
    """

    course_instructors_df = query_to_data_frame(cursor, get_course_instructors_sql_query)

    get_courses_and_translators_employee_id_sql_query = f"""
    SELECT
        CourseID,
        EmployeeID
    FROM Courses
    LEFT JOIN Translators
        ON Courses.TranslatorLanguageID = Translators.TranslatorLanguageID
    """

    courses_and_translators_employee_id_df = query_to_data_frame(cursor, get_courses_and_translators_employee_id_sql_query)

    course_instructors_id_list = list(course_instructors_df["EmployeeID"])
    classrooms_max_capacity = get_classrooms_max_capacity(cursor)
    limit_of_participants_choice_list = list(range(5, classrooms_max_capacity, 5))

    meeting_id = 0

    courses_count = get_courses_count(cursor)

    for course_id in range(1, courses_count + 1):
        no_meetings = random.randint(2, 5)

        values = []

        limit_of_participants = "NULL"

        if random.randint(1, 10) <= 5:
            limit_of_participants = random.choice(limit_of_participants_choice_list)

        for _ in range(no_meetings):

            course_instructors_id = None
            translator_employee_id = None

            while True:
                course_instructors_id = random.choice(course_instructors_id_list)
                translator_employee_id = list(courses_and_translators_employee_id_df[courses_and_translators_employee_id_df["CourseID"] == course_id]["EmployeeID"])[0]

                if course_instructors_id != translator_employee_id:
                    break
                else:
                    print("Course instructor and translator are the same person. Trying again...")

            start_date, end_date = generate_random_start_and_end_dates(5, 3)

            values.append([course_id, start_date, end_date, course_instructors_id])

        values.sort(key = lambda x: x[2])

        for value in values:
            meeting_id += 1
            course_id, start_date, end_date, course_instructors_id = value

            sql_command = f"""
            INSERT INTO dbo.CoursesMeetings (MeetingID, CourseID, StartDate, EndDate, CourseInstructorID, LimitOfParticipants)
            VALUES ({meeting_id}, {course_id}, '{start_date}', '{end_date}', {course_instructors_id}, {limit_of_participants});
            """

            cursor.execute(sql_command)

def clear_course_meetings(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.CoursesMeetings;"
    cursor.execute(sql_clear)

def query_to_data_frame(cursor: pyodbc.Cursor, query: str):
    cursor.execute(query)
    return pandas.DataFrame.from_records(cursor.fetchall(), columns=[col[0] for col in cursor.description])

def get_courses_count(cursor: pyodbc.Cursor):
    sql_query = "SELECT COUNT(*) FROM dbo.Courses"
    cursor.execute(sql_query)

    return cursor.fetchval()

def get_classrooms_max_capacity(cursor: pyodbc.Cursor):
    sql_query = "SELECT MAX(Capacity) FROM dbo.Classrooms"
    cursor.execute(sql_query)

    return cursor.fetchval()

def generate_random_start_and_end_dates(past_course_years = 5, future_course_years = 3):
    start_hour = random.randint(8, 18)
    start_minute = random.choice([0, 15, 30, 45])

    # Calculate the current date
    today = datetime.now()

    # Calculate the latest possible course date based on past_course_years
    latest_course_date = today - timedelta(days = past_course_years * 365)

    # Calculate the earliest possible course date based on future_course_years
    earliest_course_date = today + timedelta(days = future_course_years * 365)

    # Generate a random date between the earliest and latest dates
    random_course_date_int = random.randint(int(latest_course_date.timestamp()), int(earliest_course_date.timestamp()))
    course_date = datetime.fromtimestamp(random_course_date_int).date()

    # Calculate course start date based on course date
    course_start_datetime = datetime(course_date.year, course_date.month, course_date.day, start_hour, start_minute)

    # Calculate course end date based on duration
    duration_minutes = random.choice([60, 90, 120, 150, 180])
    course_end_datetime = course_start_datetime + timedelta(minutes=duration_minutes)

    return course_start_datetime, course_end_datetime
