--burada tarih aratırken veri tabanında hangi tipte varolduğunu bilemediğimizden tutturmaya çalıştık.
select * from hr.employees where hire_date='01/01/00'select * from hr.employees where hire_date='01-Mar-00'
select * from hr.employees where hire_date='17-JUN-03'select * from hr.employees where employee_id=100

select * from hr.employees where hire_date='17-06-03' --problem
select * from hr.employees where salary > '10000' ---problem

--istediğimiz tipteki ay kullanımını belirtiriz. Dönüştürücüdür.
--Bu sayade ay kullanımında istediğimiz şekilde ay tipini belirleyip tutturma şansımızı %100 yapabiliriz.
--Ekrana bastırırken kullanırız. 'tarih alanı var ekrana basacaksın'
select last_name, hire_date,TO_CHAR(hire_date, 'fmDD Month YYYY') AS HIREDATE from hr.employees
select last_name, hire_date,TO_CHAR(hire_date, 'MM-DD / YYYY') AS HIREDATE from hr.employees
select last_name, hire_date,TO_CHAR(hire_date, 'YYYY') AS HIREDATE from hr.employees
select last_name, hire_date,TO_CHAR(hire_date, 'YYYY') AS HIREDATE from hr.employees WHERE TO_CHAR(hire_date, 'YYYY')='2003'

-- Burada TO_cHAR yardımı ile salary kısmını daha da anlaşılır bir şekilde ekrana yazdırdık. 
-- Burada kullanılan 'l' lokasyonu belirtir ve veri tabanı nerede ise oranın birim işaretini ekrana yazdırır.
select salary, TO_CHAR(salary, 'l99,999.00') SALARY from hr.employees

--to_Date fonksiyonu filtreleme tarafında kullanılır. 
-- alan tarhi bir şekilde filtre olarak kullanmak istediğimizde kullanırız.
select last_name, TO_CHAR(hire_date,'DD-Mon-YYYY') from hr.employees where hire_date > TO_DATE('01-Jan-90', 'DD-Mon-RR')

--sistemin default tarih ayarını değiştirmek için kullanırız;
alter session set nls_date_format = 'DD_MM_YYYY hh24:mi:ss'
select sysdate from dual

--NVL fonksiyonunu kullanarak null olana değerleri 0 olarak değiştirdik.
select last_name, salary, NVL(commission_pct,0),
to_char((salary*12)+(salary*12*NVL(commission_pct,0)), 'l999,999.00') AN_SAL 
from hr.employees

--NVL2 fonksiyonunu null değer ise bunu yaz null değer değilse bunu yaz şeklinde bir kullanım sunar
select last_name, salary, commission_pct,
NVL2(commission_pct, 'SAL_COMN','SAL') income
from hr.employees

-- CASE sql de koşul sunarken kullandığımız operatördür.
-- case = 'eğer bu'
-- when = 'böyle ise'
-- then = 'bunu yap'
-- anlamına gelir. 
select last_name,job_id,salary, 
        CASE job_id WHEN 'IT_PROG' THEN 1.10*salary
                    WHEN  'ST_CLERK' THEN 1.15*salary
                    WHEN  'SA_REP' THEN 1.20*salary
        ELSE        salary END    "REVİSED_SALARY" 
FROM hr.employees

--En sert kural en düşük kuraldır. Kural koyarken en düşük kuralı ilk olarak yazmamız gereklidir. 
select last_name, salary, 
    (CASE when salary < 5000 then 'low' 
          when salary < 10000 then 'medium' 
          when salary < 20000 then 'great' 
        ELSE 'Excellent' 
        end) qualified_salary 
FROM hr.employees

-- Decode case gibidir. Sadece biraz daha havalı.
select last_name,job_id,salary, 
        DECODE(job_id, 'IT_PROG', 1.10*salary, 
                       'ST_CLERK', 1.15*salary, 
                       'SA_REP', 1.20*salary, 
                salary) 
                REVİSED_SALARY 
FROM hr.employees

--analetik sql yazarken genellikle over kelimesi kullanılır. eski veriler ile şuan olan verileri karşılaştırmamızı sağlar.
--geçen ay ne kadar dı? şimdi ne kadar? gibi.
-- partıtıon by over ile kullanılır. Verilen özelliğe göre parçalama yapar.
--Örneğin idsi 10 olanlar, idsi 20 olanlar gibi
select first_name, department_id,salary, sum(salary) over (PARTITION BY department_id order by salary) as depstal 
from hr.employees order by department_id 


--En baştan şimddiki sıraya kadar demektir. En baştan sona kadar toplar.
SELECT employee_id, first_name, salary, SUM (salary) OVER
(Partition by department_id ORDER BY employee_id ROWS BETWEEN unbounded
PRECEDING AND current row) AS cumul FROM hr.employees ORDER BY employee_id;

--burada bir önceki ile bir sonraki toplanır.
SELECT employee_id, first_name, salary, SUM (salary) OVER
(Partition by department_id ORDER BY employee_id ROWS BETWEEN 1
PRECEDING AND 1 FOLLOWING) AS cumul FROM hr.employees ORDER BY employee_id;

--burada ilk değeri diğer değerlere atar.
SELECT first_name, department_id, FIRST_VALUE (salary)
OVER (PARTITION BY department_id ORDER BY employee_id) AS deptsal
FROM hr.employees ORDER BY department_id;

-- bir öncekini verir.
SELECT employee_id, first_name, salary, LAG (salary, 1)
OVER (ORDER BY salary) AS LAG1 FROM hr.employees;

-- bir sonrakini verir.
SELECT employee_id, first_name, salary, LEAD (salary, 1)
OVER (ORDER BY salary) AS LEAD1 FROM hr.employees;

-- aynı özelliklere sahip olanları yan yana yazar.
SELECT department_id, LISTAGG (first_name, ',')
WITHIN GROUP (ORDER BY department_id) AS newList FROM hr.employees
GROUP BY department_id;

-- yalnızca ilk 5 satırı getirir.
select first_name,last_name,salary from hr.employees order by salary
fetch first 5 rows only;


-- Maaşa göre rank verir
SELECT department_id, last_name, salary, RANK () OVER
(PARTITION BY department_id ORDER BY salary DESC) "Rank" FROM hr.employees
WHERE department_id = 60 ORDER BY department_id, "Rank", salary;

SELECT department_id, last_name, salary, RANK () OVER (PARTITION BY department_id
ORDER BY salary DESC) "Rank", DENSE_RANK () OVER (PARTITION BY department_id
ORDER BY salary DESC) "Drank" FROM hr.employees
WHERE department_id = 60 ORDER BY "Rank";

SELECT department_id, last_name, salary,
PERCENT_RANK () OVER (PARTITION BY department_id ORDER BY salary)
AS pr FROM hr.employees WHERE department_id = 60 ORDER BY department_id, pr;