-- * 오라클 : 트리거(Trigger) - 트리거 타이밍: before, After
--           발생 시 자동적으로 방아쇠가 당겨져서 총알이 발사되듯이
--           특정 테이블 변경되면 이들 이벤트로 다른 테이블이 자동으로 변경되도록 사용
--           트리거는 insert, update, delete의 문장을 실행하기 전과 실행하고 난 후에 활용할 수 있다. / 일종의 이벤트 처리 방법임

SQL>ed trig01 --삽입이 끝난 직후에 메시지 출력하도록 구성을 해놨음
SQL>@trig01
SQL>select * from emp02;
SQL>insert into emp02 values(8010, '강감찬', 'clerk', 20);



























