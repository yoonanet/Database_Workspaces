-- 1. 급여가 1500 이하인 사원의 사원번호, 사원 이름, 급여를 출력하는 SQL 문을 작성해 보시오.

select empno, ename sal from emp where sal <= 1500;

-- 2. 사원번호가 7521 이거나 7654 이거나 7844 인 사원들을 검색하는 쿼리문을 비교 연산자와 논리 연산자 OR로 작성할 수 있지만, 이번에는 IN 연산자를 사용하여 작성해 보시오.

select empno, sal from emp where empno in (7521, 7654, 7844);


-- 3. 사원 번호가 7521도 아니고 7654도 아니고 7844도 아닌 사원들을 검색하는 쿼리문을 작성하시오.

select empno, ename from emp where empno <> 7521 and empno <> 7654 and empno <> 7844; -- 방법1

select empno, ename from emp where empno not in (7521, 7654, 7844); -- 방법2



-- 4. 사원들 중에서 이름이 J로 시작하는 사람만을 찾는 쿼리문을 작성해 보시오.

select empno, ename from emp where ename like 'J%';

-- 5. 상관이 없는 사원(CEO가 되겠지요!)을 검색하기 위한 SQL 문을 작성해 보시오.

select * from emp where mgr is NULL;


-- 6. EMP 테이블의 자료를 입사일을 오름차순으로 정렬하여 최근 입사한 직원을 먼저 출력하되 사원번호, 사원명, 직급, 입사일 칼럼을 출력하는 쿼리문을 작성하시오. 

select empno, ename, job, hiredate 
from emp 
order by hiredate;


-- 7. EMP 테이블의 자료를 사원번호를 기준으로 오름차순으로 정렬하여 사원번호와 사원명 칼럼을 표시하시오.

select empno, ename from emp order by empno asc;


-- 8. 부서 번호가 빠른 사원부터 출력하되 같은 부서내의 사원을 출력할 경우 최근에 입사한 사원부터 출력하도록 하되 사원 번호, 입사일, 사원 이름, 급여 순으로 출력하시오.

select empno, hiredate, ename, sal 
from emp 
order by deptno asc, hiredate asc; 
