import random

import pyodbc


def fill_classrooms(cursor: pyodbc.Cursor):
    NO_CLASSROOMS_TO_GENERATE = 163
    MAX_ROOM_NO = 300
    ROOM_CAPACITY = (20, 200)
    clear_classrooms(cursor)
    for i in range(1, NO_CLASSROOMS_TO_GENERATE + 1):
        add_id = random.randint(1, get_max_adr_value(cursor))
        insert_classroom(cursor, i, add_id, random.randint(1, MAX_ROOM_NO),
                         5 * random.randint(ROOM_CAPACITY[0] // 5, ROOM_CAPACITY[1] // 5))


def get_max_adr_value(cursor: pyodbc.Cursor):
    adr_sql = "select count(*) from dbo.Addresses"
    cursor.execute(adr_sql)
    return cursor.fetchval()


def insert_classroom(cursor: pyodbc.Cursor, id: int, address_id: int, room_no: int, capacity: int):
    sql_insert = f"insert into dbo.Classrooms (ClassroomID, AddressID, RoomNo, Capacity) values ({str(id)}, {str(address_id)}, {str(room_no)}, {str(capacity)})"
    cursor.execute(sql_insert)


def clear_classrooms(cursor: pyodbc.Cursor):
    cursor.execute("delete from dbo.Classrooms")
