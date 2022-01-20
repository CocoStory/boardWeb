package boardWeb.vo;

public class Member {//엔티티 클래스 : 엔티티클래스로부터 만들어진 객체가 빈이다 
	private String memberid;
	private String memberpwd;
	private String membername;
	private String gender;
	private String addr;
	private String phone;
	private int midx;
	
	
	public String getMemberid() {
		return memberid;
	}
	public int getMidx() {
		return midx;
	}
	public void setMidx(int midx) {
		this.midx = midx;
	}
	public void setMemberid(String memberid) {
		this.memberid = memberid;
	}
	public String getMemberpwd() {
		return memberpwd;
	}
	public void setMemberpwd(String memberpwd) {
		this.memberpwd = memberpwd;
	}
	public String getMembername() {
		return membername;
	}
	public void setMembername(String membername) {
		this.membername = membername;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	private String email;
	
}
