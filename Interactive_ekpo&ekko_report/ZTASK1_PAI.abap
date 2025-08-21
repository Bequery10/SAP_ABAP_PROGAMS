MODULE user_command_0110 INPUT.
  CASE sy-ucomm.
    WHEN '&SAVE'.
      PERFORM set_INPUT_BAR using gs_selected_row.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
