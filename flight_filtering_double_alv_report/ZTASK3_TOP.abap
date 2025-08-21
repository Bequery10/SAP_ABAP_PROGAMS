*&---------------------------------------------------------------------*
*& Include          ZTASK3_TOP
*&---------------------------------------------------------------------*

DATA: go_alv1 TYPE REF TO cl_gui_alv_grid,
      go_cont1 TYPE REF TO cl_gui_custom_container.

DATA: go_alv2 TYPE REF TO cl_gui_alv_grid,
      go_cont2 TYPE REF TO cl_gui_custom_container.

DATA: ot_fcat TYPE LVC_T_FCAT,
      os_fcat TYPE LVC_S_FCAT.

DATA: gs_layout TYPE lvc_s_layo.

DATA: gt_sflight TYPE TABLE OF SFLIGHT.

TABLES: ztab_carrid.

TYPES: BEGIN OF ztab_carrid,
         carrid TYPE char3,
       END OF ztab_carrid.

DATA: gt_carrid TYPE TABLE OF ztab_carrid,
      gs_carrid TYPE ztab_carrid.

DATA: gt_fcat TYPE LVC_T_FCAT,
      gs_fcat TYPE LVC_S_FCAT.

DATA: gt_carrid_fcat TYPE LVC_T_FCAT,
      gs_carrid_fcat TYPE LVC_S_FCAT.

DATA: gt_exclude TYPE TABLE OF sy-ucomm,
      gv_exclude TYPE sy-ucomm.

CLASS gcl_alv_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,
      handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column,
      handle_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed.
ENDCLASS.
