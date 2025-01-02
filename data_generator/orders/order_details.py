import random
import time

import pyodbc

from data_generator.courses.course_meetings import get_courses_count
from data_generator.orders.orders import get_orders
from data_generator.webinars.webinars import get_webinars_count

possible_services = ["studies", "webinar", "course"]


def fill_order_details(cursor: pyodbc.Cursor):
    clear_order_details(cursor)
    orders = get_orders(cursor)
    studies_limit = get_limits_for_studies(cursor)
    studies_meetups = {i: get_studies_meetups(cursor, i) for i in range(1, len(studies_limit) + 1)}
    courses_students = {i: 0 for i in range(get_courses_count(cursor) + 1)}
    studies_students = {i: 0 for i in range(len(studies_limit) + 1)}
    order_detail_id = 1
    start_time = time.time()
    for order in orders:
        order_id = order[0]
        service = random.choice(possible_services)
        if order_id % 10 == 0:
            print(f"---Genereting Order Details--- Detail for order: {order_id}/{len(orders)}, OrderDetails created {order_detail_id}, Progress: {round(order_id / len(orders) * 100, 2)}%, time elapsed: {round(time.time() - start_time, 2)}s")
        if service == "studies":
            random_studies = random.randint(1, len(studies_limit))
            while studies_students[random_studies] >= studies_limit[random_studies - 1]: # studies limit is reached
                random_studies = random.randint(1, len(studies_limit))
            insert_studies_order(cursor, order_detail_id, order_id, random_studies)
            order_detail_id += 1
            studies_students[random_studies] += 1
            for meetup in studies_meetups[random_studies]:
                insert_study_meetup(cursor, order_detail_id, order_id, meetup)
                order_detail_id += 1
        elif service == "webinar":
            random_webinar = random.randint(1, get_webinars_count(cursor))
            insert_webinar_order(cursor, order_detail_id, order_id, random_webinar)
            order_detail_id += 1
        elif service == "course":
            random_course = random.randint(1, get_courses_count(cursor))
            while courses_students[random_course] >= get_max_students_for_course(cursor, random_course):
                random_course = random.randint(1, get_courses_count(cursor))
            courses_students[random_course] += 1
            insert_course_order(cursor, order_detail_id, order_id, random_course)
            order_detail_id += 1


def insert_studies_order(cursor: pyodbc.Cursor, order_detail_id: int, order_id: int, studies_id:  int):
    sql_query = f"insert into dbo.OrderDetails (OrderDetailID, OrderID, ServiceTypeID, ServiceId) values (?,?, ?, ?)"
    cursor.execute(sql_query, (order_detail_id, order_id, 1, studies_id))

def insert_study_meetup(cursor: pyodbc.Cursor, order_detail_id: int, order_id: int, study_meetup: int):
    sql_query = f"""insert into dbo.OrderDetails (OrderDetailID, OrderID, ServiceTypeID, ServiceId) values (?,?, ?, ?)"""
    cursor.execute(sql_query, (order_detail_id, order_id, 2, study_meetup))
def insert_webinar_order(cursor: pyodbc.Cursor, order_detail_id: int, order_id: int, webinar_id: int):
    sql_query = f"insert into dbo.OrderDetails (OrderDetailID, OrderID, ServiceTypeID, ServiceId) values (?,?, ?, ?)"
    cursor.execute(sql_query, (order_detail_id, order_id, 4, webinar_id))


def insert_course_order(cursor: pyodbc.Cursor, order_detail_id: int, order_id: int, course_id: int):
    sql_query = f"insert into dbo.OrderDetails (OrderDetailID, OrderID, ServiceTypeID, ServiceId) values (?,?, ?, ?)"
    cursor.execute(sql_query, (order_detail_id, order_id, 5, course_id))


def clear_order_details(cursor: pyodbc.Cursor):
    cursor.execute("delete from dbo.OrderDetails")

def get_stationary_courses(cursor):
    sql_query = "select CourseID from dbo.StationaryCourse"
    cursor.execute(sql_query)
    courses = cursor.fetchall()
    return courses

def get_max_students_for_course(cursor, course_id):
    sql_query = f"""select min(LimitOfParticipants) from CoursesMeetings
                    where CourseID = {course_id} """
    cursor.execute(sql_query)
    res = cursor.fetchval()
    return res if res is not None else float('inf')

def get_studies_meetups(cursor, study_id):
    sql_query = f"""select StudyMeetupID from StudyMeetups sm
                    inner join StudySemesters  ss on ss.StudySemesterID = sm.StudySemesterID
                    where StudyID = {study_id}"""
    cursor.execute(sql_query)
    meetups = cursor.fetchall()
    return [meetup[0] for meetup in meetups]

def get_limits_for_studies(cursor):
    sql_query = "select StudyID, LimitOfStudents from dbo.Studies"
    cursor.execute(sql_query)
    limits = cursor.fetchall()
    return [limits[i][1] for i in range(len(limits))]
