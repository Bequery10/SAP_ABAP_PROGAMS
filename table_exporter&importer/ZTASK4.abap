*&---------------------------------------------------------------------*
*& Report ZTASK4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTASK4.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS:
  p_radio1 RADIOBUTTON GROUP rad1 USER-COMMAND rad DEFAULT 'X',
  p_radio2 RADIOBUTTON GROUP rad1,
  p_field1  TYPE string MODIF ID f1,
  p_field2  TYPE string MODIF ID f2.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN COMMENT /1(30) comm1 FOR FIELD p_radio2.

SELECTION-SCREEN PUSHBUTTON /10(20) btn1 USER-COMMAND CLICK.

INITIALIZATION.
  btn1 = 'EXPORT'.

AT SELECTION-SCREEN.
  IF p_radio2 = 'X'.
    btn1 = 'IMPORT'.
  ELSE.
    btn1 = 'EXPORT'.
  ENDIF.

   IF sy-ucomm = 'CLICK'.

      DATA lo_table TYPE REF TO data.
      DATA lv_tabname TYPE tabname.
      DATA lv_path TYPE string.
      lv_tabname = p_field1.
      lv_path = p_field2.

      CREATE DATA lo_table TYPE TABLE OF (lv_tabname).

      IF p_radio2 = 'X'.
        PERFORM import USING lo_table lv_tabname lv_path.
      ELSE.
         PERFORM export USING lo_table lv_tabname lv_path.
      ENDIF.

  ENDIF.

FORM import USING dt_object TYPE REF TO data
                   iv_tabname TYPE tabname
                   path TYPE string.

  FIELD-SYMBOLS: <lt_data> TYPE ANY TABLE,
                 <ls_data> TYPE any.

  DATA: lt_fields     TYPE STANDARD TABLE OF string,
        lt_raw        TYPE STANDARD TABLE OF string,
        lv_filename   TYPE string,
        lv_line       TYPE string,
        lv_tabix      TYPE sy-tabix,
        lv_csv_value  TYPE string.

  lv_filename = path.

  " Download CSV file to internal table lt_raw
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename            = lv_filename
      filetype            = 'ASC'
    TABLES
      data_tab            = lt_raw
    EXCEPTIONS
      OTHERS              = 1.

  IF sy-subrc <> 0.
    WRITE: / 'File upload failed.'.
    EXIT.
  ENDIF.

  " Get header fields (first row)
  READ TABLE lt_raw INTO lv_line INDEX 1.
  SPLIT lv_line AT ';' INTO TABLE lt_fields.

  " Assign dynamic internal table
  ASSIGN dt_object->* TO <lt_data>.

  DATA lo_wa TYPE REF TO data.

  " Loop through data rows (starting at index 2)
  LOOP AT lt_raw INTO lv_line FROM 2.
    CREATE DATA lo_wa LIKE LINE OF <lt_data>.
    ASSIGN lo_wa->* TO <ls_data>.

    DATA(lt_values) = VALUE string_table( ).
    SPLIT lv_line AT ';' INTO TABLE lt_values.

    DATA lv_lines TYPE i.
    DESCRIBE TABLE lt_values LINES lv_lines.

    LOOP AT lt_fields INTO DATA(lv_field).
      lv_tabix = sy-tabix.
      ASSIGN COMPONENT lv_field OF STRUCTURE <ls_data> TO FIELD-SYMBOL(<val>).
      IF sy-subrc = 0 AND lv_tabix <= lv_lines.
        CLEAR lv_csv_value.
        READ TABLE lt_values INTO lv_csv_value INDEX lv_tabix.
        IF sy-subrc = 0.
          lv_csv_value = condense( lv_csv_value ).
          REPLACE ALL OCCURRENCES OF ',' IN lv_csv_value WITH ''.
          <val> = lv_csv_value.
        ENDIF.
      ENDIF.
    ENDLOOP.

    " FIX: Use INSERT instead of APPEND for generic tables
    INSERT <ls_data> INTO TABLE <lt_data>.
  ENDLOOP.

  " Insert data into table
  IF lines( <lt_data> ) > 0.
    INSERT (iv_tabname) FROM TABLE <lt_data>.
  
    IF sy-subrc = 0.
      WRITE: / 'Data imported successfully.'.
    ELSE.
      WRITE: / 'Error importing data.'.
    ENDIF.
  ELSE.
    WRITE: / 'No data to import.'.
  ENDIF.

ENDFORM.

FORM export USING dt_object TYPE REF TO data
                        iv_tabname TYPE tabname
                        path TYPE string.

  FIELD-SYMBOLS: <lt_data> TYPE ANY TABLE.

  DATA: lt_fields   TYPE STANDARD TABLE OF DFIES,
        lt_export   TYPE STANDARD TABLE OF string,
        lv_line     TYPE string,
        lv_filename TYPE string.

  " Assign dynamic internal table
  ASSIGN dt_object->* TO <lt_data>.
  lv_filename = path.

  " Get field info dynamically
  CALL FUNCTION 'DDIF_FIELDINFO_GET'
    EXPORTING
      tabname = iv_tabname
    TABLES
      dfies_tab = lt_fields
    EXCEPTIONS
      OTHERS = 1.

  IF sy-subrc <> 0.
    WRITE: / 'Failed to get field info for table:', iv_tabname.
    EXIT.
  ENDIF.

  " Select data dynamically
  SELECT * FROM (iv_tabname) INTO TABLE @<lt_data>.

  IF sy-subrc <> 0.
    WRITE: / 'Failed to select data from table:', iv_tabname.
    EXIT.
  ENDIF.

  " Write the header row to export table
  lv_line = ''.
  LOOP AT lt_fields INTO DATA(ls_field).
    IF lv_line IS INITIAL.
      lv_line = ls_field-fieldname.
    ELSE.
      CONCATENATE lv_line ls_field-fieldname INTO lv_line SEPARATED BY ';'.
    ENDIF.
  ENDLOOP.
  APPEND lv_line TO lt_export.

  " Write data rows to export table
  LOOP AT <lt_data> ASSIGNING FIELD-SYMBOL(<ls_row>).
    lv_line = ''.
    LOOP AT lt_fields INTO DATA(ls_field1).
      ASSIGN COMPONENT ls_field1-fieldname OF STRUCTURE <ls_row> TO FIELD-SYMBOL(<value>).
      IF sy-subrc = 0.
        DATA(lv_char) = |{ <value> }|.
        IF lv_line IS INITIAL.
          lv_line = lv_char.
        ELSE.
          CONCATENATE lv_line lv_char INTO lv_line SEPARATED BY ';'.
        ENDIF.
      ENDIF.
    ENDLOOP.
    APPEND lv_line TO lt_export.
  ENDLOOP.

  " Download to local PC desktop
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename = lv_filename
      filetype = 'ASC'
    TABLES
      data_tab = lt_export
    EXCEPTIONS
      OTHERS = 1.

  IF sy-subrc = 0.
    WRITE: / 'File downloaded successfully to your Desktop.'.
  ELSE.
    WRITE: / 'File download failed.'.
  ENDIF.

ENDFORM.

