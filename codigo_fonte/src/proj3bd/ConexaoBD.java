/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package proj3bd;

import java.sql.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author bernardold
 */
public class ConexaoBD {

    private static ConexaoBD instance;

    public static Connection conn; 
    public static Statement stmt = null;

    private ConexaoBD() throws SQLException {
        String bdUser = "";
        String bdPassword = "";
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException ex) {
            System.out.println(ex.getMessage());
        }
        
        try {
            conn = DriverManager.getConnection(
                    "",
                    bdUser,      
                    bdPassword);    

            stmt = conn.createStatement();
            
            System.out.println("Conectado ao banco " + bdUser + " com sucesso!");
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

    public static ConexaoBD getInstance() throws SQLException {
        if (instance == null) {
            instance = new ConexaoBD();
        }
        return instance; 
    }
    
    public void destroy () throws SQLException {
        conn.close();
        stmt.close();
        instance = null;
    }
}
