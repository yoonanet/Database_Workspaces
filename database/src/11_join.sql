-- * 오라클 SQL문 : 조인(join)

-- 효율적인 테이블 설계를 항상 생각하는 것이 중요함
-- 두 개의 테이블로 설계를 한 이유는? 중복데이터가 있을 때 분리해서 관리하기 위함이다.
-- 테이블에서 중복된 데이터가 많이 생기게 됨 -> 만약, 중복 데이터들에 수정사항이 생긴다면 전부 검색을 해서 바꿔줘야 함. 
-- 그러므로 데이터베이스에서는 중복 데이터를 최소화하는 것이 첫번째 테이블 설계 방법이다.
-- 하나의 테이블로 관리하게 되면 데이터 손실이 일어날 수 있다.(40번 부서 사람이 퇴사하면 그 데이터 자체가 사라질 수 있음_손실)
-- 따라서 dept와 emp에 있는 deptno를 무결성 제약 조건인 Foreign Key로 설정한다.
-- emp자식이 Foreign Key를 걸고 dept부모를 primary key로 걸어야 한다.  / 즉, 연관성이 있는 데이터를 연결한다는 것을 알아야 함.

--[1] 'SCOTT'이 근무하는 부서명, 지역 출력. -> scott의 정보를 emp에서 찾고 이를 토대로 부서명과 지역을 dept에서 찾아야 한다.
--     . 원하는 정보가 두 개 이상의 테이블에 나뉘어져 있을 때 원하는 결과를 출력.
select * from dept; -- 근무부서 정보:부서명, 지역
select * from emp;  -- 사원 정보

select deptno from emp
where ename = 'SCOTT'; -- scott에 부서넘버를 먼저 알아야 함.

select dname, loc
from dept
where deptno = 20; -- scott에 부서번호
-- 두 번에 select문을 통해 최종적인 결과를 도출


-- [2] join(조인) _두 개 이상의 나뉘어진 테이블에서 데이터를 한 번의 sql문으로 원하는 결과를 받을 수 있도록 함

--   (1) cross join _독립적인 개념에 있는 테이블들을(공통사항이 없는) 하나의 테이블로 만들어줄 수 있는 조인방법이다. 
select * from emp, dept; --(,)콤마를 이용해서 테이블을 조인해주는 것이 cross join이라고 한다.
--출력 시: 14번씩 4번(deptno_10,20,30,40) 반복함_단순 결합

--   (2) equi join_두 테이블에서 공통적으로 존재하는 컬럼의 값이 일치되는 행을 연결하여 결과를 생성하는 방법.
select * from emp, dept
where emp.deptno = dept.deptno; --조건을 줌_deptno이 같은 것만 출력하라 (단순결합에서 조건을 추가하여 추려내어 출력)

--   이름이 scott인 사원의 부서명, 위치 출력
select dname, loc, emp.deptno -- 출력할 필드명 추가 /* deptno로 쓸 경우 error
--동일한 컬럼명의 데이터 출력 시 (.)다음에 테이블명을 지정해줘야 한다.  
from emp, dept 
where emp.deptno = dept.deptno 
and ename = 'SCOTT'; --대상을 추가 (추가적인 세부조항은 and를 사용했음, 둘 다 만족)

-- 컬럼명 앞에 테이블명을 기술하여 컬럼 소속을 명확히 밝힐 수 있다.
select dept.dname, dept.loc, emp.deptno --deptno로 쓸 경우 error
from emp, dept 
where emp.deptno = dept.deptno 
and ename = 'SCOTT';

-- 테이블명에 별칭을 준 후 컬럼 앞에 소속 테이블을 지정하고자 할 때
-- 반드시 테이블명이 아닌 별칭으로 붙여서 접근을 해줘야 한다.
select d.dname, d.loc, e.deptno --deptno로 쓸 경우 error
from emp e, dept d 
where e.deptno = d.deptno 
and e.ename = 'SCOTT';

--   (3) non-equi join
select * from tab;
select * from emp;
select * from salgrade; --월 수령액 금액에 따라 5개의 단계로 나눈 테이블이다. (범위적인 개념을 담고 있는 테이블)

select ename, sal, grade
from emp, salgrade
where sal between losal and hisal;

select ename, sal, grade
from emp, salgrade
where sal >= losal and sal <= hisal;

-- emp, dept, salgrade 3개의 테이블 join
select ename, sal, grade, dname
from emp, salgrade, dept
where emp.deptno = dept.deptno
and sal between losal and hisal;

--   (4) self join -- 내 테이블을 참조하면서 조인하겠다는 의미이다.
select ename, mgr from emp; --사원의 담당 매니저 사원(mgr)

select employee.ename, employee.mgr, manager.ename
from emp employee, emp manager
where employee.mgr = manager.empno; --사장은 매칭되는 데이터가 없어서 안나옴

--   (5) outer join - 조건에 만족하지 못해서 누락되는 값까지 같이 출력하는 조인방법
select * from emp;

select employee.ename, employee.mgr, manager.ename
from emp employee, emp manager
where employee.mgr = manager.empno(+); -- +_(위치는 조건의 반대부분)를 통해 매칭이 되지 않는 데이터라고 해도 출력해줌


--[3] ANSI join - 표준이다.(협회에서 표준이라고 했을 뿐이지 DB를 사용할 때 무조건 표준을 따라야하는 것은 아니다./권고사항일 뿐이다.)
--  (1) Ansi Cross join - 오라클에서는 cross join 동일하다.
select * from emp cross join dept;

--  (2) Ansi inner join - 오라클에서는 equi join 동일하다.
select ename, dname
from emp inner join dept
on emp.deptno = dept.deptno;

select ename, dname
from emp inner join dept
using (deptno); -- ()괄호는 생략 X

--특정 개인에 대한 정보를 추가 조건으로 걸어서 결과 도출
select ename, dname
from emp inner join dept
on emp.deptno = dept.deptno
where ename = 'SCOTT';

--  natural join (간단하게 equi join 기능을 제공한다.)
--  두 테이블 간에 공통된 컬럼명이 존재해야 한다.
select ename, dname
from emp natural join dept;

--  (3) Ansi Outer join
drop table dept01 purge;

create table dept01(
    deptno number(2),
    dname  varchar2(14)
);

insert into dept01 values(10, 'ACCOUNTING');
insert into dept01 values(20, 'RESEARCH');


create table dept02(
    deptno number(2),
    dname  varchar2(14)
);

insert into dept02 values(10, 'ACCOUNTING');
insert into dept02 values(30, 'SALES');

select * from dept02;

--  기존 방법(오라클) - 매칭되지 않은 데이터도 출력하고자 할 때,
select * from dept01, dept02
where dept01.deptno = dept02.deptno(+);

select * from dept01, dept02
where dept01.deptno(+) = dept02.deptno;

select * from dept01, dept02
where dept01.deptno(+) = dept02.deptno(+); -- error
-- 오라클에서는 매칭되지 않은 데이터를 양쪽으로 출력해주는 기능을 제공하지 않는다.

-- Ansi 표준 협회 - Outer join
select * 
from dept01 left outer join dept02 --키워드를 이용해서 구분지음
on dept01.deptno = dept02.deptno;

select * 
from dept01 right outer join dept02 --키워드를 이용해서 구분지음
on dept01.deptno = dept02.deptno;

--매칭되지 않는 모든 데이터 양쪽을 출력하는 기능을 제공해줌
select * 
from dept01 full outer join dept02 --키워드를 이용해서 구분지음
on dept01.deptno = dept02.deptno;

