import pyodbc
import random

def fill_employee_roles(cursor: pyodbc.Cursor):
    clear_employee_roles(cursor)

    employees_count = get_table_rows_count(cursor, "Employees")
    roles_count = get_table_rows_count(cursor, "Roles")

    # there should be only one Head Teacher and only one System Administrator
    roles_id_list_except_head_teacher_and_system_administrator = get_roles_id_list_except_head_teacher_and_system_administrator(cursor)

    # make sure there is at least one employee with each role
    for role_id in range(1, roles_count + 1):
        employee_id = (role_id - 1) % employees_count + 1
        add_employee_role(cursor, employee_id, role_id)

    for employee_id in range(role_id + 1, employees_count + 1):
        current_employee_max_roles_cnt = random.randint(1, min(4, len(roles_id_list_except_head_teacher_and_system_administrator)))

        picked_roles = set()

        for _ in range(current_employee_max_roles_cnt):
            picked_roles.add(random.choice(roles_id_list_except_head_teacher_and_system_administrator))

        for role_id in picked_roles:
            add_employee_role(cursor, employee_id, role_id)

def clear_employee_roles(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.EmployeeRoles;"
    cursor.execute(sql_clear)

def get_table_rows_count(cursor: pyodbc.Cursor, table_name: str):
    sql_query = f"SELECT COUNT(*) FROM dbo.{table_name}"
    cursor.execute(sql_query)

    rows = cursor.fetchall()

    return rows[0][0]

def get_roles_id_list_except_head_teacher_and_system_administrator(cursor: pyodbc.Cursor):
    sql_query = f"""
    select
        RoleID
    from Roles
    where RoleName != 'Head Teacher' and RoleName != 'System Administrator'
    """
    cursor.execute(sql_query)

    rows = cursor.fetchall()

    return [row[0] for row in rows]

def add_employee_role(cursor: pyodbc.Cursor, employee_id: int, role_id: int):
        sql_command = f"""
        INSERT INTO dbo.EmployeeRoles (EmployeeID, RoleID)
        VALUES ({employee_id}, {role_id})
        """

        cursor.execute(sql_command)
