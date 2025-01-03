import pyodbc
import random
import os
import json

def fill_studies_schedule(cursor: pyodbc.Cursor):
    clear_studies_schedule(cursor)

    dir = os.path.dirname(os.path.abspath(__file__))
    file_dir = 'data'
    file = 'subjects.json'

    with open(os.path.join(dir,file_dir,file), 'r') as f:
        data = json.load(f)
    
    study_subjects_dict = {}
    subjects_dict = {}
    subject_ids_names = get_subject_ids_names_pair(cursor)
    study_names_study_semesters = get_study_name_study_semester_pairs(cursor)

    for study, subjects in data.items():
        study_subjects_dict[study] = [subject['subject'] for subject in subjects]

    for subject_id, subject_name in subject_ids_names:
        subjects_dict[subject_name] = subject_id

    for study_name, study_semester_id in study_names_study_semesters:

        subject_name = str(random.choice(study_subjects_dict[study_name])).strip()

        if subject_name not in subjects_dict:
            print(f"Subject name '{subject_name}' not found in subjects_dict")
            continue
        subject_id = subjects_dict[subject_name]

        sql_command = f"""
        INSERT into dbo.StudiesSchedule (StudySemesterID, SubjectID)
        VALUES (?, ?);
        """

        cursor.execute(sql_command, (study_semester_id, subject_id))

def clear_studies_schedule(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.StudiesSchedule;"
    cursor.execute(sql_clear)

def get_study_name_study_semester_pairs(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT s.StudyName, ss.StudySemesterID FROM StudySemesters AS ss
    INNER JOIN Studies AS s on s.StudyID = ss.StudyID
    ORDER BY 2
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [(row[0], row[1]) for row in rows]

def get_subject_ids_names_pair(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT SubjectID, SubjectName FROM Subjects
    ORDER BY 1
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row for row in rows]