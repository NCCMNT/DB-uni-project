import pyodbc
import json
import people.languages
import people.roles
import people.employees
import people.employee_roles
import people.translators
# import people.users
import studies
import studies.final_exams
import studies.grades
import studies.internship_details
import studies.internships
import studies.semesters
import studies.students
import studies.studies
import studies.studies_meetings
import studies.studies_schedule
import studies.study_meetups
import studies.study_semesters
import studies.subjects
import misc
import misc.cities
import misc.countries
import misc.addresses
import webinars
import webinars.webinars
import misc.classrooms
import courses.courses
import courses.course_meetings
import courses.stationary_sync_async_course_meetings
import courses.courses_attendance


path_to_json_file = "database_credentials.json"

with open(path_to_json_file, 'r') as f:
    credentials = json.load(f)

# Database connection parameters
server = credentials["server"]
database = credentials["database"]
username = credentials["username"]
password = credentials["password"]
driver = credentials["driver"]

def main():
    conn = None
    cursor = None

    try:
        # Connect to the database
        conn = pyodbc.connect(
            f'DRIVER={driver};'
            f'SERVER={server};'
            f'DATABASE={database};'
            f'UID={username};'
            f'PWD={password}'
        )

        cursor = conn.cursor()
        print("Successfully connected to the database.")

        misc.countries.fill_countries(cursor)
        misc.cities.fill_cities(cursor)
        misc.addresses.fill_addresses(cursor)
        misc.classrooms.fill_classrooms(cursor)
        people.roles.fill_roles(cursor)
        people.languages.fill_languages(cursor)
        studies.grades.fill_grades(cursor)
        studies.subjects.fill_subjects(cursor)
        people.employees.fill_employees(cursor)
        people.employee_roles.fill_employee_roles(cursor)
        people.translators.fill_translators(cursor)
        people.users.fill_users(cursor)
        webinars.webinars.fill_webinars(cursor)
        courses.courses.fill_courses(cursor)
        courses.course_meetings.fill_course_meetings(cursor)
        courses.stationary_sync_async_course_meetings.fill_stationary_sync_async_course_meetings(cursor)

        # space for filling orders section

        courses.courses_attendance.fill_courses_attandance(cursor)
        # studies.grades.fill_grades(cursor)
        # studies.subjects.fill_subjects(cursor)
        # studies.semesters.fill_semesters(cursor)
        # studies.studies.fill_studies(cursor)
        # studies.study_semesters.fill_study_semesters(cursor)
        # studies.students.fill_students(cursor)
        # studies.internships.fill_internships(cursor)
        # studies.internship_details.fill_internship_details(cursor)
        # studies.studies_schedule.fill_studies_schedule(cursor)
        # studies.final_exams.fill_final_exams(cursor)
        # studies.study_meetups.fill_study_meetups(cursor)
        studies.studies_meetings.fill_study_meetings(cursor)


        conn.commit()
        print("Test data inserted successfully.")

    except pyodbc.Error as e:
        print(f"Database error: {e}")
    finally:
        # Clean up and close connection
        if cursor:
            cursor.close()
        if conn:
            conn.close()
            print("Database connection closed.")

if __name__ == "__main__":
    main()
