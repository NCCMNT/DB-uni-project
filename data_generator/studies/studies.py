import pyodbc
import os
import json
import random

def fill_studies(cursor: pyodbc.Cursor):
    clear_studies(cursor)

    dir = os.path.dirname(os.path.abspath(__file__))
    file_dir = 'data'
    file = 'studies.json'

    with open(os.path.join(dir,file_dir,file), 'r') as f:
        data = json.load(f)

    study_names = data['studyNames']
    fee_prices = data['fees']

    study_coordinators_ids = get_study_coordinators_ids(cursor)

    for primary_key, study_name in enumerate(study_names):
        
        fee_price = random.choice(fee_prices)
        study_coordinator = random.choice(study_coordinators_ids)
        limit_of_students = random.randint(50,200)

        sql_command = f"""
        INSERT into dbo.Studies (StudyID, StudyName, FeePrice, StudyCoordinatorID, LimitOfStudents)
        VALUES (?, ?, ?, ?, ?);
        """
        cursor.execute(sql_command, (primary_key + 1, study_name, fee_price, study_coordinator, limit_of_students))

def clear_studies(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Studies;"
    cursor.execute(sql_clear)

def get_study_coordinators_ids(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT e.EmployeeID FROM Employees AS e
    INNER JOIN EmployeeRoles AS er ON er.EmployeeID = e.EmployeeID
    INNER JOIN Roles AS r on r.RoleID = er.RoleID
    WHERE r.RoleName = 'Study Coordinator'
    ORDER BY 1
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row[0] for row in rows]