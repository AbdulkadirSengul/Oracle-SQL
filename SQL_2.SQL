--hangi tablolara erişebildiğimizi gösterirken kullanıyoruz.
select table_name, owner from all_tables

--hangi tablo bizim onu görmemiz için kullanıyoruz.
select * from user_tables

--where ile filtreleme yaparken kullanırız.
select * from hr.employees where employee_id=101
select * from hr.employees where last_name = 'King';
select * from hr.employees where lower(last_name)= 'king';
select * from hr.employees where salary = 20000
select * from hr.employees where salary > 20000

--where ile filtreleme yapıyorduk. burada kullanılan in ise parantez içerisinde olan sayıların filtrelenen şeye göre uyanları getir demektir. not in kullanır isek uyanları getirme demiş oluruz.
select * from hr.employees where department_id in (10,20,30)

--bir databasenin mimarisini verir.
describe hr.employees

-- burada kullanılan between arasında olanları kastetmektedir. and ise iki şartı da sağlayanları getir demektir.
select * from hr.employees where salary between 5000 and 10000

-- burada iki tane filtreleme işi uyguladık ve and kullanarak iki şartı da sağlamasını istediğimiz belirttik.
select * from hr.employees where salary > 5000 and department_id=50

--burada or kullanarak iki şarttan en az bir tanesini sağlması gerektiğini belirttik.
select * from hr.employees where salary > 5000 or department_id = 50

--burada like ve % işareti kullanarak belirtilen şeye göre içerisinde başında,sonunda veya ortalarında belirtilen şeyleri aramış olduk.
select * from hr.employees where last_name like 'G%' --başlangıç
select * from hr.employees where last_name like '%e' --son
select * from hr.employees where last_name like '%r%' --orta

-- burada null olanları ortaya çıkarmaya çalıştık.
select * from hr.employees where commission_pct is null

-- burada belirtilen özelliğe göre sıralamayyı yaptık. desc diyerek büyükten küçüğe sıralamış olduk.
select * from hr.employees where salary > 1000 order by salary desc

-- burada görmek istediğimiz özellikleri yazıp order by ile hangisine göre sıralanacağını belirtmiş olduk.
select employee_id, salary, email from hr.employees order by 2

-- burada belirtilen özelliğe göre sıraladık. belirtilen özelliklerli aynı olanları diğer belirttiğimiz özelliğe göre sıralamış olduk.
select * from hr.employees where salary > 1000 order by salary desc, first_name

-- burada bir özelliğin en büyüğünü, endüşüğünü ve ortalamasını aldık.
select max(salary),min(salary),avg(salary) from hr.employees 

-- burada belirtilen özelliğe göre gruplandırma yaptık. yani --Her department id nin max,min ve avgsi
select department_id, max(salary),min(salary),avg(salary) from hr.employees group by department_id

-- burada belirtilen özellikle kaç tane satır olduğunu hesapladık. commission un az çıkamsının nedeni null ifadeleri barındırdığı içindir.
select count(*), count(email), count(salary), count(commission_pct) from hr.employees

--round yuvarlama yapar.
select round(avg(salary),2),avg(salary) from hr.employees

-- burada dual ifadesi siri gibidir. söylersin yapar.
select 8*6 from dual