*&---------------------------------------------------------------------*
*& Include          ZTASK10_TOP
*&---------------------------------------------------------------------*

DATA: go_alv TYPE REF TO cl_gui_alv_grid,
      go_cont TYPE REF TO cl_gui_custom_container.

DATA: gt_fcat TYPE LVC_T_FCAT,
      gs_fcat TYPE LVC_S_FCAT.

DATA: gs_layout TYPE lvc_s_layo.

DATA: gt_programs TYPE TABLE OF ZDT_PROGRAMS.
DATA: gs_programs TYPE ZDT_PROGRAMS.

DATA: gt_exclude TYPE TABLE OF sy-ucomm,
      gv_exclude TYPE sy-ucomm.

CLASS gcl_alv_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,

      handle_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      handle_double_click
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column,

      handle_data_changed
        FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed.
ENDCLASS.
