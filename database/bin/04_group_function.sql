/*　-> 주석문 2 방법
　- 오라클 명령어 
    : Group 함수
*/

-- [1] sum() : 합계
select sum(sal) 총급여 from emp;
-- 월급여 전체를 합함.

-- [2] count() : 카운트
select count(*) 사원수 from emp;
-- 레코드 데이터 갯수를 구함. (행의 갯수 = 데이터의 갯수)

-- [3] avg() : 평균
select avg(sal) "평균 급여" from emp; 

-- [4] max() : 최대값
select max(sal) "최고 급여 수령자" from emp;

-- [5] min() : 최소값
select min(sal) "최저 급여 수령자" from emp;

-- 이름이랑 금액을 같이 출력해라. 
/* select
    ename, -- 에러가 나는 이유? 데이터 갯수가 다름 / ename은 데이터 갯수가 14개임
    min(sal) "최저 급여 수령자" -- 함수로 계산된 결과의 데이터 갯수가 1개임
from emp; 

group함수는 일관성을 요구하는 것으로 특정 칼럼은 출력할 수 없다는 것은 이해를 해야한다.
또한, group함수는 기능의 묶음인데 통합적으로 컨셉을 일치시키기 위함이 있다.
EX) avg평균함수에서 ename을 출력하라고 했을 때 평균이기 때문에 이름을 출력할 수가 없다. */

-- [6] Group by 절 : 직업별 급여 평균
select * from emp;
select distinct job from emp; 

select job, avg(sal) from emp
group by job; -- 그룹별로 직업을 묶어두는 명령
--그룹명령과 그룹함수를 같이 사용할 수 있다.
--그룹군별로 그룹을 지정하였기 때문에 그룹대로 함수를 사용할 수 있어서 그룹함수를 같이 사용할 수 있는 것이다.

-- [7] Having 절 : 직업별 급여 평균(단, 급여 평균 2000이상 직업)
select job, avg(sal) from emp
group by job 
having avg(sal) >= 2000;
