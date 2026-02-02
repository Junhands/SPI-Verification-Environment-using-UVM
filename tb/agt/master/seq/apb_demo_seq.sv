//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class apb_demo_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ,RSP);

  `uvm_object_param_utils(apb_demo_seq #(REQ,RSP))

  string my_name;
  spi_cfg spi_cfg_h;

  // debug data
  bit [31:0] debug_data [0:3] = '{
      32'hAAAA_AAAA,
      32'hBBBB_BBBB,
      32'hCCCC_CCCC,
      32'hDDDD_DDDD
  };

  //
  // NEW
  //
  function new(string name = "apb_demo_seq");
    super.new(name);
  endfunction

  //
  // BODY
  //
  task body();
    REQ req_pkt;
    RSP rsp_pkt;
    bit [31:0] masked_wdata;
    int total_bits;

    my_name = get_name();

    assert(uvm_resource_db#(spi_cfg)::read_by_name(get_full_name(),"TB_CONFIG", spi_cfg_h));

    if(spi_cfg_h == null) begin
      `uvm_error(my_name, "Could not handle to sequence config")
    end

    repeat(200) begin
      assert(spi_cfg_h.randomize());
      spi_cfg_h.set_mask();
      total_bits = spi_cfg_h.char_len + 1;
      // -------------------------------------------------------------
      // Transaction 1: RESET
      // -------------------------------------------------------------
      // send reset transaction
      req_pkt = REQ::type_id::create($sformatf("reset_req"));
      req_pkt.do_reset = 1;
      req_pkt.do_wait = 0;
      start_item(req_pkt);
      finish_item(req_pkt);
      `uvm_info(my_name, 
          $sformatf("Sending RESET transaction: do_reset=%b, do_wait=%b", req_pkt.do_reset, req_pkt.do_wait), 
          UVM_LOW)
      get_response(rsp_pkt);
      `uvm_info(my_name, 
          $sformatf("Response RESET transaction: do_reset=%b, do_wait=%b", rsp_pkt.do_reset, rsp_pkt.do_wait), 
          UVM_LOW)

      // -------------------------------------------------------------
      // Transaction 2: Write 4 transactions to Tx registers
      // -------------------------------------------------------------
      // send 4 transactions to Tx registers
      for (int i = 0; i < 4; i++) begin
            req_pkt = REQ::type_id::create($sformatf("tx_wdata_req%d", i));
            /* Data Masking Logic:
             - If the word is entirely outside the total_bits range -> set to 0.
             - If the word contains the boundary bit -> apply bitwise AND with a mask.
             - If the word is entirely within the range -> keep original data.
            */
            if (total_bits <= i * 32) begin
              masked_wdata = 32'h0;
            end else if (total_bits < (i + 1) * 32) begin
                masked_wdata = debug_data[i] & ((1 << (total_bits % 32)) - 1);
            end else begin
                masked_wdata = debug_data[i];
            end

            req_pkt.addr   = 4*i; 
            req_pkt.wdata  = masked_wdata;
            req_pkt.wr_rd  = 1;
            req_pkt.do_reset = 0;
            req_pkt.do_wait = 0;

            start_item(req_pkt);
            finish_item(req_pkt);
            get_response(rsp_pkt);
      end
      // -------------------------------------------------------------
      // Transaction 3: Write to Control Register
      // -------------------------------------------------------------
      // send transaction to control register
      req_pkt = REQ::type_id::create("ctrl_write_req");
      req_pkt.addr   = 16; // control reg

      req_pkt.wdata = 0;
      req_pkt.wdata[13]  = spi_cfg_h.ass;
      req_pkt.wdata[12]  = spi_cfg_h.ie;
      req_pkt.wdata[11]  = spi_cfg_h.lsb;
      req_pkt.wdata[10]  = spi_cfg_h.txneg;
      req_pkt.wdata[9]   = spi_cfg_h.rxneg;
      req_pkt.wdata[8]   = 1; // GO_BSY
      req_pkt.wdata[6:0] = spi_cfg_h.char_len;
      req_pkt.wr_rd      = 1;
      req_pkt.do_reset   = 0;
      req_pkt.do_wait    = 0;
      start_item(req_pkt);
      finish_item(req_pkt);

      `uvm_info(my_name, 
          $sformatf("Sent Control Reg Write: Addr=0x%h, Data=0x%h (GO_BSY asserted)", req_pkt.addr, req_pkt.wdata), 
          UVM_LOW)
      // -------------------------------------------------------------
      -> spi_cfg_h.sample_e; // PHASE3 step2

      get_response(rsp_pkt);
      #100ns;
    end
  endtask
endclass