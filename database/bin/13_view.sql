-- * 오라클-뷰(View)

--[1] 기본테이블 생성
--  (1) DEPT 테이블을 복사한 DEPT_COPY 테이블을 생성해서 사용하도록 함.
create table DEPT_COPY
as
select * from DEPT;

--  (2) EMP 테이블을 복사한 EMP_COPY 테이블을 생성해서 사용하도록 함.
create table EMP_COPY
as
select * from EMP;

--[2] 뷰(view) 정의하기
-- ex) 만일 30번 부서에 소속된 사원들의 사번과 이름과 부서번호를 자주(수시로) 검색한다고 가정하면
select empno, ename, deptno
from emp_copy
where deptno = 30;

--[view를 생성할 수 있는 권한 부여]
-- . 명령프롬프트 창에서 sqlplus system/admin1234 로 연결.
-- 권한 부여: SQL> grant create view to scott; -> Grant succeeded가 나오면 권한이 부여된 것임.

-- 가상의 테이블을 만들어서 그 가상의 테이블에서 반복되는 작성문을 볼 수 있게끔 함.
create view emp_view30 --가상의 테이블 정의(불러낼 때 테이블처럼 인식함)
as --쿼리문 연결
select empno, ename, deptno
from emp_copy
where deptno = 30; --관리자에게 권한을 받아야만 가상의 테이블을 생성할 수 있다. 따라서 에러남
--DDL은 객체에 대한 명령어이다. --> 따라서 테이블과 같은 명령이 view에도 적용되는 것이다.
--as를 하여 copy본에서는 데이터 무결성 제약 조건의 속성까지 복사되진 않는다. 따라서 따로 설정을 해줘야 한다.

select * from emp_view30; --view는 보안용으로 많이 적용이 된다.(완전히 오픈되지 말아야 할 테이블에서 일부 컬럼만 공개함)

desc emp_view30;

--[문제] 기본테이블은 emp_copy로 합니다. 20번 부서에 소속된 사원들의 사번과 이름, 부서번호,
--      상관의 사번을 출력하기 위한 select문을 emp_view20이라는 이름의 뷰로 정의해 보세요.
create view emp_view20 
as 
select empno, ename, deptno, mgr
from emp_copy
where deptno = 20;

--[3] 뷰의 내부 구조와 user_views 데이터 딕셔너리
desc user_views; -- 뷰정보와 관련된 데이터 정보를 업데이트하여 관리해주는 가상테이블이다.
select view_name, text from user_views;

--[4] 뷰의 동작 원리(pdf 참조)
--[5] 뷰와 기본 테이블 관계 파악
--   1. 뷰를 통한 데이터 저장이 가능?
insert into emp_view30 --가상에 테이블에 데이터를 입력하면
values(8000, 'ANGEL', 30);

select * from emp_view30; --가상테이블에 입력한 데이터는 저장이 된 것처럼 보여지고 있음

--가상테이블이 바라보고 있는 기본테이블에도 같이 적용이 되어 있음, 전달된 값만 들어가고 전달되지 않은 값은 defualt로 null값으로 저장됨
--노출되지 않은 컬럼 항목이 not null의 무결성 제약 조건으로 걸려있다면 저장이 되지 않는다.

--   2. insert문에 뷰(emp_view30)를 사용했지만, 뷰는 쿼리문에 대한 이름일 뿐,
--      새로운 레코드는 기본 테이블(emp_copy)에 실질적으로 추가되는 것이다.
select * from emp_copy;

--[6] 뷰의 특징
--  1. 단순 뷰(한 개의 테이블)에 대한 데이터 조작
insert into emp_view30
values(8010, 'cheolsoo', 30);

select * from emp_view30;
select * from emp_copy;

--     1) 단순 뷰의 컬럼에 별칭 부여하기
create view emp_view_copy(사원번호, 사원명, 급여, 부서번호) --()안에 별칭 부여
as
select empno, ename, sal, deptno
from emp_copy;

select * from emp_view_copy;

--별칭으로 부여한 이름들은 검색 시 기존 컬럼이름으로 접근할 수 없다. 즉, 별칭을 부여하면 그 별칭이 컬럼의 이름이 된다.
select * from emp_view_copy
where deptno = 30; -- error

select * from emp_view_copy
where 부서번호 = 30;

--     2) 그룹 함수를 사용한 단순 뷰
create view view_sal
as
select deptno, sum(sal), avg(sal)  --물리적인컬럼 = 기본테이블을 가리킴
from emp_copy
group by deptno;--error(기존에 존재하지 않는 컬럼명이기 때문)

create view view_sal
as
select deptno, sum(sal) as SalSum, avg(sal) SalAvg  
from emp_copy
group by deptno; --그룹함수를 사용할 때에는 별칭을 부여해줘야 한다.

select * from view_sal;
select * from emp_copy;

create view view_sal_year
as
select ename, sal*12 SalYear
from emp_copy;

select * from view_sal_year;

insert into view_sal_year
values('miae', 12000); --가상의 컬럼으로 값을 허락하지 않는다는 error남

--  2. 복합 뷰(두 개 이상의 테이블)
create view emp_view_dept
as
select empno, ename, sal, e.deptno, dname, loc
from emp e, dept d
where e.deptno = d.deptno
order by empno desc; --두 개 이상의 테이블을 참조해서 만들어진 뷰

select * from emp_view_dept;

--[7] 뷰 삭제
drop view emp_view_dept;

--[8] 뷰 생성에 사용되는 다양한 옵션(or replace) 
create or replace view emp_view30 --기존에 emp_view30의 뷰가 있었으면 생성 시 기존테이블을 삭제하고 현재 만드는 테이블로 만듦
as
select empno, ename, comm, deptno
from emp_copy
where deptno = 30;
--즉, 기존 존재 여부 상관 없이 무조건 생성해주는 옵션, 기존 존재하는 뷰이면 그 내용을 변경함.

--[9] 뷰 생성에 사용되는 다양한 옵션(force/noforce)
desc employees;
--오라클에서 테이블을 객체로 바라본다.
select * from employees;

create or replace view employees_view
as
select empno, ename, deptno
from employees
where deptno = 30; -- error

create or replace force view employees_view --force 강요하다는 의미
as
select empno, ename, deptno
from employees
where deptno = 30; --오류가 발생했음에도 뷰를 생성하고 있음

select view_name, text
from user_views; --view가 생성되었는지 확인하면 생성 되어져 있다는걸 확인할 수 있다.

select * from employees_view; --뷰만 생성했을 뿐이지 이 안에 테이블을 가지고 오는 것은 당연히 수행 되지 않는다.
--즉 이름만 생성된 것이다. (뷰의 이름만 사용하고자 할 때 생성을 하는 것이다.)

insert into employees_view
values(8020, '철수', 30); --error 데이터 삽입조차 되지 않는다.

--기본이 no force인 것이다. // force는 이런 옵션이 있다는 것을 알면 된다.

--[10] 뷰 생성에 사용되는 다양한 옵션(with check option)
create or replace view emp_view30
as
select empno, ename, sal, comm, deptno
from emp_copy
where deptno = 30;

select * from emp_view30;

-- 예시) 30번 부서에 소속된 사원중에 급여가 1200 이상인 사원은 20번 부서로 이동 시켜보세요.
-- 기존 데이터를 옮겨주는 수정작업
select * from emp_view30;

update emp_view30
set deptno = 20
where sal >= 1200; -- 여러 사람이 공유하는 경우에는 문제 발생.


create or replace view view_chk30
as
select empno, ename, sal, comm, deptno
from emp_copy
where deptno = 30 with check option; -- 조건에 만족하면 변경이 안되도록 고정시켜 놓는 것이다.(특정 항목의 데이터를 변경하지 못하도록 함)

update view_chk30
set deptno = 20
where sal >= 600;

select * from view_chk30;

--[11] 뷰 생성에 사용되는 다양한 옵션(with read option)
create table emp_copy30
as
select * from emp;

create or replace view view_read30
as
select empno, ename, sal, comm, deptno
from emp_copy30
where deptno = 30 with read only; -- 뷰에서 수정작업을 하지 못하도록 하는 옵션이 read only

select * from view_read30;

update view_read30
set comm = 2000; --수정 안됨 (error)

--[12] Top 쿼리
select rownum, empno, ename, sal
from emp; --rownum 오라클 데이터베이스에서만 지원해주는 기능이다.
--rownum의미: 테이블 생성하면서 데이터를 삽입하는 순서를 보여줌(내부적 부여)
--           rownum은 삽입의 순서로 값은 고정이 된다.

select rownum, empno, ename, sal
from emp
order by sal; --정렬된 순서로 출력 (rownum 지정된 순서로 나옴)

--정렬된 순서로 rownum을 지정하고 싶을 때↓
create or replace view view_sal
as
select empno, ename, sal
from emp
order by sal; 

--가져온 순서대로 rownum이 업데이트 된다.

select rownum,empno, ename, sal
from view_sal;

--[1] rownum을 이용
select rownum, empno, ename, sal
from view_sal
where rownum <= 5; --정렬이 된 상태에서 1~5까지의 순번이 잘 출력이 된다.
--순서: 데이터를 테이블에서 가져온 후 where의 조건이 먼저 수행되고 그 다음에 조건에 부합되는 컬럼데이터가 출력됨
--where가 수행된 이후에 rownum이 부여된다.

--[2] inline view(인라인 뷰)를 이용
select rownum, empno, ename, sal -- 여기서 rownum은 값이 부여되지 않았음.
from (select empno, ename, sal -- 테이블 자리에 select문을 넣어줌 -> 서브쿼리의 기능을 주지만 넣는 자리가 다름
      from emp
      order by sal) --14개의 데이터를 오름차순으로 가져왔음
where rownum <= 5; --처음부터 데이터를 꺼내옴(만족했기 때문이다.)
--from에서 정렬된 값을 가지고 와서 조건을 보고 -> 컬럼을 수행(즉, 컬럼이 수행될 때 rownum의 순번이 부여됨)
--5번까지는 만족하지만 6번부터는 불만족임. 계속 6번으로만 리턴함 
--rownum은 5개의 숫자만 부여되어 있다고 이해해야한다.

--[문제] 급여를 순위로 봤을 때 3 ~ 7사이 범위에 들어오는 사원 정보를 출력하세요.(rownum과 인라인뷰를 사용해서)
--게시판에서 화면에 보여줄 수 있는 정도에서 사용됨.
select rownum, empno, ename, sal -- 아직 부여되지 않은 rownum으로 조건이 수행되면 번호가 부여된다.
from (select empno, ename, sal
      from emp 
      order by sal) --수행돼서 가져오는 결과는 sal의 정렬값 (테이블 형태로 값을 리턴해줌)
      --안에 있는 테이블은 고정되어 있음.
where (rownum >= 3) and (rownum <= 7); --논리연산자와 연계가 있음 (and는 둘 다 참이여야 true이다.)
-- 1번부터 false가 나옴 -> 버림. 그렇게 되면 rownum은 부여가 되어있지 않기 때문에 1만 계속 리턴하게 됨 -> 무한 false임
-- 조건이 수행되는 때는 from으로 테이블을 가져오고(sal의 정렬값을 가져오고), 필드값이 출력되기 이전.
-- 왜 에러가 나는지? 이전 데이터값이 없기 때문에 계속 1을 가져옴 -> 반복되어 아무값을 만들 수 없는 것이다.
-- 위는 원하는 결과가 도출되지 않는다.

select rownum, e.*
from (select rownum rnum, empno, ename, sal --rownum은 리턴직전에 확정됨. / 밖에 있는 rownum이름과 충돌이나서 별칭을 붙여줘야 함
      from view_sal) e --번호부여가 끝난상태에서 가져오면 수행이된다.(리턴받은 상태에서 땡겨오는 것)
where (rnum >= 3) and (rnum <= 7); --여기 rownum에서 바라보는 값은 테이블 상에 데이터이다.


--[문제] 사원중에서 급여를 가장 많이 받는 사원 7명만을 출력하는 명령문을 인라인 뷰를 이용해서 구현해 보세요

select rownum, empno, ename, sal
from (select empno, ename, sal
      from emp 
      order by sal desc)
where rownum <= 7;

--[문제] 입사일자를 기준으로 내림차순으로 정렬을 해서 5와 10사이의 존재하는 사원을 출력해 보세요.
select rownum, e.*
from (select rownum rnum, empno, ename, sal
      from (select empno, ename, sal
            from emp 
            order by sal desc)) e
where (rnum >= 5) and (rnum <= 10);
