import json
import random
import pyodbc
import os
import pandas

def fill_courses(cursor: pyodbc.Cursor):
    clear_courses(cursor)

    current_path = os.path.abspath(__file__)
    current_dir = os.path.dirname(current_path)
    data_dir = "data"
    file_name = "courses.json"

    with open(os.path.join(current_dir, data_dir, file_name), 'r') as file:
        data = json.load(file)

    courses = data["courses"]

    course_coordinators = get_course_coordinators(cursor)

    translators_df = get_translators(cursor)
    translator_language_id_list = list(translators_df["TranslatorLanguageID"])
    course_coordinators_id_list = list(course_coordinators["EmployeeID"])
    total_prices_list = [20, 30, 40, 50, 60, 70, 80, 90, 100]
    procentages = [0.1, 0.2, 0.3, 0.4, 0.5]

    for course_id, course in enumerate(courses):
        total_price = random.choice(total_prices_list)
        fee_price = total_price * random.choice(procentages)
        course_coordinator_id = random.choice(course_coordinators_id_list)
        translator_language_id = random.choice(translator_language_id_list)
        translator_employee_id = list(translators_df[translators_df["TranslatorLanguageID"] == translator_language_id]["EmployeeID"])[0]

        if random.randint(1, 10) <= 5 or course_coordinator_id == translator_employee_id:
            translator_language_id = "NULL"

        sql_command = f"""
        INSERT INTO dbo.Courses (CourseID, CourseName, FeePrice, TotalPrice, TranslatorLanguageID, CourseCoordinatorID)
        VALUES ({course_id + 1}, '{course}', {fee_price}, {total_price}, {translator_language_id}, {course_coordinator_id});
        """

        cursor.execute(sql_command)

def clear_courses(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Courses;"
    cursor.execute(sql_clear)

def get_course_coordinators(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT
        Employees.EmployeeID
    FROM dbo.Employees
    INNER JOIN dbo.EmployeeRoles
        ON Employees.EmployeeID = EmployeeRoles.EmployeeID
    INNER JOIN dbo.Roles
        ON Roles.RoleID = EmployeeRoles.RoleID
    WHERE RoleName = 'Course Coordinator'
    """

    cursor.execute(sql_query)

    df = pandas.DataFrame.from_records(cursor.fetchall(), columns=[col[0] for col in cursor.description])

    return df

def get_translators(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT
        TranslatorLanguageID,
        EmployeeID
    FROM Translators;
    """

    cursor.execute(sql_query)

    df = pandas.DataFrame.from_records(cursor.fetchall(), columns=[col[0] for col in cursor.description])

    return df
