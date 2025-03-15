CREATE PROCEDURE AddOrderDetails
    @OrderID int,
    @ServiceTypeID int,
    @ServiceID int
AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @OrderDetailID int = (select max(OrderDetailID) + 1 from OrderDetails)

        IF @OrderID NOT IN (SELECT OrderID FROM dbo.Orders)
            BEGIN
                RAISERROR ('Order does not exist', 16, 1)
                RETURN
            END
        IF @ServiceTypeID NOT IN (SELECT ServiceTypeID FROM dbo.ServiceTypes)
            BEGIN
                RAISERROR ('Service Type does not exist', 16, 1)
                RETURN
            END
        IF @ServiceID NOT IN (SELECT ServiceID FROM dbo.AllServices where ServiceType = @ServiceTypeID)
            BEGIN
                RAISERROR ('Service does not exist', 16, 1)
                RETURN
            END
        IF @ServiceTypeID IN (SELECT ServiceTypeID from ServiceTypes where ServiceTypeName = 'Course')
            BEGIN
                IF NOT EXISTS(SELECT 1 FROM FutureCourses where @ServiceID = CourseID)
                BEGIN
                    RAISERROR ('Course has already started', 16, 1)
                end
                DECLARE @limit int =  (SELECT limit FROM CourseLimits WHERE CourseID = @ServiceID)
                IF @limit IS NOT NULL AND @limit <= (SELECT TOP 1 Users FROM NumberOfUsersAuthorizedForCourseMeeting N
                    INNER JOIN CoursesMeetings CM  ON CM.MeetingID = N.MeetingID
                    INNER JOIN Courses C ON C.CourseID = CM.CourseID
                    WHERE C.CourseID = @ServiceID)
                BEGIN
                    RAISERROR ('No more available spots for course', 16, 1)
                end
            end
        IF @ServiceTypeID IN (SELECT ServiceTypeID from ServiceTypes where ServiceTypeName = 'Studies Meetup')
            BEGIN
                IF NOT EXISTS(SELECT 1 FROM StudyMeetups where StudyMeetupID = @ServiceID and StartDate > GETDATE())
                BEGIN
                    RAISERROR ('Service in the past', 16, 1)
                    RETURN
                end
            end
        IF @ServiceTypeID IN (SELECT ServiceTypeID from ServiceTypes where ServiceTypeName = 'Studies')
            BEGIN
                DECLARE @Studylimit int = (SELECT LimitOfStudents FROM Studies WHERE @ServiceID = StudyID)
                DECLARE @registered int = (SELECT COUNT(*) FROM Students WHERE StudyID = @ServiceID)
                IF @registered >= @Studylimit
                BEGIN
                    RAISERROR ('No more available spots for studies', 16,1)
                end
            end
        IF @ServiceTypeID IN (SELECT ServiceTypeID from ServiceTypes where ServiceTypeName = 'Webinar')
            BEGIN
                IF NOT EXISTS(SELECT 1 FROM Webinars WHERE WebinarID = @ServiceID and Date > GETDATE())
                    BEGIN
                        RAISERROR ('Service in the past', 16, 1)
                        RETURN
                    end
            end
        INSERT INTO dbo.OrderDetails (OrderDetailID, OrderID, ServiceTypeID, ServiceID)
        VALUES (@OrderDetailID, @OrderID, @ServiceTypeID, @ServiceID)
        PRINT 'Order details added successfully'
    END
go

