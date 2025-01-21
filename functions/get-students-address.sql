CREATE FUNCTION GetStudentsAddress (@StudentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT a.* FROM Addresses AS a
        INNER JOIN Users AS u ON u.AddressID = a.AddressID
        INNER JOIN Students AS s ON u.UserID = s.UserID
        WHERE s.StudentID = @StudentID
);