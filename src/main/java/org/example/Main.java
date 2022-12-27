package org.example;
import org.postgresql.Driver;
import java.io.PrintWriter;
import java.sql.*;

public class Main {

    public static void main(String[] args) throws SQLException {
        String user = "postgres";
        String password = "";
        String url = "jdbc:postgresql://localhost:5432/postgres?currentSchema=lab10";

        Connection connection = DriverManager.getConnection(url, user, password);

        Statement statement = connection.createStatement();
        String selectTableSQL = "select stud.name, subj.subject_name, p.mark\n" +
                "from students as stud\n" +
                "         join progress as p on stud.id = p.student_id\n" +
                "         join subjects as subj on p.subject_id = subj.id where p.mark > 3 group by stud.name, subj.subject_name, p.mark offset 2 limit 4";
        ResultSet rs = statement.executeQuery(selectTableSQL);

        while (rs.next()) {
            String name = rs.getString(1);
            String  sub = rs.getString(2);
            String mark = rs.getString(3);


            System.out.println("Имя: " + name + " Предмет: " + sub + " Оценка: " + mark);


        }
            connection.close();
    }

}