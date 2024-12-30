import pyodbc
import os
import json

def fill_subjects(cursor: pyodbc.Cursor):
    clear_subjects(cursor)

    dir = os.path.dirname(os.path.abspath(__file__))
    file_dir = 'data'
    file = 'subjects.json'

    with open(os.path.join(dir,file_dir,file), 'r') as f:
        data = json.load(f)

    subject_desc_dict = {}

    for field, subjects in data.items():
        for subject in subjects:
            subject_desc_dict[subject['subject']] = subject['description']

    for primary_key, (subject_name, description) in enumerate(subject_desc_dict.items()):
        sql_command = f"""
        INSERT into dbo.Subjects (SubjectID, SubjectName, Description)
        VALUES (?, ?, ?);
        """
        cursor.execute(sql_command, (primary_key + 1, subject_name, description))

def clear_subjects(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Subjects;"
    cursor.execute(sql_clear)