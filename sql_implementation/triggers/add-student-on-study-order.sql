CREATE TRIGGER AddStudentOnStudyOrderPayment
ON Payments
AFTER INSERT
AS
BEGIN
    DECLARE @NewPaymentID INT = (SELECT MAX(PaymentID) FROM Payments);

    -- check if user paid for studies
    IF NOT EXISTS (
        SELECT 1
        FROM OrderDetails
        INNER JOIN ServiceTypes
            ON OrderDetails.ServiceTypeID = ServiceTypes.ServiceTypeID
        INNER JOIN Payments
            ON OrderDetails.OrderDetailID = Payments.OrderDetailID
        WHERE PaymentID = @NewPaymentID AND ServiceTypeName = 'Studies'
    )
    BEGIN
        RETURN;
    END

    DECLARE @UserID INT;
    DECLARE @StudyID INT;
    DECLARE @OrderID INT;

    SELECT
        @UserID = UserID,
        @StudyID = ServiceID,
        @OrderID = Orders.OrderID
    FROM OrderDetails
    INNER JOIN Orders
        ON OrderDetails.OrderID = Orders.OrderID
    INNER JOIN Payments
        ON OrderDetails.OrderDetailID = Payments.OrderDetailID
    WHERE PaymentID = @NewPaymentID;

    DECLARE @TotalAmountPaid MONEY;

    SELECT
        @TotalAmountPaid = SUM(Amount)
    FROM Payments
    INNER JOIN OrderDetails
        ON Payments.OrderDetailID = OrderDetails.OrderDetailID
    INNER JOIN ServiceTypes
        ON OrderDetails.ServiceTypeID = ServiceTypes.ServiceTypeID
    INNER JOIN Orders
        ON OrderDetails.OrderID = Orders.OrderID
    WHERE OrderDetails.OrderID = @OrderID
        AND
        ServiceTypeName = 'Studies'
        AND
        ServiceID = @StudyID
        AND
        UserID = @UserID;

    IF @TotalAmountPaid < (SELECT FeePrice FROM Studies WHERE StudyID = @StudyID)
    BEGIN
        RETURN;
    END

    EXEC AddStudent
        @UserID = @UserID,
        @StudyID = @StudyID,
        @SemesterNo = 1
END;
GO
