class ZCL_DEMO_SALESORDER definition
  public
  inheriting from ZCL_BO_ABSTRACT
  create protected .

public section.

  interfaces ZIF_DEMO_SALESORDER .
  interfaces ZIF_GW_METHODS .

  aliases GET
    for ZIF_DEMO_SALESORDER~GET .
  aliases GET_AUDAT
    for ZIF_DEMO_SALESORDER~GET_AUDAT .
  aliases GET_KUNNR
    for ZIF_DEMO_SALESORDER~GET_KUNNR .
  aliases GET_VBELN
    for ZIF_DEMO_SALESORDER~GET_VBELN .

  methods CONSTRUCTOR
    importing
      !VBELN type VBELN
    raising
      ZCX_DEMO_BO .
  PROTECTED SECTION.

    METHODS load_salesorder_data
      IMPORTING
        !vbeln TYPE vbeln
      RAISING
        zcx_demo_bo .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEMO_SALESORDER IMPLEMENTATION.


  METHOD constructor.
    super->constructor( ).

    load_salesorder_data( vbeln ).

  ENDMETHOD.


  METHOD load_salesorder_data.

    SELECT SINGLE *
      FROM vbak
      INTO CORRESPONDING FIELDS OF zif_demo_salesorder~salesorder_data
      WHERE vbeln = vbeln.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_demo_bo
        EXPORTING
          textid  = zcx_demo_bo=>not_found
          bo_type = 'DEMO_SALESORDER'
          bo_id   = |{ vbeln }|.
    ENDIF.
  ENDMETHOD.


  METHOD zif_demo_salesorder~get.

    DATA: lv_vbeln TYPE vbeln.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = vbeln
      IMPORTING
        output = lv_vbeln.

    READ TABLE zif_demo_salesorder~instances
      INTO DATA(inst)
      WITH KEY vbeln = lv_vbeln.
    IF sy-subrc NE 0.
      inst-vbeln = lv_vbeln.
      DATA(class_name) = get_subclass( 'ZCL_DEMO_SALESORDER' ).
      CREATE OBJECT inst-instance
        TYPE (class_name)
        EXPORTING
          vbeln = lv_vbeln.
      APPEND inst TO zif_demo_salesorder~instances.
    ENDIF.
    instance ?= inst-instance.
  ENDMETHOD.


  METHOD zif_demo_salesorder~get_audat.
    audat = zif_demo_salesorder~salesorder_data-audat.
  ENDMETHOD.


  METHOD zif_demo_salesorder~get_items.
    DATA key TYPE zif_demo_salesorderitem=>key.

    key-vbeln = zif_demo_salesorder~get_vbeln( ).

    SELECT posnr
      FROM vbap
      INTO key-posnr
      WHERE vbeln = key-vbeln.
      TRY.
          APPEND zcl_demo_salesorderitem=>get( key ) TO items.
        CATCH cx_root.
      ENDTRY.
    ENDSELECT.

  ENDMETHOD.


  METHOD zif_demo_salesorder~get_kunnr.
    kunnr = zif_demo_salesorder~salesorder_data-kunnr.
  ENDMETHOD.


  METHOD zif_demo_salesorder~get_vbeln.
    vbeln = zif_demo_salesorder~salesorder_data-vbeln.
  ENDMETHOD.


  METHOD zif_gw_methods~create_deep_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~CREATE_DEEP_ENTITY'.
  ENDMETHOD.


  METHOD zif_gw_methods~create_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~CREATE_ENTITY'.
  ENDMETHOD.


  METHOD zif_gw_methods~delete_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~DELETE_ENTITY'.
  ENDMETHOD.


  method ZIF_GW_METHODS~EXECUTE_ACTION.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~EXECUTE_ACTION'.
  endmethod.


  METHOD zif_gw_methods~get_entity.
    GET REFERENCE OF er_entity INTO DATA(entity).
    TRY.
        zcl_demo_salesorder=>get(
          |{ it_key_tab[ name = 'SalesOrderId' ]-value }|
          )->zif_gw_methods~map_to_entity( entity ).
      CATCH cx_root INTO DATA(cx).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid   = /iwbep/cx_mgw_busi_exception=>business_error
            previous = cx
            message  = |{ cx->get_text( ) }|.
    ENDTRY.
  ENDMETHOD.


  METHOD zif_gw_methods~get_entityset.

    FIELD-SYMBOLS: <entityset> TYPE STANDARD TABLE.
    ASSIGN et_entityset TO <entityset>.

    " Use RTTS/RTTC to create anonymous object like line of et_entityset
    DATA: entity         TYPE REF TO data.
    TRY.
        DATA(struct_descr) = get_struct_descr( et_entityset ).
        CREATE DATA entity TYPE HANDLE struct_descr.
        ASSIGN entity->* TO FIELD-SYMBOL(<entity>).
      CATCH cx_sy_create_data_error INTO DATA(cx_sy_create_data_error).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
          EXPORTING
            textid   = /iwbep/cx_mgw_tech_exception=>internal_error
            previous = cx_sy_create_data_error.
    ENDTRY.

    " $orderby query options
    DATA: orderby_clause TYPE string.
    LOOP AT it_order REFERENCE INTO DATA(order).
      DATA(abap_field) = io_model->get_sortable_abap_field_name(
          iv_entity_name = iv_entity_name
          iv_field_name  = order->property ).
      IF abap_field IS INITIAL.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid  = /iwbep/cx_mgw_busi_exception=>business_error
            message = |$orderby { order->property } not supported|.
      ENDIF.
      orderby_clause = orderby_clause &&
        |{ abap_field } { order->order CASE = UPPER }ENDING |.
    ENDLOOP.

    " $filterby query options
    DATA: where_clause   TYPE string.
    LOOP AT it_filter_select_options REFERENCE INTO DATA(option).
      abap_field = io_model->get_filterable_abap_field_name(
          iv_entity_name = iv_entity_name
          iv_field_name  = option->property ).
      CASE abap_field.
        WHEN 'VBELN'.
          DATA(vbeln_range) = option->select_options.
          where_clause = |{ where_clause } & VBELN IN VBELN_RANGE|.
        WHEN 'AUDAT'.
          DATA(audat_range) = option->select_options.
          where_clause = |{ where_clause } & AUDAT IN AUDAT_RANGE|.
        WHEN OTHERS.
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              textid       = /iwbep/cx_mgw_busi_exception=>filter_not_supported
              filter_param = option->property.
      ENDCASE.
    ENDLOOP.
    IF sy-subrc NE 0. " Catch complex $filter queries
      where_clause = io_tech_request_context->get_filter( )->get_filter_string( ).
    ENDIF.

    CASE iv_source_name.
      WHEN 'Customer'.
        TRY.
            where_clause = |{ where_clause } & KUNNR = '{ it_key_tab[ name = 'CustomerId' ]-value }'|.
          CATCH cx_sy_itab_line_not_found INTO DATA(cx_sy_itab_line_not_found).
            RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
              EXPORTING
                textid   = /iwbep/cx_mgw_busi_exception=>business_error
                previous = cx_sy_itab_line_not_found
                message  = |{ cx_sy_itab_line_not_found->get_text( ) }|.
        ENDTRY.
      WHEN OTHERS.
    ENDCASE.

    SHIFT where_clause LEFT DELETING LEADING ' &'.
    REPLACE ALL OCCURRENCES OF '&' IN where_clause WITH 'AND'.

    TRY.
        " $inlinecount=allpages
        IF io_tech_request_context->has_inlinecount( ) = abap_true.
          DATA dbcount TYPE int4 .
          SELECT COUNT(*)
            INTO dbcount
            FROM vbak
            WHERE (where_clause).
          es_response_context-inlinecount = dbcount.
        ENDIF.

        " Get primary keys
        SELECT vbeln
          INTO CORRESPONDING FIELDS OF <entity>
          FROM vbak
          WHERE (where_clause)
          ORDER BY (orderby_clause).
          CHECK sy-dbcnt > is_paging-skip.
          APPEND <entity> TO <entityset>.
          IF is_paging-top > 0 AND lines( <entityset> ) GE is_paging-top.
            EXIT.
          ENDIF.
        ENDSELECT.
      CATCH cx_sy_dynamic_osql_syntax INTO DATA(cx_sy_dynamic_osql_syntax).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid   = /iwbep/cx_mgw_busi_exception=>business_error
            previous = cx_sy_dynamic_osql_syntax
            message  = |{ cx_sy_dynamic_osql_syntax->get_text( ) }|.
    ENDTRY.

    " $count
    CHECK io_tech_request_context->has_count( ) NE abap_true.

    " $skiptoken
    CONSTANTS: max_page_size TYPE i VALUE 50.
    DATA: index_start TYPE i,
          index_end   TYPE i.

    IF lines( <entityset> ) > max_page_size.
      index_start = io_tech_request_context->get_skiptoken( ).
      IF index_start = 0. index_start = 1. ENDIF.
      index_end = index_start + max_page_size - 1.
      LOOP AT <entityset> REFERENCE INTO entity.
        IF index_start > 1.
          DELETE <entityset>.
          SUBTRACT 1 FROM index_start.
          CONTINUE.
        ENDIF.
        CHECK sy-tabix > max_page_size.
        DELETE <entityset>.
      ENDLOOP.
      IF lines( <entityset> ) = max_page_size.
        es_response_context-skiptoken = index_end + 1.
      ENDIF.
    ENDIF.

    " Fill entities
    LOOP AT <entityset> REFERENCE INTO entity.
      ASSIGN entity->* TO <entity>.
      ASSIGN COMPONENT 'VBELN' OF STRUCTURE <entity> TO FIELD-SYMBOL(<vbeln>).
      ASSIGN entity->* TO <entity>.
      TRY.
          zcl_demo_salesorder=>get( <vbeln> )->zif_gw_methods~map_to_entity( entity ).
        CATCH zcx_demo_bo.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_gw_methods~map_to_entity.
    call_all_getters( entity ).
  ENDMETHOD.


  METHOD zif_gw_methods~update_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~UPDATE_ENTITY'.
  ENDMETHOD.
ENDCLASS.