-- * 오라클 : 데이터 무결성 제약 조건

-- 컬럼 레벨 제약 조건 지정
--[1] not null 제약 조건을 설정하지 않고 테이블을 생성
drop table emp01 purge;
create table emp01(
    empno  number(4),
    ename  varchar2(20),
    job    varchar2(20),
    deptno number(2)
);

--[null 데이터 입력 연습]
insert into emp01
values(null, null, 'salesman', 40);

select * from emp01;

--[2] not null 제약 조건을 걸고 테이블 생성
create table emp02(
    empno  number(4) not null, --반드시 데이터가 삽입되어야 한다는 조건을 걸어줌
    ename  varchar2(20) not null,
    job    varchar2(20),
    deptno number(2)
);

--[null 데이터 입력 연습]
insert into emp02
values(null, '홍길동', '세일즈맨', 10); --제약조건에 해당하지 않아서 오류를 보고함. error

insert into emp02
values(1234, '홍길동', '세일즈맨', 10);

select * from emp02;

--[3]Unique 제약 조건을 설정하여 테이블 생성 (Unique는 데이터 값에서 중복을 허용하지 않겠다는 의미이다.)
create table emp03(
    empno  number(4) unique, --데이터 삽입시 먼저 empno의 데이터를 돌려봄->중복이 되면 에러.
    ename  varchar2(20) not null,
    job    varchar2(20),
    deptno number(2)
);

insert into emp03
values(1234, '홍길동', '세일즈맨', 10);

insert into emp03
values(1234, '이몽룡', '매니저', 30); -- unique(유일한) 조건에 위배된다는 오류가 뜨게 됨.

insert into emp03
values(1235, '이몽룡', '매니저', 30); 

insert into emp03
values(null, '성춘향', '연구소', 20); 

insert into emp03
values(null, '이순신', '회계부', 10); --같은 데이터값으로 null이 있더라도 에러가 안남.
--null은 의미만 담아주는 키워드로 정해진 데이터가 아니기 때문에 에러가 나지 않는 것이다.

select * from emp03;

--[4] 컬럼 레벨로 조건명 명시하기. not null & unique 제약 조건
--     . 사용자가 제약 조건명을 지정하지 않고, 제약 조건만을 명시할 경우 오라클 서버가
--       자동으로 제약 조건명을 부여한다.
--     . 오라클이 부여하는 제약 조건명은 SYS_ 다음에 숫자를 나열한다.
--     . 어떤 제약 조건을 위배했는지 알 수 없기 때문에 사용자가 의미있게 제약 조건명을 
--       명시할 수 있도록 오라클은 제공.

create table emp04(
    empno  number(4) constraint emp04_empno_uk unique, -- 제약조건 별칭 붙여줌 [테이블명_필드명_제약조건 -> 일반적인 형식]
    ename  varchar2(20) constraint emp04_ename_nn not null,
    job    varchar2(20),
    deptno number(2)
);

insert into emp04
values(1234, '홍길동', '세일즈맨', 10);

insert into emp04
values(1234, '이몽룡', '매니저', 30);
-- 출력: 오류 보고 -
-- ORA-00001: unique constraint (SCOTT.EMP04_EMPNO_UK) violated

--[5] Primary Key(기본키) 제약 조건 설정하기
--    : not null + unique
create table emp05(
    empno  number(4) constraint emp05_empno_pk primary key, 
    ename  varchar2(20) constraint emp05_ename_nn not null,
    job    varchar2(20),
    deptno number(2)
);
-- Primary Key(기본키)는 레코드데이터를 구별할 수 있는 식별자로 부여된다.

insert into emp05
values(1234, '홍길동', '세일즈맨', 10);

insert into emp05
values(1234, '이몽룡', '매니저', 30); -- 중복부분에서_error

insert into emp05
values(null, '이몽룡', '매니저', 30); -- null 오류가 남_error

--[6] 참조 무결성을 위한 Foreign Key(외래키) 제약 조건 -자식의 특정 필드의 값이 부모에 포함된 값으로만 넣을 수 있도록 지정함.
--      . 부모 키가 되기 위한 컬럼은 반드시 부모테이블의 기본키(primary key)나
--        유일키(unique key)로 설정되어 있어야 한다.

create table dept06(
    deptno  number(2) constraint dept06_deptno_pk primary key,
    dname   varchar2(20) constraint dept06_dname_nn not null,
    loc     varchar2(20) 
);

insert into dept06
values(10, '회계부', '경기');
insert into dept06
values(20, '연구소', '인천');
insert into dept06
values(30, '영업부', '서울');
insert into dept06
values(40, '관리부', '세종');

select * from dept06;

create table emp06(
    empno  number(4) constraint emp06_empno_pk primary key, 
    ename  varchar2(20) constraint emp06_ename_nn not null,
    job    varchar2(20),
    deptno number(2) constraint emp06_deptno_fk 
                     references dept06(deptno)
    --dept06에 deptno를 참조하여 등록된 값만으로 삽입할 수 있도록 관리해야 한다.
);
-- references 참조 테이블명(특정 해당 값이 담긴 컬럼명)

insert into emp06
values(1234, '홍길동', '세일즈맨', 10);

insert into emp06
values(1240, '이몽룡', '매니저', 3); --3 error(부모의 지정된 컬럼값에 3이 없음)

--[7]Check 제약 조건 설정하기 - 지정된 값으로 올바르게 들어왔는지 체크하는 제약조건이다.(들어갈 값을 미리 등록하는 개념)
--   . 급여 컬럼을 생성하되 값은 500 ~ 5000 사이의 값만 저장 가능.
--   . 성별 저장 컬럼으로 gender를 정의하고, 'M'/'F' 둘 중 하나의 값만 저장 가능.

create table emp07(
    empno  number(4) constraint emp07_empno_pk primary key, 
    ename  varchar2(20) constraint emp07_ename_nn not null,
    sal    number(7, 2) constraint emp07_sal_ck 
                        check(sal between 500 and 5000), -- and로 지정한 범위를 벗어나면 오류남
    gender varchar2(1) constraint emp07_gender_ck 
                       check(gender in ('M', 'F')) -- M이나 F일때만 저장하겠다는 의미이다.
);

insert into emp07
values(1234, '홍길동', 6000, 'M'); --error

insert into emp07
values(1240, '이몽룡', 3500, 'N'); --error

--[8] Default 제약 조건 설정하기(옵션의 개념)
--    . 지역명(LOC) 컬럼에 아무 값도 입력하지 않을 때, 
--      디폴트 값인 'SEOUL'이 입력되도록 default 제약 조건 지정.
drop table dept08 purge;

create table dept08(
    deptno  number(2) constraint dept08_deptno_pk primary key,
    dname   varchar2(20) constraint dept08_dname_nn not null,
    loc     varchar2(20) default 'SEOUL' --오류체크의 개념이 아니라서 따로 constraint 이름을 지정할 수 없다.
);

insert into dept08
values(10, '회계부', 'INCHEON');

insert into dept08
values(20, '영업부'); --"not enough values" 값이 충분하지 않다는 의미로 에러 발생
--순서도 중요하지만 값의 갯수도 중요하다.

insert into dept08(deptno, dname)
values(20, '영업부'); --결과 실행 시 loc값이 default값으로 저장이 되어 출력됨

insert into dept08
values(30, '관리부', default); --결과로는 동작이 되나 정상 동작이 되는것인지는 모름 (오라클사 검증 내용 찾아보면 공유)

select * from dept08;

--[9] 제약 조건 명시 방법
--   1) 컬럼 레벨로 제약 조건명을 명시해서 제약 조건 설정.
create table emp09(
    empno  number(4) constraint emp09_empno_pk primary key, 
    ename  varchar2(20) constraint emp09_ename_nn not null,
    sal    number(7, 2) constraint emp09_sal_ck 
                        check(sal between 500 and 5000),
    gender varchar2(1) constraint emp09_gender_ck 
                       check(gender in ('M', 'F')) 
);

--   2) 테이블 레벨 방식으로 제약 조건 설정.
--      주의) not null 제약 조건은 테이블 레벨 방식으로 제약 조건을 지정할 수가 없다.
create table emp09_2(
    empno  number(4), 
    ename  varchar2(20) constraint emp09_2_ename_nn not null, --밑에다가 따로 정의할 수 없다.
    sal    number(7, 2),
    gender varchar2(1), 
    constraint emp09_2_empno_pk primary key(empno),
    constraint emp09_2_sal_ck check(sal between 500 and 5000), --이미 어느 컬럼에 대한 것인지 나와서 따로 컬럼명을 적어줄 필요 없다.
    constraint emp09_2_gender_ck check(gender in ('M', 'F'))
);

create table emp09_3(
    empno  number(4), 
    ename  varchar2(20) constraint emp09_3_ename_nn not null,
    job    varchar2(20),
    deptno number(2),
    constraint emp09_3_empno_pk primary key(empno),
    constraint emp09_3_job_uk unique(job),
    constraint emp09_3_deptno_fk foreign key(deptno) references dept06(deptno) 
    -- foreign key(deptno)_자식의 필드명을 지정을 해줘야 함.
);

-- * USER_CONSTRAINTS 데이터 딕셔너리 뷰
--   : 제약 조건에 관한 정보를 알려줌.
-- 데이터 무결성 제약 조건을 생성할 때 이에 대한 정보를 뒤에서 다 뷰에 업데이트가 되어 있음

desc user_constraints; -- 뷰 안에 특징들 정보

select constraint_name, constraint_type, table_name
from user_constraints;

--[10]제약 조건 추가하기 (이미 만들어진 테이블에서 외부에서 무결성 제약 조건 추가하는 것임)
create table emp10(
    empno  number(4), 
    ename  varchar2(20),
    job    varchar2(20),
    deptno number(2)  
);

alter table emp10
add constraint emp10_empno_pk primary key(empno);

alter table emp10
add constraint emp10_deptno_fk 
foreign key(deptno) references dept08(deptno); -- references 부모키, foreign key 부모참조하는 자식키

--[11] not null 제약 조건 추가하기
alter table emp10
modify ename constraint emp10_ename_nn not null; 
-- 에러가 나는 이유는? null로 이미 default 설정이 되었기 때문이다.
-- 위에서 테이블 생성시에 따로 설정 지정을 안했기 때문에 null default가 됨.
-- 그래서 null을 not null로 수정하겠다는 개념으로 수정을 해야하기 때문에 명령어를 modify로 해줘야 한다.

--[12]제약 조건 제거하기
alter table emp10
drop primary key;

--[13]제약 조건(외래키) 컬럼 삭제
delete from dept06
where deptno = 10; --자식이 참조하고 있는걸 발견됐다는 오류 발생함. 즉, 참조대상이 있으면 삭제 동작을 하지 못하도록 함.
-- 데이터베이스의 기능 중에서 Foreign Key(외래키)를 사용하지 않고 (중간에 값을 삭제할 때 매우 번거로움)
-- 개발단계에서 프로그래밍언어(프로그래밍에 values를 값을 지정)를 이용하여 구현해서 처리하는 것이 일반적이다. (실질적인 방법)
-- 기능의 구현 과정에서 문제가 발생하면 문제의 원인을 찾아서 해결해가는 과정을 디버깅

-- 1) 제약 조건의 비활성화 (임시적인 기능) - 실제로는 사용 잘 안하는 기능
alter table emp06
disable constraint emp06_deptno_fk; --임시적으로 자식의 제약조건을 잠시 비활성화 _ 테스트용으로 활용함(잘 사용 안함)

delete from dept06
where deptno = 10;

insert into dept06
values(10, '회계부', '서울'); --10번부서의 정보를 변경

alter table emp06
enable constraint emp06_deptno_fk; --잠시 비활성화 된 자식의 제약조건을 활성화

-- 2) cascade 옵션(부모쪽에서 비활성화 시켜주는 개념) - 실제로는 사용 잘 안하는 기능
alter table dept06
disable primary key cascade; 

select constraint_name, constraint_type, table_name, r_constraint_name, status
from user_constraints
where table_name in ('DEPT06', 'EMP06');

alter table dept06
drop primary key; --error

alter table dept06
drop primary key cascade; --cascade의 옵션을 사용해서 비활성화했기 때문에 삭제할 때도 옵션명을 적어줘야 함.

alter table dept06
add constraint dept06_deptno_pk primary key(deptno);



