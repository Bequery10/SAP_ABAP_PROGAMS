*&---------------------------------------------------------------------*
*& Include          ZTASK2_PAI
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BACK' OR 'BACK' OR 'CANCEL' OR 'EXIT'.

         IF go_cont IS BOUND.
     CALL METHOD go_cont->free.
     CLEAR go_cont.
   ENDIF.

   IF go_alv IS BOUND.
     FREE go_alv.
     CLEAR go_alv.
   ENDIF.

   CLEAR: gt_scarr.

      LEAVE TO SCREEN 1000.
  ENDCASE.
ENDMODULE.
