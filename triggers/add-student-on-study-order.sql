CREATE TRIGGER AddStudentOnStudyOrder
ON OrderDetails
AFTER INSERT
AS
BEGIN
    DECLARE @NewOrderDetailID INT = (SELECT MAX(OrderDetailID) FROM OrderDetails);

    -- check if user ordered studies
    IF NOT EXISTS (
        SELECT 1
        FROM OrderDetails
        INNER JOIN ServiceTypes
            ON OrderDetails.ServiceTypeID = ServiceTypes.ServiceTypeID
        WHERE OrderDetailID = @NewOrderDetailID AND ServiceTypeName = 'Studies'
    )
    BEGIN
        RETURN;
    END

    DECLARE @UserID INT;
    DECLARE @StudyID INT;

    SELECT
        @UserID = UserID,
        @StudyID = ServiceID
    FROM OrderDetails
    INNER JOIN Orders
        ON OrderDetails.OrderID = Orders.OrderID
    WHERE OrderDetailID = @NewOrderDetailID;

    EXEC AddStudent
        @UserID = @UserID,
        @StudyID = @StudyID,
        @SemesterNo = 1;
END;
GO
