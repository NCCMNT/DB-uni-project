CREATE PROCEDURE CreateOrder
    @UserID int
AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @Date datetime = GETDATE()
        DECLARE @OrderID int = (select max(OrderID) + 1 from Orders)

        IF @UserID NOT IN (SELECT UserID FROM dbo.Users)
            BEGIN
                RAISERROR ('User does not exist', 16, 1)
            END

        INSERT INTO dbo.Orders (OrderID, UserID, OrderDate)
        VALUES (@OrderID, @UserID, @Date)

        PRINT 'Order created successfully'
    END