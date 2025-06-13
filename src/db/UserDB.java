package myBean.db;

import myBean.bean.User;
import java.sql.*;
import javax.naming.NamingException;

// 사용자 DB 클래스
public class UserDB {

  private Connection con;
  private PreparedStatement pstmt;
  private ResultSet rs;

  // DB 연결 생성자
  public UserDB() throws NamingException, SQLException {
    con = DsCon.getConnection();
  }

  // 자원 해제 메소드
  public void close() throws SQLException {
    if (rs != null) {
      rs.close();
    }
    if (pstmt != null) {
      pstmt.close();
    }
    if (con != null) {
      con.close();
    }
  }

  // 회원 등록
  public int insertUser(User user) throws SQLException {
    int generatedId = -1;

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
  }

  // 로그인 처리
  public User login(String loginId, String password) throws SQLException {
    User user = null;

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
  }

  // 사용자 조회
  public User getUserById(int userId) throws SQLException {
    User user = null;

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
  }

  // 아이디 중복 확인
  public boolean isLoginIdDuplicated(String loginId) throws SQLException {
    String sql = "SELECT COUNT(*) FROM users WHERE login_id = ?";
    pstmt = con.prepareStatement(sql);
    pstmt.setString(1, loginId);

    rs = pstmt.executeQuery();
    if (rs.next()) {
      return rs.getInt(1) > 0;
    }
    return false;
  }

  // 사용자 정보 수정
  public boolean updateUser(User user) throws SQLException {
    String sql = "UPDATE users SET nickname = ?, password = ? WHERE user_id = ?";
    pstmt = con.prepareStatement(sql);
    pstmt.setString(1, user.getNickname());
    pstmt.setString(2, user.getPassword());
    pstmt.setInt(3, user.getUserId());

    pstmt.executeUpdate();
    return true;
  }
}
