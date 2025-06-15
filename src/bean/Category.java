package src.bean;

import java.sql.Timestamp;

// 카테고리 테이블
public class Category {

  private int categoryId; // 카테고리 ID
  private int userId; // 유저 ID (외래키)
  private int memoCount; // 카테고리의 메모 수
  private String categoryName; // 카테고리 이름
  private Timestamp createdAt;

  public Category() {
  }

  public Category(int categoryId, int userId, String categoryName, Timestamp createdAt) {
    this.categoryId = categoryId;
    this.userId = userId;
    this.categoryName = categoryName;
    this.createdAt = createdAt;
  }

  public int getCategoryId() {
    return categoryId;
  }

  public void setCategoryId(int categoryId) {
    this.categoryId = categoryId;
  }

  public int getUserId() {
    return userId;
  }

  public void setUserId(int userId) {
    this.userId = userId;
  }

  public String getCategoryName() {
    return categoryName;
  }

  public void setCategoryName(String categoryName) {
    this.categoryName = categoryName;
  }

  public Timestamp getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Timestamp createdAt) {
    this.createdAt = createdAt;
  }

  public int getMemoCount() {
    return memoCount;
  }

  public void setMemoCount(int memoCount) {
    this.memoCount = memoCount;
  }
}
