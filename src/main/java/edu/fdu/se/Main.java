package edu.fdu.se;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class Main {
    private final Connection conn;

    public Main(Connection conn) {
        this.conn = conn;
    }

    // 演示：把外部输入直接拼进 SQL（典型 SQL 注入风险）
    public ResultSet findUser(String name) throws Exception {
        String sql = "SELECT * FROM users WHERE name = '" + name + "'";
        Statement stmt = conn.createStatement();
        return stmt.executeQuery(sql);
    }
}