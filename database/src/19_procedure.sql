-- * 오라클 : 저장 프로시저(procedure) - 파일의 형태로 저장

drop table emp01 purge; --emp01테이블 삭제

create table emp01 --emp테이블 안에 데이터들을 다 emp01에 복사하도록 함 (데이터무결성제약조건은 복사되지 않는다.)
as
select * from emp;


-- dos command 창에서 확인 - scott계정 로그인
SQL>ed proc01    -- 프로시저 생성 코드 작업 
SQL>@proc01      -- 프로시저 생성(그 파일을 읽어가면서 프로시저를 생성) / 파일의 형태로 저장이 되어져 있기 때문에 언제든지 실행을 할 수 있음.
SQL>execute del_all  -- 프로시저 실행
SQL>select * from emp01; --프로시저 동작 확인

-- ed: 편집기창을 열어달라는 명령이 되는 것이다. (새로운 sql파일창이 열림)
-- 데이터베이스는 프로시저를 객체로 관리함. (테이블, 뷰, 인덱스, 프로시저 => 공통점은 생성을 create로 삭제 drop 수정 alter로 함)

-- or replace 파일에 존재여부에 상관없이 있으면 지우고 새로 생성하고, 없으면 그냥 생성하도록 처리되어지는 옵션이 된다.
-- DEL_ALL의 프로시저를 begin과 end사이에 명령문을 저장하도록함

--@: 뒤에 지정한 파일을 읽어와서 실행해달라고 하는 추가적인 기능이다.
--scott계정파일을 c드라이브 밑에 두고 실행하고자 했었음 => @c:\scott.sql
--@proc01: 같은 폴더 내에서 파일을 찾아서 읽어가도록 하는 것임.



--[1] 저장프로시저 조회하기
desc user_source;
select name, text from user_source; --어떤 프로시저들이 생성되어져 있는지를 볼 수 있다.
--프로시저를 생성하는 순간에 오라클 데이터베이스는 user_source의 뷰창을 통해서 해당 정보에 대한 딕셔너리를 관리하게 된다.

--[2] 저장 프로시저의 매개변수
SQL>insert into emp01 select * from emp;
SQL>ed proc02
--매개변수를 선언하는 것처럼 변수를 선언해 놓음
SQL>@proc02
SQL>execute del_ename('SCOTT') --scott사원의 정보를 삭제하려고 함
--함수를 호출하듯이 동일하게 인자를 입력해준다.
SQL>select * from emp01; --프로시저 동작 확인
--프로시저는 실행하는 순간 메소드를 호출하는 것처럼 데이터를 전달해서 실시간적으로 실행할 수 있도록 폭넓게 제공해주고 있다.



--[3] IN(데이터 전달받을 때), OUT(수행된 결과를 받아갈 때), INOUT(두 가지 목적 모두 사용) 매개변수
--INOUT으로는 너무 가독성이 떨어지기 때문에 IN과 OUT을 통해 작성하는 것이 더 효율적이다.
SQL>ed proc03
--데이터를 전달받아서 진행을 하고자 하고, 이는 입력의 개념이다. 
--프로시저를 통해서 데이터를 밖에서도 사용을 하고 싶은 것이다.
--즉, cmd창에서도 그 값들을 사용하고 싶은 것이다.
--in은 입력용의 변수라는 의미, 
--out은 출력용(수행하고난 값들을 담아주는 변수)의 변수라는 의미
SQL>@proc03 

SQL>variable var_ename varchar2(15); --전달할 데이터를 위한 변수 선언하도록 함 (프로시저 호출할때 전달할 용도.)
SQL>variable var_sal number;
SQL>variable var_job varchar2(9);

SQL>execute sel_empno(7788, :var_ename, :var_sal, :var_job); --출력용일 때는 앞에 :을 붙여서 콜론을 붙여주도록 한다. -> 입력용을 통해 도출된 데이터는 변수에 저장하게 되는 것이다. 

--잘 담겨있는지 확인
SQL>print var_ename;
SQL>print var_sal;
SQL>print var_job;


--[4] 저장 함수 (저장 프로시저와 유사함)
SQL>ed proc04
SQL>@proc04 --프로시저 생성

SQL>variable var_result number; --값을 저장할 수 있는 변수생성
SQL>execute :var_result := cal_bonus(7788); --출력용은 무조건 콜론 표시!!
SQL>print var_result;

--[5] Cursor(커서): 레코드 단위의 데이터를 처리하게끔 제공하고 있다.
SQL>select * from dept;


SQL>ed proc05
--vdept dept%rowtype;는 레코드단위로 데이터를 처리하겠다는 것이다.
--cursor c1 => 커서단위로 담아주게됨
--open c1; - 데이터를 사용할 때 통로연결, fetch 읽어오기
SQL>@proc05 --실질적인 프로시저 생성

SQL>execute cursor_sample01; --dept데이터가 잘 출력되는지 확인 (프로시저 실행)

SQL>SET SERVEROUTPUT ON --출력하는 부분 활성화하고 다시 실행






/*
[프로시저_Procedure]
저장 프로시저
복잡한 쿼리문들을 필요할 때마다 다시 입력할 필요없이 간단하게 호출만 해서 
복잡한 쿼리문의 실행 결과를 얻어올 수 있도록 한다.
성능 향상, 호환선 문제 해결, 여러번 반복 호출해서 사용할 수 있는 장점을 가져감

매개변수 선언 방법
IN(데이터 전달 받을때), OUT(수행의 결과 받아갈 때), 
INOUT(두가지 목적 모두 사용)을 통해 처리

저장 함수: 실행결과를 되돌려 받을 수 있음
커서: 처리 결과가 여러 개의 행으로 구해지는 select문을 처리하려면 커서 이용
*/




