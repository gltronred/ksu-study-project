package org.kohomologie.gasaccount;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import org.junit.*;
import org.kohomologie.gasaccount.dao.EntryListHandler;
import org.kohomologie.gasaccount.entity.Entry;
import org.apache.commons.dbutils.*;
/**
 * Unit test for simple App.
 */
public class AppTest
{
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    @Test
    public void ololo() throws SQLException, ClassNotFoundException
    {
       Class.forName("org.h2.Driver");
       Connection conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/gasAccount",
               "sa","");
       QueryRunner qr = new QueryRunner();
       List<Entry> entries = (List)qr.query(conn,
               "SELECT * FROM ENTRY",
               new EntryListHandler());
       conn.close();
       System.out.println(entries.get(0));
    }
}
