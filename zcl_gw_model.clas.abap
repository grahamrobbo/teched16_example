class ZCL_GW_MODEL definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !RUNTIME type ref to /IWBEP/IF_MGW_CONV_SRV_RUNTIME
    raising
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods GET_ABAP_FIELD_NAME
    importing
      !IV_ENTITY_NAME type STRING
      !IV_FIELD_NAME type STRING
    returning
      value(RV_ABAP_FIELD) type STRING .
  methods GET_SORTABLE_ABAP_FIELD_NAME
    importing
      !IV_ENTITY_NAME type STRING
      !IV_FIELD_NAME type STRING
    returning
      value(RV_ABAP_FIELD) type STRING .
  methods GET_FILTERABLE_ABAP_FIELD_NAME
    importing
      !IV_ENTITY_NAME type STRING
      !IV_FIELD_NAME type STRING
    returning
      value(RV_ABAP_FIELD) type STRING .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mpc TYPE REF TO /iwbep/if_mgw_odata_re_model .
    DATA runtime TYPE REF TO /iwbep/if_mgw_conv_srv_runtime .

    METHODS get_entity_properties
      IMPORTING
        !iv_name             TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_internal_name
      RETURNING
        VALUE(rt_properties) TYPE /iwbep/if_mgw_med_odata_types=>ty_t_med_properties .
    METHODS get_property
      IMPORTING
        !iv_entity_name    TYPE string
        !iv_field_name     TYPE string
      RETURNING
        VALUE(rs_property) TYPE /iwbep/if_mgw_med_odata_types=>ty_s_med_property .
ENDCLASS.



CLASS ZCL_GW_MODEL IMPLEMENTATION.


  METHOD constructor.
    me->runtime = runtime.

    DATA: lr_facade TYPE REF TO /iwbep/cl_mgw_dp_facade.
    lr_facade ?= runtime->get_dp_facade( ).

    mpc ?= lr_facade->/iwbep/if_mgw_dp_int_facade~get_model( ).

  ENDMETHOD.


  METHOD get_abap_field_name.

    DATA(property) = get_property(
      iv_entity_name = iv_entity_name
      iv_field_name  = iv_field_name
         ).

    rv_abap_field = property-name.

  ENDMETHOD.


  METHOD get_entity_properties.

    DATA(entities) = mpc->get_entity_types( ).

    READ TABLE entities REFERENCE INTO DATA(node)
      WITH KEY name = iv_name.
    CHECK sy-subrc = 0.
    rt_properties = node->properties.

  ENDMETHOD.


  METHOD get_filterable_abap_field_name.

    DATA(property) = get_property(
      iv_entity_name = iv_entity_name
      iv_field_name  = iv_field_name
         ).

    CHECK property-filterable = abap_true.

    rv_abap_field = property-name.

  ENDMETHOD.


  METHOD get_property.

    DATA(properties) = get_entity_properties( |{ iv_entity_name }| ).

    READ TABLE properties INTO rs_property
      WITH KEY external_name = iv_field_name.

  ENDMETHOD.


  METHOD get_sortable_abap_field_name.

    DATA(property) = get_property(
      iv_entity_name = iv_entity_name
      iv_field_name  = iv_field_name
         ).

    CHECK property-sortable = abap_true.

    rv_abap_field = property-name.

  ENDMETHOD.
ENDCLASS.