*&---------------------------------------------------------------------*
*& Report ZTASK10
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTASK10.

INCLUDE ZTASK10_TOP.
INCLUDE ZTASK10_PBO.
INCLUDE ZTASK10_PAI.
INCLUDE ZTASK10_FRM.

INITIALIZATION.
  PERFORM load_programs.

START-OF-SELECTION.
  CALL SCREEN 0100.
