CREATE TRIGGER AddStudyMeetupOrderDetailOnNewMeetup
ON StudyMeetups
AFTER INSERT
AS
BEGIN
    -- get ServiceID of 'Study Meetup' service
    DECLARE @MeetupServiceID INT = (
        SELECT
            ServiceTypeID
        FROM ServiceTypes
        WHERE ServiceTypeName = 'Studies Meetup'
    );

    DECLARE @NewMeetupID INT, @StudySemesterID INT;

    -- get newest meetup information
    SELECT
        @NewMeetupID = StudyMeetupID,
        @StudySemesterID = StudySemesterID
    FROM StudyMeetups
    WHERE StudyMeetupID = (
      SELECT MAX(sm1.StudyMeetupID) FROM StudyMeetups AS sm1
    );

    DECLARE @StudyID INT;

    -- get StudyID for given meetup
    SELECT
        @StudyID = StudyID
    FROM StudySemesters
    WHERE StudySemesterID = @StudySemesterID;

    DECLARE @OrderID INT;

    -- find all orders for studies; consider only orders made by students
    -- who are currently enrolled in the studies and in the semester related
    -- to the new meetup
    DECLARE OrderCursor CURSOR FOR
    SELECT
        Orders.OrderID
    FROM Orders
    INNER JOIN OrderDetails
        ON Orders.OrderID = OrderDetails.OrderID
    INNER JOIN ServiceTypes
        ON OrderDetails.ServiceTypeID = ServiceTypes.ServiceTypeID
    INNER JOIN Students
        ON Students.UserID = Orders.UserID
    INNER JOIN StudySemesters
        ON Students.SemesterNo = StudySemesters.SemesterNo AND Students.StudyID = StudySemesters.StudyID
    WHERE ServiceTypeName = 'Studies'
        AND ServiceID = @StudyID
        AND StudySemesterID = @StudySemesterID;

    -- add new order details for given study meetup
    OPEN OrderCursor;

    FETCH NEXT FROM OrderCursor INTO @OrderID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC AddOrderDetails
            @OrderID = @OrderID,
            @ServiceTypeID = @MeetupServiceID,
            @ServiceID = @NewMeetupID;

        FETCH NEXT FROM OrderCursor INTO @OrderID;
    END

    CLOSE OrderCursor;
    DEALLOCATE OrderCursor;
END;
