class ZCL_DEMO_DPC_EXT definition
  public
  inheriting from ZCL_DEMO_DPC
  create public .

public section.
protected section.

  data MODEL type ref to ZCL_GW_MODEL .

  methods GET_MODEL
    returning
      value(MODEL) type ref to ZCL_GW_MODEL
    raising
      /IWBEP/CX_MGW_TECH_EXCEPTION .

  methods CUSTOMERS_GET_ENTITY
    redefinition .
  methods CUSTOMERS_GET_ENTITYSET
    redefinition .
  methods SALESORDERITEMS_GET_ENTITYSET
    redefinition .
  methods SALESORDERS_GET_ENTITY
    redefinition .
  methods SALESORDERS_GET_ENTITYSET
    redefinition .
  methods SALESORDERITEMS_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_DEMO_DPC_EXT IMPLEMENTATION.


  METHOD customers_get_entity.
    zcl_demo_customer=>zif_gw_methods~get_entity(
      EXPORTING
        iv_entity_name          = iv_entity_name
        iv_entity_set_name      = iv_entity_set_name
        iv_source_name          = iv_source_name
        it_key_tab              = it_key_tab
        io_request_object       = io_request_object
        io_tech_request_context = io_tech_request_context
        it_navigation_path      = it_navigation_path
        io_model                = get_model( )
        io_message_container    = mo_context->get_message_container( )
      IMPORTING
        er_entity               = er_entity
        es_response_context     = es_response_context
           ).
  ENDMETHOD.


  method CUSTOMERS_GET_ENTITYSET.
    zcl_demo_customer=>zif_gw_methods~get_entityset(
      EXPORTING
        iv_entity_name           = iv_entity_name
        iv_entity_set_name       = iv_entity_set_name
        iv_source_name           = iv_source_name
        it_filter_select_options = it_filter_select_options
        is_paging                = is_paging
        it_key_tab               = it_key_tab
        it_navigation_path       = it_navigation_path
        it_order                 = it_order
        iv_filter_string         = iv_filter_string
        iv_search_string         = iv_search_string
        io_tech_request_context  = io_tech_request_context
        io_model                 = get_model( )
        io_message_container     = mo_context->get_message_container( )
      IMPORTING
        et_entityset             = et_entityset
        es_response_context      = es_response_context
           ).
  endmethod.


  METHOD get_model.

    IF me->model IS NOT BOUND.
      CREATE OBJECT me->model
        EXPORTING
          runtime = me.
    ENDIF.

    model = me->model.

  ENDMETHOD.


  METHOD salesorderitems_get_entity.
    zcl_demo_salesorderitem=>zif_gw_methods~get_entity(
      EXPORTING
        iv_entity_name          = iv_entity_name
        iv_entity_set_name      = iv_entity_set_name
        iv_source_name          = iv_source_name
        it_key_tab              = it_key_tab
        io_request_object       = io_request_object
        io_tech_request_context = io_tech_request_context
        it_navigation_path      = it_navigation_path
        io_model                = get_model( )
        io_message_container    = mo_context->get_message_container( )
      IMPORTING
        er_entity               = er_entity
        es_response_context     = es_response_context
           ).
  ENDMETHOD.


  METHOD salesorderitems_get_entityset.
    zcl_demo_salesorderitem=>zif_gw_methods~get_entityset(
      EXPORTING
        iv_entity_name           = iv_entity_name
        iv_entity_set_name       = iv_entity_set_name
        iv_source_name           = iv_source_name
        it_filter_select_options = it_filter_select_options
        is_paging                = is_paging
        it_key_tab               = it_key_tab
        it_navigation_path       = it_navigation_path
        it_order                 = it_order
        iv_filter_string         = iv_filter_string
        iv_search_string         = iv_search_string
        io_tech_request_context  = io_tech_request_context
        io_model                 = get_model( )
        io_message_container     = mo_context->get_message_container( )
      IMPORTING
        et_entityset             = et_entityset
        es_response_context      = es_response_context
           ).
  ENDMETHOD.


  METHOD salesorders_get_entity.
    zcl_demo_salesorder=>zif_gw_methods~get_entity(
      EXPORTING
        iv_entity_name          = iv_entity_name
        iv_entity_set_name      = iv_entity_set_name
        iv_source_name          = iv_source_name
        it_key_tab              = it_key_tab
        io_request_object       = io_request_object
        io_tech_request_context = io_tech_request_context
        it_navigation_path      = it_navigation_path
        io_model                = get_model( )
        io_message_container    = mo_context->get_message_container( )
      IMPORTING
        er_entity               = er_entity
        es_response_context     = es_response_context
           ).
  ENDMETHOD.


  METHOD salesorders_get_entityset.
    zcl_demo_salesorder=>zif_gw_methods~get_entityset(
      EXPORTING
        iv_entity_name           = iv_entity_name
        iv_entity_set_name       = iv_entity_set_name
        iv_source_name           = iv_source_name
        it_filter_select_options = it_filter_select_options
        is_paging                = is_paging
        it_key_tab               = it_key_tab
        it_navigation_path       = it_navigation_path
        it_order                 = it_order
        iv_filter_string         = iv_filter_string
        iv_search_string         = iv_search_string
        io_tech_request_context  = io_tech_request_context
        io_model                 = get_model( )
        io_message_container     = mo_context->get_message_container( )
      IMPORTING
        et_entityset             = et_entityset
        es_response_context      = es_response_context
           ).
  ENDMETHOD.
ENDCLASS.