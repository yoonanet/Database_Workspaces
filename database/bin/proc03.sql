create or replace procedure sel_empno(
    vempno in emp.empno%type, 
    vename out emp.ename%type,
    vsal out emp.sal%type, 
    vjob out emp.job%type 
)
is
begin
    select ename, sal, job into vename, vsal, vjob
    from emp
    where empno = vempno;
end;
/