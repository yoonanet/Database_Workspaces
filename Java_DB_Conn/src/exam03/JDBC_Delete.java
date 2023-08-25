package exam03;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class JDBC_Delete {
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
					
			System.out.println("테이블 값 삭제하기.");
			System.out.print("삭제할 번호 입력 : ");
			int no = keyboard.nextInt();
					
			sql = "delete from customer where no = ?"; 
					
			//stmt = conn.createStatement(); 
			//int result = stmt.executeUpdate(sql); 
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, no);
			
			int result = pstmt.executeUpdate();
					
			System.out.println("삭제된 데이터 갯수: " + result); 
					
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

