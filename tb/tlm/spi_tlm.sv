//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_tlm extends uvm_sequence_item;

 `uvm_object_utils(spi_tlm)

  rand bit[127:0] mosi; // (Step1_p2)
  rand bit[32-1:0] addr;
  rand bit[32-1:0] wdata;
  
  bit wr_rd;
  bit do_reset;
  bit do_wait;

  bit [127:0] temp_mosi;
  
  //
  // NEW
  //
  function new(string name = "spi_tlm");
    super.new(name);
  endfunction

  function void do_copy(uvm_object rhs);
    spi_tlm der_type;
    super.do_copy(rhs);
    $cast(der_type,rhs);
    wdata = der_type.wdata;
    addr = der_type.addr;
  endfunction


  constraint default_tlm{
    wr_rd == 1'b0;
    do_reset == 1'b0;
    do_wait == 1'b0;
  }
endclass
