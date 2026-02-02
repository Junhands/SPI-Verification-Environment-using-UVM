//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_cfg extends uvm_object;

  `uvm_object_utils(spi_cfg)

  event sample_e;

  rand bit ass;
  rand bit ie;
  rand bit lsb;
  rand bit txneg;
  rand bit rxneg;
  rand bit [6:0] char_len;

  bit [127:0] mask;
  // constraint default_cstr {
  //   ass == 1;
  //   ie == 1;
  //   lsb == 1;
  //   txneg == 1;
  //   rxneg == 0;
  //   char_len == 127;
  //   // char_len tự random trong ngưỡng cho phép (0~127)
  // }
  covergroup cfg_cov_grp @(sample_e);                                 // Verification Plan
    ass_cov      : coverpoint ass      { bins ass_bin[]   = {0,1}; }  // ID1: Verify ASS
    ie_cov       : coverpoint ie       { bins ie_bin[]    = {0,1}; }  // ID2: Verify IE
    lsb_cov      : coverpoint lsb      { bins lsb_bin[]   = {0,1}; }  // ID3: Verify LSB
    txneg_cov    : coverpoint txneg    { bins txneg_bin[] = {0,1}; }  // ID4: Verify TX_NEG
    rxneg_cov    : coverpoint rxneg    { bins rxneg_bin[] = {0,1}; }  // ID4: Verify RX_NEG
    char_len_cov : coverpoint char_len { bins min_char_len     = {0}; // ID5: Verify CHAR_LEN field boundary values
                                         bins byte_char_len    = {7};
                                         bins word_char_len    = {31};
                                         bins max_char_len     = {127};
                                         bins full_range_char_len  = {[1:126]};}
    char_len_x_lsb: cross char_len_cov, lsb_cov;                      // ID6: Cross CHAR_LEN (Boundary) X LSB (Order).
  endgroup

  function void set_mask();
    if (char_len == 0) begin
      mask = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
    end else begin
      mask = (128'h1 << char_len) - 1;
    end
  endfunction
  //
  // NEW
  //
  function new(string name = "");
    super.new(name);
    cfg_cov_grp = new();
  endfunction

  
endclass
