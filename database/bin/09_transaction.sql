-- * 오라클 : 트랜잭션(transaction) - DB의 장점

--[1] 실습용 테이블 생성
drop table dept01 purge;

create table dept01
as
select * from dept;

select * from dept01;

--[2] command 창에서 실습 진행.
--    . 두 개의 command 창을 띄워서 scott 계정으로 접속.
delete from dept01; -- command(1)에서 실행. 모든 데이터 삭제
select * from dept01; --데이터 확인(반영 O)

-- command(2)에서 실행 및 데이터 확인.
select * from dept01; --데이터 확인(반영 X)

-- command(1)에서
commit; --명령을 실행하면 최종적으로 반영.

-- command(2)에서 실행 및 데이터 확인.
select * from dept01; --데이터 확인(반영 O)



/* delete from dept01;의 명령어는 그 당시에는 데이터들이 다 삭제(반영)된 것처럼 보여지지만
데이터베이스에 최종적인 반영이 되지 않았음

실질적으로 데이터베이스에 반영이 되도록 하려면
commit;이라는 명령을 했을 때 최종적으로 반영이 됨.

트랜젝션은 dml명령(데이터처리에 관련된 명령어)에만 적용된다.
--> ddl명령과 같은 경우에는 트랜젝션의 개념이 적용되지 않는다.

developer -> commit명령을 내리지 않아도 제대로 반영이 됨.
데이터베이스는 내부적으로 commit명령을 수행하기 때문에 제대로 반영이 되는 것이다. 

정전이 발생하거나 컴퓨터가 다운 시 자동으로 rollback. -> db에 반영이 안됨.
rollback의 시점: 처음 commit을 한 상태.

commit은 반영
rollback은 복귀 */

--[3] 되돌리기
--  [2]번과 동일 실습 진행.
rollback; -- 명령을 실행하면 마지막의 commit 단계로 복원.

