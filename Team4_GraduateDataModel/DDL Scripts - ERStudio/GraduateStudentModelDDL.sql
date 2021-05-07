/*
 * ER/Studio Data Architect SQL Code Generation
 * Project :      GraduateStudentModel.DM1
 *
 * Date Created : Monday, March 01, 2021 15:06:55
 * Target DBMS : Microsoft SQL Server 2017
 */

IF OBJECT_ID('Dim_Address') IS NOT NULL
BEGIN
    DROP TABLE Dim_Address
    PRINT '<<< DROPPED TABLE Dim_Address >>>'
END
go
IF OBJECT_ID('Dim_Date') IS NOT NULL
BEGIN
    DROP TABLE Dim_Date
    PRINT '<<< DROPPED TABLE Dim_Date >>>'
END
go
IF OBJECT_ID('DimCourse') IS NOT NULL
BEGIN
    DROP TABLE DimCourse
    PRINT '<<< DROPPED TABLE DimCourse >>>'
END
go
IF OBJECT_ID('DimCourseEnrollment') IS NOT NULL
BEGIN
    DROP TABLE DimCourseEnrollment
    PRINT '<<< DROPPED TABLE DimCourseEnrollment >>>'
END
go
IF OBJECT_ID('DimProgram') IS NOT NULL
BEGIN
    DROP TABLE DimProgram
    PRINT '<<< DROPPED TABLE DimProgram >>>'
END
go
IF OBJECT_ID('DimSection') IS NOT NULL
BEGIN
    DROP TABLE DimSection
    PRINT '<<< DROPPED TABLE DimSection >>>'
END
go
IF OBJECT_ID('DimStudent') IS NOT NULL
BEGIN
    DROP TABLE DimStudent
    PRINT '<<< DROPPED TABLE DimStudent >>>'
END
go
IF OBJECT_ID('DimTeacher') IS NOT NULL
BEGIN
    DROP TABLE DimTeacher
    PRINT '<<< DROPPED TABLE DimTeacher >>>'
END
go
IF OBJECT_ID('DimTerm') IS NOT NULL
BEGIN
    DROP TABLE DimTerm
    PRINT '<<< DROPPED TABLE DimTerm >>>'
END
go
IF OBJECT_ID('Fact_Grades') IS NOT NULL
BEGIN
    DROP TABLE Fact_Grades
    PRINT '<<< DROPPED TABLE Fact_Grades >>>'
END
go
/* 
 * TABLE: Dim_Address 
 */

CREATE TABLE Dim_Address(
    AddressSK           int             IDENTITY(1,1),
    City                nvarchar(10)    NULL,
    State               nvarchar(10)    NULL,
    Country             nvarchar(10)    NULL,
    SOR_ID              int             NULL,
    SOR_Load_Date       date            NULL,
    SOR_Update_Date     date            NULL,
    DI_Job_ID           int             NULL,
    DI_Create_Date      date            NULL,
    DI_Modified_Date    date            NULL,
    DI_Job_Name         varchar(40)     NULL,
    CONSTRAINT PK17 PRIMARY KEY NONCLUSTERED (AddressSK)
)
go



IF OBJECT_ID('Dim_Address') IS NOT NULL
    PRINT '<<< CREATED TABLE Dim_Address >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Dim_Address >>>'
go

/* 
 * TABLE: Dim_Date 
 */

CREATE TABLE Dim_Date(
    DateSK               int             IDENTITY(1,1),
    FullDateAK           date            NULL,
    DayNumberOfWeek      int             NULL,
    DayNameOfWeek        nvarchar(10)    NULL,
    DayNumberOfMonth     int             NULL,
    DayNumberOfYear      int             NULL,
    WeekNumberOfYear     int             NULL,
    MonthName            nvarchar(10)    NULL,
    MonthNumberofYear    int             NULL,
    CalendarQuarter      nvarchar(10)    NULL,
    CalendarYear         int             NULL,
    SOR_ID               int             NULL,
    SOR_LoadDate         date            NULL,
    SOR_Update_Date      date            NULL,
    DI_Job_ID            int             NULL,
    DI_Create_Date       date            NULL,
    DI_Modified_Date     date            NULL,
    DI_Job_Name          varchar(40)     NULL,
    CONSTRAINT PK16 PRIMARY KEY NONCLUSTERED (DateSK)
)
go



IF OBJECT_ID('Dim_Date') IS NOT NULL
    PRINT '<<< CREATED TABLE Dim_Date >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Dim_Date >>>'
go

/* 
 * TABLE: DimCourse 
 */

CREATE TABLE DimCourse(
    CourseSK               int             IDENTITY(1,1),
    CourseEnrollmentSK     int             NOT NULL,
    ProgramSK              int             NOT NULL,
    CourseID               int             NULL,
    CourseCode             varchar(10)     NULL,
    Name                   varchar(80)     NOT NULL,
    CoreCourseFlag         varchar(30)     NULL,
    CRNCode                varchar(80)     NULL,
    CreditHours            varchar(80)     NULL,
    Prerequisite           varchar(80)     NULL,
    Lab                    varchar(30)     NOT NULL,
    Room                   varchar(30)     NULL,
    InstructionalMethod    varchar(30)     NULL,
    CampusName             varchar(40)     NULL,
    TermSK                 int             NOT NULL,
    TeacherSK              int             NOT NULL,
    SOR_ID                 int             NULL,
    SOR_Load_Date          date            NULL,
    SOR_Update_Date        date            NULL,
    DI_Job_ID              int             NULL,
    DI_Create_Date         date            NULL,
    DI_modified_Date       date            NULL,
    DI_Job_Name            varchar(255)    NULL,
    CONSTRAINT PK3 PRIMARY KEY NONCLUSTERED (CourseSK, CourseEnrollmentSK)
)
go



IF OBJECT_ID('DimCourse') IS NOT NULL
    PRINT '<<< CREATED TABLE DimCourse >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE DimCourse >>>'
go

/* 
 * TABLE: DimCourseEnrollment 
 */

CREATE TABLE DimCourseEnrollment(
    CourseEnrollmentSK     int             IDENTITY(1,1),
    CourseEnrollmentID     int             NULL,
    EnrollmentStartDate    int             NULL,
    EnrollmentEndDate      int             NULL,
    Status                 varchar(30)     NULL,
    SOR_ID                 int             NULL,
    SOR_Load_Date          char(10)        NULL,
    SOR_Update_Date        date            NULL,
    DI_Job_ID              int             NULL,
    DI_Create_Date         date            NULL,
    DI_Modified_Date       date            NULL,
    DI_Job_Name            varchar(255)    NULL,
    CONSTRAINT PK10_1 PRIMARY KEY NONCLUSTERED (CourseEnrollmentSK)
)
go



IF OBJECT_ID('DimCourseEnrollment') IS NOT NULL
    PRINT '<<< CREATED TABLE DimCourseEnrollment >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE DimCourseEnrollment >>>'
go

/* 
 * TABLE: DimProgram 
 */

CREATE TABLE DimProgram(
    ProgramSK           int             IDENTITY(1,1),
    ProgramID           int             NULL,
    ProgramName         varchar(80)     NULL,
    ProgramCode         int             NULL,
    GradeLevel          varchar(80)     NULL,
    CollegeName         varchar(80)     NULL,
    Major               varchar(80)     NULL,
    Department          varchar(80)     NULL,
    UniversityName      varchar(10)     NULL,
    SOR_ID              int             NULL,
    SOR_Load_Date       date            NULL,
    SOR_Update_Date     date            NULL,
    DI_Create_Date      date            NULL,
    DI_Modified_Date    date            NULL,
    DI_Job_ID           int             NULL,
    DI_Job_Name         varchar(255)    NULL,
    CONSTRAINT PK4 PRIMARY KEY NONCLUSTERED (ProgramSK)
)
go



IF OBJECT_ID('DimProgram') IS NOT NULL
    PRINT '<<< CREATED TABLE DimProgram >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE DimProgram >>>'
go

/* 
 * TABLE: DimSection 
 */

CREATE TABLE DimSection(
    SectionSK             int            IDENTITY(1,1),
    SectionID             int            NOT NULL,
    Name                  varchar(80)    NULL,
    SectionNumber         int            NULL,
    CourseSK              int            NOT NULL,
    CourseEnrollmentSK    int            NOT NULL,
    SOR_ID                int            NULL,
    SOR_Create_Date       date           NULL,
    SOR_Load_Date         date           NULL,
    SOR_Update_Date       date           NULL,
    DI_Job_ID             int            NULL,
    DI_Create_Date        date           NULL,
    DI_Modified_Date      date           NULL,
    DI_Job_Name           char(10)       NULL,
    CONSTRAINT PK7 PRIMARY KEY NONCLUSTERED (SectionSK)
)
go



IF OBJECT_ID('DimSection') IS NOT NULL
    PRINT '<<< CREATED TABLE DimSection >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE DimSection >>>'
go

/* 
 * TABLE: DimStudent 
 */

CREATE TABLE DimStudent(
    StudentSK             int             IDENTITY(1,1),
    StudentID             int             NULL,
    FirstName             varchar(40)     NOT NULL,
    LastName              varchar(40)     NOT NULL,
    BirthDateSK           int             NULL,
    SSN                   bigint          NULL,
    GardeLevel            varchar(40)     NOT NULL,
    Ethinicity            varchar(40)     NOT NULL,
    Email                 varchar(100)    NOT NULL,
    Phone                 bigint          NOT NULL,
    Gender                varchar(10)     NULL,
    Status                varchar(10)     NULL,
    VisaType              varchar(40)     NOT NULL,
    StartDate             int             NULL,
    EndDate               int             NULL,
    OnCampusAddressSK     int             NULL,
    OffCampusAddressSK    int             NULL,
    HomeTownAddressSK     int             NULL,
    ProgramSK             int             NOT NULL,
    SOR_ID                int             NULL,
    SOR_Load_Date         date            NULL,
    SOR_Update_Date       date            NULL,
    DI_Job_ID             int             NULL,
    DI_Create_Date        date            NULL,
    DI_Modified_Date      date            NULL,
    DI_Job_Name           varchar(40)     NULL,
    CONSTRAINT PK11 PRIMARY KEY NONCLUSTERED (StudentSK)
)
go



IF OBJECT_ID('DimStudent') IS NOT NULL
    PRINT '<<< CREATED TABLE DimStudent >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE DimStudent >>>'
go

/* 
 * TABLE: DimTeacher 
 */

CREATE TABLE DimTeacher(
    TeacherSK           int             IDENTITY(1,1),
    TeacherID           int             NULL,
    FirstName           varchar(40)     NOT NULL,
    LastName            varchar(40)     NOT NULL,
    Gender              char(10)        NOT NULL,
    Email               varchar(60)     NOT NULL,
    Phone               bigint          NOT NULL,
    BirthDateSK         int             NULL,
    DepartmentName      varchar(100)    NULL,
    Status              char(10)        NULL,
    SOR_ID              int             NULL,
    SOR_Load_Date       date            NULL,
    SOR_Update_Date     date            NULL,
    DI_Job_ID           int             NULL,
    DI_Create_Date      date            NULL,
    DI_Modified_Date    date            NULL,
    DI_Job_Name         varchar(10)     NULL,
    CONSTRAINT PK12 PRIMARY KEY NONCLUSTERED (TeacherSK)
)
go



IF OBJECT_ID('DimTeacher') IS NOT NULL
    PRINT '<<< CREATED TABLE DimTeacher >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE DimTeacher >>>'
go

/* 
 * TABLE: DimTerm 
 */

CREATE TABLE DimTerm(
    TermSK              int            IDENTITY(1,1),
    TermID              int            NULL,
    Name                varchar(30)    NULL,
    Description         char(10)       NULL,
    TermPeriod          int            NULL,
    Semester            varchar(10)    NULL,
    SOR_ID              int            NULL,
    SOR_Load_Date       date           NULL,
    SOR_Update_Date     date           NULL,
    DI_Job_ID           int            NULL,
    DI_Create_Date      date           NULL,
    DI_Modified_Date    date           NULL,
    DI_Job_Name         char(10)       NULL,
    CONSTRAINT PK2 PRIMARY KEY NONCLUSTERED (TermSK)
)
go



IF OBJECT_ID('DimTerm') IS NOT NULL
    PRINT '<<< CREATED TABLE DimTerm >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE DimTerm >>>'
go

/* 
 * TABLE: Fact_Grades 
 */

CREATE TABLE Fact_Grades(
    GradesSK              int         IDENTITY(1,1),
    StudentSK             int         NOT NULL,
    TermSK                int         NOT NULL,
    MaxGradePoint         float       NULL,
    MinGradePoint         float       NULL,
    GPA                   float       NULL,
    LetterGrade           char(10)    NULL,
    QualityPoints         float       NULL,
    PassedHours           int         NULL,
    EarnedHours           int         NULL,
    AttemptHours          float       NULL,
    GPAHours              float       NULL,
    DateSK                int         NOT NULL,
    CourseSK              int         NOT NULL,
    CourseEnrollmentSK    int         NOT NULL,
    SOR_ID                int         NULL,
    SOR_Load_Date         date        NULL,
    SOR_Update_Date       date        NULL,
    DI_Job_ID             int         NULL,
    DI_Create_Date        date        NULL,
    DI_Modified_Date      date        NULL,
    CONSTRAINT PK6 PRIMARY KEY NONCLUSTERED (GradesSK)
)
go



IF OBJECT_ID('Fact_Grades') IS NOT NULL
    PRINT '<<< CREATED TABLE Fact_Grades >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Fact_Grades >>>'
go

/* 
 * TABLE: DimCourse 
 */

ALTER TABLE DimCourse ADD CONSTRAINT RefDimCourseEnrollment41 
    FOREIGN KEY (CourseEnrollmentSK)
    REFERENCES DimCourseEnrollment(CourseEnrollmentSK)
go

ALTER TABLE DimCourse ADD CONSTRAINT RefDimProgram8 
    FOREIGN KEY (ProgramSK)
    REFERENCES DimProgram(ProgramSK)
go

ALTER TABLE DimCourse ADD CONSTRAINT RefDimTerm10 
    FOREIGN KEY (TermSK)
    REFERENCES DimTerm(TermSK)
go

ALTER TABLE DimCourse ADD CONSTRAINT RefDimTeacher40 
    FOREIGN KEY (TeacherSK)
    REFERENCES DimTeacher(TeacherSK)
go


/* 
 * TABLE: DimCourseEnrollment 
 */

ALTER TABLE DimCourseEnrollment ADD CONSTRAINT RefDim_Date32 
    FOREIGN KEY (EnrollmentStartDate)
    REFERENCES Dim_Date(DateSK)
go

ALTER TABLE DimCourseEnrollment ADD CONSTRAINT RefDim_Date33 
    FOREIGN KEY (EnrollmentEndDate)
    REFERENCES Dim_Date(DateSK)
go


/* 
 * TABLE: DimSection 
 */

ALTER TABLE DimSection ADD CONSTRAINT RefDimCourse18 
    FOREIGN KEY (CourseSK, CourseEnrollmentSK)
    REFERENCES DimCourse(CourseSK, CourseEnrollmentSK)
go


/* 
 * TABLE: DimStudent 
 */

ALTER TABLE DimStudent ADD CONSTRAINT RefDimProgram42 
    FOREIGN KEY (ProgramSK)
    REFERENCES DimProgram(ProgramSK)
go

ALTER TABLE DimStudent ADD CONSTRAINT RefDim_Date30 
    FOREIGN KEY (StartDate)
    REFERENCES Dim_Date(DateSK)
go

ALTER TABLE DimStudent ADD CONSTRAINT RefDim_Date31 
    FOREIGN KEY (EndDate)
    REFERENCES Dim_Date(DateSK)
go

ALTER TABLE DimStudent ADD CONSTRAINT RefDim_Date35 
    FOREIGN KEY (BirthDateSK)
    REFERENCES Dim_Date(DateSK)
go

ALTER TABLE DimStudent ADD CONSTRAINT RefDim_Address37 
    FOREIGN KEY (OnCampusAddressSK)
    REFERENCES Dim_Address(AddressSK)
go

ALTER TABLE DimStudent ADD CONSTRAINT RefDim_Address38 
    FOREIGN KEY (OffCampusAddressSK)
    REFERENCES Dim_Address(AddressSK)
go

ALTER TABLE DimStudent ADD CONSTRAINT RefDim_Address39 
    FOREIGN KEY (HomeTownAddressSK)
    REFERENCES Dim_Address(AddressSK)
go


/* 
 * TABLE: DimTeacher 
 */

ALTER TABLE DimTeacher ADD CONSTRAINT RefDim_Date29 
    FOREIGN KEY (BirthDateSK)
    REFERENCES Dim_Date(DateSK)
go


/* 
 * TABLE: DimTerm 
 */

ALTER TABLE DimTerm ADD CONSTRAINT RefDim_Date45 
    FOREIGN KEY (TermPeriod)
    REFERENCES Dim_Date(DateSK)
go


/* 
 * TABLE: Fact_Grades 
 */

ALTER TABLE Fact_Grades ADD CONSTRAINT RefDim_Date43 
    FOREIGN KEY (DateSK)
    REFERENCES Dim_Date(DateSK)
go

ALTER TABLE Fact_Grades ADD CONSTRAINT RefDimCourse44 
    FOREIGN KEY (CourseSK, CourseEnrollmentSK)
    REFERENCES DimCourse(CourseSK, CourseEnrollmentSK)
go

ALTER TABLE Fact_Grades ADD CONSTRAINT RefDimStudent22 
    FOREIGN KEY (StudentSK)
    REFERENCES DimStudent(StudentSK)
go

ALTER TABLE Fact_Grades ADD CONSTRAINT RefDimTerm24 
    FOREIGN KEY (TermSK)
    REFERENCES DimTerm(TermSK)
go


