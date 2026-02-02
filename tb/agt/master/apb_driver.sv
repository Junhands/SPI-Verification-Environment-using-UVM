//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class apb_driver #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_driver #(REQ,RSP);

  `uvm_component_param_utils(apb_driver #(REQ,RSP))

  string my_name;
  integer rsp_pkt_cnt;

  virtual interface apb_if apb_vif;
  virtual interface clk_rst_if clk_rst_vif;
  spi_cfg spi_cfg_h;

  uvm_analysis_port #(REQ) ref_ob_ap;
  //
  // NEW
  //
  function new(string name, uvm_component parent);
     super.new(name,parent);
     my_name = get_name();
  endfunction

  //
  // BUILD phase
  //
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ref_ob_ap = new($psprintf("%s_ref_ob_ap", my_name),this);
  endfunction

  //
  // CONNECT phase
  // Retrieve a handle to the apb_if and spi_cfg
  //
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(!uvm_config_db#(virtual apb_if)::get(this,"", "APB_VIF", apb_vif)) begin
      `uvm_error(my_name, "Could not retrieve virtual apb_if")
    end
    if(!uvm_config_db#(virtual clk_rst_if)::get(this,"","CLK_RST_VIF",clk_rst_vif)) begin
      `uvm_error(my_name, "Could not retrieve virtual clk_rst_if")
    end
    if(!uvm_config_db#(spi_cfg)::get(this,"","TB_CONFIG", spi_cfg_h)) begin
      `uvm_error(my_name, "Could not retrieve TB_CONFIG");
    end
  endfunction
  //
  // RUN phase
  // Retrieve a transaction packet and act on it:
  //
  virtual task run_phase(uvm_phase phase);
    REQ req_pkt;
    RSP rsp_pkt;
    forever @(posedge apb_vif.clk) begin
      seq_item_port.get_next_item(req_pkt);
      if(req_pkt == null) begin
        continue;
      end
      if(req_pkt.do_reset) begin
        clk_rst_vif.do_reset(5);
      end
      else if(req_pkt.do_wait) begin
        clk_rst_vif.do_wait(5);
      end
      else if(req_pkt.wr_rd) begin
        // ref_ob_ap.write(req_pkt); // after receiving a write packet (Step2_p2)
        send_write_packet(req_pkt);
        ref_ob_ap.write(req_pkt); // after the APB write transaction to a Tx register (Step2_p2)
      end
      // else begin
      //   send_read_packet(req_pkt);
      // end

      rsp_pkt_cnt++;
      rsp_pkt = RSP::type_id::create($psprintf("rsp_pkt_id_%d",rsp_pkt_cnt));
      rsp_pkt.set_id_info(req_pkt);
      rsp_pkt.copy(req_pkt);
      seq_item_port.item_done(rsp_pkt);
    end //forever loop
  endtask

  virtual task send_write_packet(REQ req_pkt);
    wait(apb_vif.rst);

    @(posedge apb_vif.clk) begin
      apb_vif.PSEL <= 1'b1;
      apb_vif.PENABLE <= 1'b0;
      apb_vif.PWRITE <= 1'b1;
      apb_vif.PADDR <= req_pkt.addr;
      apb_vif.PWDATA <= req_pkt.wdata;
    end

    @(posedge apb_vif.clk)
    apb_vif.PENABLE <= 1'b1;

    wait(apb_vif.PREADY);

    @(posedge apb_vif.clk) begin
      apb_vif.PENABLE <= 1'b0;
      apb_vif.PSEL <= 1'b0;
    end
  endtask

  // PHASE 1 don't need this task //
//====================================//
  // virtual task send_read_packet(REQ req_pkt);
  //   wait(apb_vif.PRESETN);
  //   @(posedge apb_vif.PCLK) begin
  //     apb_vif.PWRITE <= 1'b0;
  //     apb_vif.PSEL <= 1'b1;
  //     apb_vif.PENABLE <= 1'b0;
  //     apb_vif.PADDR <= req_pkt.addr;
  //   end

  //   @(posedge apb_vif.PCLK)
  //   apb_vif.PENABLE <= 1'b1;

  //   wait(apb_vif.PREADY)
  //   @(posedge apb_vif.PCLK) begin
  //     apb_vif.PENABLE <= 1'b0;
  //     apb_vif.PSEL <= 1'b0;
  //   end
  // endtask

endclass

