-- * 오라클 명령어 : select문(검색) _select관련 옵션들　-> 주석문 1 방법

-- [1] scott 사용자가 관리하는 테이블 목록
select * from tab; -- 전체 테이블의 목록들을 보여주는 것임

select * from DEPT_EXERD;
select * from EMP_EXERD; 

-- [2] 특정 테이블의 구조(필드 리스트/데이터 형식/제약조건)
desc dept; -- 항목들의(특징들) 정보를 출력해줌
desc emp;

-- [3] 특정 테이블의 data 표시
select * from dept; -- 특정 테이블의 데이터 불러오기
select * from emp; -- 사원 정보에 대한 테이블

-- [4] 모든 컬럼(필드명)이 아닌, 필요한 컬럼(필드명) 내용만 출력
select 
    empno, -- 사원코드번호 
    ename, -- 사원이름
    job    -- 사원직업(직군)
from emp; 
-- *추가적인 설명(주석문_설명문)을 하기 위해서 이러한 형태로 작성하는 것을 선호함

-- [5] 각각의 필드명에 별칭을 주어서 출력 : as 생략 가능
select 
    deptno as 부서번호, -- 별칭을 부여(실행을 했을 때 본래 컬럼명이 아닌 부여한 별칭으로 출력됨)
    dname as 부서명,
    loc as 위치
from dept;

select 
    deptno 부서번호, -- as의 생략도 가능하다.
    dname 부서명,
    loc 위치 
from dept;

select 
    deptno "부서 번호", -- 별칭 중간에 여백을 넣어야할 때
    dname "부서명",
    loc 위치 -- 주의 : '' -> x
from dept;
--마지막 컬럼에는 콤마(,)가 오면 안된다.
--별칭을 부여할 때 중간에 그냥 여백을 넣으면 안된다.(오류남)
--별칭에 여백을 부여하고 싶을 때는 "부서 번호" 큰 따옴표 안에 넣어줘야 한다. 

-- [6] 사원들의 직업명을 중복 제거 후 출력
select * from emp;
select distinct job from emp;

-- [7] 급여가 3000 이상인 사원 정보 출력
select empno, ename, job, sal from emp 
where sal >= 3000;

-- [8] 이름이 scott 사원의 정보 출력
-- 단, 문자/문자열 data의 경우에는 대/소문자를 구별.
select * from emp
where ename = 'SCOTT';
--문자열일 경우 ''작은 따옴표로 감싸줘야 한다.(그래야 인식이 됨)
--문자열 데이터를 비교할 때는 대소문자를 구분하기 때문에 주의해야 한다.

-- [9] 1985년도 이후로 입사한 사원 정보
select empno, ename, hiredate
from emp
where hiredate >= '1985/01/01';
--날짜도 문자열과 같이 ''작은 따옴표로 감싸줘야 하고, 날짜는 년월일의 형태로 조건을 걸어줘야 한다.

-- [10] 부서번호가 10이고, 그리고 직업이 'MANAGER'인 사원 출력
select empno, ename, deptno, job from emp
where deptno = 10 and job = 'MANAGER'; -- 조건을 동시만족을 해야할 때는 and연산자를 사용한다.

-- [11] 부서번호가 10이거나, 직업이 'MANAGER'인 사원 출력
select empno, ename, deptno, job from emp
where deptno = 10 or job = 'MANAGER'; -- 조건을 둘 중 하나만 만족하는 결과를 받을 때 or연산자를 사용한다.

-- [12] 부서번호가 10이 아닌 사원
select empno, ename, deptno from emp
where not (deptno = 10);

-- [13] 급여가 1000 ~ 3000 사이인 사원을 출력
select ename, sal from emp
where sal >= 1000 and sal <= 3000;
-- where 1000 <= sal <= 3000; -> 오류가 나는 이유는? 비교연산자의 결과값은 true 또는 false가 옴 
-- 근데 비교연산자에서 피연산자는 숫자가 와야하는데 일차적으로 비교한 값이 참과 거짓의 값이 나와서 연산할 수가 없음.

-- [14] 급여가 1300 또는 1500 또는 1600인 사원 정보 출력
select ename, sal from emp
where sal = 1300 or sal = 1500 or sal = 1600;

-- 위를 간추리면
select ename, sal from emp
where sal in (1300, 1500, 1600);

-- 문자열과 관련된 검색 방법
-- [15] 이름이 'K'로 시작하는 사원 출력
select empno, ename from emp
where ename like 'K%';

-- [16] 이름이 'K'로 끝나는 사원 출력
select empno, ename from emp
where ename like '%K';

-- [17] 이름에 'K'가 포함되어 있는 사원 출력
select empno, ename from emp
where ename like '%K%'; -- K가 포함되면 다 검색하서 출력하라는 의미이다.

-- [18] 2번째 자리에 'A'가 들어가 있는 사원 출력
select empno, ename from emp
where ename like '_A%';

-- [19] 커미션을 받지 않는 사원 출력 => 성과금(COMM)
select empno, ename, comm from emp
where comm = 0 or comm = null; -- 수행할 수 없다.
-- null은 공간만 할당하고 의미있는 데이터가 들어가지 않았다는 의미의 키워드이다. (숫자가 아니다. 그래서 연산이 불가) 

select empno, ename, comm from emp
where comm = 0 or comm is null;
--is도 이다의 의미로 true와 false의 결과값이 나오게 된다.
--null을 연산자를 이용하여 연산할 때는 is의 키워드를 사용하는 것이다.

-- [20] 커미션을 받는 사원 출력
select empno, ename, comm from emp
where comm > 0;
-- null값(연산이 안되기 때문에)을 배제하여 누락된 것으로 온전하게 처리된 것이 아니다.

select empno, ename, comm from emp
where comm <> 0 and comm <> null;
-- 위에랑 똑같은 의미로 그냥 null이 연산의 의미가 없어서 배제된 것이다.

-- *원하는 결과는 ↓
select empno, ename, comm from emp
where comm <> 0 and comm is not null;
-- or은 값이 존재한다는 조건으로 봤을 때 사용하는 것이고, and는 금액적인 측면에서 존재한다고 조건을 보게 되면 사용하면 된다.
-- 상식적으로는 and로 사용하는 것이 정확한 표현이다.

-- [21] 사번의 정렬(오름차순)으로 출력 (정렬은 순서를 의미)
select empno, ename from emp
order by empno asc;

-- 이름순(오름차순)
select empno, ename from emp
order by ename asc; -- asc 생략 가능(defult가 asc이기 때문이다.)

-- [22] 사번의 정렬(내림차순)으로 출력
select empno, ename from emp
order by empno desc;

-- [23] 사원의 연봉 출력
select 
    ename, 
    sal, 
    sal * 12 연봉 
from emp;

-- [24] 커미션을 포함한 최종 연봉 출력
select 
    ename, 
    sal, 
    sal * 12 + comm 최종연봉 
from emp;

-- [25] [24]의 오류 해결법
select 
    ename, 
    sal,
    comm,
    sal * 12 + comm 최종연봉1,
    nvl(comm, 0), --함수이다. comm의 데이터에서 null이 나오면 0의 값으로 대체하라는 의미이다.
    sal * 12 + nvl(comm, 0) 최종연봉2
from emp;
