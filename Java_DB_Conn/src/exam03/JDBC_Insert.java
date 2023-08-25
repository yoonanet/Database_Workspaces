package exam03;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Scanner;

//실제 코드를 이렇게(JDBC_Insert의 쿼리문처럼) 작성하면 벌금 물게 됨.
//지금의 코드에서 쿼리문을 해커들이 캐치해가면 이 쿼리문에 모든 정보들이 다 담겨져 있기 때문에 문제가 된다.
//초기에 이렇게 작성하던 쿼리문들의 보안을 강화하면서 다음과 같은 코드로 작성하게끔 법적으로 지정을 해놓았다. (!!필수가 됨!!)
public class JDBC_Insert {
	public static void main(String[] args) {
		String driver = "oracle.jdbc.driver.OracleDriver"; 
		String url = "jdbc:oracle:thin:@localhost:1521:xe";

		Connection conn = null;
		//Statement stmt = null; 
		PreparedStatement pstmt = null;
		
		String sql = null;
		
		
		
		try {
			Class.forName(driver); // java 7이후 생략 가능.
			conn = DriverManager.getConnection(url, "scott", "tiger"); 
			
			//System.out.println("데이터베이스 연결 성공~~~");
			
			
			Scanner keyboard = new Scanner(System.in);
			
			System.out.println("customer 테이블에 값 입력하기.");
			System.out.print("번호 입력 : ");
			int no = keyboard.nextInt(); 
			
			keyboard.nextLine(); //dummy
			
			System.out.print("이름 입력 : ");
			String name = keyboard.nextLine();
			
			System.out.print("이메일 입력 : ");
			String email = keyboard.nextLine();
			
			System.out.print("전화번호 입력 : ");
			String tel = keyboard.nextLine();
			
			//stmt = conn.createStatement(); 

			//sql문에 데이터가 직접적으로 담겨져 있기 때문에 해야 할 작업들인 것이다.		
			sql = "insert into customer values(?, ?, ?, ?)"; 
			//이 쿼리문에 우리가 삽입할 데이터들이 다 노출이 되어 있는 것임
			//쿼리문의 보안을 강화해야 하는 것이다.
			//***들어갈 데이터 자리에 ?물음표를 삽입하여 데이터를 노출하지 않도록 보안을 강화한다.
			
			
			
			pstmt= conn.prepareStatement(sql); //prepareStatement를 추가적으로 jdbc에서 제공을 해주고 있다.
			//차이점은 기존에는 메소드를 호출하면됐지만 ***prepareStatement는 메소드를 호출하면서 쿼리문을 입력으로 바로 집어넣음
			//prepareStatement는 PreparedStatement의 객체를 반환해주고 있다.
			//주의) 위치가 쿼리문 작성의 이후로 와야 한다. 그래야 sql문이 정상적으로 탑제가 될 것이다.
			//여기에서는 데이터가 무엇이 들어가는지 모르는 상태이다.
			
			
			//물음표 자리에 어떻게 데이터가 들어가는 것일까? (물음표 값의 의미를 가지게 되는 시점이다.)
			//메소드에서 => 써줄때는 set, 가져올때는 get
			pstmt.setInt(1, no); //첫번째 물음표에다가 두번째 값을 넣는다는 의미이다.
			//내부에 숨겨져서 쿼리문으로 전달을 하게 되는 것이다. 즉, 중간에 쿼리문을 가로채도 물음표만 보이게 되는 것이다.
			pstmt.setString(2, name);
			pstmt.setString(3, email);
			pstmt.setString(4, tel);
			//들어가는 자료형에 따라서 set다음을 보면 되는 것이고,
			//첫번째 매개변수에는 물음표가 몇번째인지, 두번째 매개변수는 지정한 물음표에 들어갈 값을 넣어주도록 한다.
			
			//int result = stmt.executeUpdate(sql);
			int result = pstmt.executeUpdate();
			//주의) 쿼리문을 이미 prepareStatement로 전달을 했기 때문에 executeUpdate 메소드를 불러주기만 하면 된다.
			//      sql삽입위치가 달라진 것으로 이미 위에서 암호화를 했기 때문에 executeUpdate에 쿼리문을 넣을 필요가 없다.
			
			
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
				//if(stmt != null) { stmt.close(); } 
				if(pstmt != null) { pstmt.close(); } 
				
			} catch (SQLException e) {
				e.printStackTrace();
			} 
		}
		
		
	}
}
