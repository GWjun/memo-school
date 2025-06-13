package myBean.bean;

// 태그 테이블
public class Tag {

  private int tagId; // 태그 ID
  private String tagName; // 태그 이름

  public Tag() {
  }

  public Tag(int tagId, String tagName) {
    this.tagId = tagId;
    this.tagName = tagName;
  }

  public int getTagId() {
    return tagId;
  }

  public void setTagId(int tagId) {
    this.tagId = tagId;
  }

  public String getTagName() {
    return tagName;
  }

  public void setTagName(String tagName) {
    this.tagName = tagName;
  }
}
