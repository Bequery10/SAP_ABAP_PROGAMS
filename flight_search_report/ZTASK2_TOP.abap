*&---------------------------------------------------------------------*
*& Include          ZTASK2_TOP
*&---------------------------------------------------------------------*

DATA: go_alv TYPE REF TO cl_gui_alv_grid,
      go_cont TYPE REF TO cl_gui_custom_container.

DATA: ot_fcat TYPE LVC_T_FCAT,
      os_fcat TYPE LVC_S_FCAT.

DATA: gs_layout TYPE lvc_s_layo.

DATA: gt_scarr TYPE TABLE OF scarr.

DATA: gt_fcat TYPE LVC_T_FCAT,
      gs_fcat TYPE LVC_S_FCAT.

DATA: gt_exclude TYPE TABLE OF sy-ucomm,
      gv_exclude TYPE sy-ucomm.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS:
  p_radio1 RADIOBUTTON GROUP rad1 USER-COMMAND rad DEFAULT 'X',
  p_radio2 RADIOBUTTON GROUP rad1,
  p_field  TYPE string MODIF ID fld.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN COMMENT /1(30) comm1 FOR FIELD p_radio2.
comm1 = 'Enter flight code'.


 SELECTION-SCREEN PUSHBUTTON /10(20) btn1 USER-COMMAND CLICK.


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
