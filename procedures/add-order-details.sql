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
            END
        IF @ServiceTypeID NOT IN (SELECT ServiceTypeID FROM dbo.ServiceTypes)
            BEGIN
                RAISERROR ('Service Type does not exist', 16, 1)
            END
        IF @ServiceID NOT IN (SELECT ServiceID FROM dbo.AllServices where ServiceType = @ServiceTypeID)
            BEGIN
                RAISERROR ('Service does not exist', 16, 1)
            END
        INSERT INTO dbo.OrderDetails (OrderDetailID, OrderID, ServiceTypeID, ServiceID)
        VALUES (@OrderDetailID, @OrderID, @ServiceTypeID, @ServiceID)
        PRINT 'Order details added successfully'
    END