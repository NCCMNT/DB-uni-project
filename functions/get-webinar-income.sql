CREATE FUNCTION GetWebinarIncome
    (@WebinarID int)
RETURNS decimal(10, 2)
AS
BEGIN
    DECLARE @WebinarServiceTypeID int = (SELECT ServiceTypeID FROM ServiceTypes WHERE ServiceTypeName = 'Webinar')
    IF NOT EXISTS(SELECT 1 FROM Webinars WHERE WebinarID = @WebinarID)
        BEGIN
            RETURN 0.0
        END
    RETURN CONVERT(decimal(10, 2),
            (SELECT sum(Amount)
             FROM Payments
             INNER JOIN dbo.OrderDetails OD on OD.OrderDetailID = Payments.OrderDetailID
             WHERE ServiceTypeID = @WebinarServiceTypeID and ServiceID = @WebinarID))
END