package exam04;

import java.util.Scanner;

//[ 실제 실무에서 데이터베이스와 연동할 때의 구조를 잡아가는 부분의 실습임 ]
//자바에서 실제로 동작을 시킬 때 입력, 수정, 삭제, 검색(CRUD)의 동작을 따로 따로 실행을 하지 않을 것이다.
//프로그램이 수행되는 과정에서 삽입, 수정, 삭제, 읽어오기의 동작들이 
//수시로 이벤트들의 처리를 수행하게끔 구성을 하는 것이 일반적이다. -> 실습으로 구조를 이해할 예정(이해해야 할 필수요소임)

//테이블 형태의 데이터를 자바에서 테이블로 관리하겠다는 것이 객체지향 => class키워드를 통해 정의 (테이블의 틀)
//customer에 있는 데이터를 객체지향으로 관리하겠다는 것이다.

public class UseJDBC {
	public static void main(String[] args) {
		Menu menu = new Menu();
		
		menu.showMenu(); //메뉴를 호출하도록 한다.
		
		
	}
}
