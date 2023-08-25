--[문제1] 기본테이블은 EMP_COPY로 합니다. 20번 부서에 소속된 사원들의 
--       사번과 이름, 부서번호와 상관의 사번을 출력하기 위한 select문을 emp_view20이라는 이름의 뷰로 정의해 보세요.
create view emp_view20 
as 
select empno, ename, deptno, mgr
from emp_copy
where deptno = 20;

--[문제2] 각 부서별 최대 급여와 최소 급여를 출력하는 뷰를 sal_view 라는 이름으로 작성하세요.
create view sal_view
as
select deptno, max(sal) as SalMax , min(sal) as SalMin
from emp_copy
group by deptno;

--[문제3] 인라인뷰를 이용하여 급여를 많이 받는 순서대로 3명만 출력하는 뷰(sal_top3_view)를 작성하세요.

create view sal_top3_view 
as
select rownum as 순위, empno, ename, sal
from (select empno, ename, sal
      from emp 
      order by sal desc)
where rownum <= 3;

--[문제4] 사원중에서 급여를 가장 많이 받는 사원 7명만을 출력하는 명령문을 인라인 뷰를 이용해서 구현해 보세요.
select rownum, empno, ename, sal
from (select empno, ename, sal
      from emp 
      order by sal desc)
where rownum <= 7;


--[문제5] 입사일자를 기준으로 내림차순으로 정렬을 해서 5와 10사이의 존재하는 사원을 출력해 보세요.
select rownum, e.*
from (select rownum rnum, empno, ename, sal
      from (select empno, ename, sal
            from emp
            order by sal desc)) e
where (rnum >= 5) and (rnum <= 10);


--[문제6] tjoeun/tiger 계정을 생성해서 순번/사원번호/이름/직업/근무부서(컬럼)의 항목을 갖는 테이블을 만들어서 데이터를 저장하되 
--       순번 데이터 입력은 sequence를 이용하여 저장하고, view_acorn 뷰를 생성해서 순번/사원번호/이름만 출력할 수 있도록 만들어보세요.
c:\>sqlplus system/admin1234 -- 관리자 계정 로그인
SQL>create user tjoeun identified by tiger; -- 계정 생성
SQL>grant create session to tjoeun; -- 접속 권한 부여
SQL>grant create table to tjoeun;   -- 테이블 생성 권한 부여
SQL>alter user tjoeun quota 2m on system; -- 메모리 저장소 공간 할당

SQL>conn tjoeun/tiger

create table emp01 (
    num number(4) constraint memos_num_pk primary key,
    empno number(4),
    ename  varchar2(20),
    job    varchar2(20),
    deptno number(2)
);

create sequence emp01_seq
start with 1 increment by 1;

create view view_acorn
as
select num, empno, ename
from tjoeun;


