-- * 오라클 SQL문 : 서브쿼리(Sub-Query)문

-- ex) 'SCOTT'이 근무하는 부서명, 지역 출력.
-- 조인(서로 다른 테이블 안에 조인)을 사용하지 않고 위에 예시사항을 처리하는 방법 (두 번으로 나누어서 실행)
select deptno
from emp
where ename = 'SCOTT'; -- 근무부서 : 20

select dname, loc
from dept
where deptno = 20; 

-- subquery: 조건절에 의해서 연산자와 함께 또 하나의 select문을 작성할 수 있도록 한다. 
-- 중복(중복사항이 많을 때 DB수정 시 복잡함)과 손실(ex. 사원이 한명있는 부서에서 사원이 퇴사 시 부서자체에 대한 정보가 손실)을 최소화
-- 하나의 select문에 두 개 이상의 select문이 존재할 수 있다는 것이다.
-- 나뉘어진 테이블에 접근할 수 있는 요소가 되는 것이다.


--[단일행 서브쿼리]
select dname, loc --메인쿼리
from dept
where deptno = (select deptno --서브쿼리(우선순위가 높다)
                from emp
                where ename = 'SCOTT'); --연산에서 괄호()는 우선 연산임 _ 서브쿼리도 똑같이 적용됨
                
--[예제] 'SCOTT'와 동일한 직급(job)을 가진 사원을 출력하는 sql문을 서브쿼리를 이용해서 작성해 보세요 (하나의 테이블안에 정보가 다 있음)
select ename, job
from emp
where job = (select job
             from emp
             where ename = 'SCOTT');
--하나의 테이블 안에서 원하는 정보가 두 개일때도 서브쿼리를 이용해서 불러낼 수 있다.

--[예제] 'SCOTT'의 급여와 동일하거나, 더 많이 받는 사원이름과 급여를 출력해 보세요.
select ename, sal
from emp
where sal >= (select sal
              from emp
              where ename = 'SCOTT');

--[서브쿼리 & 그룹함수]
-- 전체 사원 평균 급여보다 더 많은 급여를 받는 사원을 출력하세요.
select ename, sal
from emp
where sal > (select avg(sal)
             from emp);

--[다중행 서브쿼리]             
-- 예제) 급여를 3000 이상 받는 사원이 소속된 부서와 동일한 부서에서 근무하는 사원들의
--      정보를 출력하세요.
select ename, sal, deptno
from emp
where deptno = (select deptno
                from emp
                where sal >= 3000); --error_서브쿼리문에 의해서 결과가 두개 이상이 나왔기 때문이다.
                -- 10과 20의 결과 값이 나오기 때문에 비교를 할 수 없다.(하나의 값으로 비교할 수 있다.)
                
-- 두 개 이상의 결과 값이 나왔을 때 서브쿼리를 이용하는 방법
--   (1) [in 연산자]
select ename, sal, deptno
from emp
where deptno in (select deptno
                from emp
                where sal >= 3000); --in연산자는 서브쿼리에서 사용되고 수행의 결과값이 복수 개일 때 의미가 있는 것이다.                 

--[문제] in 연산자를 이용하여 부서별로 가장 급여를 많이 받는 사원의 정보(사원번호, 사원명, 급여, 부서번호)를 출력하세요.
select * from emp;

select empno, ename, sal, deptno
from emp
where sal in (select max(sal)
              from emp 
              group by emp.deptno);

--   (2) [all 연산자]
--[예시] 30번(부서번호) 소속 사원들 중에서 급여를 가장 많이 받는 사원보다 더 많은 급여를 받는 사원의 이름과 급여를 출력하세요.
select max(sal) from emp
where deptno = 30; -- 2850

--[단일행 서브쿼리 & 그룹함수]
select ename, sal
from emp
where sal > (select max(sal)
             from emp
             where deptno = 30); --30번 부서에서 급여를 가장 많이 받는 사원: 2850받음
             
             
select ename, sal
from emp
where sal > (select sal
             from emp
             where deptno = 30);-- errer(30번 부서의 모든 사원의 급여가 출력돼서 에러남) 
             
--[다중행 서브쿼리]
select ename, sal
from emp
where sal >all (select sal
                from emp
                where deptno = 30); --6개의 데이터를 모두 만족해야 한다는 의미 -> 안에 있는 값들을 다 비교함. 다 만족할 경우 반환됨.
             

--[문제] 영업사원(salesman)들 중에 급여를 가장 많이 받는 영업 사원보다 
--      더 많은 급여를 받는 사원들의 이름과 급여를 출력하되 영업사원은 출력하지 않게 
--      명령문을 작성해 보세요. 
select ename, sal
from emp
where sal > all (select max(sal)
                 from emp
                 where job = 'SALESMAN');

--   (3) [any 연산자]
--[예제] 부서번호가 30번인 사원들의 급여 중에서 가장 낮은 급여보다 높은 급여를 받는 사원의 이름, 급여를 출력하는 명령문을 작성해 보세요.

--[단일행 서브쿼리 & 그룹 함수]
select ename, sal
from emp
where sal > (select min(sal)
             from emp
             where deptno = 30);
             
--[다중행 서브쿼리]
select ename, sal
from emp
where sal > any (select sal
                 from emp
                 where deptno = 30); --최소금액보다 큰 값을 만족할 경우 -> 하나라도 만족하면 조건이 만족하는 연산자가 필요함
                 --any: 모두를 만족할 때_ 최소값보다 크기만 하면, true를 반환하는 연산자이다.

--[문제] 영업 사원들의 최소 급여보다 많이 받는 사원들의 이름과 급여와 직급을 출력하되 영업사원은 출력하지 않습니다.(다중행 서브쿼리를 이용)
select ename, sal, job
from emp
where sal > any (select sal from emp
                where job = 'SALESMAN')
and job <> 'SALESMAN';
                
                
