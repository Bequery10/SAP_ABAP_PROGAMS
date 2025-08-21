*&---------------------------------------------------------------------*
*& Report ZTASK3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTASK3.

INCLUDE ZTASK3_TOP.
INCLUDE ZTASK3_PBO.
INCLUDE ZTASK3_PAI.
INCLUDE ZTASK3_FRM.

START-OF-SELECTION.
    perform initiliaze_alv_components.
    CALL SCREEN 0100.
