<html>
<! ================================================================>
<!   Program Name: QueryRelativeBFILE.php                          >
<!   Date:         2013-07-25                                      >
<!   Book:         Oracle Database 12c PL/SQL Programming          >
<!   Chapter #:    Chapter 10                                      >
<!   Author Name:  Michael McLaughlin                              >
<! ---------------------------------------------------------------->
<!   Contents:                                                     >
<!   ---------                                                     >
<!   This script demonstrates uploading, moving an uploaded        >
<! file, storing the content in an Oracle CLOB column using a      >
<! stored PL/SQL procedure, and then accesses the stored           >
<! content from the database and renders the page.                 >
<head>
<title>
  Chapter 10 : QueryRelativeBFILE.php
</title>
<style>
.e {background-color: #ccccff; font-weight: bold; color: #000000;}
.v {background-color: #cccccc; color: #000000;}
</style>
</head>
<body>
<?php
  // Declare input variables.
  (isset($_GET['id']))    ? $id = (int) $_GET['id'] : $id = 1021;

  // Call the local function.
  query_insert($id);

  // Query results after an insert.
  function query_insert($id)
  {
    // Return successful attempt to connect to the database.
    if ($c = @oci_connect("plsql","plsql","orcl"))
    {
      // Declare a SQL SELECT statement returning a CLOB.
      $stmt = "SELECT   item_title
               ,        item_desc
               ,        get_bfilename('ITEM','ITEM_PHOTO','ITEM_ID',:id)
               FROM     item
               WHERE    item_id = :id";

      // Parse a query through the connection.
      $s = oci_parse($c,$stmt);

      // Bind PHP variables to the OCI types.
      oci_bind_by_name($s,':id',$id);

      // Execute the PL/SQL statement.
      if (oci_execute($s))
      {
        // Return a LOB descriptor as the value.
        while (oci_fetch($s))
        {
          for ($i = 1;$i <= oci_num_fields($s);$i++)
            if (is_object(oci_result($s,$i)))
            {
              if ($size = oci_result($s,$i)->size())
                if (oci_field_type($s,$i) == 'CLOB')
                  $data = oci_result($s,$i)->read($size);
              else
                $data = "&nbsp;";
            }
            else
            {
              if (oci_field_is_null($s,$i))
                $title = "&nbsp;";
              else
                if (substr(oci_result($s,$i),0,1) == '/')
                  $photo = oci_result($s,$i);
                else
                  $title = oci_result($s,$i);
            }

        } // End of the while(oci_fetch($s)) loop.

        // Free statement resources.
        oci_free_statement($s);

        // Format HTML table to display BLOB photo and CLOB description.
        $out = '<table border="1" cellpadding="5" cellspacing="0">';
        $out .= '<tr>';
        $out .= '<td align="center" class="e">'.$title.'</td>';
        $out .= '</tr>';
        $out .= '<tr><td class="v">';
        $out .= '<div>';
        $out .= '<div style="margin-right:5px;float:left">';
        $out .= '<img src="'.$photo.'">';
        $out .= '</div>';
        $out .= '<div style="position=relative;">'.$data.'</div>';
        $out .= '</div>';
        $out .= '</td></tr>';
        $out .= '</table>';
      }

      // Print the HTML table.
      print $out;

      // Disconnect from database.
      oci_close($c);
    }
    else
    {
      // Assign the OCI error and format double and single quotes.
      $errorMessage = oci_error();
      print htmlentities($errorMessage['message'])."<br />";
    }
  }
?>
</body>
</html>