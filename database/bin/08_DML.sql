-- * 오라클 SQL문 : 데이터 입력/검색(select)/수정/삭제 (데이터와 관련된 작업 명령어)
--                (DML:Data Manipulation Language)

-- [1] 샘플 테이블 생성
create table exam01(
    deptno number(2),
    dname  varchar2(14),
    loc    varchar2(14)
);

select * from exam01;

-- [2] 데이터 입력(저장)
insert into exam01(deptno, dname, loc) values(10, '회계부', '서울');
insert into exam01(dname, loc, deptno) values('연구부', '경기도', 20); -- 추천을 하지 않음
-- 테이블 앞에 명시한 필드 순서대로 값을 넣어야 한다. 
-- 필드 순서는 테이블에서 만든 필드 순서대로 만들지 않아도 됨(테이블 다음에 순서 지정시)

-- [3] 데이터 입력 (헤더 정보 생략 가능 -> 테이블 생성 시 지정한 필드 순서대로 데이터를 삽입해줘야 한다.)
insert into exam01 values(30, '영업부', '인천'); -- 실무에서 선호하는 방법

-- [4] null값 입력
insert into exam01 values(40, '관리부', null); -- null은 입력데이터가 없음에도 불구하고, error 방지를 위해 활용

-- [5] 데이터 출력(검색) : 03_select_command.sql 실습 참조.

-- [6] 데이터 변경(수정)
update exam01 set deptno = 50
where deptno = 40;

-- [7] 급여 10% 인상 금액 반영
-- 예제1
create table exam02
as 
select * from emp;

select * from exam02;

update exam02 set sal = sal * 1.1; -- 따로 조건을 걸지 않아서 전체적인 행이 변경됨.

-- [8] 부서번호가 10인 사원의 부서번호를 20으로 변경.
-- 예제2
update exam02 set deptno = 20
where deptno = 10;

-- [9] 급여가 3000 이상인 사원만 급여를 10% 인상.
-- 예제3
update exam02 set sal = sal * 1.1
where sal >= 3000;

-- [10] 사원 이름이 scott인 자료의 부서번호를 10, 직급을 manager로 변경.
-- 예제4
update exam02 set deptno = 10, job = 'MANAGER' -- 여러 개를 변경할 때는 콤마(,)로 구별
where ename = 'SCOTT'; -- 문자열 대소문자 꼭 구별

-- [11] 30번 부서 사원을 삭제(데이터 삭제)
delete from exam02 
where deptno = 30;

-- [12] 사원 전체 삭제(조건이 없으면 전체 데이터 삭제임)
delete from exam02; --truncate table exam02; 실행이랑 결과가 같음. 두 개의 차이점은? 내부 로직의 차이이다.
-- delete dml 명령으로 데이터를 날리는 것이고, 
-- truncate ddl 명령으로 데이터 부분의 테이블을 삭제(깔끔하게 삭제하고 데이터를 만들고자 할 때)해버리는 것이다. 
-- 눈으로 봤을 때의 결과는 동일함

select * from exam02;



