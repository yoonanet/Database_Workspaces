package exam04;

//테이블의 특징: 데이터에 대한 정보가 타이틀로 있음 -> 컬럼
//객체지향을 선언할 때 객체지향은 순수하게 데이터를 관리하기 위한 클래스도 있고,
//컨트롤처럼 동작부분에 포커스를 두고 만든 클래스로 두가지의 종류가 있다.
//데이터 관리(처리)를 목적으로 정의하고 있는 자료형(테이블)을 JavaBean이라고 부른다.

//데이터베이스와 연동해서 자바 프로그램안에서 사용하려면
//그 테이블과 매핑되는 참조자료형을 연결해서 사용하는 것이 
//전형적인 객체지향을 제공해주는 모든 프로그래밍 언어에 공통사항이다.

//new를 하면 이 레코드단위의 데이터를 저장할 메모리 공간이 만들어지는 것임.
//이 필드와 같은 데이터를 한꺼번에 관리를 하는 것이다.
class CustomerDTO { // JavaBean(DTO:Data Transer Object, VO:Value Object)
	private int no; //객체지향의 기본컨셉: 은닉화
	private String name;
	private String email;
	private String tel;
	
	
	//이때 getter, setter를 통해 간접적으로 필드에 접근하도록 한다.
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}	
	
}
