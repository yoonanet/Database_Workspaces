-- * cmd환경에서 실습했던 내용(2022/12/30)추가
-- * 오라클 접속

c:\Users>sqlplus system/admin1234 -- 방법1

c:\Users>sqlplus -- 방법2
사용자명 입력 : system
암호 입력 : (admin1234)

-- system 계정으로 접속시만 적용 가능.

--[1] 최고 관리자로 접속하여 hr 사용자의 계정을 풀어줌
SQL>alter user hr account unlock;

--[2] 사용자 암호를 변경
SQL>alter user hr identified by tiger;

--[3] 현재 접속하고 있는 계정 확인
SQL>show user;

--[4] 접속 계정 변경
SQL>conn scott/tiger

--[5] 계정 사용 풀어줌 + 암호변경
SQL>alter user scott identified by tiger account unlock;
