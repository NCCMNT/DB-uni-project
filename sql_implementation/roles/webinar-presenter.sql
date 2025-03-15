CREATE ROLE WebinarPresenter
GRANT SELECT, UPDATE ON Webinars TO WebinarPresenter
GRANT SELECT, INSERT, DELETE ON WebinarsAttendance TO WebinarPresenter
GRANT SELECT ON WebinarMeetingPresence TO WebinarPresenter
GRANT SELECT ON WebinarAttendance TO WebinarPresenter
GRANT EXECUTE ON AddWebinar TO WebinarPresenter


