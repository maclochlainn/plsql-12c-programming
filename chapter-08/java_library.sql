/* ================================================================
||   Program Name: java_library.sql
||   Date:         2013-07-25
||   Book:         Oracle Database 12c PL/SQL Programming
||   Chapter #:    Chapter 8
||   Author Name:  Michael McLaughlin
|| ----------------------------------------------------------------
||   Contents:
||   ---------
||   This script demonstrates Java library and a PL/SQL wrapper to
||   the Java library.
|| ================================================================*/

SET SERVEROUTPUT ON SIZE UNLIMITED


CREATE OR REPLACE AND COMPILE JAVA SOURCE NAMED "TwoSignersJava" AS

  // Required class libraries.
  import java.sql.*;
  import oracle.jdbc.driver.*;

  // Define class.
  public class TwoSignersJava {

    // Connect and verify new insert would be a duplicate.
    public static int contactTrigger(Integer memberID)
      throws SQLException {
      Boolean duplicateFound = false;  // Control default value.

      // Create a Java 5 and Oracle 11g connection.
      Connection conn =
        DriverManager.getConnection("jdbc:default:connection:");

      // Create a prepared statement that accepts binding a number.
      PreparedStatement ps =
         conn.prepareStatement("SELECT   null " +
                               "FROM     contact c JOIN member m " +
                               "ON       c.member_id = m.member_id " +
                               "WHERE    c.member_id = ? " +
                               "HAVING   COUNT(*) > 1");

      // Bind the local variable to the statement placeholder.
      ps.setInt(1, memberID);

      // Execute query and check if there is a second value.
      ResultSet rs = ps.executeQuery();
      if (rs.next())
        duplicateFound = true;         // Control override value.

      // Clean up resources.
      rs.close();
      ps.close();
      conn.close();

      /* Return 1 (true) when two signers exist and 0 when they don't. */
      if (duplicateFound) return 1;
      else                return 0; }}
/

CREATE OR REPLACE FUNCTION two_signers
( pv_member_id  NUMBER) RETURN NUMBER IS
LANGUAGE JAVA
NAME 'TwoSignersJava.contactTrigger(java.lang.Integer) return int';
/

SELECT  CASE
          WHEN two_signers(member_id) = 0 THEN 'Only one signer.'
          ELSE 'Already two signers.'
        END AS "Available for Assignment"
FROM    contact c JOIN member m USING (member_id)
WHERE   c.last_name = 'Sweeney'
OFFSET 1 ROWS FETCH FIRST 1 ROWS ONLY;
