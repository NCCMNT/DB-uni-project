import datetime
import math
import random
from random import shuffle

import pyodbc

STUDY_MEETING_POSTPONEMENTS = 0.01
COURSES_POSTPONEMENTS = 0.03
PROBABILITY_OF_PAYING_IN_DUE_DATE = 0.8

def fill_postponements(cursor: pyodbc.Cursor):
    postponements = 1
    clear_postponements(cursor)
    courses_orders = get_courses_orders(cursor)
    studies_orders = get_study_meetings_orders(cursor)
    shuffle(courses_orders)
    shuffle(studies_orders)
    orders_to_change = courses_orders[:math.floor(len(courses_orders) * COURSES_POSTPONEMENTS)] + studies_orders[:math.floor(len(studies_orders) * STUDY_MEETING_POSTPONEMENTS)]
    for order in orders_to_change:
        if postponements % 100 == 0:
            print(f"---Generating Postponements--- Orders processed: {postponements}/{len(orders_to_change)}, Postponements created: {postponements}, Progress: {round(postponements / len(orders_to_change) * 100, 2)}%")
        due_to_date = order["StartDate"] + datetime.timedelta(days=7)
        if random.random() < PROBABILITY_OF_PAYING_IN_DUE_DATE: # pay in due date
            payment_date = due_to_date - datetime.timedelta(days=random.randint(0, 6), minutes=random.randint(0, 59))
        else: # pay after due date
            payment_date = due_to_date + datetime.timedelta(days=random.randint(1, 30), minutes=random.randint(0, 59))
        insert_postponement(cursor, postponements, order["UserID"], order["ServiceTypeID"], order["ServiceID"], due_to_date)
        change_payment_date(cursor, order["PaymentID"], payment_date)
        postponements += 1




def change_payment_date(cursor: pyodbc.Cursor, payment_id: int, new_date: datetime):
    cursor.execute("update dbo.Payments set PayDate = ? where PaymentID = ?", (new_date, payment_id))

def insert_postponement(cursor: pyodbc.Cursor, post_id, user_id, service_type_id, service_id, due_date):
    cursor.execute("insert into dbo.HeadTeacherPaymentPostponements (PostponementID, UserID, ServiceTypeID, ServiceID, DueDate) values (?, ?, ?, ?, ?)", (post_id, user_id, service_type_id, service_id, due_date))

def clear_postponements(cursor: pyodbc.Cursor):
    cursor.execute("delete from dbo.HeadTeacherPaymentPostponements")


def get_courses_orders(cursor: pyodbc.Cursor):
    cursor.execute("""select PaymentID, ServiceTypeID, ServiceID, OrderDate, PayDate, (select min(StartDate) from CoursesMeetings where C.CourseID = CoursesMeetings.CourseID) as [StartDate],UserID from Payments
                        inner join dbo.OrderDetails OD on Payments.OrderDetailID = OD.OrderDetailID
                        inner join dbo.Orders O on OD.OrderID = O.OrderID
                        inner join dbo.Courses C on C.CourseID = OD.ServiceID
                        where ServiceTypeID = 5""")
    return [{
        "PaymentID": course[0],
        "ServiceTypeID": course[1],
        "ServiceID": course[2],
        "OrderDate": course[3],
        "PayDate": course[4],
        "StartDate": course[5],
        "UserID": course[6]
         } for course in cursor.fetchall()]

def get_study_meetings_orders(cursor):
    cursor.execute("""select PaymentID, ServiceTypeID, ServiceID, OrderDate, PayDate, StartDate,UserID from Payments
                        inner join dbo.OrderDetails OD on Payments.OrderDetailID = OD.OrderDetailID
                        inner join dbo.Orders O on OD.OrderID = O.OrderID
                        inner join dbo.StudyMeetups on ServiceID = StudyMeetupID
                        where ServiceTypeID = 2""")
    return [{
        "PaymentID": course[0],
        "ServiceTypeID": course[1],
        "ServiceID": course[2],
        "OrderDate": course[3],
        "PayDate": course[4],
        "StartDate": course[5],
        "UserID": course[6]
         } for course in cursor.fetchall()]
