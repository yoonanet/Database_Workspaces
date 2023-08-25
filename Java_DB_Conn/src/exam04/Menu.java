package exam04;

import java.util.List;
import java.util.Scanner;

class Menu { 
	CustomerDAO dao;
	
	Menu() {
		dao = new CustomerDAO();
	}
	
	public void showMenu() {
		
		while(true) {
			Scanner input = new Scanner(System.in);
			
			System.out.println("\n=== 메뉴 ===");
			System.out.println("0. 프로그램 종료.");
			System.out.println("1. 데이터 삽입.");
			System.out.println("2. 데이터 읽어오기.");
			System.out.println("3. 데이터 수정.");
			System.out.println("4. 데이터 삭제."); //특정데이터만 삭제하도록 함
			System.out.println();
			
			System.out.print("메뉴 선택: ");
			int choice = input.nextInt();
			
			switch(choice) {
			case 0:
				System.out.println("프로그램 종료.");
				return;
			case 1:
				insertAction();
				break;
			case 2:
				selectAction();
				break;
			case 3:
				updateAction();
				break;
			case 4:
				deleteAction();
				break;
			default:
				break;
			}
			
		}	
	}
	
	
	private void insertAction() { //외부에서 불러서 사용하지 못하도록 접근제어자를 private로 지정하도록 한다.
		//사용자로부터 입력받은 데이터를 전달하게 되는데 그 전달하는 단위를 DTO단위로 잡는 것이다.
		//그 단위로 데이터베이스에 전달하면 된다.
		Scanner keyboard = new Scanner(System.in);
		
		//CustomerDAO dao = new CustomerDAO();
		CustomerDTO data = new CustomerDTO(); //데이터는 CustomerDTO객체 하나로 바라보는 것임
		
		// DB에 데이터 삽입
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
		
		
		//키보드로부터 전달받은 값들은 set에 넣어주면 할당된 메모리에 저장이 됨
		data.setNo(no);
		data.setName(name);
		data.setEmail(email);
		data.setTel(tel);
		
		//특징들은 수천 개로 보관을 할 수 있고, 특징이 추가되면 변경하기 번거롭고 어려울 것이다.
		//dao.insert(no, name, email, tel); //따라서 객체지향적으로 관리하면 된다는 것이다. (할당된 메모리 만큼으로 관리하는 것)
		dao.insert(data); //필드가 추가된다고 하더라도 이 코드를 변경할 필요가 없음
	}
	
	
	private void selectAction() {
		List<CustomerDTO> list = dao.select(); //전체데이터 읽어오는 기능으로 구현.
		//정상적인 작동으로 반환되어 온다면 list의 주소값이 반환되어 올 것이다. => 그 주소값을 보관한다.
		//이미 데이터베이스에서 데이터를 꺼내와서 heap영역에 담아두는 작업을 끝냈기 때문에 더이상 데이터베이스를 신경 쓸 필요가 없다.
		
		System.out.println("번호\t이름\t이메일\t전화번호\t");
		System.out.println("-------------------------------------------");
		
		for(CustomerDTO dto: list) {
			System.out.printf("%d\t %s\t %s\t %s \n", dto.getNo(), dto.getName(), dto.getEmail(), dto.getTel());
			
		}
		
	}
	
	//내가 수정하고 싶은 대상에 대한 정보를 사용자로부터 전달받아서 
	//그 정보를 다시 DB에 전달해서 쿼리문을 날리게끔 기능을 구현
	private void updateAction() {
		Scanner input = new Scanner(System.in);
		
		CustomerDTO dto = new CustomerDTO(); //프로그램에서 사용할 테이블 - 자바빈(레코드 단위)
		
		System.out.print("수정할 번호 입력: ");
		dto.setNo(input.nextInt()); 
		//변수에 담지 않고 다이렉트로 데이터를 담아주도록 한다. => 변수를 한번만 쓰기 때문에 두 줄로 작성할 필요가 없음
		
		input.nextLine(); //dummy code => enter가 살아있기 때문이다.
		
		//수정할 데이터들을 입력 받기 => 입력받은 값들을 dao에 바로 전달하도록 한다. 그래야 쿼리문을 받아서 처리를 해줌
		System.out.print("수정할 이름: ");
		dto.setName(input.nextLine());
		
		System.out.print("수정할 이메일: ");
		dto.setEmail(input.nextLine());
		
		System.out.print("수정할 전화번호: ");
		dto.setTel(input.nextLine());
		
		//dto.setNo(no); //이 코드는 한번밖에 사용하지 않기 때문에 간단하게 코드를 구성하도록 한다. => 바로 set에 담도록 함

		
		dao.update(dto);
		
	}
	
	private void deleteAction() {
		Scanner input = new Scanner(System.in);
		
		CustomerDTO dto = new CustomerDTO();
		
		System.out.println("테이블 값 삭제하기.");
		System.out.print("삭제할 번호 입력 : ");
		dto.setNo(input.nextInt());
		
		dao.delete(dto);
	}
	
	
}
