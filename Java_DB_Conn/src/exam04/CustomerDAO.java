package exam04;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

//데이터베이스 기능은 CRUD가 핵심이다.
//운영에 포커스를 두고 있는 자바에서의 참조자료형의 컨셉은 
//데이터베이스에서 CRUD로써 데이터베이스와 자바간에 운영에 포커스를 두고 있다.
//즉, 데이터 운영에 대한 목적으로써 CRUD의 기능을 탑제시키면 된다.
//DB와 연동이 되어 동작이 되어지는 기능들이 구현이 되어져 있는 것이다.
class CustomerDAO { // Data Access Object
	String driver = "oracle.jdbc.driver.OracleDriver"; 
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String insertSql = "insert into customer values(?, ?, ?, ?)"; 
	String selectSql = "select * from customer"; 
	String updateSql = "update customer set name = ?, email = ?, tel = ? where no = ?";
	String deleteSql = "delete from customer where no = ?"; 
	
	//Connection conn;
	
	
	
	//데이터베이스를 연동하기 위해 사용자의 승인이 필요하다.(최초 한번만) => 기능 모두에서 공통적으로 필요한 작업
	CustomerDAO() { //커넥션의 연결을 생성자에서 단 한번만 해주면 되는 것이다.
		
		try {
			Class.forName(driver); 
			//conn = DriverManager.getConnection(url, "scott", "tiger");
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}
	
	//자바빈을 통해 레코드 단위의 메모리를 생성하여 주소값(참조변수)만 매개변수로 전달 받도록 하고, 데이터들은 getter, setter으로 대체하도록 한다!!
	public void insert(CustomerDTO data) { // 기존에 작성했던 코드들이 기능으로 들어가면 된다.
		//메인에서 사용자로부터 입력받은 데이터를 데이터베이스와 자바에 사이에서 운영을 할 자료형 안에 
		//insert메소드를 호출하면서 데이터를 전달해주도록 해서
		//전달받은 데이터를 실제 데이터베이스에 데이터를 저장할 기능을 구현하도록 한다.
		//데이터를 꺼내오고 싶다면 data.을 통해 접근하여 getter메소드를 꺼내오면 됨.
		PreparedStatement pstmt = null; //공통으로 사용할 목적이 아님.
		//사용할 기능에 따라 변하기 때문에 자동소멸되게끔 지역변수로 처리하도록 한다.
		Connection conn = null; 
		
		try { //DB와 실질적으로 작업하는 기능만 몰아놓도록 함.
			conn = DriverManager.getConnection(url, "scott", "tiger");
			//동작마다 연결객체를 얻어와서 finally에서 사용이 끝나면 close를 해주게끔 작성을 하는 것이 메모리 사용 입장에서는 효율적이다.
			//커넥션풀이 바뀌면 이 코드 하나만 바꾸면 됨.
			
			pstmt = conn.prepareStatement(insertSql);
			pstmt.setInt(1, data.getNo());
			pstmt.setString(2, data.getName());
			pstmt.setString(3, data.getEmail());
			pstmt.setString(4, data.getTel());
			
			pstmt.executeUpdate(); //저장된 갯수만큼의 데이터 반환
			
			
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); }
				if(conn != null) { conn.close(); } 
				//필드로 선언해놓은 연결통로를 없애면 다시 연결할 수가 없음. 문제임.
				//작업단위로 close로 끊어주지 말라고 필드로 선언을 해놓은 것이다.
				//나중에 작업이 다 끝났을 때 close를 어떻게 해줘야 할까? 메소드를 따로 생성하여 close를 호출해주지 않으면 방법이 없음.
				//따라서 작업마다 통로를 기능 안에서 생성을 시키고 끊어주도록 한다.
				//위와같이 작성을 하게 되면 심각한 문제가 초래함. => 작업마다 연결객체를 만들어야함.
				//내부에서는 new를 해야함. 자바에서 가장많은 퍼포먼스를 차지하는 동작이 new이므로 성능이 크게 떨어질 수 있다.
				//그래서 다음에는 커넥션풀을 공부하게 된다. 
				//처음 서버라는 컴퓨터가 켜질 때 미리 커넥션 객체를 왕창 만들어놓는 것이다.(컴퓨터가 처음 켜질때는 느릴 수 있지만 문제는 없음)
				//=> 컴퓨터가 켜지고 나서 요청이 오면 미리 할당된 메모리를 사용할 때 
				//잠깐 할당했다가 close시 연결통로만 닫아주고 메모리는 할당이 되어지게끔한다.
				//그렇게 요청이 올때마다 재사용이 가능하도록 하는 것이 커넥션풀이다. => jsp에서 자세히 배울 예정
			} catch (SQLException e) { e.printStackTrace(); }
		}
		//현재는 서비스적으로 운영목적이 아니기 때문에 퍼포먼스는 고려하지 않고 컨셉만 맞춰서 코드구성할 예정.

	}
	
	public List<CustomerDTO> select() {
		Connection conn = null; 
		PreparedStatement pstmt = null;
		
		String sql = null;
		ResultSet rs = null;
		
		//int no = 0; 
		//String name = null, email = null, tel = null;
		
		
		List<CustomerDTO> list = new ArrayList<>(); //들어온 값을 유지하는 특징을 가짐 즉, 테이블에서 들어오는 값을 그대로 저장함
		//add할 때 담는 값 참조변수로 담아줬었음. (시작주소값이 담기는 것이다.)
		//지금 현재 CustomerDTO로 레코드단위 데이터로 바라보도록 선언을 해놨음
		
		//list.add(dto);
		//인스턴스를 add하여 집어넣고, menu에서 호출할 때는 list만 전달을 해주면 list.iterator로 꺼내오거나 get메서드로 꺼내올 수 있다.
		
		try { 
			conn = DriverManager.getConnection(url, "scott", "tiger");
						
			pstmt = conn.prepareStatement(selectSql); 
			
			rs = pstmt.executeQuery(); //실행해달라는 요청
			
			
			while(rs.next()) { //3개의 레코드가 반복되면서 가져오게 됨.
				CustomerDTO dto = new CustomerDTO(); //반복될 때마다 new를 하게 됨. (자바 프로그램의 테이블)
				
				//자바빈에 데이터를 저장하려고 한다면?
				//아래는 데이터베이스의 테이블이다.
				dto.setNo(rs.getInt("no")); //다이렉트로 데이터를 저장하도록 한다.
				dto.setName(rs.getString("name"));
				dto.setEmail(rs.getString("email"));
				dto.setTel(rs.getString("tel"));
				//데이터베이스 테이블에 저장된 데이터를 꺼내와서 자바 테이블에 담아주는 것이다.
				
				list.add(dto); //담아온 인스턴스(시작주소값)들을 컬렉션 프레임워크에 담아주는 것이다.
				//이미 list에 담아줬기 때문에 dto인 지역변수는 소멸되더라도 문제가 되지 않는다.
				
				
				//System.out.printf("%d\t %s\t %s\t %s\t\n", no, name, email, tel);
				//출력에 관련된 기능을 dao에 구현하는 것은 옳지 않다.
				//호출해준 쪽에서 데이터를 받아서 출력하는 것으로
				//***DB와의 연동에만 포커스를 맞추는 것이 바람직하다.
				
				//반환받아온 데이터를 select를 호출한 쪽에서 리턴하고 복귀할 때
				//데이터들도 전달받아서 menu에서 처리를 해주고 싶은 것이다.
				
				//rs에 담겨진 데이터를 어떻게 menu쪽으로 반환(리턴)을 할 수 있을까?
				//return은 하나의 값만 전달할 수 있음!!
				//자바는 객체지향적으로 데이터를 관리하자 -> 레코드 단위(3개임)
				//레코드단위를 쉽게 관리하라고 컬렉션 프레임워크를 제공하는 것이다. (인스턴스 단위로 데이터를 관리)
				
			}
			
			return list; //호출해준 쪽으로 list의 주소값만 반환해주면 list.get을 통해 호출해주면 된다.
			//정상적일 때는 list를 반환
			
		} catch (Exception e) { 
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
		
		//예외가 발생을 했다고 한다면 null이 반환되도록 한다.
		return null;
		
	}
	
	
	public void update(CustomerDTO data) {
		
		PreparedStatement pstmt = null; 
		Connection conn = null; 
		
		try { 
			conn = DriverManager.getConnection(url, "scott", "tiger");
			
			pstmt = conn.prepareStatement(updateSql);
			pstmt.setString(1, data.getName()); //자바빈으로 전달받은 데이터 값을 통해 getter로 꺼내오도록 한다.
			pstmt.setString(2, data.getEmail());
			pstmt.setString(3, data.getTel());
			pstmt.setInt(4, data.getNo());
			
			pstmt.executeUpdate(); //실행하고 저장된 갯수만큼의 데이터 반환 
			
			
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); }
				if(conn != null) { conn.close(); } 
				
			} catch (SQLException e) { e.printStackTrace(); }
		}
		
	}
	
	
	public void delete(CustomerDTO data) {
		
		PreparedStatement pstmt = null;
		Connection conn = null;
				
		try {
			conn = DriverManager.getConnection(url, "scott", "tiger");
			pstmt = conn.prepareStatement(deleteSql);
			pstmt.setInt(1, data.getNo());
			pstmt.executeUpdate();
			
					
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); } 
				if(conn != null) { conn.close(); } 
				
			} catch (SQLException e) { e.printStackTrace(); }
		}
		
	}
}


//객체지향이란? DB와 같이 테이블로써 데이터를 관리할 수 있도록 DB와 연동이 가능하도록 프로그램상에서 제공해주는 것
//DB안에 만들어져 있는 테이블의 데이터를 프로그램 안에서 어떻게 레코드 데이터로 동일한 의미로 데이터를 다룰 것인가 
//그것을 매칭시키기 위해서 제공하고 있는 것이 프로그램 안에서는 객체지향인 것이다.

//자바가 웹서비스기술을 위해 추가적으로 제공해주는 것이 jsp이다.
//모든 데이터를 데이터베이스에서 관리하는 것이다. 이 관리하는 데이터들을 exam04의 구조로 구현된다.
