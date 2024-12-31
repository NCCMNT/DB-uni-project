import pyodbc
import random
from datetime import datetime, timedelta

def fill_study_meetings(cursor: pyodbc.Cursor):
    clear_study_meetings(cursor)

    MAX_ADDITIONAL_PARTICIPANTS = 40

    meetup_info = get_study_meetup_info(cursor)
    lecturers_ids = get_lecturers_ids(cursor)
    translator_languages_ids = get_translator_languages_ids(cursor)

    primary_key = 0

    for subject_id, study_meetup_id, start_date, end_date, study_limit in meetup_info:

        additional_spots = random.randint(0,MAX_ADDITIONAL_PARTICIPANTS)

        time_difference = end_date - start_date
        hours = time_difference.seconds // 3600

        for hour in range(hours):

            start_date = start_date + timedelta(hours=hour)
            end_date = start_date + timedelta(minutes=45)

            limit = study_limit + additional_spots

            lecturer_id = random.choice(lecturers_ids)

            translator_language_id = get_random_translator_language_with_null_option(translator_languages_ids)

            sql_command = f"""
            INSERT into dbo.StudiesMeetings (MeetingID, StudyMeetupID, SubjectID, StartDate, EndDate, LecturerID, LimitOfMeetingParticipants, TranslatorLanguageID)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?);
            """
            cursor.execute(sql_command, (primary_key, study_meetup_id, subject_id, start_date, end_date, lecturer_id, limit, translator_language_id))
            primary_key += 1

def clear_study_meetings(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.StudiesMeetings;"
    cursor.execute(sql_clear)

def get_study_meetup_info(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT s.SubjectID, sm.StudyMeetupID, sm.StartDate, sm.EndDate, stud.LimitOfStudents FROM Subjects AS s
    INNER JOIN StudiesSchedule AS ss on s.SubjectID = ss.SubjectID
    INNER JOIN StudySemesters AS ssem on ssem.StudySemesterID = ss.StudySemesterID
    INNER JOIN Studies AS stud on stud.StudyID = ssem.StudyID
    INNER JOIN StudyMeetups AS sm on sm.StudySemesterID = ssem.StudySemesterID
    ORDER BY 1
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row for row in rows]

def get_lecturers_ids(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT e.EmployeeID FROM Employees AS e
    INNER JOIN EmployeeRoles AS er ON er.EmployeeID = e.EmployeeID
    INNER JOIN Roles AS r ON r.RoleID = er.RoleID
    WHERE r.RoleName = 'Lecturer'
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row[0] for row in rows]

def get_translator_languages_ids(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT TranslatorLanguageID FROM Translators
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row[0] for row in rows]

def get_random_translator_language_with_null_option(translator_language_ids):
    choice = random.randint(0,100)
    if choice <= 20: return random.choice(translator_language_ids)
    else: return None