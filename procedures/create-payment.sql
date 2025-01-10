CREATE PROCEDURE CreatePayment
    @OrderDetailID int,
    @PaymentAmount money
AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @PaymentID int = (select max(PaymentID) + 1 from Payments)
        DECLARE @Date datetime = GETDATE()

        IF @OrderDetailID NOT IN (SELECT OrderDetailID FROM dbo.OrderDetails)
            BEGIN
                RAISERROR ('Order Detail does not exist', 16, 1)
            END
        IF @PaymentAmount < 0 OR @PaymentAmount IS NULL OR @PaymentAmount > 999999
            BEGIN
                RAISERROR ('Payment Amount must be between 0 and 999999', 16, 1)
            END
        INSERT INTO dbo.Payments (PaymentID, OrderDetailID, PayDate, Amount)
        VALUES (@PaymentID, @OrderDetailID, @Date, @PaymentAmount)

        PRINT 'Payment created successfully'
    END
