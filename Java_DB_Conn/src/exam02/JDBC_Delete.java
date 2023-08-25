package exam02;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class JDBC_Delete {
	public static void main(String[] args) {
		String driver = "oracle.jdbc.driver.OracleDriver";  
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; 
		String sql = null;
				
		Connection conn = null;
		Statement stmt = null;
				
		Scanner keyboard = new Scanner(System.in);
				
				
		try {
			Class.forName(driver); 
			conn = DriverManager.getConnection(url, "scott", "tiger");
		
			//System.out.println("데이터 접속 성공~");
					
			System.out.println("테이블 값 삭제하기.");
			System.out.print("삭제할 번호 입력 : ");
			int no = keyboard.nextInt();
					
			sql = "delete from customer where no = " + no; 
					
			stmt = conn.createStatement(); 
			int result = stmt.executeUpdate(sql); //삭제도 executeUpdate를 사용한다.
					
			System.out.println("삭제된 데이터 갯수: " + result); 
					
		} catch (ClassNotFoundException e) {
			//e.printStackTrace();
			System.out.println(e.getMessage()); 
		} catch (SQLException e) {
			//e.printStackTrace();
			System.out.println(e.getMessage());
		} finally {
			try {
				if(stmt != null) { stmt.close(); } 
				if(conn != null) { conn.close(); } 
			} catch (SQLException e) { e.printStackTrace(); }
		}
										
	}
}

//실제 코드를 이렇게(JDBC_Insert의 쿼리문처럼) 작성하면 벌금 물게 됨.
//지금의 코드에서 쿼리문을 해커들이 캐치해가면 이 쿼리문에 모든 정보들이 다 담겨져 있기 때문에 문제가 된다.
//초기에 이렇게 작성하던 쿼리문들의 보안을 강화하면서 다음과 같은 코드로 작성하게끔 법적으로 지정을 해놓았다. (!!필수가 됨!!)