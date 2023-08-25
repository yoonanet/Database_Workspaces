-- * cmd환경에서 실습했던 내용(2022/12/30)추가
-- * scott 계정 활성화
c:\>sqlplus system/admin1234 -- 최고권한으로 접속


SQL>@c:\scott.sql -- 읽어오는 명령
SQL>alter user scott identified by tiger; -- 비밀번호 변경
SQL>conn scott/tiger -- scott 계정으로 변환
SQL>show user; -- 현재 접속한 계정의 정보를 보여줌
SQL>select * from tab; -- scott 계정 테이블 목록
SQL>select * from dept;
SQL>quit; -- 종료