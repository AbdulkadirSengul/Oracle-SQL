--sorgularımızı yazarken maliyetini öğrenmek için bu kodu kullanıyoruz;
explain plan for select * from hr.employees

SELECT plan_table_output
FROM TABLE(DBMS_XPLAN.DISPLAY('plan_table',null,'typical'));

--Subqueri

--106 idli adamın maaşından fazla olanları getir.
select * from hr.employees where employee_id=106 --maaşı 4800
select first_name from hr.employees where salary > 4800 

--106 idli adamın maaşının 4800 olduğunu nereden biliyordun?
--tam burada subqueri devreye giriyor.
select first_name from hr.employees where salary>(select salary from hr.employees where employee_id=106)

--subqueri de tek bir değer dönüyorsa büyük, küçük, eşit,eşit değil gibi matematiksel ifadeler kullanılabilir.

--Daviesten sonra işe girenleri listele.
--() içerisinde ki sorguda ilk önce daviesin işe girme tarhini bulduk.
-- daha sonra ondan sonra işe girenleri döndürdük.
select first_name, hire_date from hr.employees where hire_date>(select hire_date from hr.employees where last_name='Davies')

--işi ernst ile aynı olacak fakat  maaşı ernsten fazla olacak?
--ilk parantezde ernstin job idisini bulduk
-- ikinci parantezde ernstin maaşını bulduk
-- en sonda iki parantezi sağlayanı ekrana yazdırdık.
select last_name, job_id, salary from hr.employees where job_id=(select job_id from hr.employees where last_name='Ernst')
and salary>(select salary from hr.employees where last_name='Ernst')


--department idsi 10 olan departmanın en düşük maaşından fazla olan departmanların en düşük maaşını getir.
select department_id, min(salary) from hr.employees group by department_id
having min(salary)>(select min(salary) from hr.employees where department_id=10)

--job idsi Hunold ile aynı olanları getir
select last_name,job_id from hr.employees where job_id = (select job_id from hr.employees where last_name='Hunold')

--birden fazla değer gelebilir ise o zaman ne yapacağız?.
--any;
-- ANY DERKEN HERHANGİBİR TANESİ DEMİŞ OLURUZ.
-- parantez içerisinde ıt_progların herbirininin maaşına baktık.(9000,6000,4800,4800,4200)
-- burada any kullanarak HERHANGİ bir salaryden yüksek olanları getirdik.
-- çıktıda 4400 salarysi olanda geldi çünkü 4200 salaryden yüksekti.
select employee_id, first_name, job_id, salary from hr.employees where salary > any (select salary from hr.employees where job_id ='IT_PROG')


--all;
-- ALL DERKEN HEPSİNDEN DEMİŞ OLURUZ.
-- parantez içerisimde 30 idli çalışanların maaşına baktık(11000,3100,2900,2800,2600,2500)
-- burada all kullanarak çıkan maaşların 30 idli çalışanların HEPSİNİN maaşından yüksek olanları ekrana yazdırdık. 
-- yani aslında en yüksek maaşa göre işlem yapmış olduk
select department_id, first_name, salary from hr.employees where salary > all (select salary from hr.employees where department_id=30)

-- ıt progda çalışanların maaşından herhangi bir tanesinden yüksek olanları yazdır fakat ıt progdakileri ekrana bastırma.
select employee_id , salary, job_id, last_name from hr.employees where salary < any
(select salary from hr.employees where job_id='IT_PROG')
and job_id <> 'IT_PROG'