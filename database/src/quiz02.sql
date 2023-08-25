--[문제1] 30번 부서 소속의 사원 중에서 커미션을 받는 사원의 수를 구해보세요.
select count(*) 
from emp
where comm > 0 
and deptno = 30;

--[문제2] 가장 최근에 입사한 사원의 입사일과 입사한 지 가장 오래된 사원의 입사일을 출력하는 쿼리문을 작성해 보세요.
select max(hiredate) "New", min(hiredate) "Old" 
from emp;

--[문제3] SCOTT과 동일한 부서에서 근무하는 사원의 이름을 출력하세요.
select e1.ename
from emp e1 , emp e2
where e1.deptno = e2.deptno
and e2.ename = 'SCOTT';

select ename
from emp
where deptno = (select deptno
                from emp
                where ename = 'SCOTT' );

--[문제4] 직급이 'SALESMAN'인 사원중 최소 급여보다 많이 받는 사원들의 이름과 급여를 출력하되 부서 번호가 20번인 사원은 제외한다(다중행 연산자 이용).
select ename, sal
from emp
where sal > (select min(sal)
            from emp
            where job = 'SALESMAN')
 and deptno <> 20;


--[문제5] 직급이 'SALESMAN'인 사원중 최대 급여보다 많이 받는 사원들의 이름과 급여를 출력하되 부서번호가 10번인 사원은 제외한다(다중행 연산자 이용).
select ename, sal
from emp
where sal > all (select sal
                from emp
                where job = 'SALESMAN')
and deptno <> 10;


--[문제6] 사원테이블(emp)과 부서 테이블(dept)을 join하여 사원 이름과 부서번호와 부서명을 출력하세요(단 40번 부서의 부서 이름도 출력되도록 쿼리문을 작성하세요).
select ename, emp.deptno, dname 
from emp full outer join dept 
on emp.deptno=dept.deptno;

--[문제7] 뉴욕에서 근무하는 사원의 이름과 급여를 출력하세요(join 이용).
select ename, sal
from emp, dept
where emp.deptno = dept.deptno
and dept.loc = 'NEW YORK';

--[문제8] 급여를 순위로 봤을 때 3 ~ 7사이 범위에 들어오는 사원 정보를 출력하세요.
select rownum, e.*
from (select rownum rnum, empno, ename, sal 
      from view_sal) e 
where (rnum >= 3) and (rnum <= 7);

