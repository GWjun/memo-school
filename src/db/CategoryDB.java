package myBean.db;

import myBean.bean.Category;
import java.sql.*;
import javax.naming.NamingException;
import java.util.ArrayList;
import java.util.List;

// 카테고리 DB 클래스
public class CategoryDB {

  private Connection con;

  // 데이터베이스 연결
  public CategoryDB() throws NamingException, SQLException {
    con = DsCon.getConnection();
  }

  // 연결 종료
  public void close() throws SQLException {
    if (con != null) {
      con.close();
    }
  }

  // 카테고리 등록
  public int insertCategory(Category category) throws SQLException {
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int generatedId = -1;

    try {
      String sql = "INSERT INTO categories (user_id, category_name) VALUES (?, ?)";
      pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
      pstmt.setInt(1, category.getUserId());
      pstmt.setString(2, category.getCategoryName());

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

  // 카테고리 목록 조회
  public List<Category> getCategoriesByUserId(int userId) throws SQLException {
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<Category> categories = new ArrayList<>();

    try {
      String sql = "SELECT c.*, COUNT(m.memo_id) as memo_count FROM categories c " +
          "LEFT JOIN memos m ON c.category_id = m.category_id " +
          "WHERE c.user_id = ? " +
          "GROUP BY c.category_id " +
          "ORDER BY c.category_name";
      pstmt = con.prepareStatement(sql);
      pstmt.setInt(1, userId);

      rs = pstmt.executeQuery();
      while (rs.next()) {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setUserId(rs.getInt("user_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setMemoCount(rs.getInt("memo_count"));
        categories.add(category);
      }
      return categories;
    } finally {
      if (rs != null) {
        rs.close();
      }
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }

  // 카테고리 조회
  public Category getCategoryById(int categoryId) throws SQLException {
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Category category = null;

    try {
      String sql = "SELECT c.*, COUNT(m.memo_id) as memo_count FROM categories c " +
          "LEFT JOIN memos m ON c.category_id = m.category_id " +
          "WHERE c.category_id = ? " +
          "GROUP BY c.category_id";
      pstmt = con.prepareStatement(sql);
      pstmt.setInt(1, categoryId);

      rs = pstmt.executeQuery();
      if (rs.next()) {
        category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setUserId(rs.getInt("user_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setMemoCount(rs.getInt("memo_count"));
      }
      return category;
    } finally {
      if (rs != null) {
        rs.close();
      }
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }

  // 카테고리 수정
  public boolean updateCategory(Category category) throws SQLException {
    PreparedStatement pstmt = null;

    try {
      String sql = "UPDATE categories SET category_name = ? WHERE category_id = ? AND user_id = ?";
      pstmt = con.prepareStatement(sql);
      pstmt.setString(1, category.getCategoryName());
      pstmt.setInt(2, category.getCategoryId());
      pstmt.setInt(3, category.getUserId());

      pstmt.executeUpdate();
      return true;
    } finally {
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }

  // 카테고리 삭제
  public boolean deleteCategory(int categoryId, int userId) throws SQLException {
    PreparedStatement pstmt = null;

    try {
      String sql = "DELETE FROM categories WHERE category_id = ? AND user_id = ?";
      pstmt = con.prepareStatement(sql);
      pstmt.setInt(1, categoryId);
      pstmt.setInt(2, userId);

      pstmt.executeUpdate();
      return true;
    } finally {
      if (pstmt != null) {
        pstmt.close();
      }
    }
  }
}
