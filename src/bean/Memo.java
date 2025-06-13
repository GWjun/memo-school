package myBean.bean;

import java.sql.Timestamp;

// 메모 테이블
public class Memo {

  private int memoId; // 메모 ID
  private int userId; // 유저 ID (외래키)
  private int categoryId; // 카테고리 ID (외래키)
  private String title; // 메모 제목
  private String content; // 메모 내용
  private boolean isImportant; // 중요 여부
  private String backgroundColor; // 배경색
  private String imageUrl; // 이미지 URL
  private String categoryName; // 카테고리 이름 표시를 위한 필드
  private Timestamp createdAt;
  private Timestamp updatedAt;

  public Memo() {
  }

  public Memo(int memoId, int userId, int categoryId, String title, String content,
      boolean isImportant, String backgroundColor, String imageUrl,
      Timestamp createdAt, Timestamp updatedAt) {
    this.memoId = memoId;
    this.userId = userId;
    this.categoryId = categoryId;
    this.title = title;
    this.content = content;
    this.isImportant = isImportant;
    this.backgroundColor = backgroundColor;
    this.imageUrl = imageUrl;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  public int getMemoId() {
    return memoId;
  }

  public void setMemoId(int memoId) {
    this.memoId = memoId;
  }

  public int getUserId() {
    return userId;
  }

  public void setUserId(int userId) {
    this.userId = userId;
  }

  public int getCategoryId() {
    return categoryId;
  }

  public void setCategoryId(int categoryId) {
    this.categoryId = categoryId;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getContent() {
    return content;
  }

  public void setContent(String content) {
    this.content = content;
  }

  public boolean isImportant() {
    return isImportant;
  }

  public void setImportant(boolean important) {
    isImportant = important;
  }

  public String getBackgroundColor() {
    return backgroundColor;
  }

  public void setBackgroundColor(String backgroundColor) {
    this.backgroundColor = backgroundColor;
  }

  public String getImageUrl() {
    return imageUrl;
  }

  public void setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }

  public Timestamp getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Timestamp createdAt) {
    this.createdAt = createdAt;
  }

  public Timestamp getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(Timestamp updatedAt) {
    this.updatedAt = updatedAt;
  }

  public String getCategoryName() {
    return categoryName;
  }

  public void setCategoryName(String categoryName) {
    this.categoryName = categoryName;
  }
}
