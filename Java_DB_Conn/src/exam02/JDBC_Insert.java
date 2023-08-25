package exam02;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class JDBC_Insert {
	public static void main(String[] args) {
		//정보를 변수에 담아주고 사용해주는 것이 일반적이다.
		String driver = "oracle.jdbc.driver.OracleDriver"; //오라클에서 오버라이딩하여 작성한 정보들의 위치
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		//다른 데이터베이스 회사라고 하더라도 데이터베이스의 드라이브 정보만 연결을 시켜주면 다른 코드의 수정없이 활용을 할 수 있다.
		//다형성에 의한 오버라이딩이기 때문이다. => 각 회사들이 이러한 정보들을 오버라이딩된 메소드로 동일하게 기능을 부여했음
		//어떤 데이터베이스든 간에 코드를 고치지 않게 하는 것이 자바의 컨셉인 것이다.
		//!!자바의 개발자들은 자바만 바라보도록 한다!!
		
		Connection conn = null;
		Statement stmt = null; //java.sql로 import
		
		String sql = null;
		
		
		
		try {
			Class.forName(driver); // java 7이후 생략 가능.
			//생략이 가능하지만 하위버전과의 호환성을 위해서 코드를 추가해줌
			conn = DriverManager.getConnection(url, "scott", "tiger"); 
			
			//System.out.println("데이터베이스 연결 성공~~~");
			
			//키보드로 부터 데이터를 입력받기.
			Scanner keyboard = new Scanner(System.in);
			
			System.out.println("customer 테이블에 값 입력하기.");
			System.out.print("번호 입력 : ");
			int no = keyboard.nextInt(); //문자열로 전달한 값을 int로 형변환하여 반환함 -> no에 보관
			
			//enter키값이 버릴 용도의 더미코드 추가
			keyboard.nextLine(); //dummy
			
			System.out.print("이름 입력 : ");
			String name = keyboard.nextLine();
			
			System.out.print("이메일 입력 : ");
			String email = keyboard.nextLine();
			
			System.out.print("전화번호 입력 : ");
			String tel = keyboard.nextLine();
			
			//지역변수에 데이터값들을 임시저장 -> 데이터베이스에 저장하도록 해야함.
			//conn에 데이터베이스와의 연결과 관련된 모든 정보들이 담겨져 있음 이를 이용하도록 한다.
			//createStatement메소드: class가 정의되어있다. 즉, 그 클래스를 가지고 new로 인스턴스를 생성하여 그것을 전달하게끔 정의됨
			//                       어떤 인터페이스로 전달을 하는지를 알아야 한다. -> Statement최상위부모클래스 (메소드를 통해 new를 한 것임)
			stmt = conn.createStatement(); //Statement의 메소드에 접근하는 이유는 실질적으로 insert를 하기 위함이다.
			//자바의 jdbc가 sqlplus에 접근하는 것을 이 인터페이스에서 제공해주는 것이다.
			
			sql = "insert into customer values("+no+", '"+name+"', '"+email+"', '"+tel+"')"; //쿼리문을 담아주도록 함 => DB의 명령을 통해 넣도록 함
			//주의) 실제 데이터베이스에서 문자열을 넣을 때는 작은따옴표로 문자열을 감싸줘야 했다.
			//      그렇기 때문에 문자열의 시작과 끝에 작은 따옴표를 꼭 넣어주도록 해야한다!!
			
			int result = stmt.executeUpdate(sql);
			//입력에다가 쿼리문을 전달하면 내부에서 sql환경에서 그 쿼리문을 바로 실행이 된다. (오라클 개발자들이 자기들의 기능으로 오버라이딩해놓은 것임)
			//=> 오라클사가 쿼리문을 전달받게 되는 것이다. 오버라이딩된 기능을 통해 쿼리문을 바로 실행하도록 한다.
			//이 코드를 실행하고 난 후 jdbc는 삽입된 데이터의 갯수만큼의 정보를 전달해주게 된다!! 즉 1이라는 정수값이 반환되는 것임
			
			//위와 같은 메소드들이 자바가 제공해주는 jdbc인 것이다.
			//각 데이터베이스 개발사들이 자기네들이 저장된 기능들로써 오버라이딩하여 기능들을 제공해주고 있는 것임
			
			
			
			if(result == 1) {
				System.out.println("데이터 저장 성공.");
			}else {
				System.out.println("데이터 저장 실패.");
			}
			
			
		} catch (Exception e) { 
			//e.printStackTrace();
			System.out.println("데이터베이스 연결 실패ㅠㅠ");
			
		} finally { 
			try {
				if(conn != null) { conn.close(); }
				if(stmt != null) { stmt.close(); } //!!데이터를 입력하는 연결통로 닫기!!
				
			} catch (SQLException e) {
				e.printStackTrace();
			} 
		}
		
		
	}
}
