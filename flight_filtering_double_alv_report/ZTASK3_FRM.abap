*&---------------------------------------------------------------------*
*& Include          ZTASK3_FRM
*&---------------------------------------------------------------------*

CLASS gcl_alv_event_handler IMPLEMENTATION.

  METHOD handle_toolbar.
  ENDMETHOD.

  METHOD handle_double_click.
   " Extract the row index from the event parameter
   DATA lv_row_index TYPE lvc_index.
   lv_row_index = e_row-index.

   " You can retrieve the data of the clicked row if needed
   DATA ls_row TYPE ztab_carrid.
   READ TABLE gt_carrid INDEX lv_row_index INTO ls_row.

   IF sy-subrc = 0.
     PERFORM reset_alv.
     CLEAR: gt_sflight.
     PERFORM set_data USING ls_row-carrid.
     PERFORM display_alv1.
   ELSE.
     MESSAGE 'Row not found.' TYPE 'E'.
   ENDIF.
  ENDMETHOD.

  METHOD handle_data_changed.
    MESSAGE 'Data changed by user!' TYPE 'I'.
  ENDMETHOD.

   METHOD handle_user_command.
  ENDMETHOD.

ENDCLASS.

FORM display_alv1 .

  PERFORM exclude_default_toolbar.

  CREATE OBJECT go_cont1
    EXPORTING
*      parent                      =                  " Parent container
      container_name               = 'Z_INFO_CON'                  " Name of the Screen CustCtrl Name to Link Container To
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

  CREATE OBJECT go_alv1
    EXPORTING
*      i_shellstyle            = 0                " Control Style
*      i_lifetime              =                  " Lifetime
       i_parent                 =  go_cont1.
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
*  DATA(lo_handler) = NEW gcl_alv_event_handler( ).
*  SET HANDLER lo_handler->handle_double_click FOR go_alv1.
*  SET HANDLER lo_handler->handle_data_changed FOR go_alv1.
*  SET HANDLER lo_handler->handle_toolbar FOR go_alv1.
*  SET HANDLER lo_handler->handle_user_command FOR go_alv1.

  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL METHOD go_alv1->set_table_for_first_display
    EXPORTING
*      i_buffer_active               =                  " Buffering Active
*      i_bypassing_buffer            =                  " Switch Off Buffer
*      i_consistency_check           =                  " Starting Consistency Check for Interface Error Recognition
       i_structure_name              =                 'sflight'
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
      it_outtab                      =                  gt_sflight
      it_fieldcatalog                =                  gt_fcat.
*      it_sort                       =                  " Sort Criteria
*      it_filter                     =                  " Filter Criteria
*    EXCEPTIONS
*      invalid_parameter_combination = 1                " Wrong Parameter
*      program_error                 = 2                " Program Errors
*      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
*      others                        = 4
    .
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.

FORM display_alv2 .

  PERFORM exclude_default_toolbar.

  CREATE OBJECT go_cont2
    EXPORTING
*      parent                      =                  " Parent container
      container_name               = 'Z_CARRID_CON'                  " Name of the Screen CustCtrl Name to Link Container To
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

  CREATE OBJECT go_alv2
    EXPORTING
*      i_shellstyle            = 0                " Control Style
*      i_lifetime              =                  " Lifetime
       i_parent                 =  go_cont2.
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
  SET HANDLER lo_handler->handle_double_click FOR go_alv2.
  SET HANDLER lo_handler->handle_data_changed FOR go_alv2.
  SET HANDLER lo_handler->handle_toolbar FOR go_alv2.
  SET HANDLER lo_handler->handle_user_command FOR go_alv2.

  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL METHOD go_alv2->set_table_for_first_display
    EXPORTING
*      i_buffer_active               =                  " Buffering Active
*      i_bypassing_buffer            =                  " Switch Off Buffer
*      i_consistency_check           =                  " Starting Consistency Check for Interface Error Recognition
       i_structure_name              =                 'ztab_carrid'
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
      it_outtab                      =                  gt_carrid
      it_fieldcatalog                =                  gt_carrid_fcat.
*      it_sort                       =                  " Sort Criteria
*      it_filter                     =                  " Filter Criteria
*    EXCEPTIONS
*      invalid_parameter_combination = 1                " Wrong Parameter
*      program_error                 = 2                " Program Errors
*      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
*      others                        = 4
    .
  IF SY-SUBRC <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.

FORM initiliaze_ALV_components.
  PERFORM set_field_cat1.
  PERFORM set_field_cat2.
  PERFORM set_layout.
  PERFORM set_carrids.
ENDFORM.

FORM set_data USING carr_id TYPE char3.
  clear gt_sflight.
  SELECT * FROM sflight
    WHERE carrid = @carr_id
    INTO TABLE @gt_sflight.
ENDFORM.

FORM set_carrids.
  SELECT DISTINCT carrid
    FROM sflight
    INTO TABLE @gt_carrid.
ENDFORM.

FORM set_field_cat1.
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CARRID'.
  gs_fcat-coltext   = 'Carrier ID'.
  gs_fcat-datatype  = 'CHAR'.
  gs_fcat-outputlen = 3.
  gs_fcat-key       = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CARRNAME'.
  gs_fcat-coltext   = 'Carrier Name'.
  gs_fcat-datatype  = 'CHAR'.
  gs_fcat-outputlen = 20.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CURRCODE'.
  gs_fcat-coltext   = 'Currency Code'.
  gs_fcat-datatype  = 'CUKY'.
  gs_fcat-outputlen = 5.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'URL'.
  gs_fcat-coltext   = 'Website'.
  gs_fcat-datatype  = 'CHAR'.
  gs_fcat-outputlen = 255.
  gs_fcat-edit = abap_true.
  APPEND gs_fcat TO gt_fcat.

ENDFORM.

FORM set_field_cat2.
  CLEAR gs_carrid_fcat.
   gs_carrid_fcat-fieldname = 'CARRID'.
   gs_carrid_fcat-coltext   = 'Carrier ID'.
   gs_carrid_fcat-datatype  = 'CHAR'.
   gs_carrid_fcat-outputlen = 3.
   gs_carrid_fcat-key       = 'X'.
  APPEND  gs_carrid_fcat TO gt_carrid_fcat.
ENDFORM.

FORM set_layout.
  gs_layout-zebra = 'X'.
*  gs_layout-cwidth_opt = 'X'.
  gs_layout-grid_title = 'FLIGHTS'.
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

FORM reset_alv.
   IF go_cont1 IS BOUND.
     CALL METHOD go_cont1->free.
     CLEAR go_cont1.
   ENDIF.

   IF go_alv1 IS BOUND.
     FREE go_alv1.
     CLEAR go_alv1.
   ENDIF.

   CLEAR gt_fcat.
ENDFORM.
