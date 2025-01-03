import random
import pyodbc

PROBABILITY_OF_SKIP = 0.08

def fill_webinar_attendance(cursor: pyodbc.Cursor):
    clear_webinar_attendance(cursor)

    user_list = get_webinar_user_list(cursor)
    unique_user_list = list({frozenset(item.items()): item for item in user_list}.values())
    insertions = 0
    cnt = 0

    for user in unique_user_list:
        if cnt % 100 == 0:
            print(f"---Generating Webinar Attendance--- Users processed: {cnt}/{len(user_list)}, Insertions: {insertions}, Progress: {round(cnt/ len(user_list) * 100, 2)}%")
        if random.random() > PROBABILITY_OF_SKIP:
            insert_webinar_attendance(cursor, user["UserID"], user["WebinarID"])
            insertions += 1
        cnt += 1

def insert_webinar_attendance(cursor: pyodbc.Cursor, user_id: int, webinar_id: int):
    cursor.execute("insert into dbo.WebinarsAttendance (WebinarID, UserID) values (?, ?)", (webinar_id,user_id))

def clear_webinar_attendance(cursor: pyodbc.Cursor):
    cursor.execute("delete from dbo.WebinarsAttendance")

def get_webinar_user_list(cursor: pyodbc.Cursor):
    cursor.execute("""select O.UserID, ServiceID from Payments
inner join dbo.OrderDetails OD on Payments.OrderDetailID = OD.OrderDetailID
inner join dbo.ServiceTypes ST on OD.ServiceTypeID = ST.ServiceTypeID
inner join dbo.Orders O on OD.OrderID = O.OrderID
inner join dbo.Users U on O.UserID = U.UserID
inner join dbo.Webinars W on W.WebinarID = ServiceID
where ServiceTypeName = 'Webinar' and W.Date < GETDATE()""")
    user_list = cursor.fetchall()
    return [{"UserID": user[0], "WebinarID": user[1]} for user in user_list]
