*&---------------------------------------------------------------------*
*& Report ZTASK1
*&---------------------------------------------------------------------*
REPORT ZTASK1.

INCLUDE ztask1_top.
INCLUDE ztask1_frm.
INCLUDE ztask1_PBO.
INCLUDE ztask1_PAI.

START-OF-SELECTION.
  PERFORM set_fields.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM      = SY-REPID
      I_CALLBACK_PF_STATUS_SET = 'ALV_PF_STATUS_SET'
      I_CALLBACK_USER_COMMAND = 'ALV_USER_COMMAND'
      I_CALLBACK_TOP_OF_PAGE  = 'ALV_TOP_OF_PAGE'
      IS_LAYOUT               = gs_layout
      IT_FIELDCAT             = gt_fieldcat
      I_DEFAULT               = 'X'
      I_SAVE                  = 'A'
    TABLES
      t_outtab = gt_list
    EXCEPTIONS
      program_error = 1
      others        = 2.

  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.
