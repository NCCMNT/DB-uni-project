import datetime
import random

import pyodbc

p_id = 1

PROBABILITY_OF_NOT_PAYING_TOTAL_PRICE = 0.02
PROBABILITY_OF_NOT_FINISHING_STUDIES = 0.02
MAX_DAYS_BEFORE_START = 300


def fill_payments(cursor: pyodbc.Cursor):
    global p_id
    clear_payments(cursor)
    fill_courses_payments(cursor)
    fill_webinar_payments(cursor)
    fill_studies_payments(cursor)


def fill_studies_payments(cursor: pyodbc.Cursor):
    global p_id
    num_of_orders = len(get_studies_orders(cursor))
    orders_with_studies = convert_studies(get_studies_orders(cursor))
    studies_start_dates = get_studies_start_date(cursor)
    cnt = 0
    for key in orders_with_studies.keys():
        order_id = orders_with_studies[key][0]["OrderID"]
        new_order_date = generate_random_date(studies_start_dates[orders_with_studies[key][0]["ServiceID"]])
        payment_date = new_order_date + datetime.timedelta(minutes=random.randint(1, 30))
        if cnt % 10 == 0:
            print(f"---Generating Studies Payments--- Orders processed: {cnt}/{num_of_orders}, Payments created: {p_id - 1}, Progress: {round(cnt / num_of_orders * 100, 2)}%")
        if random.random() > PROBABILITY_OF_NOT_FINISHING_STUDIES:
            for order in orders_with_studies[key]:
                insert_payment(cursor, p_id, order["OrderDetailID"], payment_date, order["Price"])
                p_id += 1
                cnt += 1
        else:
            meetups_in_order = len(orders_with_studies[key])
            meetups_paid = random.randint(1, meetups_in_order)
            for i in range(meetups_paid):
                order = orders_with_studies[key][i]
                insert_payment(cursor, p_id, order["OrderDetailID"], payment_date, order["Price"])
                p_id += 1
                cnt += 1
        fix_order_date(cursor, order_id , new_order_date)


def fill_courses_payments(cursor: pyodbc.Cursor):
    global p_id
    courses = get_courses_orders(cursor)
    courses_start_dates = get_courses_start_dates(cursor)
    cnt = 0
    for course in courses:
        start_date = courses_start_dates[course["CourseID"]]
        new_order_date = generate_random_date(start_date)
        payment_date = new_order_date + datetime.timedelta(minutes=random.randint(1, 30))
        if cnt % 100 == 0:
            print(
                f"---Generating Course Payments--- Courses processed: {cnt}/{len(courses)}, Payments created: {p_id - 1}, Progress: {round(cnt / len(courses) * 100, 2)}%")
        insert_payment(cursor, p_id, course["OrderDetailID"], payment_date, course["FeePrice"])
        p_id += 1
        if random.random() > PROBABILITY_OF_NOT_PAYING_TOTAL_PRICE:
            total_payment_date = payment_date + datetime.timedelta(days=random.randint(0, 15),
                                                                   minutes=random.randint(0, 30))
            if total_payment_date < start_date:
                insert_payment(cursor, p_id, course["OrderDetailID"], total_payment_date,
                               course["TotalPrice"] - course["FeePrice"])
                p_id += 1
        cnt += 1
        fix_order_date(cursor, course["OrderID"], new_order_date)


def fill_webinar_payments(cursor: pyodbc.Cursor):
    global p_id
    webinars = get_webinar_orders(cursor)
    cnt = 0
    for webinar in webinars:
        if cnt % 100 == 0:
            print(
                f"---Generating Webinar Payments--- Webinars processed: {cnt}/{len(webinars)}, Payments created: {p_id - 1}, Progress: {round(cnt / len(webinars) * 100, 2)}%")
        new_order_date = generate_random_date(webinar["Date"])
        insert_payment(cursor, p_id, webinar["OrderDetailID"],
                       new_order_date + datetime.timedelta(minutes=random.randint(1, 30)), webinar["Price"])
        p_id += 1
        cnt += 1
        fix_order_date(cursor, webinar["OrderID"], new_order_date)


def insert_payment(cursor: pyodbc.Cursor, payment_id, order_detail_id, payment_date, payment_amount):
    sql_query = f"""insert into dbo.Payments (PaymentID, OrderDetailID, PayDate, Amount) values (?, ?, ?, ?)"""
    cursor.execute(sql_query, (payment_id, order_detail_id, payment_date, payment_amount))


def clear_payments(cursor: pyodbc.Cursor):
    cursor.execute("delete from dbo.Payments")

def get_studies_start_date(cursor):
    sql_query = f"""select S2.StudyID,
       (select min(StartDate)
        from StudyMeetups SM
                 inner join StudySemesters SS on SS.StudySemesterID = SM.StudySemesterID
                 where SS.StudyID = S2.StudyID
        )
from Studies S2"""
    res = cursor.execute(sql_query)
    return {study[0]: study[1] for study in res}

def get_studies_orders(cursor):
    sql_query = f"""select OrderDetailID, OrderID, ServiceTypeID, StudyID as ServiceID, FeePrice as ToPay from OrderDetails OD
                    inner join Studies on StudyID = OD.ServiceID
                    where ServiceTypeID = 1
                    union
                    select OrderDetailID, OrderID, ServiceTypeID, StudyMeetupID, Price from OrderDetails OD
                    inner join StudyMeetups SM on SM.StudyMeetupID = ServiceID
                    where ServiceTypeID = 2
                    order by 1"""
    res = cursor.execute(sql_query)
    return [{
        "OrderDetailID": order[0],
        "OrderID": order[1],
        "ServiceTypeID": order[2],
        "ServiceID": order[3],
        "Price": order[4]
    } for order in res]


def get_study_meetups_info(cursor):
    cursor.execute("""select StudyMeetupID, Price, ExtraPrice, StartDate from Studies S
                        inner join StudySemesters SS on SS.StudyID = S.StudyID
                        inner join StudyMeetups SM on SM.StudySemesterID = SS.StudySemesterID""")

    return [{
        "MeetupID": study[0],
        "Price": study[1],
        "ExtraPrice": study[2],
        "StartDate": study[3]
    } for study in cursor.fetchall()]


def convert_studies(raw_studies):
    orders = {}
    for raw_study in raw_studies:
        orders[raw_study["OrderID"]] = []
    for raw_study in raw_studies:
        orders[raw_study["OrderID"]].append(raw_study)
    return orders


def get_courses_orders(cursor: pyodbc.Cursor):
    cursor.execute(f"""select OrderDetailID, O.OrderID, C.CourseID, FeePrice, TotalPrice
from dbo.OrderDetails OD
         inner join dbo.Orders O on OD.OrderID = O.OrderID
         inner join dbo.Courses C on C.CourseID = OD.ServiceID
where ServiceTypeID = 5""")
    courses = [{
        "OrderDetailID": course[0],
        "OrderID": course[1],
        "CourseID": course[2],
        "FeePrice": course[3],
        "TotalPrice": course[4]
    } for course in cursor.fetchall()]
    return courses


def get_courses_start_dates(cursor: pyodbc.Cursor):
    sql_query = f"""select CourseID, min(StartDate) from CoursesMeetings group by CourseID"""
    res = cursor.execute(sql_query)
    return {course[0]: course[1] for course in res}


def get_webinar_orders(cursor: pyodbc.Cursor):
    cursor.execute(f"""select OrderDetailID,O.OrderID, Price, Date from Webinars W
                        inner join OrderDetails OD on OD.ServiceTypeID = 4 and OD.ServiceID = W.WebinarID
                        inner join Orders O on O.OrderID = OD.OrderID""")
    webinars = [{
        "OrderDetailID": webinar[0],
        "OrderID": webinar[1],
        "Price": webinar[2],
        "Date": webinar[3]
    } for webinar in cursor.fetchall()]
    return webinars


def fix_order_date(cursor, order_id, order_date):
    cursor.execute("update dbo.Orders set OrderDate = ? where OrderID = ?", (order_date, order_id))


def generate_random_date(start_date: datetime) -> datetime:
    start_date = min(start_date, datetime.datetime.now())
    return start_date - datetime.timedelta(days=random.randint(0, MAX_DAYS_BEFORE_START),
                                           minutes=random.randint(0, 30)) - datetime.timedelta(minutes=40)


def get_payments_count(cursor: pyodbc.Cursor):
    cursor.execute("select count(*) from dbo.Payments")
    return cursor.fetchval() + 1
