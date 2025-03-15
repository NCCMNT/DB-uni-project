CREATE ROLE AdministrativeEmployee
GRANT SELECT ON BilocationReport TO AdministrativeEmployee
GRANT SELECT ON WebinarsIncome TO AdministrativeEmployee
GRANT SELECT ON StudyIncome TO AdministrativeEmployee
GRANT SELECT ON CoursesIncome TO AdministrativeEmployee
GRANT SELECT ON SummaryIncome TO AdministrativeEmployee
GRANT SELECT ON DiplomaInfo TO AdministrativeEmployee
GRANT SELECT ON CoursesDebtors TO AdministrativeEmployee
GRANT SELECT ON StudentDebtors TO AdministrativeEmployee
GRANT EXECUTE ON GetAnnualIncome TO AdministrativeEmployee
GRANT EXECUTE ON GetRangeIncome TO AdministrativeEmployee
GRANT EXECUTE ON GetStudyIncome TO AdministrativeEmployee
GRANT EXECUTE ON GetWebinarIncome TO AdministrativeEmployee
GRANT EXECUTE ON GetCourseIncome TO AdministrativeEmployee
