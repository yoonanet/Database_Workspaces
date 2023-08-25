-- SQL 개발환경에서만 Database Connections를 연결을 해줘야 하는 것이다.
-- other -> SQL Dvelopments -> SQL File로 생성
create table customer(
	no		number(4) primary key, --데이터베이스 관리자가 중복되지 않으면서 null값이 담기지 않게끔 관리하는 것이 목적
	--사용자에게 전달받을 목적이 아니라 데이터가 들어오면 자동적으로 번호가 순차적인 부여가 되도록 하려는 것이다.
	--하지만 이러한 기능을 부여하려면 아직은 어렵기 때문에 입력에 포커스를 맞추고 직접 입력하여 저장하도록 한다.
	name	varchar2(20),
	email	varchar2(20),
	tel		varchar2(20)
);

select * from customer;


insert into customer values(2, '강감찬', 'xyz@company.com', '010-2222-2222');