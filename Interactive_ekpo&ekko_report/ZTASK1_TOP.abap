*--------------------------------------------------------------*
* TOP Include: Types and Data Declarations
*--------------------------------------------------------------*
TYPES: BEGIN OF gty_list,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         sel   TYPE xfeld,
         bstyp TYPE ekko-bstyp,
         bsart TYPE ekko-bsart,
         matnr TYPE ekpo-matnr,
         menge TYPE ekpo-menge,
       END OF gty_list.

DATA: gt_list     TYPE TABLE OF gty_list,
      gs_list     TYPE gty_list,
      gt_fieldcat TYPE SLIS_T_FIELDCAT_ALV,
      gs_fieldcat TYPE SLIS_FIELDCAT_ALV,
      gt_sort     TYPE SLIS_T_SORTINFO_ALV,
      gs_sort     TYPE SLIS_SORTINFO_ALV,
      gs_layout   TYPE SLIS_LAYOUT_ALV.

DATA:
      DISPLAY_BAR TYPE string,
      INPUT_BAR   TYPE string.

TYPES: BEGIN OF gty_info_list,
         matnr TYPE ekpo-matnr,
         info TYPE string,
       END OF gty_info_list.

DATA:
      gs_selected_row TYPE ekpo,
      gt_info_list TYPE TABLE OF gty_info_list,
      gs_info_list TYPE gty_info_list.
