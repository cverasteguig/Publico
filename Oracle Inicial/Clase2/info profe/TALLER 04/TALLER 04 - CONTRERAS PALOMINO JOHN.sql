/*1*/
SELECT EMPLOYEE_ID, FIRST_NAME,LAST_NAME,SALARY FROM EMPLOYEES;

/*2*/
SELECT EMPLOYEE_ID, FIRST_NAME,LAST_NAME,SALARY 
FROM EMPLOYEES WHERE SALARY<=3000 ORDER BY SALARY DESC;

/*3*/
SELECT 
EMPLOYEE_ID ID, FIRST_NAME||','||LAST_NAME "DATOS DE EMPLEADO",SALARY SUELDO,
' ' COMISION 
FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NULL
ORDER BY SALARY;

/*4*/
DESCRIBE EMPLOYEES;

/*5*/
SELECT DISTINCT JOB_ID FROM EMPLOYEES;

/*6*/
SELECT 
EMPLOYEE_ID ID, FIRST_NAME||','||LAST_NAME||' -> '||JOB_ID "EMPLEADOS Y PUESTOS"
FROM EMPLOYEES;

/*7*/
SELECT 
FIRST_NAME||','||LAST_NAME EMPLEADOS, SALARY
FROM EMPLOYEES WHERE SALARY BETWEEN 13000 AND 17000;

/*8*/
SELECT 
LAST_NAME APELLIDOS, FIRST_NAME NOMBRES, JOB_ID PUESTO,SALARY SUELDO
FROM EMPLOYEES 
WHERE 
JOB_ID = 'SH_CLERK' AND
SALARY BETWEEN 2000 AND 3000;

/*9*/
SELECT 
LAST_NAME,FIRST_NAME, HIRE_DATE,SALARY
FROM EMPLOYEES
WHERE HIRE_DATE 
BETWEEN '01/01/2000' AND '31/01/2000'
ORDER BY HIRE_DATE;

/*10*/
SELECT last_name, salary
FROM employees
WHERE salary > &sal_amt;
--RPTA: MUESTRA LOS EMPLEADOS CON EL SUELDO MAYOR AL MONTO INGRESARO. 
--      SI SE EJECUTA OTRA VEZ EL QUERY, SE TIENE QUE INGRESAR EL MONTO MINIMO NUEVAMENTE.

/*11*/
SELECT 
LAST_NAME
FROM EMPLOYEES
WHERE LAST_NAME LIKE '___a%';

/*12*/
SELECT 
LAST_NAME,SALARY,JOB_ID
FROM EMPLOYEES
WHERE JOB_ID IN ('SH_CLERK' , 'MK_REP','HR_REP');