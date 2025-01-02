import pyodbc

def fill_service_types(cursor: pyodbc.Cursor):
    clear_service_types(cursor)

    service_types = ["Studies", "Studies Meetup", "Studies Meeting", "Webinar", "Course"]

    for pk, service_type in enumerate(service_types):
        sql_command = f"""
        INSERT into dbo.ServiceTypes (ServiceTypeID, ServiceTypeName)
        VALUES (?, ?);
        """
        cursor.execute(sql_command, (pk + 1, service_type))

def clear_service_types(cursor: pyodbc.Cursor):
    cursor.execute("delete from dbo.ServiceTypes")