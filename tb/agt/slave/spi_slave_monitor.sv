//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_slave_monitor #(type PKT = uvm_sequence_item) extends uvm_monitor;

  `uvm_component_param_utils(spi_slave_monitor #(PKT))

  uvm_analysis_port #(PKT) act_ob_ap;

  virtual interface spi_if spi_vif;
  virtual interface clk_rst_if clk_rst_vif;
  spi_cfg spi_cfg_h;

  bit[127:0] temp_mosi;
  string my_name;
  //
  // NEW
  //
  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = get_name();
    act_ob_ap = new($psprintf("%s_act_ob_ap", my_name), this);
  endfunction

  //
  // CONNECT phase
  //
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db#(virtual spi_if)::get(this,"", "SPI_VIF", spi_vif)) begin
      `uvm_error(my_name, "Could not retrieve virtual spi_if")
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
  //
  task run_phase(uvm_phase phase);
    PKT spi_pkt;
    int bit_cnt;
    @ (spi_cfg_h.sample_e)
    forever begin
      if(spi_cfg_h.txneg) begin
        @ (negedge spi_vif.sclk_pad_o);
      end
      else begin
        @ (posedge spi_vif.sclk_pad_o);
      end
      if(spi_cfg_h.lsb) begin
        temp_mosi = {spi_vif.mosi_pad_o, temp_mosi[127:1]}; // LSB-first (shift right)
        // `uvm_info(my_name, $sformatf("[LSB] MOSI bit [%3d] received: %0b",bit_cnt, spi_vif.mosi_pad_o), UVM_LOW)
      end
      else begin
        temp_mosi = {temp_mosi[126:0], spi_vif.mosi_pad_o}; // MSB-first (shift left)
        // `uvm_info(my_name, $sformatf("[MSB] MOSI bit [%3d] received: %0b",bit_cnt, spi_vif.mosi_pad_o), UVM_LOW)
      end
      bit_cnt ++;

      if(bit_cnt == spi_cfg_h.char_len) begin
        if(spi_cfg_h.char_len != 128) begin
          temp_mosi = temp_mosi >> (128 - spi_cfg_h.char_len - 1); // align to LSB
          temp_mosi[spi_cfg_h.char_len] = 1'b0; // clear unused bits
        end
        spi_pkt = PKT::type_id::create("transaction");
        spi_pkt.mosi = temp_mosi;
        act_ob_ap.write(spi_pkt);
        bit_cnt = 0;
        temp_mosi = 0;
      end
    end
  endtask

endclass
