-- * 오라클 : PL/SQL

--[1] 'Hello World!!!' 출력
SET SERVEROUTPUT ON -- 출력할 수 있도록 활성화를 함.

--프로그래밍은 처음 시작할 때 틀을 만들어줘야 했었다.
--PL에서의 틀은 3부분(선언부, 실행부, 예외 처리부)으로 나눠서 제공을 해주고 있다. 이틀을 통해 명령을 작성해주면 된다. 이를 변수에서 사용함.

--BEGIN과 END사이에 명령어를 작성해주면 된다. 또한 END에서는 /를 통해 명령의 끝을 한번 더 알려주도록 한다.
BEGIN
DBMS_OUTPUT.put_line('Hello World!!!'); --system.out.println과 같은 동작이 되어진다. 입력으로 넣어준 문자열이 출력됨 
END;
/


--[2] 변수 사용하기 (선언의 이유, 저장해두고 있다가 필요할 때마다 꺼내서 사용하기 위함)
-- 변수를 선언할 때는 선언부, 실행부, 예외 처리부의 크게 3부분으로 나눠서 선언하도록 한다.
DECLARE --선언부(변수의 선언)
    VEMPNO NUMBER(4); -- 스칼라 변수 선언
    VENAME VARCHAR2(20);
    -- 이 변수는 최대 정수값 4자리까지 저장 가능
    -- 유의할 점) 변수선언이 테이블 선언하는 것과 동일하다. 

BEGIN --실행부
    VEMPNO := 7788; -- 변수의 값을 초기화의 방법(저장)
    VENAME := 'SCOTT';
    -- 자바에서는 '='이 대입연산자이고, 데이터베이스에서는 '='이 좌우를 같은지 비교하는 연산자로 사용이 되고 있다.
    -- 따라서 데이터베이스에서는 대입연산자를 := 로 제공해주고 있다.
    
    DBMS_OUTPUT.put_line('사번 / 이름');
    DBMS_OUTPUT.put_line('---------------------------------');
    DBMS_OUTPUT.put_line(VEMPNO||' / '||VENAME); -- 변수의 참조
    -- 자바와 동일하게 변수의 이름만 지정을 해준다면 변수에 담긴 데이터를 읽어올 수 있다.
    -- || : 자바의 Println에서의 +와 동일한 동작이 되어진다. => 즉 문자열 결합의 용도.

END; 
/


DECLARE
    VEMPNO EMP.EMPNO%TYPE; -- 레퍼런스 변수 선언
    -- 기존에 존재하는 테이블의 컬럼항목과 동일한 자료형으로 맞춰주도록 선언할 수 있다.
    VENAME EMP.ENAME%TYPE;
BEGIN
    
    DBMS_OUTPUT.put_line('사번 / 이름');
    DBMS_OUTPUT.put_line('---------------------------------');
    
    -- 기존의 쿼리문에서 읽어온 데이터를 변수에 담아서 사용하고자 하는 것이다.
    SELECT EMPNO, ENAME INTO VEMPNO, VENAME 
    FROM EMP
    WHERE ENAME = 'SCOTT';
    
    DBMS_OUTPUT.put_line(VEMPNO||' / '||VENAME);

END;
/


--원래는 DECLARE, BEGIN, END;/는 하나의 파일로 만들어야 한다. 하지만 지금은 실습 때문에 한 파일 안에서 블록을 지정해서 실행
--데이터베이스의 레코드(테이블 속에 담겨진 데이터)가 자바에서는 인스턴스

--[3] RECORD TYPE 사용
--    . EMP 테이블에서 SCOTT사원의 정보 출력.

DECLARE
    -- 레코드 타입을 정의 (아래 코드를 쌍으로 이루어야 한다.)
    TYPE EMP_RECORD_TYPE --클래스를 하면서 이름을 붙여준 것과 동일하다 즉, 아래의 데이터들을 담을 수 있는 참조자료형이 되는 것이다. 
    Is RECORD(
        V_EMPNO     EMP.EMPNO%TYPE,
        V_ENAME     EMP.ENAME%TYPE,
        V_JOB       EMP.JOB%TYPE,
        V_DEPTNO    EMP.DEPTNO%TYPE
    ); 
    
    --아래의 변수의 자료형을 EMP_RECORD_TYPE로 지정하는 것이다.
    EMP_RECORD EMP_RECORD_TYPE; --참조변수를 만들어준 것이다.
BEGIN
    SELECT EMPNO, ENAME, JOB, DEPTNO INTO EMP_RECORD --변수명 하나만 넣어주면 자료형들을 매핑해서 넣어주게 된다.
    FROM EMP
    WHERE ename = 'SCOTT';
    
    DBMS_OUTPUT.put_line('사원번호 ' || TO_CHAR(emp_record.V_EMPNO)); -- 레코드 타입의 변수를 접근하고자 할 때 .을 통해 접근하도록 한다. (프로그래밍과 동일컨셉)
    -- 입력의 데이터를 문자로 변환해주는 함수 -> TO_CHAR 
    DBMS_OUTPUT.put_line('사원이름 ' || TO_CHAR(emp_record.V_ENAME)); 
    DBMS_OUTPUT.put_line('담당업무 ' || TO_CHAR(emp_record.V_JOB)); 
    DBMS_OUTPUT.put_line('부서번호 ' || TO_CHAR(emp_record.V_DEPTNO)); 
    
END;
/

--[4] 조건문 (=선택문)
--    . 사원번호가 7788인 사원의 부서번호를 얻어와서 부서 번호에 따른 부서명을 구하세요.

DECLARE
    VEMPNO      NUMBER(4);
    VENAME      VARCHAR2(20);
    VDEPTNO     EMP.DEPTNO%TYPE;
    VDNAME      VARCHAR2(20) := NULL; --값을 바로 초기화

BEGIN
    SELECT EMPNO, ENAME, DEPTNO --가지고 온 값을 
    INTO VEMPNO, VENAME, VDEPTNO --변수에 넣어달라고 요청을 한 것이다.
    FROM EMP
    WHERE EMPNO = 7788;
    
    if(VDEPTNO = 10) then
        vdname := 'ACCOUNTING';
    elsif(VDEPTNO = 20) then
        vdname := 'RESEARCH';
    elsif(VDEPTNO = 30) then
        vdname := 'SALES';
    elsif(VDEPTNO = 40) then
        vdname := 'OPERATIONS';
    else
        vdname := null;
    end if; --오라클에서는 조건문을 끝낼때 꼭 마지막에 써줘야 한다.
    
    dbms_output.put_line('사번 / 이름 / 부서명');
    dbms_output.put_line('-------------------------------------------');
    dbms_output.put_line(vempno||' / '||vename||' / '||vdname);
END;
/

-- [5] 반복문
--     1) basic loop문
declare
    n   number := 1; --n이라는 변수에 1로 초기화
begin
    loop  --무한반복되는 반복문이다.
       dbms_output.put_line(n); 
       n := n + 1; -- n += 1로 하면 에러임. 오라클은 복합대입연산자를 제공하지 않는다.
       
       if(n > 5) then
        exit; --반복문에서 빠져나가는 방법임
       end if;
       
    end loop;
end;
/

--     2) for loop문
--DECLARE 별도의 변수를 선언하지 않을 때는 옵션사항이 된다.

BEGIN --필수적인 틀이다.
    for n in 1..5 LOOP --in이라는 키워드를 통해 반복하고자 하는 카운트값을 ..을 통해 지정하도록 한다.
    -- for라는 키워드를 이용한 반복문.
        dbms_output.put_line(n);
    END LOOP;
END;
/

--     3) while loop문

DECLARE
    n number := 1;
BEGIN
    while(n <= 5) Loop --조건을 괄호안에(_boolean값이 들어가도록 함) 넣어주도록 한다. [자바와 컨셉이 동일]
        dbms_output.put_line(n);
        n := n + 1;
    end Loop;
END;
/


/*
데이터베이스에서 [PL/SQL] 기능을 제공
=> 프로그래밍에서 핵심이 되어지는 몇가지 기능들을
데이터베이스가 저장소 기능이면서도 제공을 해주고 있다.

!!PL은 오라클만이 제공해주는 기능이다!!
PL(Procedural Language) SQL => 절차적 언어이다.

기존에는 한가지의 명령씩만 진행을 할 수 있었다.
구조화된 명령언어(DDL - 테이블 관련된 명령, DCL - CRUD관련 명령어 생각)
데이터베이스는 단순하게 하나의 명령을 전달해서 
하나의 결과를 수행하는 것으로 쿼리 질의 응답과 같은 방식이였다.
그런 데이터베이스가 절차적 언어인 PL을 제공해주는 것이다.

PL은 어떠한 기능을 제공해주느냐
1. 변수 선언
2. 비교 처리 -> 조건문
3. 반복 처리 -> 반복문
*/