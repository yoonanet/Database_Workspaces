-- * 오라클 : 동의어(Synonym)  - 객체에 대해 쉽게 접근할 수 있도록 하는 것으로 별칭을 생각하면 된다.
-- 객체 = 사용자계정 생각
-- 동의어도 오라클에서 객체로 바라본다.

--[1] 테이블 생성 후 객체 권한 부여하기 - 원래 마스터 관리자(관리하는 사람임)에 테이블을 만들면 안되는데 실습을 위해서 만드는 것임
SQL>sqlplus system/admin1234
SQL>create table table_systbl(
    ename varchar2(20)
);

SQL>insert into table_systbl values('홍길동');
SQL>insert into table_systbl values('이순신');

-- scott 사용자(계정)에게 table_systbl 테이블에 select 할 수 있는 권한을 부여합니다.
SQL>grant select on table_systbl to scott;

SQL>conn scott/tiger
SQL>select * from system.table_systbl; --타계정에서 작성한 테이블에 접속하는 명령

--[2] 동의어 생성 및 의미 파악하기
SQL>conn system/admin1234
SQL>grant create synonym to scott; --scott에게 동의어를 생성할 수 있는 권한을 부여하는 명령

SQL>conn scott/tiger
SQL>create synonym systab for system.table_systbl; --system.table_systbl로 접근할 때 systab의 한 단어로 접속할 수 있도록 동의어 지정
SQL>select * from systab; --생성된 동의어로 접근

--[3] 비공개 동의어 생성 및 의미
-- 객체에 대한 접근 권한을 부여 받은 사용자가 정의한 동의어로 해당 사용자만 사용할 수 있다.
SQL>conn system/admin1234
SQL>create role test_role; --권한을 하나 생성해보겠다는 의미이다. (사용자 정의 권한임)
SQL>grant connect, resource to test_role; --connect, resource을 test_role 한단어로 권한의 묶음들을 부여하겠다는 의미이다.
-- SQL>grant connect, resource, create synonym to test_role; 동의어 권한까지 다 주고 싶을때
SQL>grant select on scott.dept to test_role; --test_role에다가 권한을 추가적으로 부여

-- tmp
SQL>grant create synonym to tester10;
SQL>grant create synonym to tester11;
SQL>grant create synonym to tester12;



-- 사용자 생성
SQL>create user tester10 identified by tiger;
SQL>create user tester11 identified by tiger;

-- 사용자에게 Role(권한) 부여
SQL>grant test_role to tester10;
SQL>grant test_role to tester11;

SQL>conn scott/tiger
SQL>grant select on dept to tester10;

SQL>conn tester10/tiger
SQL>select * from scott.dept;

-- 사용자 tester10 비공개 동의어 생성
SQL>conn tester10/tiger
SQL>create synonym dept for scott.dept; --내 안에서만 사용할 수 있는 동의어를 생성하여 사용함, 다른 테이블에서는 사용 불가능하여 비공개동의어이다.
SQL>select * from dept;

-- 사용자 tester11 접속
SQL>conn tester11/tiger
SQL>select * from dept; --tester11에서 tester10의 접근 테이블의 명령을 주면 에러가 난다.(접근 불가)

--[4] 공개 동의어 정의하기
SQL>conn system/admin1234
SQL>create public synonym PubDept for scott.dept;
-- public이라는 키워드 사용 / 어떤 계정이든 다 사용을 할 수 있도록 한다.

-- 사용자 생성
SQL>create user tester12 identified by tiger;

-- 사용자에게 Role(권한) 부여
SQL>grant test_role to tester12;

SQL>conn tester12/tiger
SQL>select * from PubDept; --공개 동의어

--[5] 비공개 동의어 제거하기
--    : 비공개 동의어인 dept는 동의어를 소유한 사용자로 접속한 후 제거해야 한다. (tester10 계정)
SQL>conn tester10/tiger
SQL>drop synonym dept;
SQL>select * from dept; -- error 확인

--[6] 공개 동의어 제거하기
SQL>conn system/admin1234
SQL>drop public synonym PubDept;

--교재에서는 15장까지 살펴본 것임!! 










