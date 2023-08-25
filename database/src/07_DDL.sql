-- * 오라클 SQL문 : 테이블 생성/수정/삭제
--                  (DDL: Data Definition Language) => 테이블에 관련된 작업이다. 
--                   테이블과 관련되었기 때문에 검색(_데이터와 관련 있음 DML)과는 관련이 없다.
-- DDL의 명령어들을 살펴볼 예정이다.
-- 내가 원하는 데이터를 넣기 위해선 테이블을 먼저 만들어야 한다.


-- [1] 테이블 생성 : create table문
create table exam01(
    exno number(2), 
    exname varchar2(20), 
    exsal number(7, 2)
);
--create table 테이블명(컬럼명 컬럼의 자료형들-위는 3개의 특징을 가지는 테이블을 생성);
--오라클 11버전 부터는 drop table로 삭제하면 임시 휴지통에 이름을 변경해서 보관됨. 그래서 나중에 복원이 가능함

select * from tab; --테이블 확인
desc exam01; --컬럼 확인
select * from exam01;

-- [2] 기존 테이블과 동일하게 테이블 만들기
create table exam02
as
select * from emp;
-- 기존(원본) 테이블은 냅두고, 기존 테이블에 있는 데이터들을 새로운 테이블 그대로 추가할 때(생성과 동시에 만드는 개념)
-- 즉, 샘플 테이블을 만드는 것(테스트를 위하여.)

select * from exam02; -- emp테이블에서 그대로 옮겨지는 것을 확인할 수 있다.

-- [3] 기존 테이블에서 새로운 컬럼 추가 : alter문(필드추가)
alter table exam01 
add (
    exjob varchar2(10)
);
-- alter 수정해달라는 키워드, add 추가 키워드

select * from exam01;
desc exam01;

-- [4] 테이블 구조 수정 : 필드 수정
-- 부분적인 수정(데이터 타입의 크기)
alter table exam01
modify(
    exjob varchar2(20)
);

desc exam01;

-- [5] 테이블 구조 수정 : 필드 삭제
alter table exam01
drop column exjob;

-- [6] 테이블 수정 : 이름 변경
-- 방법1
alter table exam01 rename to test01;

-- 방법2(간단적용)
rename test01 to exam01;

select * from tab; -- 확인용

-- [7] 테이블 삭제
drop table exam01; --삭제는 되지만 임시저장소에 임시테이블로 저장됨
drop table exam01 purge; --임시저장소에 저장하지 않고 완전히 삭제가 됨
drop table exam02 purge;

purge recyclebin; --임시로 보관중인 테이블들을 일괄 삭제됨

-- [8] 테이블 내의 모든 데이터(레코드) 삭제
truncate table exam02;

select * from exam02; -- 확인용


