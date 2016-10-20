interface ZIF_DEMO_SALESORDER
  public .


  interfaces ZIF_GW_METHODS .

  types:
    BEGIN OF instance_type,
      vbeln    TYPE vbeln,
      instance TYPE REF TO zif_demo_salesorder,
    END OF instance_type .
  types:
    instance_ttype TYPE TABLE OF instance_type .

  class-data INSTANCES type INSTANCE_TTYPE .
  data SALESORDER_DATA type ZDEMO_SALESORDER .

  class-methods GET
    importing
      !VBELN type VBELN
    returning
      value(INSTANCE) type ref to ZIF_DEMO_SALESORDER
    raising
      ZCX_DEMO_BO .
  methods GET_VBELN
    returning
      value(VBELN) type VBELN
    raising
      ZCX_DEMO_BO .
  methods GET_AUDAT
    returning
      value(AUDAT) type EPSORDDAT
    raising
      ZCX_DEMO_BO .
  methods GET_KUNNR
    returning
      value(KUNNR) type KUNNR
    raising
      ZCX_DEMO_BO .
  methods GET_ITEMS
    returning
      value(ITEMS) type OSREFTAB
    raising
      ZCX_DEMO_BO .
endinterface.