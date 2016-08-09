INTERFACE zif_demo_customer
  PUBLIC .


  INTERFACES zif_gw_methods .

  TYPES:
    BEGIN OF instance_type,
      kunnr    TYPE kunnr,
      instance TYPE REF TO zif_demo_customer,
    END OF instance_type .
  TYPES:
    instance_ttype TYPE TABLE OF instance_type .

  CLASS-DATA instances TYPE instance_ttype .
  DATA customer_data TYPE zdemo_customer .

  CLASS-METHODS get
    IMPORTING
      !kunnr          TYPE kunnr
    RETURNING
      VALUE(instance) TYPE REF TO zif_demo_customer
    RAISING
      zcx_demo_bo .
  METHODS get_kunnr
    RETURNING
      VALUE(kunnr) TYPE kunnr
    RAISING
      zcx_demo_bo .
  METHODS get_name1
    RETURNING
      VALUE(name1) TYPE name1_gp
    RAISING
      zcx_demo_bo .
  METHODS get_stras
    RETURNING
      VALUE(stras) TYPE stras_gp
    RAISING
      zcx_demo_bo .
  METHODS get_ort01
    RETURNING
      VALUE(ort01) TYPE ort01_gp
    RAISING
      zcx_demo_bo .
  METHODS get_regio
    RETURNING
      VALUE(regio) TYPE regio
    RAISING
      zcx_demo_bo .
  METHODS get_region_text
    RETURNING
      VALUE(region_text) TYPE bezei20
    RAISING
      zcx_demo_bo .
  METHODS get_pstlz
    RETURNING
      VALUE(pstlz) TYPE pstlz
    RAISING
      zcx_demo_bo .
  METHODS get_land1
    RETURNING
      VALUE(land1) TYPE land1_gp
    RAISING
      zcx_demo_bo .
  METHODS get_land_text
    RETURNING
      VALUE(land_text) TYPE landx50
    RAISING
      zcx_demo_bo .
ENDINTERFACE.