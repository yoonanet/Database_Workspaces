create or replace trigger trg_01
after insert -- 삽입 끝난 직후에 트리거가 관찰하고 있는 것임 언제 이벤트가 발생하는지 (before로 하면 삽입하기 직전)
on emp02 -- emp02테이블에 데이터가 삽입되고난 직후에 begin end수행해달라는 의미
begin
    dbms_output.put_line('data insert...'); --데이터가 잘 삽입되고 있는지 눈으로 확인할 용도
end;
/