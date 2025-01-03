import pyodbc
import random
from datetime import datetime, timedelta

def fill_study_meetups(cursor: pyodbc.Cursor):
    clear_study_meetups(cursor)

    MEETUPS_PER_STUDY_SEMESTER = 10

    study_semester_ids_semesters = get_study_semester_ids(cursor)

    primary_key = 0

    for study_semester_id, semester_no in study_semester_ids_semesters:
        
        start_year_of_study = random.randint(2015,datetime.now().year)
        start_dates = generate_random_dates_for_semester(semester_no, start_year_of_study, MEETUPS_PER_STUDY_SEMESTER)

        for start_date in start_dates:

            start_date = start_date + timedelta(hours=random.randint(9,15), minutes=random.randrange(0,45,15), seconds=0)
            end_date = start_date + timedelta(hours=random.randint(4,7))

            price = float(random.randint(40,200))
            extra_price = float(random.randint(10,50))

            sql_command = f"""
            INSERT into dbo.StudyMeetups (StudyMeetupID, StudySemesterID, StartDate, EndDate, Price, ExtraPrice)
            VALUES (?, ?, ?, ?, ?, ?);
            """
            cursor.execute(sql_command, (primary_key + 1, study_semester_id, start_date, end_date, price, extra_price))
            primary_key += 1

def clear_study_meetups(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.StudyMeetups;"
    cursor.execute(sql_clear)

def get_study_semester_ids(cursor: pyodbc.Cursor):
    sql_query = f"""
    SELECT StudySemesterID, SemesterNo FROM StudySemesters
    """
    cursor.execute(sql_query)
    rows = cursor.fetchall()
    return [row for row in rows]

def generate_random_dates_for_semester(semester_no, study_start_year, n):
    years_to_add = semester_no // 3
    months_to_add = (4 * (semester_no - 1))

    days_for_month = 28
    if (1 + months_to_add) % 13 != 2 and (4 + months_to_add) % 13 != 2: days_for_month += 2

    start_month = (1 + months_to_add) % 13
    if start_month == 0: start_month = 1

    end_month = (4 + months_to_add) % 13
    if end_month == 0: end_month = 1

    next_year = 0
    if (4 + months_to_add) > 12: next_year = 1

    beg_ranges = datetime(study_start_year + years_to_add, start_month, 1)
    end_ranges = datetime(study_start_year + years_to_add + next_year, end_month, days_for_month)

    def generate_unique_random_dates(start_date, end_date, n):
        delta = end_date - start_date
        all_dates = [start_date + timedelta(days=i) for i in range(delta.days + 1)]
        
        if n > len(all_dates):
            raise ValueError("n is larger than the number of unique dates available in the range.")

        random_dates = random.sample(all_dates, n)
        return [date for date in random_dates]
    
    return generate_unique_random_dates(beg_ranges, end_ranges, n)