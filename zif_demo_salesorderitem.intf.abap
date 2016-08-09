interface ZIF_DEMO_SALESORDERITEM
  public .


  interfaces ZIF_GW_METHODS .

  types:
    BEGIN OF key,
      vbeln TYPE vbeln_va,
      posnr TYPE posnr_va,
    END OF key .
  types:
    BEGIN OF instance_type,
      key      TYPE key,
      instance TYPE REF TO zif_demo_salesorderitem,
    END OF instance_type .
  types:
    instance_ttype TYPE TABLE OF instance_type .

  class-data INSTANCES type INSTANCE_TTYPE .
  data ITEM_DATA type ZDEMO_SALESORDERITEM .

  class-methods GET
    importing
      !KEY type ZIF_DEMO_SALESORDERITEM=>KEY
    returning
      value(INSTANCE) type ref to ZIF_DEMO_SALESORDERITEM
    raising
      ZCX_DEMO_BO .
  methods GET_VBELN
    returning
      value(VBELN) type VBELN
    raising
      ZCX_DEMO_BO .
  methods GET_POSNR
    returning
      value(POSNR) type POSNR_VA
    raising
      ZCX_DEMO_BO .
  methods GET_MATNR
    returning
      value(MATNR) type MATNR
    raising
      ZCX_DEMO_BO .
  methods GET_ARKTX
    returning
      value(ARKTX) type ARKTX
    raising
      ZCX_DEMO_BO .
  methods GET_ZMENG
    returning
      value(ZMENG) type DZMENG
    raising
      ZCX_DEMO_BO .
  methods GET_ZIEME
    returning
      value(ZIEME) type DZIEME
    raising
      ZCX_DEMO_BO .
  methods GET_MSEHT
    returning
      value(MSEHT) type MSEHT
    raising
      ZCX_DEMO_BO .
  methods GET_NETWR
    returning
      value(NETWR) type NETWR_AP
    raising
      ZCX_DEMO_BO .
  methods GET_WAERK
    returning
      value(WAERK) type WAERK
    raising
      ZCX_DEMO_BO .
  methods GET_WAERK_TXT
    returning
      value(WAERK_TXT) type LTEXT
    raising
      ZCX_DEMO_BO .
endinterface.