
    TYPES:
      lty_t_val TYPE STANDARD TABLE OF helpval WITH DEFAULT KEY.

    CONSTANTS:
         lc_txt TYPE string VALUE 'Fill keys'.

    DATA:
      lt_fields TYPE dd03ttyp,
	  mt_keys TYPE TABLE OF sval.

    cl_reca_ddic_tabl=>get_field_list_x(
      EXPORTING
        id_name            = CONV #( "DDIC tabname" )
        if_suppress_mandt  = abap_true
        if_suppress_nonkey = abap_true
      IMPORTING
        et_field_list_x    = lt_fields
      EXCEPTIONS
        not_found          = 1
        OTHERS             = 2 ).
    IF sy-subrc <> 0.
    ENDIF.
	
	DATA(lv_return) = VALUE boolean( ).
	
	IF "Tabname has RAW type key fields.

      DATA(lt_keys) = VALUE lty_t_val( FOR ls_fields IN lt_fields ( 
	                                                  tabname   = ls_fields-tabname
                                                      fieldname = ls_fields-fieldname
                                                      length    = "Fields length
                                                      keyword   = ls_fields-ddtext ) ).
	  "Usign FM for RAW type fields	
      CALL FUNCTION 'HELP_GET_VALUES'
        EXPORTING
          popup_title = lc_txt
        IMPORTING
          returncode  = lv_return
        TABLES
          fields      = lt_keys
        EXCEPTIONS
          no_entries  = 1
          OTHERS      = 2.
      IF sy-subrc = 0.
        MOVE-CORRESPONDING lt_keys TO mt_keys.
      ENDIF.	
	
	
	ELSE.

      MOVE-CORRESPONDING lt_fields TO mt_keys.

      DATA(lv_lines) = lines( lt_fields ).

      CALL FUNCTION 'POPUP_GET_VALUES_SET_MAX_FIELD'
        EXPORTING
          number_of_fields = lv_lines
        EXCEPTIONS
          out_of_range     = 1
          OTHERS           = 2.
      IF sy-subrc <> 0.
        lv_lines = 10.
      ENDIF.

      "This FM doesn't support fields type RAW
      CALL FUNCTION 'POPUP_GET_VALUES_USER_HELP'
        EXPORTING
          popup_title     = lc_txt
        IMPORTING
          returncode      = lv_return
        TABLES
          fields          = mt_keys
        EXCEPTIONS
          error_in_fields = 1
          OTHERS          = 2.
	
	
	
	ENDIF.