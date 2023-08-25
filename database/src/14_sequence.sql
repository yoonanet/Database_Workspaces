-- * 오라클 - 시퀀스(Sequence)

--[1] 샘플테이블 생성
create table memos(
    num      number(4)    constraint memos_num_pk primary key,
    name     varchar2(20) constraint memos_name_nn not null,
    postDate Date         default(sysdate)
);

-- 제약 조건을 걸고 그 데이터를 삭제할 때 그 기능을 체크해야하는데 
-- 오라클에서 스스로 관리해주는 기능(null값도 안되고 중복도 안되도록 - 기본키의 기능)
-- sequence가 일련번호를 생성해주는 객체(_명령어는 DDL)이다.

-- 시퀀스는 고유번호를 오라클에서 자동적으로 생성해주는 기능을 제공한다. -> 의미 기억하기.

--[2] 해당 테이블의 시퀀스 생성
create sequence memos_seq
start with 1 increment by 1; --1부터 시작해서 번호를 1씩 증가하는 sequnce를 생성

--[3] 데이터 입력 : 일련번호 포함
insert into memos(num, name) values(memos_seq.nextVal, '홍길동');
insert into memos(num, name) values(memos_seq.nextVal, '이순신'); 
insert into memos values(memos_seq.nextVal, '강감찬', default); 
insert into memos values(memos_seq.nextVal, '유관순', default); 
insert into memos values(memos_seq.nextVal, '장영실', default); 
--원래는 기본키로 설정한 num은 우리가 번호를 관리해야함. (1부터 넣으면서)
--memos_seq.nextVal을 하게 되면 기본키의 번호 값을 넣지 않아도 순차적으로 부여해줌

--[4] 현재 시퀀스가 어디까지 증가되어져 있는지 확인.
select memos_seq.currVal from dual; -- 현재 5까지 데이터가 삽입되어져 있음

--[5] 시퀀스 수정 : 최대 증가값을 9까지로 제한을 두고 싶다면.
alter sequence memos_seq maxValue 9;

insert into memos values(memos_seq.nextVal, '안창호', default);
insert into memos values(memos_seq.nextVal, '안중근', default);
insert into memos values(memos_seq.nextVal, '김구', default);
insert into memos(num, name) values(memos_seq.nextVal, '홍길동');
insert into memos(num, name) values(memos_seq.nextVal, '이순신'); -- 9개가 max라 실행이 안됨.

alter sequence memos_seq maxValue 100; 
insert into memos values(memos_seq.nextVal, '세종대왕', default);

--객체와 관련된 명령어를 DDL / CLUD와 관련된 명령어는 DML -> 기억해두기.
--[6] 시퀀스 삭제
drop sequence memos_seq;

--작업을 하다 보면 시퀀스가 제대로 동작되지 않는 상황도 발생할 수 있다.
--[7] 시퀀스 없는 상태에서 자동 증가값 구현?
select max(num) from memos;

insert into memos(num, name)
values((select max(num)+1 from memos), '김정희'); -- values에서 select가 먼저 실행됨.

select * from memos;

