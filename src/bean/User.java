package myBean.bean;

import java.sql.Timestamp;

// 유저 테이블
public class User {

  private int userId; // 유저 ID
  private String loginId; // 로그인 ID
  private String password; // 비밀번호
  private String nickname; // 닉네임
  private Timestamp createdAt;

  public User() {
  }

  public User(int userId, String loginId, String password, String nickname, Timestamp createdAt) {
    this.userId = userId;
    this.loginId = loginId;
    this.password = password;
    this.nickname = nickname;
    this.createdAt = createdAt;
  }

  public int getUserId() {
    return userId;
  }

  public void setUserId(int userId) {
    this.userId = userId;
  }

  public String getLoginId() {
    return loginId;
  }

  public void setLoginId(String loginId) {
    this.loginId = loginId;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  public String getNickname() {
    return nickname;
  }

  public void setNickname(String nickname) {
    this.nickname = nickname;
  }

  public Timestamp getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Timestamp createdAt) {
    this.createdAt = createdAt;
  }
}
