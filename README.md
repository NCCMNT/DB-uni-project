# Database Systems 2024/2025 – Mini Project

## Requirements

### **Introduction**
You have been tasked with designing a database system for a company that offers various types of courses and training programs. Initially, the services were provided exclusively in-person, but due to the COVID-19 pandemic, they have been digitized to varying degrees. Currently, the service delivery model is hybrid but inconsistent across different services. The offered services are categorized into:

#### **1. Webinars**
- Conducted live on one of the popular cloud platforms and then recorded and made available to participants for 30 days.
- The database system does not store binary data – recordings are stored externally.
- Each webinar can be either free or paid. Paid webinars require purchasing access (also for 30 days). Free webinars are publicly accessible. All webinars are stored indefinitely (unless deleted by an administrator).
- A user account is required to access a webinar. For paid webinars, payment confirmation is also necessary.

#### **2. Courses**
Short educational programs, usually lasting a few days, all of which are paid. Completing a course requires passing at least 80% of the modules. Modules can be:
- **In-person** – conducted synchronously, assigned to a physical classroom, and attendance-based.
- **Online synchronous** – conducted live on a webinar platform, requiring participation. Like webinars, they are recorded and stored externally. Completion is based on attendance.
- **Online asynchronous** – completion is based on watching a provided recording (automatic verification).
- **Hybrid** – combines online and in-person approaches (e.g., two recordings and two in-person days).

#### **3. Studies**
Long-term (multi-year) education programs consisting of both online and in-person meetings (same considerations as courses). Additionally, they require completing internships twice a year and conclude with a final exam.
- The study program (syllabus) must be defined before the studies begin and cannot be modified.
- The schedule for each semester must be established in advance but should allow for changes due to unforeseen circumstances – a specific number of sessions per semester (e.g., 7, similar to traditional part-time studies).
- Participation in at least 80% of classes is required. Absences can be made up by attending a similar course or training program.
- Internships last 14 days and require 100% attendance.
- Like courses, meetings can be in-person, online, or hybrid.
- It is possible to enroll in individual study sessions without committing to the full program. The price for external participants differs from that of regular students.

### **Integration with the Payment System**
1. The payment system is provided by an external company – its implementation should be omitted.
2. Participants can add one or more products to their cart, and a payment link is generated for each order. Upon payment completion, the integration sends a status update (successful/unsuccessful).
3. Webinar access is granted only after payment (even right before the session starts).
4. Course participation requires a deposit at registration and full payment at least three days before the course starts. Full payment upfront is also possible.
5. Study participation requires a registration fee (varies per program) and payment for each session at least three days before it starts.
6. Exceptions to rules 3-5 may be granted by the School Director (e.g., deferred payments for regular clients).

### **Reporting**
The system should support the generation of frequently used reports through predefined views. Example reports include:
1. **Financial reports** – revenue summaries for each webinar/course/study program.
2. **Debtor list** – individuals who used services but have not paid.
3. **General report on registered participants for upcoming events** (including event type: in-person or online).
4. **Attendance report for completed events.**
5. **Attendance list for each training session** (with date, first name, last name, and attendance status).
6. **Conflict report** – list of individuals enrolled in at least two upcoming training sessions that have schedule conflicts.

### **Additional Information**
1. All educational formats are conducted by an assigned instructor in a specified language (usually Polish).
2. Some training sessions have live translation into Polish – in such cases, translator details should be provided.
3. Webinars and online courses have no participant limits. Hybrid and in-person courses have varying participant limits.
4. Study programs also have participant limits, which may be lower than the limits for individual sessions (i.e., some sessions allow more external participants, while others do not). However, the total study program enrollment cannot exceed the smallest session limit.
5. Upon completing a course or study program, participants receive a diploma (if they attended). The diploma must be sent via Polish Post to the correspondence address provided during registration.

### **Required Project Elements**
- Proposal of system functions, specifying which users can perform which functions (brief list).
- Database design.
- Database definition.
- Data generation.
- Definition of integrity constraints, including default values, allowed value ranges, uniqueness constraints, nullability constraints, and complex integrity conditions.
- Proposal and definition of views to facilitate data access – views should present relevant information for users and support reporting needs.
- Proposal and definition of data operations (stored procedures, triggers, functions) – stored procedures should handle data entry and configuration changes. Functions should return key quantitative data, while triggers should enforce consistency and client-specific requirements.
- Proposal and definition of indexes.
- Proposal and specification of data access permissions – defining roles and their permissions for operations, views, and procedures.

### **The Final Report Should Include:**
- Description of system functions, specifying what each user can do.
- Database schema (in diagram form) + description of each table (field names, data types, field meanings, and integrity constraints, including table creation code).
- List of views with their creation code and descriptions.
- List of stored procedures, triggers, and functions with their code and explanations.
- Information on generated data.
- Specification of data access permissions – roles and their associated access rights.
- Information on indexed fields.

The project should be implemented using **MS SQL Server**.

## Implementation

First we realized schema of database, then we created *data_generator* to generate example data with **python**, finaly we used **SQL** to properly set up Database Management System and create procedures, functions, views and triggers, roles.

> [!IMPORTANT]
> Full report in polish can be found in <a href="./report/project_report.pdf">project_report.pdf</a>.


### Schema
<hr>

> [!NOTE]
> Schama was made with <a href="https://vertabelo.com">Vertabelo</a> online tool.

<img src="./report/db_schema.png">
