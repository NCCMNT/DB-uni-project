import pyodbc

def fill_roles(cursor: pyodbc.Cursor):
    clear_roles(cursor)

    roles = ["Head Teacher", "System Administrator", "Course Coordinator", "Course Instructor",
             "Webinar Presenter", "Study Coordinator", "Lecturer", "Translator", "Administrative Employee"]

    for primary_key, role in enumerate(roles):
        sql_command = f"""
        INSERT into dbo.Roles (RoleID, RoleName)
        VALUES ({primary_key + 1}, '{role}');
        """
        cursor.execute(sql_command)

def clear_roles(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Roles;"
    cursor.execute(sql_clear)
