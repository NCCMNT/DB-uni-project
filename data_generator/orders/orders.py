import datetime
import random

import pyodbc

from data_generator.people.users import get_users_count


def fill_orders(cursor: pyodbc.Cursor):
    clear_orders(cursor)
    users_count = get_users_count(cursor)
    CHANCE_FOR_ORDER = 0.6 # chance for a user to have an order
    ORDERS_LIMIT = 5 # max number of orders per user
    orders_count = 1
    orders = []
    for user_id in range(1, users_count + 1):
        u_ord = 1
        if user_id % 100 == 0:
            print(f"---Genereting Orders--- Users processed: {user_id}/{users_count}, Orders created: {orders_count}, Progress: {round(user_id / users_count * 100, 2)}%")
        while random.random() < CHANCE_FOR_ORDER and u_ord <= ORDERS_LIMIT:
            order_date = datetime.datetime(
                year=random.randint(2016, 2024),
                month=random.randint(1, 12),
                day=random.randint(1, 28),
                hour=random.randint(0, 23),
            )
            insert_order(cursor, orders_count, user_id, order_date)
            orders_count += 1
            u_ord += 1


def insert_order(cursor: pyodbc.Cursor, order_id: int, user_id: int, order_date: datetime):
    sql_query = f"insert into dbo.Orders (OrderID, UserID, OrderDate) values (?, ?, ?)"

    cursor.execute(sql_query, (order_id, user_id, order_date))


def clear_orders(cursor: pyodbc.Cursor):
    cursor.execute("delete from dbo.Orders")


def get_orders_count(cursor: pyodbc.Cursor):
    cursor.execute("select count(*) from dbo.Orders")
    return cursor.fetchval()

def get_orders(cursor: pyodbc.Cursor):
    cursor.execute("select * from dbo.Orders")
    return cursor.fetchall()
