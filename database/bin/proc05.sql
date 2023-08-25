create or replace procedure cursor_sample01
is
    vdept dept%rowtype; --레코드단위를 처리하기 위한 변수 선언 
    cursor c1 --레코드 단위를 저장할 공간을 커서로 관리
    is
    select * from dept;
begin
    dbms_output.put_line('deptno / dname / loc');
    dbms_output.put_line('-----------------------------');
    
    open c1; --데이터를 주고받을 수 있는 연결통로 만들어주기 

    Loop
        fetch c1 into vdept.deptno, vdept.dname, vdept.loc; --읽어온데이터 꺼내와서 변수에 담아줌 
        exit when c1%notfound; --c1의 데이터가 존재하지 않으면 notfound가 반환되고 반복문을 빠져나오게 함

        dbms_output.put_line(vdept.deptno||' '||vdept.dname||' '||vdept.loc); --읽어온 데이터를 그때마다 출력

    END Loop;
    
    close c1; --연결통로 해제
end;
/