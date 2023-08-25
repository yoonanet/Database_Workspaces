package exam02;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

//Database Connections를 연결하는 환경과는 상관이 없다.
//자바의 인터페이스 메소드들만 알면 데이터베이스의 활용이 가능해지는 것이다.
//자바 프로그램이 실행하는 과정에서 데이터를 읽어올 수 있게끔 처리가 되어야 프로그램 안에서 사용을 할 수 있을 것이다.
//select의 기능을 살펴볼 예정
public class JDBC_Select {
	public static void main(String[] args) {
		String driver = "oracle.jdbc.driver.OracleDriver"; 
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		
		Connection conn = null; 
		Statement stmt = null;
		
		String sql = null;
		ResultSet rs = null;
		
		int no = 0; 
		String name = null, email = null, tel = null;
		
		try { //필수 선행 작업이다.
			Class.forName(driver); // java 7이후 생략 가능.
			conn = DriverManager.getConnection(url, "scott", "tiger"); //성공하면 필요 객체들이 담겨짐
			
			//System.out.println("데이터베이스 연결 성공~~~");
			
			//연결객체를 통해 실질적인 데이터베이스와의 작업이 가능해진다.
			stmt = conn.createStatement(); //메소드 반환 객체 안에 Statement인터페이스를 구현하도록 정의가 되어져 있다는 것말 알고 있으면됨
			
			sql = "select * from customer"; //전체 데이터를 읽어오도록 함.
			
			rs = stmt.executeQuery(sql); 
			//삽입,수정,삭제는 executeUpdate의 메소드 하나이다. => 데이터를 전달하고 나면 끝임
			// select는 만족하는 데이터를 반환해주기 때문에 동작의 결과가 다르다. 
			//그렇기 때문에 select만 executeQuery메소드로 제공해주고 있다.
			
			//실행을 한 후 조건에 맞는 데이터를 반환받고 그 반환받은 데이터를 new를 하여 보관하게 되는 것이다.
			//new를 하면 그 뒤에 자료형을 써줘야 하는데 그때의 자료형이 ResultSet으로 저장하고 있다.
			//DB로부터 select를 통해 반환되어지는 데이터를(읽어온 데이터) 저장(보관)하기 위한 용도로 제공해주는 ResultSet참조자료형이다.
			//개발자는 반환되는 위치를 모르기 때문에 주소값을 리턴해줌 -> 변수에 보관
			//rs.하면 ResultSet메모리에 접근할 수 있도록 한다. => 해당 데이터를 어떻게 읽어오면 될지의 방법만 알면 된다.
			
			
			//데이터베이스에서 자체적으로 제공해주는 프로그램의 기능이 있었음 => PL/SQL
			//전체의 데이터를 반환받아서 프로그램내에서 저장을 할 때 
			//오라클 데이터베이스는 커서라는 자료형으로 제공을 해주고 있었다.
			//자바는 ResultSet을 통해 제공을 해주고 있다.
			//내부적으로는 커서와 ResultSet이 연동되어 동작이 되게끔 설계가 되어 있는 것이다.
			
			//프로그램 안에서 데이터를 실시간적으로 읽어오는 방법 - 하나하나씩 컬럼별로 꺼내와야 함
			
			
			//1. 데이터 존재유무 확인
			while(rs.next()) { //resultset에 가서 데이터가 있는지 확인한다 -> 있으면 true, 없으면 false
			//데이터를 레코드 단위로 바라본다 => 두 번 반복하게 됨
				no = rs.getInt("no"); //입력으로 컬럼이름을 문자열로 넘겨주면 문자열로 읽어와서 int로 형변환을 해주게 된다.
				//데이터베이스로부터 반환되어진 값을 메모리에 임시 보관
				name = rs.getString("name");
				email = rs.getString("email");
				tel = rs.getString("tel");
				
				System.out.printf("%d\t %s\t %s\t %s\t\n", no, name, email, tel);
			}
			
			
			
		} catch (Exception e) { 
			//e.printStackTrace();
			System.out.println("데이터베이스 연결 실패ㅠㅠ");
		} finally { 
			try {
				if(conn != null) { conn.close(); }
				if(stmt != null) { stmt.close(); }
				if(rs != null) { rs.close(); } //데이터를 꺼내서 저장해놓는 연결통로를 닫아준다.
				//***열었던 순서의 역순으로 닫아주도록 한다.
			} catch (SQLException e) {
				e.printStackTrace();
			} 
		}
		
		
	}
}

//데이터베이스는 정형화된 구조로 데이터를 보관하고 있음 -> 테이블
//데이터 처리의 흐름(어떻게 메모리 공간을 확보해서 어떻게 접근,저장,읽어올지)은 똑같은데 대상에 따라서 방법만 다를 뿐임
//변수의 특징은 언제든지 하나의 값만을 보관하는 특징을 가지지만 하나의 값이 고정된 것이 아니라 얼마든지 변경할 수 있다.
//데이터베이스에서 update라는 쿼리문을 이용해서 기존 데이터를 변경할 수 있었다. 
//자바에서 실시간적으로 데이터를 변경하고 싶을 때 어떻게 변경을 할 수 있을지 체크 => insert와 거의 동일하게 처리됨