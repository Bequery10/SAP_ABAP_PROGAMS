*&---------------------------------------------------------------------*
*& Include          ZTASK10_PAI
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK' OR 'BACK' OR 'CANCEL' OR 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN '&SAVE' or 'SAVE'.
      PERFORM save_programs.
    ENDCASE.

ENDMODULE.
