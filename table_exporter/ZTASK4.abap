*&---------------------------------------------------------------------*
*& Report ZTASK4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTASK4.

DATA: lt_data    TYPE TABLE OF ZTABLE,
      lt_fields  TYPE STANDARD TABLE OF DFIES,
      lt_export  TYPE STANDARD TABLE OF string,
      lv_line    TYPE string,
      lv_filename TYPE string.

lv_filename = 'C:\Users\stajyersap\Desktop\ZTABLE.csv'.

" Get field info dynamically
CALL FUNCTION 'DDIF_FIELDINFO_GET'
  EXPORTING
    tabname = 'ZTABLE'
  TABLES
    dfies_tab = lt_fields.

SELECT * FROM ZTABLE INTO TABLE lt_data.

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
LOOP AT lt_data INTO DATA(ls_row).
  lv_line = ''.
  LOOP AT lt_fields INTO DATA(ls_field1).
    ASSIGN COMPONENT ls_field1-fieldname OF STRUCTURE ls_row TO FIELD-SYMBOL(<value>).
    IF sy-subrc = 0.
      DATA(lv_char) = ''.
      WRITE <value> TO lv_char.
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
