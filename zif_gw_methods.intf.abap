INTERFACE zif_gw_methods
  PUBLIC .


  CLASS-METHODS create_entity
    IMPORTING
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_c OPTIONAL
      !io_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider OPTIONAL
      !io_model                TYPE REF TO zcl_gw_model
      !io_message_container    TYPE REF TO /iwbep/if_message_container OPTIONAL
    EXPORTING
      !er_entity               TYPE data
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
  CLASS-METHODS create_deep_entity
    IMPORTING
      !io_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider
      !io_expand               TYPE REF TO /iwbep/if_mgw_odata_expand
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_c OPTIONAL
      !io_model                TYPE REF TO zcl_gw_model
      !io_message_container    TYPE REF TO /iwbep/if_message_container OPTIONAL
    EXPORTING
      !er_deep_entity          TYPE REF TO data
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
  CLASS-METHODS delete_entity
    IMPORTING
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_d OPTIONAL
      !io_model                TYPE REF TO zcl_gw_model
      !io_message_container    TYPE REF TO /iwbep/if_message_container OPTIONAL
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
  CLASS-METHODS get_entity
    IMPORTING
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity OPTIONAL
      !io_model                TYPE REF TO zcl_gw_model
      !io_message_container    TYPE REF TO /iwbep/if_message_container OPTIONAL
    EXPORTING
      !er_entity               TYPE data
      !es_response_context     TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_entity_cntxt
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
  CLASS-METHODS get_entityset
    IMPORTING
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entityset
      !io_model                TYPE REF TO zcl_gw_model
      !io_message_container    TYPE REF TO /iwbep/if_message_container OPTIONAL
    EXPORTING
      !et_entityset            TYPE data
      !es_response_context     TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
  CLASS-METHODS update_entity
    IMPORTING
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_u OPTIONAL
      !io_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider OPTIONAL
      !io_model                TYPE REF TO zcl_gw_model
      !io_message_container    TYPE REF TO /iwbep/if_message_container OPTIONAL
    EXPORTING
      !er_entity               TYPE data
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
  CLASS-METHODS execute_action
    IMPORTING
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_func_import
      !io_model                TYPE REF TO zcl_gw_model
      !io_message_container    TYPE REF TO /iwbep/if_message_container OPTIONAL
    EXPORTING
      !er_data                 TYPE REF TO data
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
  METHODS map_to_entity
    IMPORTING
      !entity TYPE REF TO data
    RAISING
      zcx_demo_bo .
ENDINTERFACE.
