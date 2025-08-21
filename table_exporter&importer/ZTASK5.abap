*&---------------------------------------------------------------------*
*& Report ZTASK4_IMPORT
*&---------------------------------------------------------------------*
*&  Import CSV data into ZTABLE
*&---------------------------------------------------------------------*
REPORT ZTASK5.

DATA: lt_fields     TYPE STANDARD TABLE OF string,
      lt_raw        TYPE STANDARD TABLE OF string,
      lt_data       TYPE TABLE OF ZTABLE,
      ls_data       TYPE ZTABLE,
      lv_filename   TYPE string,
      lv_line       TYPE string,
      lv_tabix      TYPE sy-tabix.

lv_filename = 'C:\Users\stajyersap\Desktop\ZTABLE.csv'. " Or app server path

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

" Loop through data rows (starting at index 2)
LOOP AT lt_raw INTO lv_line FROM 2.
  CLEAR ls_data.
  DATA(lt_values) = VALUE string_table( ).
  SPLIT lv_line AT ';' INTO TABLE lt_values.

  DATA lv_lines TYPE i.
  DESCRIBE TABLE lt_values LINES lv_lines.

  LOOP AT lt_fields INTO DATA(lv_field).
  lv_tabix = sy-tabix.
  ASSIGN COMPONENT lv_field OF STRUCTURE ls_data TO FIELD-SYMBOL(<val>).
  IF sy-subrc = 0 AND lv_tabix <= lv_lines.
    DATA(lv_csv_value) = lt_values[ lv_tabix ].
    lv_csv_value = condense( lv_csv_value ).
    REPLACE ALL OCCURRENCES OF ',' IN lv_csv_value WITH ''.
    <val> = lv_csv_value.
  ENDIF.
ENDLOOP.

  APPEND ls_data TO lt_data.
ENDLOOP.

" Insert data into table
IF NOT lt_data IS INITIAL.

INSERT ZTABLE FROM TABLE lt_data.

  IF sy-subrc = 0.
    WRITE: / 'Data imported successfully.'.
  ELSE.
    WRITE: / 'Error importing data.'.
  ENDIF.
ELSE.
  WRITE: / 'No data to import.'.
ENDIF.
