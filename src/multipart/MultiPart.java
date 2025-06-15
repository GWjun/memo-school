package src.multipart;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import jakarta.servlet.http.Part;
import src.bean.MyPart;

// 파일 업로드를 위한 MultiPart 클래스
public class MultiPart {

  private Map<String, MyPart> fileMap;

  public MultiPart(Collection<Part> parts, String realFolder) throws IOException {
    fileMap = new HashMap<>();
    for (Part part : parts) {
      String fileName = part.getSubmittedFileName();

      if (fileName != null && fileName.length() != 0) {
        String fileDotExt = fileName.substring(fileName.lastIndexOf("."), fileName.length());
        UUID uuid = UUID.randomUUID();
        String savedFileName =
            fileName.substring(0, fileName.lastIndexOf(".")) + "_" + uuid.toString() + fileDotExt;

        part.write(
            realFolder + File.separator + savedFileName);

        MyPart mp = new MyPart(part, savedFileName);
        fileMap.put(part.getName(), mp);  //file type name속성 값을 key로 설정

        part.delete();
      }
    }
  }

  // 클라이언트에서 전송받은 파일이 없으면, null 반환
  public MyPart getMyPart(String paramName) {
    return fileMap.get(paramName);
  }

  public String getSavedFileName(String paramName) {
    return fileMap.get(paramName).getSavedFileName();
  }

  // HashMap에서 file type name 파라미터 값을 key로하는 value값(MyPart)을 알아낸 후, 변경전 파일명 반환
  public String getOriginalFileName(String paramName) {
    return this.getMyPart(paramName).getPart().getSubmittedFileName();
  }
}
