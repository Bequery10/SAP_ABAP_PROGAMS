*--------------------------------------------------------------*
* FORM Routines
*--------------------------------------------------------------*

FORM set_fields.
  PERFORM add_field_to_catalog USING 'EBELN' 1 'PO Number' abap_true abap_false CHANGING gt_fieldcat.
  PERFORM add_field_to_catalog USING 'EBELP' 2 'Item'      abap_false abap_false CHANGING gt_fieldcat.
  PERFORM add_field_to_catalog USING 'SEL'   3 'Select'    abap_false abap_false CHANGING gt_fieldcat.
  PERFORM add_field_to_catalog USING 'BSTYP' 4 'Doc Type'  abap_false abap_false CHANGING gt_fieldcat.
  PERFORM add_field_to_catalog USING 'BSART' 5 'PO Category' abap_false abap_false CHANGING gt_fieldcat.
  PERFORM add_field_to_catalog USING 'MATNR' 6 'Material'  abap_false abap_false CHANGING gt_fieldcat.
  PERFORM add_field_to_catalog USING 'MENGE' 7 'Quantity'  abap_false abap_true CHANGING gt_fieldcat.
  PERFORM set_layout.
  PERFORM load_from_file.
ENDFORM.

FORM add_field_to_catalog
  USING
    p_fieldname TYPE slis_fieldcat_alv-fieldname
    p_col_pos   TYPE i
    p_seltext_l TYPE slis_fieldcat_alv-seltext_l
    p_key       TYPE abap_bool
    p_do_sum    TYPE abap_bool
  CHANGING pt_fieldcat TYPE slis_t_fieldcat_alv.

  DATA ls_fieldcat TYPE SLIS_FIELDCAT_ALV.
  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = p_fieldname.
  ls_fieldcat-col_pos   = p_col_pos.
  ls_fieldcat-seltext_l = p_seltext_l.
  ls_fieldcat-key       = p_key.
  ls_fieldcat-do_sum    = p_do_sum.
  ls_fieldcat-edit = 'X'.
  IF p_fieldname = 'MATNR'.
    ls_fieldcat-hotspot = abap_true.
  ENDIF.
  APPEND ls_fieldcat TO pt_fieldcat.
ENDFORM.

FORM set_layout.
  gs_layout-window_titlebar = 'bla bla table'.
  gs_layout-zebra = abap_true.
  gs_layout-COLWIDTH_OPTIMIZE = abap_true.
  gs_layout-edit = 'X'.
  gs_layout-box_fieldname = 'SEL'.
ENDFORM.

FORM save_data.
  DATA: lt_list TYPE TABLE OF gty_list.
  LOOP AT gt_list INTO DATA(ls_list).
    IF ls_list-sel = 'X'.
      APPEND ls_list TO lt_list.
    ENDIF.
  ENDLOOP.
  MODIFY ztable FROM TABLE lt_list.
  COMMIT WORK.
ENDFORM.

FORM load_from_file.
  SELECT * FROM ztable INTO TABLE gt_list.
ENDFORM.

FORM remove_data.
  IF gt_list IS NOT INITIAL.
    DELETE gt_list INDEX lines( gt_list ).
  ENDIF.
ENDFORM.

FORM add_data.
  DATA: ls_list TYPE gty_list.
  CLEAR ls_list.
  APPEND ls_list TO gt_list.
ENDFORM.

FORM alv_top_of_page.
  DATA: lt_list_commentary TYPE slis_t_listheader,
        ls_list_commentary TYPE slis_listheader.
  CLEAR ls_list_commentary.
  ls_list_commentary-typ  = 'H'.
  ls_list_commentary-info = 'Purchase Order List'.
  APPEND ls_list_commentary TO lt_list_commentary.
  CLEAR ls_list_commentary.
  ls_list_commentary-typ  = 'S'.
  ls_list_commentary-info = 'This is a custom ALV header'.
  APPEND ls_list_commentary TO lt_list_commentary.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_list_commentary.
ENDFORM.

FORM alv_user_command USING r_ucomm LIKE sy-ucomm
                            rs_selfield TYPE slis_selfield.
  CASE r_ucomm.
    WHEN 'ADD1'.
      PERFORM add_data.
      rs_selfield-refresh = 'X'.
    WHEN 'REMOVE1'.
      PERFORM remove_data.
      rs_selfield-refresh = 'X'.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
    WHEN '&SAVE'.
      PERFORM save_data.
    WHEN '&IC1'.
      IF rs_selfield-fieldname = 'MATNR'.
        READ TABLE gt_list INTO DATA(ls_clicked) INDEX rs_selfield-tabindex.
        IF sy-subrc = 0.
          PERFORM show_material_alv USING ls_clicked-matnr.
        ENDIF.
      ENDIF.
  ENDCASE.
ENDFORM.

FORM set_sorting.
  CLEAR gs_sort.
  gs_sort-fieldname = 'BSART'.
  gs_sort-up = 'X'.
  gs_sort-subtot = 'X'.
  APPEND gs_sort TO gt_sort.
  CLEAR gs_sort.
  gs_sort-fieldname = 'MATNR'.
  gs_sort-up = 'X'.
  gs_sort-subtot = 'X'.
  APPEND gs_sort TO gt_sort.
ENDFORM.

FORM alv_pf_status_set USING p_extab TYPE slis_t_extab.
  SET PF-STATUS '0100'.
ENDFORM.

FORM select_data.
  DATA: ls_list TYPE gty_list.
  SELECT ekpo~ebeln,
         ekpo~ebelp,
         ekko~bstyp,
         ekko~bsart,
         ekpo~matnr,
         ekpo~menge
    FROM ekpo
    INNER JOIN ekko
      ON ekpo~ebeln = ekko~ebeln
    INTO (@ls_list-ebeln,
          @ls_list-ebelp,
          @ls_list-bstyp,
          @ls_list-bsart,
          @ls_list-matnr,
          @ls_list-menge)
    UP TO 5 ROWS.
    ls_list-sel = 'X'.
    APPEND ls_list TO gt_list.
  ENDSELECT.
ENDFORM.

FORM show_material_alv USING p_matnr TYPE ekpo-matnr.
  DATA: ls_mat TYPE ekpo.

  SELECT SINGLE * FROM ekpo INTO ls_mat WHERE matnr = p_matnr.

  IF sy-subrc = 0.
    DISPLAY_BAR = |PO: { ls_mat-ebeln }, Item: { ls_mat-ebelp }, Qty: { ls_mat-menge }|.
    gs_selected_row = ls_mat.

    CLEAR INPUT_BAR.
    PERFORM get_INPUT_BAR using gs_selected_row.
    CALL SCREEN 110.
   ELSE.
    DISPLAY_BAR = 'No info found for this material.'.
    CLEAR INPUT_BAR.
    CALL SCREEN 110.
  ENDIF.
ENDFORM.

FORM get_INPUT_BAR USING p_row type ekpo.

  LOOP AT gt_info_list INTO DATA(ls_info).
   IF ls_info-matnr = p_row-matnr.
     INPUT_BAR = ls_info-info.
   ENDIF.
  ENDLOOP.
ENDFORM.

FORM set_INPUT_BAR USING p_row type ekpo.

  DATA ls_info_list TYPE gty_info_list.
  ls_info_list-matnr = p_row-matnr.
  ls_info_list-info = INPUT_BAR.

  APPEND ls_info_list TO gt_info_list.
ENDFORM.
