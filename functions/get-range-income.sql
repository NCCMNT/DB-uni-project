CREATE FUNCTION GetRangeIncome
    (@StartDate date, @EndDate date)
RETURNS decimal(10, 2)
AS
    BEGIN
        IF @StartDate > @EndDate
            BEGIN
                RETURN 0.0
            END
        RETURN CONVERT(decimal(10, 2), (SELECT sum(Amount)
                        FROM Payments
                        INNER JOIN dbo.OrderDetails OD on OD.OrderDetailID = Payments.OrderDetailID
                        WHERE PayDate BETWEEN @StartDate AND @EndDate))
    END
