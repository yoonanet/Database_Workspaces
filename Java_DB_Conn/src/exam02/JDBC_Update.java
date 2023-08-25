package exam02;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class JDBC_Update {
	public static void main(String[] args) {
		//버전에 따라 달라짐. 인폼을 잘 찾아서 넣으면 된다.
		String driver = "oracle.jdbc.driver.OracleDriver";  //현재 사용할 데이터베이스 정보를 JDBC에게 알려주기 (ojdbc6.jar안에 저장되어 있음)
		                                                    //데이터베이스사마다 제공해주는 인폼에 따라 정보를 넣어주면 된다. 
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; //localhost: 내 자신의 PC를 가리키는 주소값으로 약속됨.
		String sql = null;
		
		Connection conn = null;
		Statement stmt = null;
		
		Scanner keyboard = new Scanner(System.in);
		
		
		//어떤 데이터베이스를 사용할꺼라는 것을 입력으로 정보를 넣어주도록 한다. -> 이패키지로 들어가면 된다고 알려줌
		//프로젝트내에 포함되어져 있지 않으면 예외가 발생됨
		try {
			Class.forName(driver); //자바 7버전부터 생략이 가능하지만 가독성과 하위버전과의 호환성때문에 적어주도록 한다.
			//정보가 있으면 오라클 DB에 접근을 시도하도록 요청을 해야한다. 
			//등록된 계정에 대한 인증을 수행할 수 있게끔 DriverManager클래스 안에 getConnection메소드를 수행하도록 한다.
			//=> url을 가지고 계정을 통해 데이터베이스에 접속을 시도하게 된다.
			conn = DriverManager.getConnection(url, "scott", "tiger");
			//Connection new를 하여 시작주소값을 리턴하게끔 정의가 되어져 있음 
			//-> 변수에 보관 (연결객체를 만든 것임 => 연결에 필요한 모든 기능들을 가짐)
			
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
			
			sql = "update customer set name = '"+name+"', email = '"+email+"', tel = '"+tel+"' where no = "+no; //수정의 쿼리문 작성
			
			stmt = conn.createStatement(); //위와 같이 이 메소드 안에 로컬클래스가 정의되어져 있음!!
			//이 메소드 안에 클래스는 conn이 연결이 안되어 있으면 그 클래스의 사용 의미가 없어지는 것이다.
			//createStatement클래스 안에 jdbc의 삽입, 수정, 삭제의 핵심기능을 제공해주고 있다.
			
			int result = stmt.executeUpdate(sql); //insert와 동일한 executeUpdate메소드로 쿼리문을 전달해주면 된다.
			//이 메소드 안에서 오라클이 오버라이딩을 해놓았기 때문에 실제로 이 쿼리문을 받아서 실행을 하게 된다.
			//executeUpdate은 수정된 데이터의 갯수 값을 리턴한다. 
			
			System.out.println("수정 데이터 갯수: " + result); //수정동작이 정상적으로 처리가 되었는지 판단하기 위함
			
			//jdbc에서에 insert와 update는 쿼리문 외에는 동일하게 동작되는 것을 알 수 있다.
			
		} catch (ClassNotFoundException e) {
			//e.printStackTrace();
			System.out.println(e.getMessage()); //자바제공 메시지 출력
		} catch (SQLException e) {
			//e.printStackTrace();
			System.out.println(e.getMessage());
		} finally {
			try {
				if(stmt != null) { stmt.close(); } //stmt가 할당이 되어졌을 때만 닫아주도록 한다.
				if(conn != null) { conn.close(); } //new하여 할당된 공간들을 다 닫아주도록 하는 것임.
			} catch (SQLException e) { e.printStackTrace(); }
		}
		
		
		
		
	}
}
