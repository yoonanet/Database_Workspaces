package exam03;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class JDBC_Update {
	public static void main(String[] args) {
		
		String driver = "oracle.jdbc.driver.OracleDriver";  
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; 
		String sql = null;
		
		Connection conn = null;
		//Statement stmt = null;
		PreparedStatement pstmt = null;
		
		Scanner keyboard = new Scanner(System.in);
		
		
	
		try {
			Class.forName(driver); 
			conn = DriverManager.getConnection(url, "scott", "tiger");
			
			//System.out.println("데이터 접속 성공~");
			
			System.out.println("테이블 값 수정하기.");
			System.out.print("수정할 번호 입력 : ");
			int no = keyboard.nextInt();
			
			keyboard.nextLine(); // dummy code
			
			System.out.print("수정할 이름 입력 : ");
			String name = keyboard.nextLine();
			
			System.out.print("수정할 이메일 입력 : ");
			String email = keyboard.nextLine();
			
			System.out.print("수정할 전화번호 입력 : ");
			String tel = keyboard.nextLine();
			
			sql = "update customer set name = ?, email = ?, tel = ? where no = ?"; 
			
			//stmt = conn.createStatement(); 
			//int result = stmt.executeUpdate(sql); 
			
			pstmt = conn.prepareStatement(sql);
			
			//각 물음표의 값을 채워주기 (물음표 순서대로 번호값을 넣으면서 담을 데이터를 지정해주면 된다.)
			pstmt.setString(1, name);
			pstmt.setString(2, email);
			pstmt.setString(3, tel);
			pstmt.setInt(4, no); 
			
			int result = pstmt.executeUpdate(); 
			
			System.out.println("수정 데이터 갯수: " + result); 
			
		} catch (ClassNotFoundException e) {
			//e.printStackTrace();
			System.out.println(e.getMessage()); 
		} catch (SQLException e) {
			//e.printStackTrace();
			System.out.println(e.getMessage());
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); } 
				if(conn != null) { conn.close(); } 
			} catch (SQLException e) { e.printStackTrace(); }
		}
		
		
		
		
	}
}
