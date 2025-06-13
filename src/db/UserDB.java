package myBean.db;

import myBean.bean.User;
import java.sql.*;
import javax.naming.NamingException;

// 사용자 DB 클래스
public class UserDB {

  private Connection con;

  // DB 연결 생성자
  public UserDB() throws NamingException, SQLException {
    con = DsCon.getConnection();
  }

  // 자원 해제 메소드
  public void close() throws SQLException {
    if (con != null) {
      con.close();
    }
  }

  // 회원 등록
  public int insertUser(User user) throws SQLException {
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int generatedId = -1;

    try {
      String sql = "INSERT INTO users (login_id, password, nickname) VALUES (?, ?, ?)";
      pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
      pstmt.setString(1, user.getLoginId());
      pstmt.setString(2, user.getPassword());
      pstmt.setString(3, user.getNickname());

      pstmt.executeUpdate();
      rs = pstmt.getGeneratedKeys();
      if (rs.next()) {
        generatedId = rs.getInt(1);
      }
      return generatedId;
    } finally {
      if (rs != null) {
        rs.close();
      }
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }

  // 로그인 처리
  public User login(String loginId, String password) throws SQLException {
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    User user = null;

    try {
      String sql = "SELECT * FROM users WHERE login_id = ? AND password = ?";
      pstmt = con.prepareStatement(sql);
      pstmt.setString(1, loginId);
      pstmt.setString(2, password);

      rs = pstmt.executeQuery();
      if (rs.next()) {
        user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setLoginId(rs.getString("login_id"));
        user.setPassword(rs.getString("password"));
        user.setNickname(rs.getString("nickname"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
      }
      return user;
    } finally {
      if (rs != null) {
        rs.close();
      }
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }

  // 사용자 조회
  public User getUserById(int userId) throws SQLException {
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    User user = null;

    try {
      String sql = "SELECT * FROM users WHERE user_id = ?";
      pstmt = con.prepareStatement(sql);
      pstmt.setInt(1, userId);

      rs = pstmt.executeQuery();
      if (rs.next()) {
        user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setLoginId(rs.getString("login_id"));
        user.setPassword(rs.getString("password"));
        user.setNickname(rs.getString("nickname"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
      }
      return user;
    } finally {
      if (rs != null) {
        rs.close();
      }
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }

  // 사용자 정보 수정
  public boolean updateUser(User user) throws SQLException {
    PreparedStatement pstmt = null;

    try {
      String sql = "UPDATE users SET nickname = ?, password = ? WHERE user_id = ?";
      pstmt = con.prepareStatement(sql);
      pstmt.setString(1, user.getNickname());
      pstmt.setString(2, user.getPassword());
      pstmt.setInt(3, user.getUserId());

      pstmt.executeUpdate();
      return true;
    } finally {
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }

  // 사용자 삭제
  public boolean deleteUser(int userId) throws SQLException {
    PreparedStatement pstmt = null;

    try {
      String sql = "DELETE FROM users WHERE user_id = ?";
      pstmt = con.prepareStatement(sql);
      pstmt.setInt(1, userId);

      pstmt.executeUpdate();
      return true;
    } finally {
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }
}
