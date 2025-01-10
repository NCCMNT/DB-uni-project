CREATE PROCEDURE AddServiceType
    @ServiceTypeName nvarchar(50)
AS
    BEGIN
        DECLARE @ServiceTypeID int = (SELECT MAX(ServiceTypeID) + 1 FROM ServiceTypes)
        IF @ServiceTypeName IS NULL
            BEGIN
                RAISERROR ('Service Type Name cannot be null', 16, 1)
            END

        INSERT INTO ServiceTypes (ServiceTypeID, ServiceTypeName)
        VALUES (@ServiceTypeID, @ServiceTypeName)
    END
