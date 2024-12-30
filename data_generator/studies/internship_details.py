import pyodbc
import os
import json
import random

def fill_internship_details(cursor: pyodbc.Cursor):
    clear_internship_details(cursor)

    dir = os.path.dirname(os.path.abspath(__file__))
    file_dir = 'data'
    file = 'companies.json'

    with open(os.path.join(dir,file_dir,file), 'r') as f:
        data = json.load(f)

    company_names = data['companyNames']

    internships_students = get_internship_student_pairs(cursor)

    for internship_id, student_id in internships_students:
        
        company_name = random.choice(company_names)

        sql_command = f"""
        INSERT into dbo.InternshipDetails (InternshipID, StudentID, CompanyName, Pass)
        VALUES (?, ?, ?, ?);
        """
        cursor.execute(sql_command, (internship_id, student_id, company_name, random.randint(0,1)))

def clear_internship_details(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.InternshipDetails;"
    cursor.execute(sql_clear)

def get_internship_student_pairs(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT i.InternshipID,  s.StudentID FROM Students AS s
    INNER JOIN Studies AS st ON s.StudyID = st.StudyID
    INNER JOIN Internships AS i on i.StudyID = s.StudyID
    ORDER BY 1
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [(row[0],row[1]) for row in rows]