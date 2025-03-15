CREATE TRIGGER AddInternshipsOnAddStudy
ON Studies
AFTER INSERT AS
    BEGIN
        DECLARE @NewStudyID int = (SELECT MAX(StudyID) FROM Studies)
        EXECUTE AddInternship
            @StudyID = @NewStudyID;
    END