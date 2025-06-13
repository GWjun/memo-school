package myBean.db;

import myBean.bean.Memo;
import java.sql.*;
import javax.naming.NamingException;
import java.util.ArrayList;
import java.util.List;

// 메모 DB 클래스
public class MemoDB {

  private Connection con;

  // DB 연결 생성자
  public MemoDB() throws NamingException, SQLException {
    con = DsCon.getConnection();
  }

  // 연결 종료
  public void close() throws SQLException {
    if (con != null) {
      con.close();
    }
  }

  // 메모 등록
  public int insertMemo(Memo memo) throws SQLException {
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int generatedId = -1;

    try {
      String sql =
          "INSERT INTO memos (user_id, category_id, title, content, is_important, background_color, image_url) "
              +
              "VALUES (?, ?, ?, ?, ?, ?, ?)";
      pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
      pstmt.setInt(1, memo.getUserId());
      pstmt.setInt(2, memo.getCategoryId());
      pstmt.setString(3, memo.getTitle());
      pstmt.setString(4, memo.getContent());
      pstmt.setBoolean(5, memo.isImportant());
      pstmt.setString(6, memo.getBackgroundColor());
      pstmt.setString(7, memo.getImageUrl());

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

  // 카테고리별 메모 목록 조회
  public List<Memo> getMemosByCategory(int categoryId, int userId) throws SQLException {
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<Memo> memos = new ArrayList<>();

    try {
      String sql = "SELECT m.*, c.category_name FROM memos m " +
          "INNER JOIN categories c ON m.category_id = c.category_id " +
          "WHERE m.category_id = ? AND m.user_id = ? " +
          "ORDER BY m.is_important DESC, m.created_at DESC";
      pstmt = con.prepareStatement(sql);
      pstmt.setInt(1, categoryId);
      pstmt.setInt(2, userId);

      rs = pstmt.executeQuery();
      while (rs.next()) {
        Memo memo = new Memo();
        memo.setMemoId(rs.getInt("memo_id"));
        memo.setUserId(rs.getInt("user_id"));
        memo.setCategoryId(rs.getInt("category_id"));
        memo.setTitle(rs.getString("title"));
        memo.setContent(rs.getString("content"));
        memo.setImportant(rs.getBoolean("is_important"));
        memo.setBackgroundColor(rs.getString("background_color"));
        memo.setImageUrl(rs.getString("image_url"));
        memo.setCreatedAt(rs.getTimestamp("created_at"));
        memo.setUpdatedAt(rs.getTimestamp("updated_at"));
        memo.setCategoryName(rs.getString("category_name"));
        memos.add(memo);
      }
      return memos;
    } finally {
      if (rs != null) {
        rs.close();
      }
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }

  // 메모 상세 조회
  public Memo getMemoById(int memoId, int userId) throws SQLException {
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Memo memo = null;

    try {
      String sql = "SELECT m.*, c.category_name FROM memos m " +
          "INNER JOIN categories c ON m.category_id = c.category_id " +
          "WHERE m.memo_id = ? AND m.user_id = ?";
      pstmt = con.prepareStatement(sql);
      pstmt.setInt(1, memoId);
      pstmt.setInt(2, userId);

      rs = pstmt.executeQuery();
      if (rs.next()) {
        memo = new Memo();
        memo.setMemoId(rs.getInt("memo_id"));
        memo.setUserId(rs.getInt("user_id"));
        memo.setCategoryId(rs.getInt("category_id"));
        memo.setTitle(rs.getString("title"));
        memo.setContent(rs.getString("content"));
        memo.setImportant(rs.getBoolean("is_important"));
        memo.setBackgroundColor(rs.getString("background_color"));
        memo.setImageUrl(rs.getString("image_url"));
        memo.setCreatedAt(rs.getTimestamp("created_at"));
        memo.setUpdatedAt(rs.getTimestamp("updated_at"));
        memo.setCategoryName(rs.getString("category_name"));
      }
      return memo;
    } finally {
      if (rs != null) {
        rs.close();
      }
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }

  // 메모 수정
  public boolean updateMemo(Memo memo) throws SQLException {
    PreparedStatement pstmt = null;

    try {
      String sql = "UPDATE memos SET category_id = ?, title = ?, content = ?, is_important = ?, " +
          "background_color = ?, image_url = ? WHERE memo_id = ? AND user_id = ?";
      pstmt = con.prepareStatement(sql);
      pstmt.setInt(1, memo.getCategoryId());
      pstmt.setString(2, memo.getTitle());
      pstmt.setString(3, memo.getContent());
      pstmt.setBoolean(4, memo.isImportant());
      pstmt.setString(5, memo.getBackgroundColor());
      pstmt.setString(6, memo.getImageUrl());
      pstmt.setInt(7, memo.getMemoId());
      pstmt.setInt(8, memo.getUserId());

      pstmt.executeUpdate();
      return true;
    } finally {
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }

  // 메모 삭제
  public boolean deleteMemo(int memoId, int userId) throws SQLException {
    PreparedStatement pstmt = null;

    try {
      String sql = "DELETE FROM memos WHERE memo_id = ? AND user_id = ?";
      pstmt = con.prepareStatement(sql);
      pstmt.setInt(1, memoId);
      pstmt.setInt(2, userId);

      pstmt.executeUpdate();
      return true;
    } finally {
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }

  // 메모 검색 기능
  public List<Memo> searchMemos(int userId, String keyword, String searchType) throws SQLException {
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<Memo> memos = new ArrayList<>();

    try {
      String whereClause;

      if (searchType.equals("title")) {
        whereClause = "m.title LIKE ?";
      } else if (searchType.equals("content")) {
        whereClause = "m.content LIKE ?";
      } else {
        // 제목과 내용 모두 검색
        whereClause = "(m.title LIKE ? OR m.content LIKE ?)";
      }

      String sql = "SELECT m.*, c.category_name FROM memos m " +
          "INNER JOIN categories c ON m.category_id = c.category_id " +
          "WHERE m.user_id = ? AND " + whereClause + " " +
          "ORDER BY m.is_important DESC, m.created_at DESC";

      pstmt = con.prepareStatement(sql);
      pstmt.setInt(1, userId);

      String keywordPattern = "%" + keyword + "%";
      if (searchType.equals("title") || searchType.equals("content")) {
        pstmt.setString(2, keywordPattern);
      } else {
        // 제목과 내용 모두 검색
        pstmt.setString(2, keywordPattern);
        pstmt.setString(3, keywordPattern);
      }

      rs = pstmt.executeQuery();
      while (rs.next()) {
        Memo memo = new Memo();
        memo.setMemoId(rs.getInt("memo_id"));
        memo.setUserId(rs.getInt("user_id"));
        memo.setCategoryId(rs.getInt("category_id"));
        memo.setTitle(rs.getString("title"));
        memo.setContent(rs.getString("content"));
        memo.setImportant(rs.getBoolean("is_important"));
        memo.setBackgroundColor(rs.getString("background_color"));
        memo.setImageUrl(rs.getString("image_url"));
        memo.setCreatedAt(rs.getTimestamp("created_at"));
        memo.setUpdatedAt(rs.getTimestamp("updated_at"));
        memo.setCategoryName(rs.getString("category_name"));
        memos.add(memo);
      }
      return memos;
    } finally {
      if (rs != null) {
        rs.close();
      }
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }
}
