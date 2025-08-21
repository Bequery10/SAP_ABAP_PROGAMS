*&---------------------------------------------------------------------*
*& Report ZTASK2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTASK2.

INCLUDE ZTASK2_TOP.
INCLUDE ZTASK2_PBO.
INCLUDE ZTASK2_PAI.
INCLUDE ZTASK2_FRM.


INITIALIZATION.
  btn1 = 'Search'.
  perform initiliaze_alv_components.

START-OF-SELECTION.

AT SELECTION-SCREEN.

    IF sy-ucomm = 'CLICK'.
         LOOP AT SCREEN.
            IF screen-group1 = 'FLD' AND  screen-active = '1'.
              DATA lv_carr_id TYPE string.
                    lv_carr_id = p_field.

              perform set_data using lv_carr_id.
              CALL SCREEN 0100.
              EXIT.
          ENDIF.
         ENDLOOP.
         perform set_all_data.
         CALL SCREEN 0100.
    ENDIF.


AT SELECTION-SCREEN OUTPUT.
  PERFORM search_section.

*CALL SCREEN 0100.
