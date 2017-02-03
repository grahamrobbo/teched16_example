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
  methods GET_PROPERTY
    importing
      !IV_ENTITY_NAME type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_INTERNAL_NAME
      !IV_PROPERTY_NAME type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_INTERNAL_NAME
    returning
      value(RS_PROPERTY) type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_S_MED_PROPERTY .
  PROTECTED SECTION.
private section.

  data MPC type ref to /IWBEP/IF_MGW_ODATA_RE_MODEL .

  methods GET_ENTITY_PROPERTIES
    importing
      !IV_NAME type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_INTERNAL_NAME
    returning
      value(RT_PROPERTIES) type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_T_MED_PROPERTIES .
ENDCLASS.



CLASS ZCL_GW_MODEL IMPLEMENTATION.


  METHOD constructor.

    DATA: lr_facade TYPE REF TO /iwbep/cl_mgw_dp_facade.
    lr_facade ?= runtime->get_dp_facade( ).

    mpc ?= lr_facade->/iwbep/if_mgw_dp_int_facade~get_model( ).

  ENDMETHOD.


  METHOD get_entity_properties.

    DATA(entities) = mpc->get_entity_types( ).

    rt_properties = entities[ name = iv_name ]-properties.
  ENDMETHOD.


  METHOD GET_PROPERTY.

    DATA(properties) = get_entity_properties( |{ iv_entity_name }| ).

    rs_property = properties[ name = iv_property_name ].

  ENDMETHOD.
ENDCLASS.
