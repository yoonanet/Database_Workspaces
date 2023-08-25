package exam01;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

//자바를 메인에서 수행되는 과정에서 데이터들을 데이터베이스로 주고받고자 하는 것이다.
//데이터베이스에서 데이터를 주고받기 위해서는 승인을 받은 계정만이 연결을 허용한다.
//따라서 데이터베이스에게 먼저 승인을 받아야 한다. 그것을 연결객체라고 부른다.
//승인을 어떻게 받는지 부터 알아야 한다. 그부분에 대한 실습을 진행
public class JDBC_Connect {
	public static void main(String[] args) {
		String driver = "oracle.jdbc.driver.OracleDriver"; 
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		
		Connection conn = null; 
		
		
		
		//Class라는 클래스를 제공해주고 있다. 자바는 대소문자를 구분함(class는 키워드, Class는 자바제공 참조자료형)
		//Class를 제너릭으로 제공을 해주고 있다. static선언되어 있는 forName이라는 메소드를 제공해주고 있음.
		//forName 입력으로 드라이버 클래스를 담아주도록 한다. 
		//forName: 오라클 데이터베이스 사용할꺼야라고 자바에게 알려줌
		//포워드 엔지니어링에서 데이터베이스와 연동할 때 드라이버 클래스를 보여주고 있었음.
		//JDBC드라이버 안에 드라이버 클래스가 탑제되어 있음
		try {
			Class.forName(driver); // java 7이후 생략 가능.
			//자바는 입력을 보고 안으로 찾아가서 데이터베이스의 인폼과 관련된 작업을 이 메소드 안에서 체크를 한다.
			
			//연결 객체의 드라이브 연결 정보를 보면 오라클이라는 것을 판단할 수 있기 때문에
			//자바사가 정보도 드라이브 이름을 보고 오라클 위치를 바탕으로 찾아갈 수 있어서 
			//데이터베이스 정보를 알려주지 않아도 됨
			
			
			conn = DriverManager.getConnection(url, "scott", "tiger");
			//DriverManager참조자료형 안에 getConnection이 static메소드로 정의되어져 있음. 
			//연결정보(접속 URL정보)를 자바한테 알려줘야 한다. 그 정보를 getConnection메소드에 첫번째 매개변수에 넣어줘야 한다.
			//두번째, 접속계정정보 세번째, 비밀번호
			//그렇게 데이터베이스로부터 허가를 받으면 허가받은 정보를 자바는 내부에서 new로 메모리를 할당하여 그 정보를 보관한다.
			//메소드를 통해서 new를 할 수 있다. 그것이 바로 getConnection(익명클래스로 대표적)이 하는 일이다.
			//Connection이라는 인터페이스를 반환해준다.(최상위 인터페이스가 Connection이다)
			//이 Connection을 가지고 DB와 대화를 하면 된다.
			
			//연결통로를 만들어서 데이터를 주고받기 위한 과정을 만든 것이다.
			System.out.println("데이터베이스 연결 성공~~~");
		} catch (Exception e) { //파일을 찾지 못하면 예외를 발생하도록 함.
		//예외의 Exception 최상위부모를 통해 모든 예외를 다형성으로 쳐다보게 하는 것이다.
			//e.printStackTrace();
			System.out.println("데이터베이스 연결 실패ㅠㅠ");
		} finally { 
			try {
				if(conn != null) {  //무조건 예외를 시키는 것이 아닌 conn이 null이 아닐경우에만 실행을 하도록 한다.
					conn.close(); //연결이 끝나면 꼭 닫아주기.
				}
			} catch (SQLException e) {
				e.printStackTrace();
			} 
		} 
		//연결이 되면 자바의 인터페이스에서 제공해주는 메소드를 통해 오버라이딩하여 데이터베이스를 사용을 하면 된다.
		//테이블은 미리 만들어져 있고, 그 테이블에 실시간적인 데이터 삽입, 삭제, 수정이 실행이 되는 것이다.
		
	}
}

//OracleDriver참조자료형은 ojdbc6.jar에 들어있는데 프로젝트에 포함이 안되고 있음
//8버전이하에서는 집어넣기만 하면 포함이 되어지게끔 동작이 되었었음
//11버전으로 오면서 자동포함이 안되어지고 있다.
//Build Path -> Configule build path -> libraries -> add external jars -> ojdbc6.jar 선택


//데이터베이스 제조사들이 만들어서 데이터베이스의 정보가 담겨져 있다는 것을 
//개발자들에게 알려주고 있기 때문에 이 인폼을 알고 있으면 됨!





