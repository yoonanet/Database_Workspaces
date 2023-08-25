-- * 오라클에서 탑제된 함수라 하여 내장함수
-- * 오라클 명령어 : 내장 함수

-- [1] 임시 데이터 출력
select 1234 * 1234 from dual; --오라클에서의 가상의 테이블: dual
--특정테이블에서 가져온 값은 아니지만 임시적인 데이터를 출력하고자 할 때 사용하는 가상 테이블은 dual
select * from dual; -- 결과에서 dummy는 문제점을 해결하기 위한 임시적인 요소를 말한다. -> 또한, 어떤 데이터를 담고 있지 않다는 의미

-- [2] 샘플 테이블인 dual 테이블
select * from friend; -- 존재하지 않는 테이블로 에러남
select * from tab; -- scott에 있는 모든 테이블


-- ** 3~11까지는 데이터 타입 중에 문자열을 처리 관련 함수 **
-- [3] lower() : 모든 문자를 소문자로 변환
select lower('Hong Kil Dong') as "소문자" from dual;
-- * 문자열 데이터는 작은따옴표로 감싸줘야한다!!

-- [4] upper() : 모든 문자를 대문자로 변환
select upper('Hong Kil Dong') as "대문자" from dual;

-- [5] initcap() : 단어의 첫글자만 대문자로 변환
select initcap('hong kil dong') as "첫글자만 대문자" from dual;

-- [6] concat() : 문자열 연결
select concat('더조은 ', '컴퓨터') "문자열 연결" from dual;

-- [7] length() : 문자열의 길이
select length('더조은 컴퓨터'), length('The Joeun Computer') from dual; --공백도 문자열 길이에 포함된다.

-- [8] substr() : 문자열 추출(데이터, 인덱스(1), 카운트)
select substr('홍길동 만세', 1, 3) from dual;
--데이터에서 첫번째위치(홍)에서 세글자(홍길동)를 추출해서 출력하라는 의미이다.

select substr('홍길동 만세', 3, 4) from dual;
--데이터에서 세번째위치(동)에서 네글자(동 만세)를 추출해서 출력하라는 의미이다.

-- [9] instr() : 문자열 시작 위치 *응용하게 될 예정
select instr('홍길동 만세', '동') from dual; -- 3
--indexstring / 특정 문자가 있는지를 확인해주고 그 위치를 알려주는 기능
--문자열에서 지정한(찾고자 하는) 문자열의 시작 위치를 알려준다.

select instr('seven', 'e') from dual; -- 2
-- 가장 앞에 있는 위치에 있는 글자의 위치값을 알려줌

-- [10] lpad(), rpad() : 자리 채우기
select lpad('Oracle', 20, '#') from dual;
-- Oracle 영문을 포함해서 20개의 자리를 할당해주고, 
-- 선언한 영문(Oracle=>6개)을 제외한 14개의 빈자리를 #으로 왼쪽 여백에 채움
select rpad('Oracle', 20, '*') from dual;
-- 20개의 자리를 할당해주고, Oracle 영문의 갯수를 제외한 14개의 빈자리를 *으로 오른쪽 여백에 채움
-- [일정 영역을 할당하고 여백을 없앨 때 사용함]

-- [11] trim() : 컬럼이나 대상 문자열에서 특정 문자가 첫번째 글자이거나 마지막 글자이면 잘라내고 
--               남은 문자열만 반환.
-- [활용 빈도가 높은 함수로 회원가입 시 앞, 뒤 공백(여백)을 없애줌]
select trim('a' from 'aaaOracleaaaaaa') from dual; --a문자를 제거한 Oracle만 출력됨
-- trim(제거하고자 하는 문자 from 작업될 문자열)

select trim(' ' from '    Oracle      ') from dual;
-- 여백이 제거되어 결과값이 추출됨


-- ** 12번부터는 수식 처리 관련 함수(숫자데이터 관련) **
-- [12] round() : 반올림(음수: 소숫점 이상 자리)
select round(12.3456, 2) from dual;

select deptno, sal, round(sal, -3) from emp 
where deptno = 30;
--반올림 값으로 음수값도 넣어줄 수 있다. 음수값의 반올림 개념은 앞으로 가서 반올림한다.

-- [13] abs() : 절대값 (양수의 값을 반환해줌)
select abs(10) from dual;
select abs(-10) from dual;

-- [14] floor() : 소수자리 버리기
select floor(12.3456) from dual; -- 12출력됨 즉, 실수에서 정수를 반환하고자 할 때 사용한다.

-- [15] trunc() : 특정 자리 자르기
select trunc(12.3456, 2) from dual;
/* round와 trunc 구분)
   trunc와 round의 의미는 같지만, 
   round는 지정 자릿수에서 반올림을 하는 것이고, trunc는 지정 자릿수에서 뒷자리를 버리는 것이다.(차이점을 잘 파악해두기.) */

-- [16] mod() : 나머지
select mod(8, 5) from dual; -- 몫은 1, 나머지는 3으로 결과값은 3이 출력된다.


-- ** 날짜 처리 관련 함수 **
-- [17] sysdate : 날짜
-- 창에서만 임시적으로 형식을 적용하고자 할 때 아래처럼 선언 (해당 창에서만 적용시)
ALTER SESSION SET NLS_DATE_FORMAT='YYYY/MM/DD (DAY) HH24:MI:SS'; --여기서도 대소문자 구분하지 않는다.

select sysdate from dual; --현재 날짜와 시간
-- 날짜 형식 포맷을 지정하고자 할 때(전체를 항상 적용시): 도구->환경설정->NLS->날짜형식에서 지정
-- 따로 데이터를 지정해주지 않는 함수.

-- [18] months_between() : 개월 수 구하기 (활용성이 높지는 않음)
select ename, hiredate, round(months_between(sysdate, hiredate), 2) -- 첫번째와 두번째에 날짜정보에서 개월수의 차를 반환해주는 함수
from emp;

-- 실행 시 현재 날짜와 14명의 입사일자 정보를 통해 각각의 개월 수의 차를 구함
-- 개월수를 계산하는 것이기 때문에 소수점으로 결과값이 나올 수 있음 -> round를 이용함.

-- [19] add_months() : 개월 수 더하기 (개월수로 날짜를 예측할 때 사용할 수 있음.)
select add_months(sysdate, 200) from dual; -- 현재날짜에서 200개월 이후
select add_months(sysdate, -200) from dual; -- 현재날짜에서 200개월 전

-- [20] next_day() : 다가올 요일에 해당하는 날짜 (현재 설치된 것이 한글버전이기 때문에 인식이 한글로 됨)
select next_day(sysdate, '일요일') from dual; -- 이번주 일요일(현재 날짜정보를 토대로)에 대한 정보를 알려줌

-- [21] last_day() : 해당 달의 마지막 일 수
select last_day(sysdate) from dual; --현재 달에서 마지막 날짜에 대한 정보를 반환해주는 것이다.

-- [22] to_char() : 문자열로 반환 ☆☆☆ 첫프로젝트에서 사용될 가능성 있음(프로그래밍언어와 같이 연동하여 사용)
select to_char(sysdate, 'yyyy-mm-dd') from dual;
-- 출력되어지는 결과의 자료형은 문자열이다.

-- [23] to_date() : 날짜형(date)으로 변환 ☆☆☆ 첫프로젝트에서 사용될 가능성 있음(프로그래밍언어와 같이 연동하여 사용)
select to_date('2009/12/31', 'yyyy/mm/dd') from dual; --문자열의 date를 오라클의 날짜 데이터로 변경
-- 첫번째는 변경하고자하는 문자열 날짜, 두번째는 변경되는 date의 형식


-- ** 기타 함수 **
-- [24] nvl() : null인 데이터를 다른 데이터로 변경
-- null이라는 값이 존재하게 되면 연산이 안되기 때문에 그 문제점을 해결하기 위해서 nvl()함수를 사용한다.
select ename, comm, nvl(comm, 0) from emp;

-- [25] decode() : switch문과 같은 기능
select 
    ename, deptno, decode(deptno,
                          10, 'A',
                          20, 'R',
                          30, 'S',
                          40, 'O') as "부서약자"
from emp;
--decode(데이터 필드명(부서번호), 부서번호의 데이터 값, 뭘로 표시할지 ,... ,... ,.....)
--데이터의 의미를 빠르게 파악하고자 출력할 때 유용하게 사용할 수 있다.

select * from dept; -- 부서정보가 있음(4개의 부서를 가지고 있음)
select * from emp; -- deptno: 부서에 대한 번호가 있음

-- [26] case() : if ~ else if ~
select ename, deptno, 
                     case 
                         when deptno = 10 then 'ACCOUNT'
                         when deptno = 20 then 'RESEARCH'
                         when deptno = 30 then 'SALES'
                         when deptno = 40 then 'OPERATIONS'
                     end as "부서명"
from emp;
-- case는 sysdate처럼 단독으로 사용이 된다.
-- case(시작), when(조건 걸어주기_deptno가 10번이냐), then(조건이 맞으면 결과값 반환), end(끝)가 한 쌍이므로 기억을 해둬야 한다.
