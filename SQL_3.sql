--nvl fonksiyonunu kullanarak null değerlere 0 atama işlemi yaptık.
select avg(commission_pct), avg(nvl(commission_pct,0)) from hr.employees
select salary + (salary+nvl(salary*commission_pct,0)) from hr.employees

--gruplama yapmak son derece önemlidir. hangi diyorsan group by kullanacaksın. burada ilk olarak dp_idye göre grubladık. daha sonra aynı olanları kendi içerisinde jb_idye göre sıraladık. order by vererek güze görüntü elde ettik.
select department_id,job_id,sum(salary) from hr.employees group by department_id, job_id order by 1 desc

--rowid görünmezdir. ve çok hızlı aynı zamanda az maliyetlidir.
select rowid, employee_id from hr.employees

-- having where gibidir. fakat group by dan sonra yazılır. matematiksel fonksiyon kullanılacaksa having tercih edilir.
-- join yaparken kartezyen yapmak çok kötüdür. axb dir.
select e.employee_id, d.department_name from hr.departments d, hr.employees e  

--join yaparken iki türlü yazım vardır biri eski diğeri yeni.
--eski
select e.employee_id, d.department_name from hr.departments d, hr.employees e  
where e.department_id=d.department_id 
--yeni
select e.employee_id, d.department_name from hr.departments d join hr.employees e  
on e.department_id=d.department_id 

select c.FirstName, c.CustomerId , c.City , e.EmployeeId ,e.City  from Employee e join Customer c
on c.SupportRepId = e.EmployeeId --yeni yazım

select c.FirstName , c.CustomerId ,c.City , e.EmployeeId , e.City  from Employee e , Customer c 
where e.EmployeeId = c.SupportRepId --eski yazım 

select e.City , c.City  from Employee e join Customer c on e.EmployeeId = c.SupportRepId 

--birden fazla tablo birbirine bağlandı
select DISTINCT e.FirstName , e.LastName ,t.UnitPrice  from Employee e  left join Customer c 
on c.SupportRepId = e.EmployeeId 
join Invoice i 
on c.CustomerId = i.CustomerId 
join InvoiceLine il 
on i.InvoiceId = il.InvoiceId 
join Track t 
on il.TrackId = t.TrackId 

--left right join
--eski
select e.employee_id, d.department_name from hr.departments d, hr.employees e  
where e.department_id (+) = d.department_id 
--yeni
select e.employee_id, d.department_name from hr.departments d right join hr.employees e  
on e.department_id=d.department_id 

--full JOİN
select e.employee_id, d.department_name from hr.departments d full join hr.employees e  
on e.department_id=d.department_id 


