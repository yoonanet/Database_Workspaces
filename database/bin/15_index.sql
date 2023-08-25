-- * 오라클 - 인덱스(index) : 조회를 빠르게(빠른 검색)하도록 도와준다. 
--  오라클에서 index는 객체(_명령어는 DDL)로 해당한다.
--  index는 검색뿐만 아니라 삽입(insert)에서도 사용됨. / insert에서는 빠르게 검색이 선행이 되어 중복적인 부분을 최소화시킨다.
--  unique나 primary key 무결성 제약 조건에는 index의 기능이 탑제되어 있다.

--[1] 인덱스 정보 조회
select index_name, table_name, column_name
from user_ind_columns -->오라클에서 제공해주는 딕셔너리 뷰 가상테이블이다. / 인덱스에 대한 정보를 담고 있는 가상 테이블
where table_name in ('EMP', 'DEPT'); -- 두개의 테이블 정보를 출력

--출력 시 index_name에는 primary key가 있음
--column_name unique의 기능이 들어가 있음

--index를 생성해주는 방법
--[2] 조회 속도 비교하기
--    . 사원 테이블 복사하기
drop table emp01 purge;

create table emp01
as
select * from emp;

select index_name, table_name, column_name
from user_ind_columns 
where table_name in ('EMP', 'EMP01');
--  주의) 데이터 복사시 테이블 구조와 내용만 복사될 뿐 제약조건은 복사되지 않는다.

insert into emp01 select * from emp01; 
-- emp01 데이터에다가 emp01 데이터를 읽어오라는 의미로 데이터가 28개가 됨. (1,835,008개까지 늘림)
select * from emp01;

insert into emp01(empno, ename) values(8010, 'ANGEL'); 
--무결성 제약 조건이 있으면 데이터가 많을 때 다 훑어보고 중복값이 없을 때 넣음
--현재는 무결성 제약 조건이 없어서 바로 넣어진 것임

set timing on --command 창에서 수행된 실행시간이 같이 출력되어 보여준다.

select distinct empno, ename
from emp01
where ename = 'ANGEL'; --0.082초(index 연결 X)

--[3]인덱스 생성
--   . 기본키나 유일키가 아닌 컬럼에 대해서 인덱스를 지정하려면 create index 명령어를 사용하면 된다.
create index idx_emp01_ename
on emp01(ename); --index로 등록(내용적으로 훑기 때문에 시간이 좀 걸림)
--특정 컬럼과 연계를 시켜서 index 알고리즘이 실행시키도록 함

select distinct empno, ename
from emp01
where ename = 'ANGEL'; --0.006초(index 연결 O)
--나중에 알고리즘의 부분에서 검색 초에 대한 부분에 대한 이해를 할 수 있게 될 것이다.

--[4] 인덱스 제거
drop index idx_emp01_ename;




