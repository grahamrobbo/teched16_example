class ZCL_DEMO_CUSTOMER_CUST definition
  public
  inheriting from ZCL_DEMO_CUSTOMER
  final
  create protected

  global friends ZCL_DEMO_CUSTOMER .

public section.

  methods GET_SEGMENTATION
    returning
      value(SEGMENTATION) type ZDEMO_SEGMENTATION
    raising
      ZCX_DEMO_BO .

  methods ZIF_DEMO_CUSTOMER~GET_PSTLZ
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_DEMO_CUSTOMER_CUST IMPLEMENTATION.


method GET_SEGMENTATION.
*--------------------------------------------------------------------*
* Sample extension of BO class with new method                       *
*--------------------------------------------------------------------*
    segmentation = 'A'.
  endmethod.


METHOD zif_demo_customer~get_pstlz.
*--------------------------------------------------------------------*
* Sample extension of BO class                                       *
*--------------------------------------------------------------------*
    pstlz = super->get_pstlz( ).

    IF pstlz IS INITIAL.
      pstlz = 'N/A'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.