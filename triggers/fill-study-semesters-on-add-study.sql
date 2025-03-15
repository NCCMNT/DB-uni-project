CREATE TRIGGER FillStudySemestersOnAddStudy
ON Studies
AFTER INSERT AS
    BEGIN
        DECLARE @NewStudyID int = (SELECT MAX(StudyID) FROM Studies)
        EXECUTE FillStudySemesters 
            @StudyID = @NewStudyID;
    END