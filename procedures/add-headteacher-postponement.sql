CREATE PROCEDURE AddHeadteacherPostponement
    @UserID int,
    @ServiceTypeID int,
    @ServiceID int,
    @DueDate datetime
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @PostponementID int = (select max(PostponementID) + 1 from dbo.HeadTeacherPaymentPostponements)
    IF @UserID NOT IN (SELECT UserID FROM dbo.Users)
        BEGIN
            RAISERROR ('User does not exist', 16, 1)
        END
    IF @ServiceTypeID NOT IN (SELECT ServiceTypeID FROM dbo.ServiceTypes)
        BEGIN
            RAISERROR ('Service Type does not exist', 16, 1)
        END
    IF @ServiceID NOT IN (SELECT ServiceID FROM dbo.AllServices where ServiceType = @ServiceTypeID)
        BEGIN
            RAISERROR ('Service does not exist', 16, 1)
        END
    IF @DueDate IS NULL
        BEGIN
            RAISERROR ('Due Date cannot be null', 16, 1)
        END
    IF (SELECT COUNT(*)
        FROM OrderDetails OD
        INNER JOIN Orders O on OD.OrderID = O.OrderID
        WHERE UserID = @UserID AND ServiceTypeID = @ServiceTypeID AND ServiceID = @ServiceID) = 0
        BEGIN
            RAISERROR ('User did not order this service', 16, 1)
        END
    INSERT INTO dbo.HeadTeacherPaymentPostponements (PostponementID, UserID, ServiceTypeID, ServiceID, DueDate)
    VALUES (@PostponementID, @UserID, @ServiceTypeID, @ServiceID, @DueDate)
    PRINT 'HeadteacherPostponement added successfully'
END