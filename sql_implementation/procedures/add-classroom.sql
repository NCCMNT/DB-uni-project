CREATE PROCEDURE AddClassroom
    @AddressID int,
    @RoomNumber int,
    @Capacity int
AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @ClassroomID int = (SELECT MAX(ClassroomID) + 1 FROM Classrooms)
        IF @AddressID NOT IN (SELECT AddressID FROM Addresses)
            BEGIN
                RAISERROR ('Address does not exist', 16, 1)
                RETURN
            END
        IF @RoomNumber IS NULL OR @RoomNumber < 0
            BEGIN
                RAISERROR ('Room Number cannot be null or less than 0', 16, 1)
                RETURN
            END
        IF @Capacity IS NULL OR @Capacity < 0
            BEGIN
                RAISERROR ('Capacity cannot be null or less than 0', 16, 1)
                RETURN
            END
        IF @RoomNumber IN (SELECT RoomNo FROM Classrooms WHERE AddressID = @AddressID)
            BEGIN
                RAISERROR ('Classroom already exists at this address', 16, 1)
                RETURN
            END

        INSERT INTO Classrooms (ClassroomID, AddressID, RoomNo, Capacity)
        VALUES (@ClassroomID, @AddressID, @RoomNumber, @Capacity)
        PRINT 'Classroom added successfully'
    END