class ZCL_DEMO_CUSTOMER definition
  public
  inheriting from ZCL_BO_ABSTRACT
  create protected .

public section.

  interfaces ZIF_DEMO_CUSTOMER .
  interfaces ZIF_GW_METHODS .

  aliases GET
    for ZIF_DEMO_CUSTOMER~GET .
  aliases GET_KUNNR
    for ZIF_DEMO_CUSTOMER~GET_KUNNR .
  aliases GET_LAND1
    for ZIF_DEMO_CUSTOMER~GET_LAND1 .
  aliases GET_LAND_TEXT
    for ZIF_DEMO_CUSTOMER~GET_LAND_TEXT .
  aliases GET_NAME1
    for ZIF_DEMO_CUSTOMER~GET_NAME1 .
  aliases GET_ORT01
    for ZIF_DEMO_CUSTOMER~GET_ORT01 .
  aliases GET_PSTLZ
    for ZIF_DEMO_CUSTOMER~GET_PSTLZ .
  aliases GET_REGIO
    for ZIF_DEMO_CUSTOMER~GET_REGIO .
  aliases GET_REGION_TEXT
    for ZIF_DEMO_CUSTOMER~GET_REGION_TEXT .
  aliases GET_STRAS
    for ZIF_DEMO_CUSTOMER~GET_STRAS .

  methods CONSTRUCTOR
    importing
      !KUNNR type KUNNR
    raising
      ZCX_DEMO_BO .
  PROTECTED SECTION.

    CLASS-DATA countries TYPE isi_country_help_tt .
    CLASS-DATA regions TYPE isi_region_help_tt .

    METHODS load_customer_data
      IMPORTING
        !kunnr TYPE kunnr
      RAISING
        zcx_demo_bo .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEMO_CUSTOMER IMPLEMENTATION.


  METHOD constructor.
    super->constructor( ).

    load_customer_data( kunnr ).

  ENDMETHOD.


  METHOD load_customer_data.

    SELECT SINGLE *
      FROM kna1
      INTO CORRESPONDING FIELDS OF zif_demo_customer~customer_data
      WHERE kunnr = kunnr.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_demo_bo
        EXPORTING
          textid  = zcx_demo_bo=>not_found
          bo_type = 'DEMO_CUSTOMER'
          bo_id   = |{ kunnr }|.
    ENDIF.
  ENDMETHOD.


  METHOD zif_demo_customer~get.

    DATA: lv_kunnr TYPE kunnr.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = kunnr
      IMPORTING
        output = lv_kunnr.

    READ TABLE zif_demo_customer~instances
      INTO DATA(inst)
      WITH KEY kunnr = lv_kunnr.
    IF sy-subrc NE 0.
      inst-kunnr = lv_kunnr.
      DATA(class_name) = get_subclass( 'ZCL_DEMO_CUSTOMER' ).
      CREATE OBJECT inst-instance
        TYPE (class_name)
        EXPORTING
          kunnr = lv_kunnr.
      APPEND inst TO zif_demo_customer~instances.
    ENDIF.
    instance ?= inst-instance.
  ENDMETHOD.


  METHOD zif_demo_customer~get_kunnr.
    kunnr = zif_demo_customer~customer_data-kunnr.
  ENDMETHOD.


  METHOD zif_demo_customer~get_land1.
    land1 = zif_demo_customer~customer_data-land1.
  ENDMETHOD.


  METHOD zif_demo_customer~get_land_text.
    TRY.
        land_text = countries[ land1 = zif_demo_customer~customer_data-land1 ]-landx50.
      CATCH cx_sy_itab_line_not_found.
        SELECT land1 landx50
          FROM t005t
          APPENDING CORRESPONDING FIELDS OF TABLE countries
          WHERE spras = sy-langu
          AND land1 = zif_demo_customer~customer_data-land1.
        IF sy-subrc = 0.
          land_text = countries[ land1 = zif_demo_customer~customer_data-land1 ]-landx50.
        ENDIF.
    ENDTRY.
  ENDMETHOD.


  METHOD zif_demo_customer~get_name1.
    name1 = zif_demo_customer~customer_data-name1.
  ENDMETHOD.


  METHOD zif_demo_customer~get_ort01.
    ort01 = zif_demo_customer~customer_data-ort01.
  ENDMETHOD.


  METHOD zif_demo_customer~get_pstlz.
    pstlz = zif_demo_customer~customer_data-pstlz.
  ENDMETHOD.


  METHOD zif_demo_customer~get_regio.
    regio = zif_demo_customer~customer_data-regio.
  ENDMETHOD.


  METHOD zif_demo_customer~get_region_text.
    TRY.
        region_text = regions[
          land1 = zif_demo_customer~customer_data-land1
          bland = zif_demo_customer~customer_data-regio
          ]-bezei.
      CATCH cx_sy_itab_line_not_found.
        SELECT land1 bland bezei
          FROM t005u
          APPENDING CORRESPONDING FIELDS OF TABLE regions
          WHERE spras = sy-langu
          AND land1 = zif_demo_customer~customer_data-land1
          AND bland = zif_demo_customer~customer_data-regio.
        IF sy-subrc = 0.
          region_text = regions[
            land1 = zif_demo_customer~customer_data-land1
            bland = zif_demo_customer~customer_data-regio
            ]-bezei.
        ENDIF.
    ENDTRY.
  ENDMETHOD.


  METHOD zif_demo_customer~get_stras.
    stras = zif_demo_customer~customer_data-stras.
  ENDMETHOD.


  method ZIF_GW_METHODS~CREATE_DEEP_ENTITY.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~CREATE_DEEP_ENTITY'.
  endmethod.


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


  METHOD zif_gw_methods~execute_action.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~EXECUTE_ACTION'.
  ENDMETHOD.


  METHOD zif_gw_methods~get_entity.

    GET REFERENCE OF er_entity INTO DATA(entity).
    TRY.
        CASE iv_source_name.
          WHEN 'SalesOrder'.
            zcl_demo_customer=>get(
              |{ zcl_demo_salesorder=>get(
                |{ it_key_tab[ name = 'SalesOrderId' ]-value }|
                )->get_kunnr( ) }|
              )->zif_gw_methods~map_to_entity( entity ).
          WHEN OTHERS.
            zcl_demo_customer=>get(
              |{ it_key_tab[ name = 'CustomerId' ]-value }|
              )->zif_gw_methods~map_to_entity( entity ).
        ENDCASE.

      CATCH zcx_demo_bo cx_sy_itab_line_not_found INTO DATA(exception).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid   = /iwbep/cx_mgw_busi_exception=>business_error
            previous = exception
            message  = |{ exception->get_text( ) }|.
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
            message = |Order parameter '{ order->property }' is not supported|.
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
        WHEN 'KUNNR'.
          DATA(kunnr_range) = option->select_options.
          where_clause = |{ where_clause } & KUNNR IN KUNNR_RANGE|.
        WHEN 'NAME1'.
          DATA(name1_range) = option->select_options.
          where_clause = |{ where_clause } & NAME1 IN NAME1_RANGE|.
        WHEN 'STRAS'.
          DATA(stras_range) = option->select_options.
          where_clause = |{ where_clause } & STRAS IN STRAS_RANGE|.
        WHEN 'ORT01'.
          DATA(ort01_range) = option->select_options.
          where_clause = |{ where_clause } & ORT01 IN ORT01_RANGE|.
        WHEN 'REGIO'.
          DATA(regio_range) = option->select_options.
          where_clause = |{ where_clause } & REGIO IN REGIO_RANGE|.
        WHEN 'PSTLZ'.
          DATA(pstlz_range) = option->select_options.
          where_clause = |{ where_clause } & PSTLZ IN PSTLZ_RANGE|.
        WHEN 'LAND1'.
          DATA(land1_range) = option->select_options.
          where_clause = |{ where_clause } & LAND1 IN LAND1_RANGE|.
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

    SHIFT where_clause LEFT DELETING LEADING ' &'.
    REPLACE ALL OCCURRENCES OF '&' IN where_clause WITH 'AND'.

    TRY.
        " $inlinecount=allpages
        IF io_tech_request_context->has_inlinecount( ) = abap_true.
          DATA dbcount TYPE int4 .
          SELECT COUNT(*)
            INTO dbcount
            FROM kna1
            WHERE (where_clause).
          es_response_context-inlinecount = dbcount.
        ENDIF.

        " Get primary keys
        SELECT kunnr
          INTO CORRESPONDING FIELDS OF <entity>
          FROM kna1
          WHERE (where_clause)
          ORDER BY (orderby_clause).
          CHECK sy-dbcnt > is_paging-skip.
          APPEND <entity> TO <entityset>.
          IF is_paging-top > 0 AND lines( <entityset> ) GE is_paging-top.
            EXIT.
          ENDIF.
        ENDSELECT.
      CATCH cx_sy_dynamic_osql_error INTO DATA(cx_sy_dynamic_osql_error).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid   = /iwbep/cx_mgw_busi_exception=>business_error
            previous = cx_sy_dynamic_osql_error
            message  = |{ cx_sy_dynamic_osql_error->get_text( ) }|.
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
      ASSIGN COMPONENT 'KUNNR' OF STRUCTURE <entity> TO FIELD-SYMBOL(<kunnr>).
      CHECK <kunnr> IS ASSIGNED.
      TRY.
          zcl_demo_customer=>get( <kunnr> )->zif_gw_methods~map_to_entity( entity ).
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