create or replace function cal_bonus(vempno in emp.empno%type) 
    return number
is
    vsal number(7, 2); 
begin
    select sal into vsal 
    from emp
    where empno = vempno;

    return (vsal * 12);
end;
/

