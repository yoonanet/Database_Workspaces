-- * 오라클 : 사용자(User) 권한(Role)
--           (DCL:Data Control Language)

--마스터권한에 의해서 새로운 사용자 계정을 만들어주는 것부터
--DB접근 부터 저장하고자하는 작업들을 수행할 수 있는 환경을 구성을 해주는 부분이다. (신입에게는 시키지 않는 일임)

--[1] 권한의 역할과 종류
--    .권한↓
--    .시스템 권한
--    .객체 권한

--가정: 회사입사 -> DB관리자로부터 사용하고 싶은 사용자 계정 id를 제출하라는 요청을 줬다.
--     DB관리자는 그 아이디로 부터 계정을 생성해야함. 그게 나임.
--[2] thomas 계정 생성(command 창에서 실행) / SQL> -> DOS창의 의미
SQL>sqlplus system/admin1234 -- system 접속
SQL>show user; --현재 접속하고 있는 계정의 정보를 보여주는 명령어

--신입사원이 비밀번호를 줌, DB에서 계정을 만들어라.
SQL>create user thomas identified by tiger; --관리자 계정에서만 가능한 명령어이다.
--아이디를 만들게 됨.

--exit후 thomas로 로그인하면 접속에 대한 권한이 없다고 오류가 뜸 (관리자가 승인을 해줘야 로그인할 수 있다.)
SQL>exit
SQL>sqlplus thomas/tiger -- thomas 접속 : error - 접속에 대한 권한이 부족하다.

--[3] 데이터베이스 접속 권한 부여 (system 계정만 가능하다.)
SQL>sqlplus system/admin1234 -- system 접속
SQL>grant create session to thomas; -- thomas에게 권한을 부여하겠다는 명령어
-- Grant succeeded.라고 뜨면 권한이 부여된 것임.

SQL>sqlplus thomas/tiger  -- 권한 부여 이후에 접속하면 접속이 됨.

--thomas계정에서
create table emp01(
    empno   number(2),
    ename   varchar2(10),
    job     varchar2(10),
    deptno  number(2)
); -- 불충분한 권한이라고 에러(에러가 나는 이유는 그만큼 DB의 보안이 있다는 것)

--[4] 테이블 생성 권한의 부여
SQL>sqlplus system/admin1234
SQL>grant create table to thomas;
--하다 보면 나중에 할당 공간이 부족하다고 에러뜸 (저장소 공간이 할당되지 않았기 때문이다.)

--[5] 테이블 스페이스 확인
--    : 테이블 스페이스(table space)는 디스크 공간을 소비하는 테이블과 뷰 
--      그리고 그 밖에 다른 데이터베이스 객체들이 저장되는 장소를 의미한다.
--    cf) 오라클 xe(학습용으로 가볍게 사용할 수 있는 프로그램) 버전의 경우 메모리 영역은 system으로 할당을 해줘야 한다.
--        오라클 full 버전의 경우 메모리 영역은 users으로 할당을 해줘야 한다.
--        -> SQL>alter user thomas quota 2m on users; --quota는 메모리 할당 용어
SQL>alter user thomas quota 2m on system; --system 계정에서 해줘야 함.

create table emp01( -- thomas계정에서 실행
    empno   number(2),
    ename   varchar2(10),
    job     varchar2(10),
    deptno  number(2)
);

select * from tab;
select * from emp01;

-- * 계정 생성 및 테이블 생성까지의 권한 부여 정리
c:\>sqlplus system/admin1234 -- 관리자 계정 로그인
SQL>create user thomas identified by tiger; -- 계정 생성
SQL>grant create session to thomas; -- 접속 권한 부여
SQL>grant create table to thomas;   -- 테이블 생성 권한 부여
SQL>alter user thomas quota 2m on system; -- 메모리 저장소 공간 할당 

--[6] with admin option -> 부관리자에게 시스템 권한(권한을 부여할 수 있는)의 일부 기능을 상속해줌
--  tester1 계정 생성 및 권한 부여
c:\>sqlplus system/admin1234 
SQL>create user tester1 identified by tiger; 
SQL>grant create session to tester1; 
SQL>grant create table to tester1;   
SQL>alter user tester1 quota 2m on system; 

SQL>conn tester1/tiger --연결하여 접속함.(접속한 상태에서 다른 계정으로 접속함)
SQL>show user; -- 'TESTER1'에 접속이 되어 있는 것을 확인할 수 있다.

SQL>grant create session to thomas; --권한 부여에 자격이 없기 때문에 에러(insufficient privileges)가 남.


--  tester2 계정 생성 및 권한 부여
c:\>sqlplus system/admin1234 
SQL>create user tester2 identified by tiger; 
SQL>grant create session to tester2 with admin option; -- 권한을 부여할 능력치를 물려받는 것으로 보면 됨.
SQL>grant create table to tester2;   
SQL>alter user tester2 quota 2m on system; 

SQL>conn tester2/tiger 
SQL>show user; -- 'TESTER2' 

SQL>grant create session to thomas; -- 다른 계정에 접속 권한을 오류없이 부여함 OK

--[7] 테이블 객체에 대한 select 권한 부여(scott/emp_scott만이 테이블을 볼 수 있음 -> thomas가 emp테이블을 읽어오고 싶다면) 
-- 다른 사람이 만든 테이블을 열어보고 싶다면 테이블을 소유한 관리자에게 권한을 받아야만 가능하다. (테이블을 서로 공유해야 하는 직군일 때)
--[scott의 cmd창]
SQL>conn scott/tiger -- sqlplus에서 접속이 되어졌을때만 실행되는 명령어이다.
SQL>grant select on emp to thomas;  --thomas에게 scott_emp를 열람할 수 있는 권한을 부여함

--[thomas의 cmd창]
SQL>conn thomas/tiger
SQL>select * from emp; -- 자신의 테이블에 접속하는 것이라 없어서 에러남 
-- 자신의 테이블의 이름과 겹칠 수 있기 때문에 스키마를 통해서 접근해줘야 한다.

--[8] 스키마(SCHEMA) : 객체를 소유한 사용자명을 의미
--    scott의 테이블에 접근할 때는 
SQL>select * from scott.emp; --테이블 명을 앞에 (.)으로 부여해줘야 한다.

--[9] 사용자에게 부여된 권한 조회
--    .user_tab_privs_made : 현재의 사용자가 다른 사용자에게 어떤 권한을 부여했냐에 대한 정보를 관리하는 테이블 
--    .user_tab_privs_recd : 나한테 부여된 권한을 알고 싶을 때에 열람하는 테이블
SQL>conn thomas/tiger
SQL>select * from user_tab_privs_made; --thomas가 부여한 권한
SQL>select * from user_tab_privs_recd; --thomas가 부여받은 권한

--[10] 비밀번호 변경시 (따로 실습하지는 않음)
SQL>conn system/admin1234
SQL>alter user thomas identified by thomas;

--[11] 객체 권한 제거하기
SQL>conn scott/tiger
SQL>revoke select on emp from thomas;

--[12] with grant option : 접속 권한을 주면서 + 사용자 계정끼리의 테이블 접근 권한도 같이 부여함(테이블에서의 각 계정에 대한 권한의 의미로 객체 권한을 생각)
-- command 창에서 실행(1)
SQL>conn scott/tiger
SQL>grant select on emp to tester1 with grant option; --tester1계정에 emp테이블을 열람할 수 있는 권한 + 계정에 권한을 줄 수 있는 권한까지.

-- 새로운 command 창에서 실행(2)
SQL>sqlplus tester1/tiger
SQL>select * from scott.emp;

SQL>grant select on scott.emp to tester2; --다른 계정에게 scott의 emp 테이블 열람 권한을 주는 것이 가능하다. _ 타사용자 권한 부여. (부사수의 권한 옵션)

-- 새로운 command 창에서 실행(3)
SQL>sqlplus tester2/tiger
SQL>select * from scott.emp;

--[13] 사용자 계정 제거
SQL>conn system/admin1234
SQL>drop user tester2; --사용자 계정을 삭제하는 명령 (사용자 계정이 접속하고 있으면 삭제가 안됨.)

SQL>conn tester2/tiger -- 계정이 없어서 접속에 실패된다.
-- 접속에 실패하면 들어가 있던 계정에서도 빠져나오게 된다.
-- SQL> show user 실행하면
-- USER is "" 이렇게 결과가 뜸

--[14] 권한(Role) - 사용자에게 보다 효율적으로 권한을 부여할 수 있도록 여러 개의 권한을 묶어 놓은 것.
--   1)connect Role
--   1)resource Role
--   3)DBA Role
SQL>conn system/admin1234
SQL>create user tester2 identified by tiger; --실습을 위한 계정 생성
SQL>grant connect, resource to tester2; --한 줄로 다섯 줄 이상의 권한 부여 부분을 쉽게 부여할 수 있음
SQL>conn tester2/tiger

create table emp01( 
    empno   number(2),
    ename   varchar2(10),
    job     varchar2(10),
    deptno  number(2)
);

select * from tab;

--별도로 권한을 부여했던 부분을 최고 관리자가 쉽게 권한을 부여해줄 수 있다 (계정생성과 동시에 쉽게 권한을 부여하기 위하여 오라클에서 묶음 권한을 제공)
--connect Role: 사용자가 데이터베이스에 접속 가능하도록 하기 위해서 다음과 같이 가장 기본적인 시스템 권한 8가지 묶어 놓은 권한.
--resource Role: 사용자가 객체(테이블, 시퀀스, 뷰)를 생성할 수 있도록 시스템 권한을 묶어 놓은 것

