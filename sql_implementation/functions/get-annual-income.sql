CREATE FUNCTION GetAnnualIncome
    (@Year int)
RETURNS decimal(10, 2)
AS
    BEGIN
        RETURN CONVERT(decimal(10, 2), (SELECT sum(Amount)
                        FROM Payments
                        INNER JOIN dbo.OrderDetails OD on OD.OrderDetailID = Payments.OrderDetailID
                        WHERE YEAR(PayDate) = @Year))
    END