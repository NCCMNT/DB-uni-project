CREATE PROCEDURE AddServiceType
    @ServiceTypeName nvarchar(50)
AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @ServiceTypeID int = (SELECT MAX(ServiceTypeID) + 1 FROM ServiceTypes)
        IF @ServiceTypeName IS NULL
            BEGIN
                RAISERROR ('Service Type Name cannot be null', 16, 1)
                RETURN
            END

        INSERT INTO ServiceTypes (ServiceTypeID, ServiceTypeName)
        VALUES (@ServiceTypeID, @ServiceTypeName)
        PRINT 'Service Type added successfully'
    END
