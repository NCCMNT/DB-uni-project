-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-12-17 10:41:43.521

-- tables
-- Table: Addresses
CREATE TABLE Addresses (
    AddressID int  NOT NULL,
    CityID int  NOT NULL,
    Street varchar(30)  NOT NULL,
    ZipCode varchar(20)  NOT NULL,
    CONSTRAINT Addresses_pk PRIMARY KEY  (AddressID)
);

-- Table: Cities
CREATE TABLE Cities (
    CityID int  NOT NULL,
    CountryID int  NOT NULL,
    CityName varchar(20)  NOT NULL,
    CONSTRAINT unique_city_country_combination UNIQUE (CountryID, CityName),
    CONSTRAINT Cities_pk PRIMARY KEY  (CityID)
);

-- Table: Classrooms
CREATE TABLE Classrooms (
    ClassroomID int  NOT NULL,
    AddressID int  NOT NULL,
    RoomNo int  NOT NULL,
    Capacity int  NOT NULL,
    CONSTRAINT CapacityGtZero CHECK (Capacity > 0),
    CONSTRAINT Classrooms_pk PRIMARY KEY  (ClassroomID)
);

-- Table: Countries
CREATE TABLE Countries (
    CountryID int  NOT NULL,
    CountryName varchar(20)  NOT NULL,
    CONSTRAINT unique_country_name UNIQUE (CountryName),
    CONSTRAINT Countries_pk PRIMARY KEY  (CountryID)
);

-- Table: Courses
CREATE TABLE Courses (
    CourseID int  NOT NULL,
    CourseName varchar(40)  NOT NULL,
    FeePrice money  NOT NULL,
    TotalPrice money  NOT NULL,
    TranslatorLanguageID int  NULL,
    CourseCoordinatorID int  NOT NULL,
    CONSTRAINT FeePriceLtTotalPrice CHECK (FeePrice < TotalPrice),
    CONSTRAINT FeePriceGtZero CHECK (FeePrice > 0),
    CONSTRAINT Courses_pk PRIMARY KEY  (CourseID)
);

-- Table: CoursesAttendance
CREATE TABLE CoursesAttendance (
    CourseMeetingID int  NOT NULL,
    UserID int  NOT NULL,
    CONSTRAINT CoursesAttendance_pk PRIMARY KEY  (CourseMeetingID,UserID)
);

-- Table: CoursesMeetings
CREATE TABLE CoursesMeetings (
    MeetingID int  NOT NULL,
    CourseID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    CourseInstructorID int  NOT NULL,
    LimitOfParticipants int  NULL,
    CONSTRAINT CoursesMeetings_pk PRIMARY KEY  (MeetingID)
);

-- Table: EmployeeRoles
CREATE TABLE EmployeeRoles (
    EmployeeID int  NOT NULL,
    RoleID int  NOT NULL,
    CONSTRAINT EmployeeRoles_pk PRIMARY KEY  (EmployeeID,RoleID)
);

-- Table: Employees
CREATE TABLE Employees (
    EmployeeID int  NOT NULL,
    Firstname varchar(20)  NOT NULL,
    Lastname varchar(20)  NOT NULL,
    BirthDate date  NOT NULL,
    HireDate date  NOT NULL,
    AddressID int  NOT NULL,
    Phone varchar(15)  NOT NULL,
    CONSTRAINT ValidBirthDate CHECK (BirthDate >= '1900-01-01' and BirthDate <= GETDATE()),
    CONSTRAINT ValidHireDate CHECK (HireDate > BirthDate and HireDate <= GETDATE()),
    CONSTRAINT Employees_pk PRIMARY KEY  (EmployeeID)
);

-- Table: FinalExams
CREATE TABLE FinalExams (
    StudyID int  NOT NULL,
    UserID int  NOT NULL,
    GradeID int  NOT NULL,
    CONSTRAINT FinalExams_pk PRIMARY KEY  (StudyID,UserID)
);

-- Table: Grades
CREATE TABLE Grades (
    GradeID int  NOT NULL,
    GradeValue decimal(1,1)  NOT NULL,
    CONSTRAINT GradeValueGt2Lt5 CHECK (GradeValue between 2 and 5),
    CONSTRAINT Grades_pk PRIMARY KEY  (GradeID)
);

-- Table: HeadTeacherPaymentPostponements
CREATE TABLE HeadTeacherPaymentPostponements (
    PostponementID int  NOT NULL,
    UserID int  NOT NULL,
    ServiceTypeID int  NOT NULL,
    ServiceID int  NOT NULL,
    DueDate datetime  NOT NULL,
    CONSTRAINT HeadTeacherPaymentPostponements_pk PRIMARY KEY  (PostponementID)
);

-- Table: InternshipDetails
CREATE TABLE InternshipDetails (
    InternshipID int  NOT NULL,
    StudentID int  NOT NULL,
    CompanyName varchar(20)  NOT NULL,
    Pass bit  NOT NULL,
    CONSTRAINT InternshipDetails_pk PRIMARY KEY  (InternshipID,StudentID)
);

-- Table: Internships
CREATE TABLE Internships (
    InternshipID int  NOT NULL,
    StudyID int  NOT NULL,
    CycleNo int  NOT NULL,
    CONSTRAINT CheckCycleNo CHECK NOT FOR REPLICATION (CycleNo in (1,2)),
    CONSTRAINT Internships_pk PRIMARY KEY  (InternshipID)
);

-- Table: Languages
CREATE TABLE Languages (
    LanguageID int  NOT NULL,
    LanguageName varchar(30)  NOT NULL,
    CONSTRAINT LanguagesIsUnique UNIQUE (LanguageName),
    CONSTRAINT Languages_pk PRIMARY KEY  (LanguageID)
);

-- Table: OnlineAsyncCourse
CREATE TABLE OnlineAsyncCourse (
    OnlineAsyncCourseMeetingID int  NOT NULL,
    RecordingLink varchar(50)  NOT NULL,
    CONSTRAINT OnlineAsyncCourse_pk PRIMARY KEY  (OnlineAsyncCourseMeetingID)
);

-- Table: OnlineStudy
CREATE TABLE OnlineStudy (
    OnlineStudyMeetingID int  NOT NULL,
    MeetingLink varchar(50)  NOT NULL,
    CONSTRAINT CheckMeetingLink CHECK (MeetingLink LIKE 'http://%' OR  MeetingLink LIKE 'https://%'),
    CONSTRAINT OnlineStudy_pk PRIMARY KEY  (OnlineStudyMeetingID)
);

-- Table: OnlineSyncCourse
CREATE TABLE OnlineSyncCourse (
    OnlineSyncCourseMeetingID int  NOT NULL,
    MeetingLink varchar(50)  NOT NULL,
    CONSTRAINT OnlineSyncCourse_pk PRIMARY KEY  (OnlineSyncCourseMeetingID)
);

-- Table: OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailID int  NOT NULL,
    OrderID int  NOT NULL,
    ServiceTypeID int  NOT NULL,
    ServiceID int  NOT NULL,
    CONSTRAINT OrderDetails_pk PRIMARY KEY  (OrderDetailID)
);

-- Table: Orders
CREATE TABLE Orders (
    OrderID int  NOT NULL,
    UserID int  NOT NULL,
    OrderDate datetime  NOT NULL,
    CONSTRAINT Orders_pk PRIMARY KEY  (OrderID)
);

-- Table: Payments
CREATE TABLE Payments (
    PaymentID int  NOT NULL,
    OrderDetailID int  NOT NULL,
    PayDate datetime  NOT NULL,
    Amount money  NOT NULL,
    CONSTRAINT AmountGt0 CHECK (Amount > 0),
    CONSTRAINT Payments_pk PRIMARY KEY  (PaymentID)
);

-- Table: Roles
CREATE TABLE Roles (
    RoleID int  NOT NULL,
    RoleName varchar(30)  NOT NULL,
    CONSTRAINT Roles_pk PRIMARY KEY  (RoleID)
);

-- Table: Semesters
CREATE TABLE Semesters (
    SemesterNo int  NOT NULL,
    CONSTRAINT ValidSemester CHECK (SemesterNo >= 1),
    CONSTRAINT Semesters_pk PRIMARY KEY  (SemesterNo)
);

-- Table: ServiceTypes
CREATE TABLE ServiceTypes (
    ServiceTypeID int  NOT NULL,
    ServiceTypeName varchar(20)  NOT NULL,
    CONSTRAINT ServiceNameUnique UNIQUE (ServiceTypeName),
    CONSTRAINT ServiceTypes_pk PRIMARY KEY  (ServiceTypeID)
);

-- Table: StationaryCourse
CREATE TABLE StationaryCourse (
    StationaryCourseMeetingID int  NOT NULL,
    ClassroomID int  NOT NULL,
    CONSTRAINT StationaryCourse_pk PRIMARY KEY  (StationaryCourseMeetingID)
);

-- Table: StationaryStudy
CREATE TABLE StationaryStudy (
    StationaryStudyMeetingID int  NOT NULL,
    ClassroomID int  NOT NULL,
    CONSTRAINT StationaryStudy_pk PRIMARY KEY  (StationaryStudyMeetingID)
);

-- Table: Students
CREATE TABLE Students (
    StudentID int  NOT NULL,
    UserID int  NOT NULL,
    StudyID int  NOT NULL,
    SemesterNo int  NOT NULL,
    CONSTRAINT Students_pk PRIMARY KEY  (StudentID)
);

-- Table: Studies
CREATE TABLE Studies (
    StudyID int  NOT NULL,
    StudyName varchar(40)  NOT NULL,
    FeePrice money  NOT NULL DEFAULT 100,
    StudyCoordinatorID int  NOT NULL,
    LimitOfStudents int  NOT NULL,
    CONSTRAINT UniqueStudyName UNIQUE (StudyName),
    CONSTRAINT LimitOfStudentsGtZero CHECK (LimitOfStudents > 0),
    CONSTRAINT Studies_pk PRIMARY KEY  (StudyID)
);

-- Table: StudiesMeetings
CREATE TABLE StudiesMeetings (
    MeetingID int  NOT NULL,
    StudyMeetupID int  NOT NULL,
    SubjectID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    LecturerID int  NOT NULL,
    LimitOfMeetingParticipants int  NOT NULL,
    TranslatorLanguageID int  NULL,
    CONSTRAINT StudyMeetingDates CHECK (StartDate < EndDate),
    CONSTRAINT StudyParticipantsMoreThan0 CHECK (LimitOfMeetingParticipants > 0),
    CONSTRAINT StudiesMeetings_pk PRIMARY KEY  (MeetingID)
);

-- Table: StudiesSchedule
CREATE TABLE StudiesSchedule (
    StudySemesterID int  NOT NULL,
    SubjectID int  NOT NULL,
    CONSTRAINT StudiesSchedule_pk PRIMARY KEY  (StudySemesterID,SubjectID)
);

-- Table: StudyAttandance
CREATE TABLE StudyAttandance (
    StudyMeetingID int  NOT NULL,
    StudentID int  NOT NULL,
    CONSTRAINT StudyAttandance_pk PRIMARY KEY  (StudyMeetingID,StudentID)
);

-- Table: StudyMeetups
CREATE TABLE StudyMeetups (
    StudyMeetupID int  NOT NULL,
    StudySemesterID int  NOT NULL,
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    Price money  NOT NULL DEFAULT 250,
    ExtraPrice money  NOT NULL,
    CONSTRAINT EndDateGtStartDate CHECK (EndDate > StartDate),
    CONSTRAINT PriceGt0 CHECK (Price > 0),
    CONSTRAINT ExtraPriceGt0 CHECK (ExtraPrice > 0),
    CONSTRAINT StudyMeetups_pk PRIMARY KEY  (StudyMeetupID)
);

-- Table: StudySemesters
CREATE TABLE StudySemesters (
    StudySemesterID int  NOT NULL,
    StudyID int  NOT NULL,
    SemesterNo int  NOT NULL,
    CONSTRAINT StudySemesters_pk PRIMARY KEY  (StudySemesterID)
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID int  NOT NULL,
    SubjectName varchar(30)  NOT NULL,
    Description text  NOT NULL,
    CONSTRAINT Subjects_pk PRIMARY KEY  (SubjectID)
);

-- Table: Translators
CREATE TABLE Translators (
    TranslatorLanguageID int  NOT NULL,
    LanguageID int  NOT NULL,
    EmployeeID int  NOT NULL,
    CONSTRAINT Translators_pk PRIMARY KEY  (TranslatorLanguageID)
);

-- Table: Users
CREATE TABLE Users (
    UserID int  NOT NULL,
    Firstname varchar(20)  NOT NULL,
    Lastname varchar(20)  NOT NULL,
    Email varchar(30)  NOT NULL,
    Password varchar(255)  NOT NULL,
    Phone varchar(15)  NULL,
    AddressID int  NOT NULL,
    CONSTRAINT ValidEmail CHECK (Email LIKE '%_@__%.__%'),
    CONSTRAINT Users_pk PRIMARY KEY  (UserID)
);

-- Table: Webinars
CREATE TABLE Webinars (
    WebinarID int  NOT NULL,
    WebinarName varchar(40)  NOT NULL,
    RecordingLink varchar(50)  NOT NULL,
    Date datetime  NOT NULL,
    Price money  NULL,
    WebinarPresenterID int  NOT NULL,
    TranslatorLanguageD int  NULL,
    CONSTRAINT WebinarNameUnique UNIQUE (WebinarName),
    CONSTRAINT RecordingLinkUnique UNIQUE (RecordingLink),
    CONSTRAINT Webinars_pk PRIMARY KEY  (WebinarID)
);

-- Table: WebinarsAttendance
CREATE TABLE WebinarsAttendance (
    WebinarID int  NOT NULL,
    UserID int  NOT NULL,
    CONSTRAINT WebinarsAttendance_pk PRIMARY KEY  (WebinarID,UserID)
);

-- foreign keys
-- Reference: Addresses_City (table: Addresses)
ALTER TABLE Addresses ADD CONSTRAINT Addresses_City
    FOREIGN KEY (CityID)
    REFERENCES Cities (CityID);

-- Reference: City_Country (table: Cities)
ALTER TABLE Cities ADD CONSTRAINT City_Country
    FOREIGN KEY (CountryID)
    REFERENCES Countries (CountryID);

-- Reference: Classrooms_Addresses (table: Classrooms)
ALTER TABLE Classrooms ADD CONSTRAINT Classrooms_Addresses
    FOREIGN KEY (AddressID)
    REFERENCES Addresses (AddressID);

-- Reference: Copy_of_CoursesMeetings_Employees (table: CoursesMeetings)
ALTER TABLE CoursesMeetings ADD CONSTRAINT Copy_of_CoursesMeetings_Employees
    FOREIGN KEY (CourseInstructorID)
    REFERENCES Employees (EmployeeID);

-- Reference: CoursesAttendance_CoursesMeetings (table: CoursesAttendance)
ALTER TABLE CoursesAttendance ADD CONSTRAINT CoursesAttendance_CoursesMeetings
    FOREIGN KEY (CourseMeetingID)
    REFERENCES CoursesMeetings (MeetingID);

-- Reference: CoursesAttendance_Users (table: CoursesAttendance)
ALTER TABLE CoursesAttendance ADD CONSTRAINT CoursesAttendance_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: CoursesMeetings_Courses (table: CoursesMeetings)
ALTER TABLE CoursesMeetings ADD CONSTRAINT CoursesMeetings_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: Courses_Employees (table: Courses)
ALTER TABLE Courses ADD CONSTRAINT Courses_Employees
    FOREIGN KEY (CourseCoordinatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: Courses_Translators (table: Courses)
ALTER TABLE Courses ADD CONSTRAINT Courses_Translators
    FOREIGN KEY (TranslatorLanguageID)
    REFERENCES Translators (TranslatorLanguageID);

-- Reference: EmployeeRoles_Employees (table: EmployeeRoles)
ALTER TABLE EmployeeRoles ADD CONSTRAINT EmployeeRoles_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES Employees (EmployeeID);

-- Reference: EmployeeRoles_Roles (table: EmployeeRoles)
ALTER TABLE EmployeeRoles ADD CONSTRAINT EmployeeRoles_Roles
    FOREIGN KEY (RoleID)
    REFERENCES Roles (RoleID);

-- Reference: Employees_Addresses (table: Employees)
ALTER TABLE Employees ADD CONSTRAINT Employees_Addresses
    FOREIGN KEY (AddressID)
    REFERENCES Addresses (AddressID);

-- Reference: FinalExams_Grades (table: FinalExams)
ALTER TABLE FinalExams ADD CONSTRAINT FinalExams_Grades
    FOREIGN KEY (GradeID)
    REFERENCES Grades (GradeID);

-- Reference: FinalExams_Studies (table: FinalExams)
ALTER TABLE FinalExams ADD CONSTRAINT FinalExams_Studies
    FOREIGN KEY (StudyID)
    REFERENCES Studies (StudyID);

-- Reference: FinalExams_Users (table: FinalExams)
ALTER TABLE FinalExams ADD CONSTRAINT FinalExams_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: HeadTeacherPaymentPostponements_Courses (table: HeadTeacherPaymentPostponements)
ALTER TABLE HeadTeacherPaymentPostponements ADD CONSTRAINT HeadTeacherPaymentPostponements_Courses
    FOREIGN KEY (ServiceID)
    REFERENCES Courses (CourseID);

-- Reference: HeadTeacherPaymentPostponements_ServiceTypes (table: HeadTeacherPaymentPostponements)
ALTER TABLE HeadTeacherPaymentPostponements ADD CONSTRAINT HeadTeacherPaymentPostponements_ServiceTypes
    FOREIGN KEY (ServiceTypeID)
    REFERENCES ServiceTypes (ServiceTypeID);

-- Reference: HeadTeacherPaymentPostponements_Studies (table: HeadTeacherPaymentPostponements)
ALTER TABLE HeadTeacherPaymentPostponements ADD CONSTRAINT HeadTeacherPaymentPostponements_Studies
    FOREIGN KEY (ServiceID)
    REFERENCES Studies (StudyID);

-- Reference: HeadTeacherPaymentPostponements_StudyMeetup (table: HeadTeacherPaymentPostponements)
ALTER TABLE HeadTeacherPaymentPostponements ADD CONSTRAINT HeadTeacherPaymentPostponements_StudyMeetup
    FOREIGN KEY (ServiceID)
    REFERENCES StudyMeetups (StudyMeetupID);

-- Reference: HeadTeacherPaymentPostponements_Users (table: HeadTeacherPaymentPostponements)
ALTER TABLE HeadTeacherPaymentPostponements ADD CONSTRAINT HeadTeacherPaymentPostponements_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: HeadTeacherPaymentPostponements_Webinars (table: HeadTeacherPaymentPostponements)
ALTER TABLE HeadTeacherPaymentPostponements ADD CONSTRAINT HeadTeacherPaymentPostponements_Webinars
    FOREIGN KEY (ServiceID)
    REFERENCES Webinars (WebinarID);

-- Reference: InternshipDetails_Internships (table: InternshipDetails)
ALTER TABLE InternshipDetails ADD CONSTRAINT InternshipDetails_Internships
    FOREIGN KEY (InternshipID)
    REFERENCES Internships (InternshipID);

-- Reference: InternshipDetails_Students (table: InternshipDetails)
ALTER TABLE InternshipDetails ADD CONSTRAINT InternshipDetails_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: Internships_Studies (table: Internships)
ALTER TABLE Internships ADD CONSTRAINT Internships_Studies
    FOREIGN KEY (StudyID)
    REFERENCES Studies (StudyID);

-- Reference: LanguageId (table: Translators)
ALTER TABLE Translators ADD CONSTRAINT LanguageId
    FOREIGN KEY (LanguageID)
    REFERENCES Languages (LanguageID);

-- Reference: OnlineAsyncCourse_Copy_of_CoursesMeetings (table: OnlineAsyncCourse)
ALTER TABLE OnlineAsyncCourse ADD CONSTRAINT OnlineAsyncCourse_Copy_of_CoursesMeetings
    FOREIGN KEY (OnlineAsyncCourseMeetingID)
    REFERENCES CoursesMeetings (MeetingID);

-- Reference: OnlineStudy_StudiesMeetings (table: OnlineStudy)
ALTER TABLE OnlineStudy ADD CONSTRAINT OnlineStudy_StudiesMeetings
    FOREIGN KEY (OnlineStudyMeetingID)
    REFERENCES StudiesMeetings (MeetingID);

-- Reference: OnlineSyncCourse_Copy_of_CoursesMeetings (table: OnlineSyncCourse)
ALTER TABLE OnlineSyncCourse ADD CONSTRAINT OnlineSyncCourse_Copy_of_CoursesMeetings
    FOREIGN KEY (OnlineSyncCourseMeetingID)
    REFERENCES CoursesMeetings (MeetingID);

-- Reference: OrderDetails_Courses (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Courses
    FOREIGN KEY (ServiceID)
    REFERENCES Courses (CourseID);

-- Reference: OrderDetails_Orders (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: OrderDetails_ServiceTypes (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_ServiceTypes
    FOREIGN KEY (ServiceTypeID)
    REFERENCES ServiceTypes (ServiceTypeID);

-- Reference: OrderDetails_Studies (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Studies
    FOREIGN KEY (ServiceID)
    REFERENCES Studies (StudyID);

-- Reference: OrderDetails_StudiesMeetings (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_StudiesMeetings
    FOREIGN KEY (ServiceID)
    REFERENCES StudiesMeetings (MeetingID);

-- Reference: OrderDetails_StudyMeetup (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_StudyMeetup
    FOREIGN KEY (ServiceID)
    REFERENCES StudyMeetups (StudyMeetupID);

-- Reference: OrderDetails_Webinars (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Webinars
    FOREIGN KEY (ServiceID)
    REFERENCES Webinars (WebinarID);

-- Reference: Orders_Users (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: Payments_OrderDetails (table: Payments)
ALTER TABLE Payments ADD CONSTRAINT Payments_OrderDetails
    FOREIGN KEY (OrderDetailID)
    REFERENCES OrderDetails (OrderDetailID);

-- Reference: StationaryCourse_Classrooms (table: StationaryCourse)
ALTER TABLE StationaryCourse ADD CONSTRAINT StationaryCourse_Classrooms
    FOREIGN KEY (ClassroomID)
    REFERENCES Classrooms (ClassroomID);

-- Reference: StationaryCourse_Copy_of_CoursesMeetings (table: StationaryCourse)
ALTER TABLE StationaryCourse ADD CONSTRAINT StationaryCourse_Copy_of_CoursesMeetings
    FOREIGN KEY (StationaryCourseMeetingID)
    REFERENCES CoursesMeetings (MeetingID);

-- Reference: StationaryStudy_Classrooms (table: StationaryStudy)
ALTER TABLE StationaryStudy ADD CONSTRAINT StationaryStudy_Classrooms
    FOREIGN KEY (ClassroomID)
    REFERENCES Classrooms (ClassroomID);

-- Reference: StationaryStudy_StudiesMeetings (table: StationaryStudy)
ALTER TABLE StationaryStudy ADD CONSTRAINT StationaryStudy_StudiesMeetings
    FOREIGN KEY (StationaryStudyMeetingID)
    REFERENCES StudiesMeetings (MeetingID);

-- Reference: Students_Semesters (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Semesters
    FOREIGN KEY (SemesterNo)
    REFERENCES Semesters (SemesterNo);

-- Reference: Students_Studies (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Studies
    FOREIGN KEY (StudyID)
    REFERENCES Studies (StudyID);

-- Reference: Students_Users (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: StudiesMeetings_Employees (table: StudiesMeetings)
ALTER TABLE StudiesMeetings ADD CONSTRAINT StudiesMeetings_Employees
    FOREIGN KEY (LecturerID)
    REFERENCES Employees (EmployeeID);

-- Reference: StudiesMeetings_StudyMeetup (table: StudiesMeetings)
ALTER TABLE StudiesMeetings ADD CONSTRAINT StudiesMeetings_StudyMeetup
    FOREIGN KEY (StudyMeetupID)
    REFERENCES StudyMeetups (StudyMeetupID);

-- Reference: StudiesMeetings_Subjects (table: StudiesMeetings)
ALTER TABLE StudiesMeetings ADD CONSTRAINT StudiesMeetings_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: StudiesMeetings_Translators (table: StudiesMeetings)
ALTER TABLE StudiesMeetings ADD CONSTRAINT StudiesMeetings_Translators
    FOREIGN KEY (TranslatorLanguageID)
    REFERENCES Translators (TranslatorLanguageID);

-- Reference: StudiesSchedule_StudySemesters (table: StudiesSchedule)
ALTER TABLE StudiesSchedule ADD CONSTRAINT StudiesSchedule_StudySemesters
    FOREIGN KEY (StudySemesterID)
    REFERENCES StudySemesters (StudySemesterID);

-- Reference: StudiesSchedule_Subjects (table: StudiesSchedule)
ALTER TABLE StudiesSchedule ADD CONSTRAINT StudiesSchedule_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: Studies_Coordinators (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_Coordinators
    FOREIGN KEY (StudyCoordinatorID)
    REFERENCES Employees (EmployeeID);

-- Reference: StudyAttandance_Students (table: StudyAttandance)
ALTER TABLE StudyAttandance ADD CONSTRAINT StudyAttandance_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: StudyAttandance_StudiesMeetings (table: StudyAttandance)
ALTER TABLE StudyAttandance ADD CONSTRAINT StudyAttandance_StudiesMeetings
    FOREIGN KEY (StudyMeetingID)
    REFERENCES StudiesMeetings (MeetingID);

-- Reference: StudyMeetup_StudySemesters (table: StudyMeetups)
ALTER TABLE StudyMeetups ADD CONSTRAINT StudyMeetup_StudySemesters
    FOREIGN KEY (StudySemesterID)
    REFERENCES StudySemesters (StudySemesterID);

-- Reference: StudySemesters_Semesters (table: StudySemesters)
ALTER TABLE StudySemesters ADD CONSTRAINT StudySemesters_Semesters
    FOREIGN KEY (SemesterNo)
    REFERENCES Semesters (SemesterNo);

-- Reference: StudySemesters_Studies (table: StudySemesters)
ALTER TABLE StudySemesters ADD CONSTRAINT StudySemesters_Studies
    FOREIGN KEY (StudyID)
    REFERENCES Studies (StudyID);

-- Reference: TranslatorsLanguages_Employees (table: Translators)
ALTER TABLE Translators ADD CONSTRAINT TranslatorsLanguages_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES Employees (EmployeeID);

-- Reference: Translators_Webinars (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Translators_Webinars
    FOREIGN KEY (TranslatorLanguageD)
    REFERENCES Translators (TranslatorLanguageID);

-- Reference: Users_Addresses (table: Users)
ALTER TABLE Users ADD CONSTRAINT Users_Addresses
    FOREIGN KEY (AddressID)
    REFERENCES Addresses (AddressID);

-- Reference: WebinarsAttendance_Users (table: WebinarsAttendance)
ALTER TABLE WebinarsAttendance ADD CONSTRAINT WebinarsAttendance_Users
    FOREIGN KEY (UserID)
    REFERENCES Users (UserID);

-- Reference: WebinarsAttendance_Webinars (table: WebinarsAttendance)
ALTER TABLE WebinarsAttendance ADD CONSTRAINT WebinarsAttendance_Webinars
    FOREIGN KEY (WebinarID)
    REFERENCES Webinars (WebinarID);

-- Reference: Webinars_Employees (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Employees
    FOREIGN KEY (WebinarPresenterID)
    REFERENCES Employees (EmployeeID);

-- End of file.

