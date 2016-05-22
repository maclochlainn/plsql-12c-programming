<?php
  /* ================================================================
  ||   Program Name: ReadCanonicalFileToImage.php
  ||   Date:         2013-07-25
  ||   Book:         Oracle Database 12c PL/SQL Programming
  ||   Chapter #:    Chapter 10
  ||   Author Name:  Michael McLaughlin
  || ----------------------------------------------------------------
  ||   Contents:
  ||   ---------
  ||   The header must be inside the PHP script tag because nothing
  ||   can be rendered before the header() function call that signals
  ||   this is a PNG file.
  || ================================================================ */

  // Return successful attempt to connect to the database.
  if ($c = @oci_new_connect("plsql","plsql","orcl"))
  {
    // Declare input variables.
    (isset($_GET['id']))    ? $id = $_GET['id'] : $id = 1021;

    // Declare a SQL SELECT statement returning a CLOB.
    $stmt = "SELECT get_canonical_bfilename('ITEM','ITEM_PHOTO','ITEM_ID',:id)
             FROM   dual";

    // Parse a query through the connection.
    $s = oci_parse($c,$stmt);

    // Bind PHP variables to the OCI types.
    oci_bind_by_name($s,':id',$id);

    // Execute the PL/SQL statement.
    if (oci_execute($s))
    {
      // Return a LOB descriptor and free resource as the value.
      while (oci_fetch($s))
      {
        for ($i = 1;$i <= oci_num_fields($s);$i++)
          if ((!is_object(oci_result($s,$i))) && (!oci_field_is_null($s,$i)))
            $data = oci_result($s,$i);
          else
            $data = "&nbsp;";
      }


      // Print the header first.
      header('Content-type: image/png');
      imagepng(imagecreatefromstring(file_get_contents($data)));

    }

    // Disconnect from database.
    oci_close($c);
  }
  else
  {
    // Assign the OCI error and format double and single quotes.
    $errorMessage = oci_error();
    print htmlentities($errorMessage['message'])."<br />";
  }
?>