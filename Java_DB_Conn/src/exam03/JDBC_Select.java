package exam03;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

//보안의 컨셉을 통일시켜서 코드를 작성하도록 한다.
//select query문은 따로 데이터가 담겨있지 않기 때문에 크게 위험요소는 없음
//*** 그래도 통일성 있게 수행되는 기능처리에 있어서는 변경하도록 하고 있음.
public class JDBC_Select {
	public static void main(String[] args) {
		String driver = "oracle.jdbc.driver.OracleDriver"; 
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		
		Connection conn = null; 
		//Statement stmt = null;
		PreparedStatement pstmt = null;
		
		String sql = null;
		ResultSet rs = null;
		
		int no = 0; 
		String name = null, email = null, tel = null;
		
		try { 
			Class.forName(driver);
			conn = DriverManager.getConnection(url, "scott", "tiger");
			
			//System.out.println("데이터베이스 연결 성공~~~");
			
			//stmt = conn.createStatement(); 
			
			sql = "select * from customer"; 
			pstmt = conn.prepareStatement(sql); //sql명령문을 담기 위해서 sql다음에 적어주도록 한다.
			
			//rs = stmt.executeQuery(sql); 
			rs = pstmt.executeQuery(); //sql을 넣지 않도록 함. -> 위에서 이미 처리했음
			
			
			while(rs.next()) { 
				no = rs.getInt("no"); 
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
				if(pstmt != null) { pstmt.close(); }
				if(rs != null) { rs.close(); } 
			} catch (SQLException e) {
				e.printStackTrace();
			} 
		}
		
		
	}
}
