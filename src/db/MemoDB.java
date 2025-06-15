package src.db;

import src.bean.Memo;
import java.sql.*;
import javax.naming.NamingException;
import java.util.ArrayList;
import java.util.List;

// 메모 DB 클래스
public class MemoDB {

  private Connection con;
  private PreparedStatement pstmt;
  private ResultSet rs;

  // DB 연결 생성자
  public MemoDB() throws NamingException, SQLException {
    con = DsCon.getConnection();
  }

  // 연결 종료
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

  // 메모 등록
  public int insertMemo(Memo memo) throws SQLException {
    int generatedId = -1;

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
  }

  // 카테고리별 메모 목록 조회
  public List<Memo> getMemosByCategory(int categoryId, int userId) throws SQLException {
    List<Memo> memos = new ArrayList<>();

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
  }

  // 메모 상세 조회
  public Memo getMemoById(int memoId, int userId) throws SQLException {
    Memo memo = null;

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
  }

  // 메모 수정
  public boolean updateMemo(Memo memo) throws SQLException {
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
  }

  // 메모 삭제
  public boolean deleteMemo(int memoId, int userId) throws SQLException {
    String sql = "DELETE FROM memos WHERE memo_id = ? AND user_id = ?";
    pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, memoId);
    pstmt.setInt(2, userId);

    pstmt.executeUpdate();
    return true;
  }

  // 메모 검색 기능
  public List<Memo> searchMemos(int userId, String keyword) throws SQLException {
    List<Memo> memos = new ArrayList<>();

    String sql = "SELECT m.*, c.category_name FROM memos m " +
        "INNER JOIN categories c ON m.category_id = c.category_id " +
        "WHERE m.user_id = ? AND (m.title LIKE ? OR m.content LIKE ?) " +
        "ORDER BY m.is_important DESC, m.created_at DESC";

    pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, userId);

    String keywordPattern = "%" + keyword + "%";
    pstmt.setString(2, keywordPattern);
    pstmt.setString(3, keywordPattern);

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
  }

  // 메모 ID 목록으로 메모 조회
  public List<Memo> getMemosByIds(List<Integer> memoIds, int userId) throws SQLException {
    List<Memo> memos = new ArrayList<>();

    if (memoIds == null || memoIds.isEmpty()) {
      return memos;
    }

    // memoIds 목록을 IN 절에 사용하기 위한 쉼표로 구분된 물음표 생성
    StringBuilder placeholders = new StringBuilder();
    for (int i = 0; i < memoIds.size(); i++) {
      if (i > 0) {
        placeholders.append(", ");
      }
      placeholders.append("?");
    }

    String sql = "SELECT m.*, c.category_name " +
        "FROM memos m " +
        "LEFT JOIN categories c ON m.category_id = c.category_id " +
        "WHERE m.memo_id IN (" + placeholders.toString() + ") " +
        "AND m.user_id = ? " +
        "ORDER BY m.is_important DESC, m.created_at DESC";

    pstmt = con.prepareStatement(sql);

    // 물음표에 메모 ID 값 설정
    int paramIndex = 1;
    for (Integer memoId : memoIds) {
      pstmt.setInt(paramIndex++, memoId);
    }

    // 마지막 물음표는 userId
    pstmt.setInt(paramIndex, userId);

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
      memo.setCategoryName(rs.getString("category_name"));
      memo.setCreatedAt(rs.getTimestamp("created_at"));
      memo.setUpdatedAt(rs.getTimestamp("updated_at"));
      memos.add(memo);
    }

    return memos;
  }
}
