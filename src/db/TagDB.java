package src.db;

import src.bean.Tag;
import java.sql.*;
import javax.naming.NamingException;
import java.util.ArrayList;
import java.util.List;

// 태그 DB 클래스
public class TagDB {

  private Connection con;
  private PreparedStatement pstmt;
  private ResultSet rs;

  // DB 연결 생성자
  public TagDB() throws NamingException, SQLException {
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

  // 태그 등록
  public int insertTag(Tag tag) throws SQLException {
    int generatedId = -1;

    String sql = "INSERT INTO tags (tag_name) VALUES (?) ON DUPLICATE KEY UPDATE tag_id = LAST_INSERT_ID(tag_id)";
    pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
    pstmt.setString(1, tag.getTagName());

    pstmt.executeUpdate();
    rs = pstmt.getGeneratedKeys();
    if (rs.next()) {
      generatedId = rs.getInt(1);
    } else {
      // 이미 존재하는 태그 ID 조회
      sql = "SELECT tag_id FROM tags WHERE tag_name = ?";
      pstmt = con.prepareStatement(sql);
      pstmt.setString(1, tag.getTagName());
      rs = pstmt.executeQuery();
      if (rs.next()) {
        generatedId = rs.getInt("tag_id");
      }
    }
    return generatedId;
  }

  // 메모에 태그 연결
  public boolean addTagToMemo(int memoId, int tagId) throws SQLException {
    try {
      String sql = "INSERT INTO memo_tags (memo_id, tag_id) VALUES (?, ?)";
      pstmt = con.prepareStatement(sql);
      pstmt.setInt(1, memoId);
      pstmt.setInt(2, tagId);

      pstmt.executeUpdate();
      return true;
    } catch (SQLIntegrityConstraintViolationException e) {
      // 이미 존재하는 관계
      return true;
    }
  }

  // 메모의 태그 목록 조회
  public List<Tag> getTagsByMemoId(int memoId) throws SQLException {
    List<Tag> tags = new ArrayList<>();

    String sql = "SELECT t.* FROM tags t " +
        "INNER JOIN memo_tags mt ON t.tag_id = mt.tag_id " +
        "WHERE mt.memo_id = ? " +
        "ORDER BY t.tag_name";
    pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, memoId);

    rs = pstmt.executeQuery();
    while (rs.next()) {
      Tag tag = new Tag();
      tag.setTagId(rs.getInt("tag_id"));
      tag.setTagName(rs.getString("tag_name"));
      tags.add(tag);
    }
    return tags;
  }

  // 태그로 메모 검색
  public List<Integer> getMemoIdsByTagName(String tagName) throws SQLException {
    List<Integer> memoIds = new ArrayList<>();

    String sql = "SELECT mt.memo_id FROM memo_tags mt " +
        "INNER JOIN tags t ON mt.tag_id = t.tag_id " +
        "WHERE t.tag_name = ?";
    pstmt = con.prepareStatement(sql);
    pstmt.setString(1, tagName);

    rs = pstmt.executeQuery();
    while (rs.next()) {
      memoIds.add(rs.getInt("memo_id"));
    }
    return memoIds;
  }

  // 메모의 태그 삭제
  public boolean removeTagFromMemo(int memoId, int tagId) throws SQLException {
    String sql = "DELETE FROM memo_tags WHERE memo_id = ? AND tag_id = ?";
    pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, memoId);
    pstmt.setInt(2, tagId);

    pstmt.executeUpdate();
    return true;
  }

  // 메모의 모든 태그 삭제
  public boolean removeAllTagsFromMemo(int memoId) throws SQLException {
    String sql = "DELETE FROM memo_tags WHERE memo_id = ?";
    pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, memoId);

    pstmt.executeUpdate();
    return true;
  }

  // 태그 목록 조회
  public List<Tag> getAllTags() throws SQLException {
    List<Tag> tags = new ArrayList<>();

    String sql = "SELECT * FROM tags ORDER BY tag_name";
    pstmt = con.prepareStatement(sql);

    rs = pstmt.executeQuery();
    while (rs.next()) {
      Tag tag = new Tag();
      tag.setTagId(rs.getInt("tag_id"));
      tag.setTagName(rs.getString("tag_name"));
      tags.add(tag);
    }
    return tags;
  }
}
