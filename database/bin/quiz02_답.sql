--[문제1] 30번 부서 소속의 사원 중에서 커미션을 받는 사원의 수를 구해보세요.

SQL>select count(*)
	from emp
	where comm > 0 
	and deptno = 30 ;

select count(*)
	from emp
	where nvl(comm,0) <>0 ;

--[문제2] 가장 최근에 입사한 사원의 입사일과 입사한 지 가장 오래된 사원의 입사일을 출력하는
           쿼리문을 작성해 보세요.

SQL>select min(hiredate) "Old", max(hiredate) "New"
	from emp;

--[문제3] SCOTT과 동일한 부서에서 근무하는 사원의 이름을 출력하세요.

SQL>select ename
from emp
where deptno = (select deptno
                             from emp
                             where ename = 'SCOTT' ); 

--[문제4] 직급이 'SALESMAN'인 사원이 받는 급여들의 최소 급여보다 많이 받는 사원들의
           이름과 급여를 출력하되 부서 번호가 20번인 사원은 제외한다(다중행 연산자 이용).

SQL>select ename,sal
from emp
where sal>(select min(sal)
                  from emp
                  where job ='SALESMAN')
and deptno <> 20; 

SQL>select ename,sal
from emp
where sal>any(select sal
from emp
where job ='SALESMAN')
and deptno<>20;
--[문제5] 직급이 'SALESMAN'인 사원이 받는 급여들의 최대 급여보다 많이 받는 사원들의 
           이름과 급여를 출력하되 부서번호가 10번인 사원은 제외한다(다중행 연산자 이용).

SQL>select ename, sal 
from emp where sal > all ( 
select sal from emp 
where job='SALESMAN') 
and deptno <> 10;

--[문제6] 사원테이블(emp)과 부서 테이블(dept)을 join하여 사원 이름과 부서번호와 부서명을
           출력하세요. 단 40번 부서의 부서 이름도 출력되도록 쿼리문을 작성하세요.

SQL>select ename, emp.deptno, dname 
	from emp full outer join dept 
	on emp.deptno=dept.deptno;

--[문제7] 뉴욕에서 근무하는 사원의 이름과 급여를 출력하세요(join 이용).

SQL> select ename, sal 
	from emp, dept 
	where emp.deptno = dept.deptno 
	and dept.loc ='NEW YORK';


SQL> select ename, sal 
	from emp inner join dept 
	on emp.deptno = dept.deptno
	where dept.loc = 'NEW YORK';