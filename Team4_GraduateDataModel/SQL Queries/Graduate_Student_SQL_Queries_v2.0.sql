
--1.What are the core requirements and elective courses for these programs
select
p.ProgramName,
CASE 
 When CoreCourseFlag = 'NO' THEN 'Elective Course' ELSE 'Core Course' end AS 'Courses Type',
 [Name] 'Course Name',
 Prerequisite 'Prerequisite'
from DimCourse c JOIN DimProgram p
ON c.ProgramSK = p.ProgramSK

















------------------------------------------------------------------------------------------------------------
--2. What classes (course & section) did students complete in a semester & what were their grades
SELECT
s.StudentID 'Student ID', 
(s.FirstName+' '+s.LastName) 'Student Name',
(c.Name +' , '+ ds.Name) 'Class',
f.LetterGrade 'Grade',
CASE WHEN dce.Status = 'Inactive' THEN 'Semester Complete' END 'Current Status'
FROM FactGrades f 
JOIN DimStudent s ON f.StudentSK = s.StudentSK
JOIN DimCourse c
ON f.CourseSK = c.CourseSK
JOIN DimSection ds
ON f.CourseSK = ds.CourseSK
JOIN DimCourseEnrollment dce
ON f.CourseEnrollmentSK = dce.CourseEnrollmentSK
AND dce.Status = 'Inactive'








----------------------------------------------------------------------------------------------------------
-- 3. What were the enrollment and drop dates if applicable for students in each class in a semester

SELECT distinct c.Name AS CourseName,ds.StartDate as 'Enrollment Date', de.EndDate 'Drop Date', dt.semester, (c.Name +' , '+ dst.[Name]) 'Class'
FROM DimCourseEnrollment e
join DimCourse c on e.CourseEnrollmentSK = c.CourseEnrollmentSK
left join DimStartDate ds on ds.StartDate = e.EnrollmentStartDateSK
left join DimEndDate de on de.EndDate = e.EnrollmentEndDateSK
inner join DimTerm dt on dt.TermSK = c.TermSK
inner join DimSection dst on dst.coursesk = c.CourseSK











----------------------------------------------------------------------------------------------------------
-- 4. Who were the teachers in each class above
select c.Name as 'Course Name', CONCAT(t.FirstName, ' ', t.LastName) as 'Professor Name' , (c.Name +' , '+ dst.[Name]) 'Class'
from DimCourseEnrollment e 
join DimCourse c on e.CourseEnrollmentSK = c.CourseEnrollmentSK
join DimTeacher t on t.TeacherSK = c.TeacherSK
inner join DimSection dst on dst.coursesk = c.CourseSK












----------------------------------------------------------------------------------------------------------
--5. What were the classes taught each semester


with courseEnrollment as (

Select distinct
dsd.CalendarYear,ce.CourseEnrollmentSK
from DimCourseEnrollment ce
join DimStartDate dsd on dsd.StartDate = ce.EnrollmentStartDateSK

)

select  distinct
t.Semester as 'Term' 
,ce.CalendarYear as 'Year' 
,STRING_AGG(c.Name,' , ') as 'Course Offerings'
from DimCourse c 
join courseEnrollment ce on ce.CourseEnrollmentSK = c.CourseEnrollmentSK
join DimTerm t on t.TermSK = c.TermSK
group by t.Semester,ce.CalendarYear







----------------------------------------------------------------------------------------------------------
--6. What teachers taught classes in a degree program in a semester
with courseEnrollment as (

Select  distinct
d.CalendarYear
,ce.CourseEnrollmentSK
from DimCourseEnrollment ce
join DimStartDate d on d.StartDate = ce.EnrollmentStartDateSK

)

select distinct

t.Semester as 'Term' 
,ce.CalendarYear as 'Year' 
,STRING_AGG(CONCAT(te.FirstName, ' ', te.LastName) ,' , ') as 'Teacher Name' , dp.ProgramName
from DimCourse c 
join DimTeacher te on te.TeacherSK = c.TeacherSK
join courseEnrollment ce on ce.CourseEnrollmentSK = c.CourseEnrollmentSK
join DimTerm t on t.TermSK = c.TermSK
inner join DimProgram dp on dp.ProgramSK = c.ProgramSK
group by t.Semester,ce.CalendarYear, dp.ProgramName


-----------------------------------------------------------------------------------------------------------------------------------
--7.Who are the students enrolled in a degree program and attributes such as ID, email, date of birth (DOB), hometown, campus/off-campus address if applicable, etc

SELECT 
s.FirstName+' '+s.LastName 'Student Name',
p.ProgramName 'Degree Program',
s.Email,
ofa.City+' '+ofa.State+', '+ofa.Country 'Off Campus Address',
oca.City+' '+oca.State+', '+oca.Country 'On Campus Address',
hta.City+' '+hta.State+', '+hta.Country 'HomeTownAddress Address',
s.Phone,
d.BirthDate 'Date Of Birth'
FROM DimStudent s JOIN DimProgram p ON
s.ProgramSK = p.ProgramSK
JOIN DimBirthDate d ON s.BirthDateSK = d.BirthDateSK
JOIN DimOffCampusAddress ofa ON  ofa.OffCampusAddressSK = s.OffCampusAddressSK
JOIN DimOnCampusAddress oca ON oca.OnCampusAddressSK = s.OnCampusAddressSK
JOIN DimHomeTownAddress hta ON hta.HomeTownAddressSK  = s.HomeTownAddressSK


