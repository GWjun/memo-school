package src.db;

import java.sql.*;
import javax.naming.*;
import javax.sql.*;

public class DsCon {

  /**
   * Context로부터 커넥션 풀에 접근하여 Connection 을 가져온다.
   *
   * @return Connection
   * @throws SQLException, NamingException
   */
  public static Connection getConnection() throws NamingException, SQLException {
    Context initContext = new InitialContext();
    DataSource ds = (DataSource) initContext.lookup("java:/comp/env/jdbc/memodb");
    return ds.getConnection();
  }
}
