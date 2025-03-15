CREATE PROCEDURE AddStationaryCourseMeeting
    @CourseID INT,
    @StartDate DATETIME,
    @EndDate DATETIME,
    @CourseInstructorID INT,
    @LimitOfParticipants INT,
    @ClassroomID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StationaryCourseMeetingID INT = (SELECT MAX(MeetingID) + 1 FROM CoursesMeetings);

    IF NOT EXISTS(SELECT 1 FROM Courses WHERE CourseID = @CourseID)
    BEGIN
        RAISERROR('Given course does not exist.', 16, 1);
        RETURN;
    END;

    IF @StartDate < GETDATE()
    BEGIN
        RAISERROR('Date cannot be in the past.', 16, 1);
        RETURN;
    END;

    IF @StartDate >= @EndDate
    BEGIN
        RAISERROR('Start date must be earlier than end date.', 16, 1);
        RETURN;
    END;

    IF @LimitOfParticipants <= 0
    BEGIN
        RAISERROR('Limit of participants must be greater than 0.', 16, 1);
        RETURN;
    END;

    IF @LimitOfParticipants > (SELECT Capacity FROM Classrooms WHERE ClassroomID = @ClassroomID)
    BEGIN
        RAISERROR('Limit of participants cannot be greater than classroom capacity.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS(
        SELECT 1
        FROM EmployeeRoles
        INNER JOIN Roles
            ON EmployeeRoles.RoleID = Roles.RoleID
        WHERE RoleName = 'Course Instructor' AND EmployeeID = @CourseInstructorID
    )
    BEGIN
        RAISERROR('Given course instructor does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS(SELECT 1 FROM Classrooms WHERE ClassroomID = @ClassroomID)
    BEGIN
        RAISERROR('Given classroom does not exist.', 16, 1);
        RETURN;
    END;

    IF EXISTS(
        SELECT 1
        FROM CoursesMeetings
        WHERE CourseID = @CourseID AND StartDate = @StartDate AND EndDate = @EndDate
    )
    BEGIN
        RAISERROR('Given course meeting already exists.', 16, 1);
        RETURN;
    END;

    INSERT INTO CoursesMeetings (MeetingID, CourseID, StartDate, EndDate, CourseInstructorID, LimitOfParticipants)
    VALUES (@StationaryCourseMeetingID, @CourseID, @StartDate, @EndDate, @CourseInstructorID, @LimitOfParticipants);

    INSERT INTO StationaryCourse (StationaryCourseMeetingID, ClassroomID)
    VALUES (@StationaryCourseMeetingID, @ClassroomID);

    PRINT 'Stationary course meeting added successfully.';
END;
