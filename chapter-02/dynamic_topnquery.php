<?php
  /* ================================================================
  ||   Program Name: dynamic_topnquery.php
  ||   Date:         2013-12-02
  ||   Book:         Oracle Database 12c PL/SQL Programming
  ||   Chapter #:    Chapter 2
  ||   Author Name:  Michael McLaughlin
  || ----------------------------------------------------------------
  ||   Contents:
  ||   ---------
  ||   This script shows you how to use dynamic boundaries as the
  ||   arguments to the OFFSET and FIRST parameters.
  ||
  ||   Call without bounds:
  ||   ====================
  ||     http://localhost/dynamic_topnquery.php
  ||
  ||   Call with bounds:
  ||   =================
  ||     http://localhost/dynamic_topnquery.php?offset=1&rows=5
  || ================================================================*/


  $title = "Item Title";

  // Attempt to connect to your database.
  $c = @oci_connect("c##plsql", "Student1", "localhost/orcl");
  if (!$c) {
    print "Sorry! The connection to the database failed. Please try again later.";
    die();
  }
  else {
    // Initialize incoming message whether or not parameter sent.
    $offset = (isset($_GET['offset'])) ? $_GET['offset'] : 0;
    $rows = (isset($_GET['rows'])) ? $_GET['rows'] : 20;
 
    // Set the call statement, like a SQL statement.
    $sql = "SELECT   i.item_title "
         . "FROM     item i "
         . "OFFSET :bv_offset ROWS FETCH FIRST :bv_rows ROWS ONLY";
 
    // Prepare the statement and bind the two strings.
    $stmt = oci_parse($c,$sql);
 
    // Bind local variables into PHP statement, you MUST size OUT only variables.
    oci_bind_by_name($stmt, ":bv_offset", $offset);
    oci_bind_by_name($stmt, ":bv_rows", $rows);
 
    // Execute the PL/SQL statement.
    if (oci_execute($stmt))
    {

      // Set the table tags and header title.
      $out = '<html>';
      $out .= '<head>';
      $out .= '<style type="text/css">';
      $out .= '.e {background-color: #ccccff; font-weight: bold; color: #000000;}';
      $out .= '.h {background-color: #9999cc; font-weight: bold; color: #000000;}';
      $out .= '.v {background-color: #cccccc; color: #000000;}';
      $out .= '</style>';
      $out .= '</head>';
      $out .= '<body>';
      $out .= '<table border="1" cellpadding="3" cellspacing="0">';
      $out .= '<tr>';
      $out .= '<th align="center" class="e">'.$title.'</th>';
      $out .= '</tr>';

      // Return a LOB descriptor as the value.
      while (oci_fetch($stmt))
      { 
        // Open the row.
        $out .= '<tr>';

        // Read the list of columns.
        for ($i = 1;$i <= oci_num_fields($stmt);$i++) {
          if (is_object(oci_result($stmt,$i)))
          {
            if ($size = oci_result($stmt,$i)->size())
              $data = oci_result($stmt,$i)->read($size);
            else
              $data = "&nbsp;";
          }
          else
          {
            if (oci_field_is_null($stmt,$i))
              $data = "&nbsp;";
            else {
              $data = oci_result($stmt,$i);
            }
          }

          // Set the cell.
          $out .= '<td class="v">'.$data.'</td>';
        }
        // Close the row.
        $out .= '</tr>';
      } // End of the while(oci_fetch($s)) loop. 

      // Close the table.
      $out .= '</table>';
      $out .= '</body>';
      $out .= '</html>';
    }
    else { // Pardody on the movie 2001 A Space Odessey.
      print "Sorry, I can't do that Dave...";
    }

    // Free resources.
    oci_free_statement($stmt);
    oci_close($c);
  }

  print $out;
?>
