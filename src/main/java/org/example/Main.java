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
        String selectTableSQL = "select  get_avg_mark(subj.subject_name), subj.subject_name, stud.name, p.mark from students as stud\n" +
                "    join progress as p on stud.id = p.student_id\n" +
                "    join subjects as subj on p.subject_id = subj.id where subj.subject_name = 'Технологии программирования'\n" +
                "                                                    or subj.subject_name = 'Управление данными'\n" +
                "group by p.mark, stud.name, subj.subject_name having p.mark > get_avg_mark(subj.subject_name)";
        ResultSet rs = statement.executeQuery(selectTableSQL);

        // И если что то было получено то цикл while сработает
        while (rs.next()) {
            String avg = rs.getString(1);
            String subj = rs.getString("subject_name");
            String name = rs.getString("name");
            String mark = rs.getString("mark");

            System.out.println("avg : " + avg);
            System.out.println("subj : " + subj);
            System.out.println("name : " + name);
            System.out.println("mark : " + mark);
        }
        /*try {

            // выбираем данные с БД
            ResultSet rs = statement.executeQuery(selectTableSQL);

            // И если что то было получено то цикл while сработает
            while (rs.next()) {
                String userid = rs.getString("id");
                String username = rs.getString("name");

                System.out.println("userid : " + userid);
                System.out.println("username : " + username);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }*/

        /*try (PreparedStatement statement = connection.prepareStatement("SELECT * FROM students")) {

            //statement.setInt(1, 2);

            //final ResultSet resultSet = statement.executeQuery();





            while (resultSet.next())
            {

            }
            if (resultSet.next()) {
                System.out.println(resultSet.getString('1'));
                String byName = "login: " + resultSet.getString("login");
                String byIndex = "password: " + resultSet.getString(3);
                final int role = resultSet.getInt("role");
                System.out.println(byName);
                System.out.println(byIndex);
                System.out.println("role: " +role);
            }*/

            connection.close();

    }

}