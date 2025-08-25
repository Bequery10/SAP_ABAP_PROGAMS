*&---------------------------------------------------------------------*
*& Include          ZTASK10_FRM
*&---------------------------------------------------------------------*

CLASS gcl_alv_event_handler IMPLEMENTATION.

 METHOD handle_toolbar.
  DATA ls_toolbar TYPE stb_button.

  " Add 'ADD' button
  CLEAR ls_toolbar.
  ls_toolbar-function = 'ADD'.
  ls_toolbar-icon = '@01@'.                 " Choose a suitable SAP icon!
  ls_toolbar-quickinfo = 'Add Program'.
  ls_toolbar-text = 'Add'.
  ls_toolbar-butn_type = 0.
  APPEND ls_toolbar TO e_object->mt_toolbar.

  " Add 'REMOVE' button
  CLEAR ls_toolbar.
  ls_toolbar-function = 'REMOVE'.
  ls_toolbar-icon = '@02@'.
  ls_toolbar-quickinfo = 'Remove Program'.
  ls_toolbar-text = 'Remove'.
  ls_toolbar-butn_type = 0.
  APPEND ls_toolbar TO e_object->mt_toolbar.

  " Add 'SAVE' button
  CLEAR ls_toolbar.
  ls_toolbar-function = '&SAVE'.           " Standard save code
  ls_toolbar-icon = '@03@'.
  ls_toolbar-quickinfo = 'Save Programs'.
  ls_toolbar-text = 'Save'.
  ls_toolbar-butn_type = 0.
  APPEND ls_toolbar TO e_object->mt_toolbar.
ENDMETHOD.

 METHOD handle_double_click.
   " Extract the row index from the event parameter
   DATA lv_row_index TYPE lvc_index.
   lv_row_index = e_row-index.

   " You can retrieve the data of the clicked row if needed
   DATA ls_row TYPE ZDT_PROGRAMS.
   READ TABLE gt_programs INDEX lv_row_index INTO ls_row.

   IF sy-subrc = 0.
     PERFORM navigate_program  USING ls_row-T_CODE.
   ELSE.
     MESSAGE 'Row not found.' TYPE 'E'.
   ENDIF.
  ENDMETHOD.

  METHOD handle_data_changed.
  ENDMETHOD.

   METHOD handle_user_command.
     CASE e_ucomm.
       WHEN 'REMOVE'.
         PERFORM remove_program.
       WHEN 'ADD'.
         PERFORM add_program.
       WHEN '&SAVE'.
*         PERFORM save_programs.
       WHEN OTHERS.
         MESSAGE |Unknown command: { e_ucomm }| TYPE 'I'.
     ENDCASE.
     PERFORM reset_alv.
  ENDMETHOD.


ENDCLASS.

FORM display_alv .

  PERFORM exclude_default_toolbar.

  CREATE OBJECT go_cont
    EXPORTING
*      parent                      =                  " Parent container
      container_name               = 'CC_ALV'                  " Name of the Screen CustCtrl Name to Link Container To
*      style                       =                  " Windows Style Attributes Applied to this Container
*      lifetime                    = lifetime_default " Lifetime
*      repid                       =                  " Screen to Which this Container is Linked
*      dynnr                       =                  " Report To Which this Container is Linked
*      no_autodef_progid_dynnr     =                  " Don't Autodefined Progid and Dynnr?
*    EXCEPTIONS
*      cntl_error                  = 1                " CNTL_ERROR
*      cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
*      create_error                = 3                " CREATE_ERROR
*      lifetime_error              = 4                " LIFETIME_ERROR
*      lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
*      others                      = 6
    .
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CREATE OBJECT go_alv
    EXPORTING
*      i_shellstyle            = 0                " Control Style
*      i_lifetime              =                  " Lifetime
       i_parent                 =  go_cont.
*      i_appl_events           = space            " Register Events as Application Events
*      i_parentdbg             =                  " Internal, Do not Use
*      i_applogparent          =                  " Container for Application Log
*      i_graphicsparent        =                  " Container for Graphics
*      i_name                  =                  " Name
*      i_fcat_complete         = space            " Boolean Variable (X=True, Space=False)
*      o_previous_sral_handler =
*      i_use_one_ux_appearance = abap_false
*    EXCEPTIONS
*      error_cntl_create       = 1                " Error when creating the control
*      error_cntl_init         = 2                " Error While Initializing Control
*      error_cntl_link         = 3                " Error While Linking Control
*      error_dp_create         = 4                " Error While Creating DataProvider Control
*      others                  = 5
    .
  DATA(lo_handler) = NEW gcl_alv_event_handler( ).
  SET HANDLER lo_handler->handle_double_click FOR go_alv.
  SET HANDLER lo_handler->handle_data_changed FOR go_alv.
  SET HANDLER lo_handler->handle_toolbar FOR go_alv.
  SET HANDLER lo_handler->handle_user_command FOR go_alv.

  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
*      i_buffer_active               =                  " Buffering Active
*      i_bypassing_buffer            =                  " Switch Off Buffer
*      i_consistency_check           =                  " Starting Consistency Check for Interface Error Recognition
       i_structure_name              =                 'ZDT_PROGRAMS'
*      is_variant                    =                  " Layout
*      i_save                        = 'X'              " Save Layout
*      i_default                     = 'X'              " Default Display Variant
       is_layout                     =                  gs_layout
*      is_print                      =                  " Print Control
*      it_special_groups             =                  " Field Groups
      it_toolbar_excluding           =                  gt_exclude
*      it_hyperlink                  =                  " Hyperlinks
*      it_alv_graphics               =                  " Table of Structure DTC_S_TC
*      it_except_qinfo               =                  " Table for Exception Quickinfo
*      ir_salv_adapter               =                  " Interface ALV Adapter
    CHANGING
      it_outtab                      =                  gt_programs
      it_fieldcatalog                =                  gt_fcat.
*      it_sort                       =                  " Sort Criteria
*      it_filter                     =                  " Filter Criteria
*    EXCEPTIONS
*      invalid_parameter_combination = 1                " Wrong Parameter
*      program_error                 = 2                " Program Errors
*      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
*      others                        = 4

  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.

FORM initiliaze_ALV_components.
  PERFORM set_field_cat.
  PERFORM set_layout.
ENDFORM.

FORM set_field_cat.
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'PROJECT_TITLE'.
  gs_fcat-coltext   = 'ZPROJECT_TITLE'.
  gs_fcat-datatype  = 'CHAR'.
  gs_fcat-edit      = 'X'.
  gs_fcat-outputlen = 50.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'T_CODE'.
  gs_fcat-coltext   = 'ZT_CODE'.
  gs_fcat-datatype  = 'CHAR'.
  gs_fcat-edit      = 'X'.
  gs_fcat-outputlen = 50.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'PROJECT_DESCRIPTION'.
  gs_fcat-coltext   = 'ZPROJECT_DESCRIPTION'.
  gs_fcat-datatype  = 'CHAR'.
  gs_fcat-edit      = 'X'.
  gs_fcat-outputlen = 255.
  APPEND gs_fcat TO gt_fcat.

ENDFORM.

FORM set_layout.
  gs_layout-zebra = 'X'.
  gs_layout-edit = 'X'.
*  gs_layout-cwidth_opt = 'X'.
  gs_layout-grid_title = 'INTERNSHIP PROGRAMS'.
  gs_layout-info_fname = 'COLOR'.
ENDFORM.

FORM exclude_default_toolbar.


gv_exclude = '&PRINT'.       APPEND gv_exclude TO gt_exclude.     " Print
gv_exclude = '&GRAPH'.       APPEND gv_exclude TO gt_exclude.     " Graphic
gv_exclude = '&INFO'.        APPEND gv_exclude TO gt_exclude.     " Info
gv_exclude = '&SORT'.        APPEND gv_exclude TO gt_exclude.     " Sort
gv_exclude = '&FILTER'.      APPEND gv_exclude TO gt_exclude.     " Filter
gv_exclude = '&SUM'.         APPEND gv_exclude TO gt_exclude.     " Sum
gv_exclude = '&COLOPT'.      APPEND gv_exclude TO gt_exclude.     " Optimize Columns
gv_exclude = '&SAVE'.        APPEND gv_exclude TO gt_exclude.     " Save Layout
gv_exclude = '&FIND'.        APPEND gv_exclude TO gt_exclude.     " Find
gv_exclude = '&REFRESH'.     APPEND gv_exclude TO gt_exclude.     " Refresh
gv_exclude = '&EXPORT'.      APPEND gv_exclude TO gt_exclude.     " Export
gv_exclude = '&HELP'.        APPEND gv_exclude TO gt_exclude.     " Help
gv_exclude = '&NAVIGATE'.    APPEND gv_exclude TO gt_exclude.     " Navigation
gv_exclude = '&LOCAL'.       APPEND gv_exclude TO gt_exclude.     " Local file
gv_exclude = '&XXL'.         APPEND gv_exclude TO gt_exclude.     " XXL
gv_exclude = '&SEND'.        APPEND gv_exclude TO gt_exclude.     " Send
gv_exclude = '&MULSEL'.      APPEND gv_exclude TO gt_exclude.     " Multi-select
gv_exclude = '&VIEW'.        APPEND gv_exclude TO gt_exclude.     " Change View
gv_exclude = '&VARIANT'.     APPEND gv_exclude TO gt_exclude.     " Variant
gv_exclude = '&SET'.         APPEND gv_exclude TO gt_exclude.     " Set
gv_exclude = '&AGGREGATE'.   APPEND gv_exclude TO gt_exclude.     " Aggregate
gv_exclude = '&DETAIL'.      APPEND gv_exclude TO gt_exclude.     " Detail
gv_exclude = '&TOT'.         APPEND gv_exclude TO gt_exclude.     " Total
gv_exclude = '&SUBTOT'.      APPEND gv_exclude TO gt_exclude.     " Subtotal
gv_exclude = '&CHART'.       APPEND gv_exclude TO gt_exclude.     " Chart
gv_exclude = '&HIER'.        APPEND gv_exclude TO gt_exclude.     " Hierarchy
gv_exclude = '&DOCU'.        APPEND gv_exclude TO gt_exclude.     " Documentation
gv_exclude = '&CLOSE'.       APPEND gv_exclude TO gt_exclude.     " Close


ENDFORM.


FORM add_program.

  DATA lv_new_id TYPE zdt_programs-PROJECT_NO.

  SELECT MAX( PROJECT_NO ) FROM zdt_programs INTO lv_new_id.

  DATA wa_program TYPE zdt_programs.
  wa_program-mandt = sy-mandt.
  wa_program-PROJECT_NO = lv_new_id + 1.
  wa_program-project_title = 'New Project'.
  wa_program-t_code = 'TX01'.
  wa_program-project_description = 'Description'.
  APPEND wa_program TO gt_programs.
ENDFORM.

FORM remove_program.
   IF gt_programs IS NOT INITIAL.
    DELETE gt_programs INDEX lines( gt_programs ).
  ENDIF.
ENDFORM.

FORM save_programs.
  DELETE FROM ZDT_PROGRAMS.
  MODIFY ZDT_PROGRAMS FROM TABLE gt_programs.

  SELECT * FROM ZDT_PROGRAMS INTO TABLE @DATA(lt_programs).

  COMMIT WORK.
ENDFORM.

FORM load_programs.
  SELECT * FROM ZDT_PROGRAMS INTO TABLE gt_programs.
ENDFORM.

FORM reset_alv.
   IF go_cont IS BOUND.
     CALL METHOD go_cont->free.
     CLEAR go_cont.
   ENDIF.

   IF go_alv IS BOUND.
     FREE go_alv.
     CLEAR go_alv.
   ENDIF.

   CLEAR gt_fcat.

   PERFORM initiliaze_ALV_components.
   PERFORM display_alv.
ENDFORM.

FORM navigate_program USING T_CODE TYPE CHAR50.

  DATA: lv_tcode TYPE tcode.

  lv_tcode = T_CODE.  " T_CODE from your input

  SELECT SINGLE * FROM TSTC INTO @DATA(ls_tstc) WHERE tcode = @lv_tcode.

  IF sy-subrc = 0.

    CALL TRANSACTION lv_tcode. "`AND SKIP FIRST SCREEN.
    IF sy-subrc <> 0.
      WRITE: / 'Navigation to transaction', lv_tcode, 'failed.'.
    ENDIF.
  ELSE.
    WRITE: / 'Transaction code', lv_tcode, 'does not exist.'.
  ENDIF.


  IF sy-subrc <> 0.
    WRITE: / 'Navigation to transaction', T_CODE, 'failed.'.
  ENDIF.

ENDFORM.
