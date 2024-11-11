--1.Initialize DB
if not exists (select* from sys.databases where name = 'carerhub')
begin 
create database careerhub;
end;
--2.Creating tables

--Creating companies table 
create table companies
(CompanyId int primary key identity(1,1),
 companyname varchar(100) not null,
 location varchar(100) );

 --creating jobs table 
 create table jobs(
 JobId int primary key identity(1,1),
 CompanyId int,
 jobtitle varchar(100) not null,
 jobdescription text ,
 joblocation varchar(100) not null,
 salary decimal check (salary>0),
 jobtype varchar(50) not null,
 posteddate datetime not null,
constraint FK_companies_job 
foreign key (CompanyId) references companies(CompanyId))

--creating table applicants 
create table Applicants (
 ApplicantID int primary key identity(1,1),
FirstName varchar(50) not null,
LastName varchar(50) not null,
Email varchar(100) UNIQUE not null,
Phone varchar(15) not null,
Resume text)

--creating application table
create table Applications (
ApplicationId int primary key identity(1,1),
Jobid int,
ApplicantID int,
Applicationdate datetime not null,
Coverletter text,
constraint FK_applications_job foreign key (JobId) references jobs(JobId),
constraint FK_applications_applicants foreign key (ApplicantID) references applicants(ApplicantID)
);

--Inserting into Companies table 
insert into Companies(companyname, location) 
values 
('Hexaware', 'Bangalore'),
('Mindtree', 'Mumbai'),
('Accenture', 'Chennai'),
('Infosys', 'Hyderabad')

--Inserting into jobs table 
insert into jobs (companyid, jobtitle, jobdescription, joblocation, salary, jobtype, posteddate) 
values 
(1, 'Software Developer', 'Develop and maintain web applications', 'Bangalore', 600000.00, 'Full-time','2024-09-10'),
(2, 'Data Analyst', 'Analyze complex data sets', 'Mumbai', 150000.00, 'Part-time', '2024-10-18'),
(3, 'Project Manager', 'Manage projects from start to finish', 'Chennai', 800000.00, 'Contract', '2024-09-29'),
(4, 'UX Designer', 'Design user-friendly interfaces and experiences', 'Hyderabad', 700000.00, 'Full-time', '2024-10-20')

--inserting into applicants table 
insert into Applicants(FirstName, LastName, Email, Phone, Resume) 
values 
('Fiza', 'Shaikh', 'fiza.shaikh@gmail.com', '9876543210', 'Experienced in Java and Python'),
('Swetha', 'Kumar', 'swetha.kumar@gmail.com', '9123456789', 'Data Science and Analytics Expert'),
('Godlin', 'Donya', 'godlin.donya@gmail.com', '9988776655', 'Project Management and Scrum Master Certified'),
('Harini', 'Reddy', 'harini.reddy@gmail.com', '9765432109', 'UI/UX Designer with experience in Figma')

--inserting into Applications table 
insert into applications (Jobid, ApplicantID, Applicationdate, Coverletter) 
values 
(1, 1, '2024-09-12', 'Looking forward to working on exciting software projects.'),
(2, 2, '2024-10-19', 'Passionate about analyzing data and making data-driven decisions.'),
(3, 3, '2024-09-29', 'Experienced in managing large-scale projects effectively.'),
(4, 4, '2024-10-21', 'Excited to contribute to user experience.');

select * from companies
select * from jobs
select * from Applicants
select * from Applications

--QUERIES 
/*5. Write an SQL query to count the number of applications received for each job listing in the
"Jobs" table. Display the job title and the corresponding application count. Ensure that it lists all
jobs, even if they have no applications.*/

select j.jobtitle , count(a.ApplicantID) as Applicant_count
from jobs j 
left join Applications a
on j.JobId = a.Jobid
group by j.jobtitle


/*6. Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary
range. Allow parameters for the minimum and maximum salary values. Display the job title,
company name, location, and salary for each matching job. */

select j.jobtitle , c.companyname, c.location 
from jobs j join companies c 
on j.CompanyId = c.CompanyId 
where j.salary  between 150000 and 80000

/*7. Write an SQL query that retrieves the job application history for a specific applicant. Allow a
parameter for the ApplicantID, and return a result set with the job titles, company names, and
application dates for all the jobs the applicant has applied to.*/ declare @ApplicantId int set @ApplicantId = 1 select j.jobtitle , c.companyname, a.applicationdate from Applications a inner join jobs j  on a.Jobid = j.JobId inner join companies c on j.CompanyId = c.CompanyId where a.ApplicantID= @ApplicantId  /*8. Create an SQL query that calculates and displays the average salary offered by all companies for
job listings in the "Jobs" table. Ensure that the query filters out jobs with a salary of zero. */

select avg(salary) as Average_Salary 
from jobs where salary>0

/*9. Write an SQL query to identify the company that has posted the most job listings. Display the
company name along with the count of job listings they have posted. Handle ties if multiple
companies have the same maximum count*/

insert into jobs (CompanyId,jobtitle,jobdescription,joblocation,salary,jobtype,posteddate)
values(1,'Database Administrator','Manage and optimize databases','Banglore ',40000.00,'Full-time','2024-11-01' )

select top 1  c.companyname , count(j.CompanyId) as job_count
from companies c 
join jobs j 
on c.CompanyId = j.CompanyId
group by c.companyname
order by job_count desc

/*10. Find the applicants who have applied for positions in companies located in 'CityX' and have at
least 3 years of experience.*/

alter table applicants 
add Experience int 
update applicants
set Experience =5
where ApplicantID=1

update applicants
set Experience =4
where ApplicantID=2

update applicants
set Experience =2
where ApplicantID=3

update applicants
set Experience =3
where ApplicantID=4
select*from Applicants

select CONCAT_WS(' ',a.FirstName, a.LastName  ) as Applicant_Name , j.jobtitle , c.companyname , a.experience
from Applications ap
inner join jobs j on ap.Jobid = j.JobId
inner join companies c on j.CompanyId = c.CompanyId
inner join Applicants a on ap.ApplicantID = a.ApplicantID
where c.location = 'Mumbai'
and a.Experience >= 3


/*11. Retrieve a list of distinct job titles with salaries between $60,000 and $80,000. */
select distinct jobtitle from jobs
where salary>=60000 and salary<=80000

/*12. Find the jobs that have not received any application*/
select j.jobtitle, j.joblocation, j.salary
from  jobs j
left join applications a on j.JobId = a.JobId
where a.ApplicationId IS NULL;

/* 13. Retrieve a list of job applicants along with the companies they have applied to and the positions
they have applied for.*/
select CONCAT_WS(' ',a.FirstName, a.LastName  ) as Applicant_Name , j.jobtitle , c.companyname 
from applications ap
inner join applicants a ON ap.ApplicantID = a.ApplicantID
inner join jobs j ON ap.JobId = j.JobId
inner join companies c ON j.CompanyId = c.CompanyId;

/*14. Retrieve a list of companies along with the count of jobs they have posted, even if they have not
received any applications. */

select c.companyname , count(j.jobid) as jobcount
from companies c left join jobs j 
on c.companyId = j.companyid 
group by c.companyname 

/*15. List all applicants along with the companies and positions they have applied for, including those
who have not applied. */

select CONCAT_WS(' ',a.FirstName, a.LastName  ) as Applicant_Name , j.jobtitle , c.companyname 
from applications ap
left join applicants a ON ap.ApplicantID = a.ApplicantID
left join jobs j ON ap.JobId = j.JobId
left join companies c ON j.CompanyId = c.CompanyId;

/*16. Find companies that have posted jobs with a salary higher than the average salary of all jobs. */
select c.companyname , j.jobtitle 
from companies c join jobs j 
on c.CompanyId = j.CompanyId
where j.salary > (select avg(salary ) from jobs )

/*17. Display a list of applicants with their names and a concatenated string of jobname and joblocation */
select CONCAT_WS(' ',a.FirstName, a.LastName  ) as Applicant_Name , CONCAT_WS(',',j.jobtitle,j.joblocation) as jobdetails
from Applicants a 
join Applications ap
on a.ApplicantID = ap.ApplicantID
join jobs j on
ap.Jobid = j.JobId

/*18. Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'. */
select jobtitle 
from jobs 
where jobtitle like '%Developer' or 
jobtitle like 'Engineer'

/*19. Retrieve a list of applicants and the jobs they have applied for, including those who have not
applied and jobs without applicants. */

select CONCAT_WS(' ',a.FirstName, a.LastName  ) as Applicant_Name , j.jobtitle , c.companyname 
from applications ap
full join applicants a ON ap.ApplicantID = a.ApplicantID
full join jobs j ON ap.JobId = j.JobId
full join companies c ON j.CompanyId = c.CompanyId;

/*20. List all combinations of applicants and companies where the company is in a specific city and the
applicant has more than 2 years of experience. For example: city=Chennai */

declare @city varchar(20)
set @city= 'Chennai'

select CONCAT_WS(' ',a.FirstName,a.LastName), c.companyname
from Applicants a 
cross join companies c
where c.location = @city and a.experience>2

