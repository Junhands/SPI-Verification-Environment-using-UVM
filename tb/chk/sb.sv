//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class sb #(type REQ = uvm_sequence_item) extends uvm_scoreboard;

	`uvm_component_param_utils(sb #(REQ))

  // `uvm_analysis_imp_decl(_ref_ob_imp)
  // uvm_analysis_imp_ref_ob_imp # (REQ, sb) ref_ob_imp;
  
  // `uvm_analysis_imp_decl(_act_ob_imp)
  // uvm_analysis_imp_act_ob_imp # (REQ, sb) act_ob_imp;

  uvm_analysis_imp #(REQ, sb #(REQ)) ref_ob_imp;
  uvm_analysis_imp #(REQ, sb #(REQ)) act_ob_imp;

  REQ ref_ob_pkt;
  integer cnt;
  string my_name;
  //
  // NEW
  //
  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = get_name();
    ref_ob_imp = new($psprintf("%s_ref_ob_imp", my_name), this);
    act_ob_imp = new($psprintf("%s_act_ob_imp", my_name), this);
    ref_ob_pkt = REQ::type_id::create("ref_ob_pkt");
    cnt = 0;
  endfunction
		
  //
  // BUILD phase
  //

  //
  // CONNECT phase
  //

  //
  //
  // RUN phase
  //
 function void write_ref_ob_imp(REQ pkt);
    if (cnt == 0)
      ref_ob_pkt.mosi[31:0]    = pkt.wdata;
    else if (cnt == 1)
      ref_ob_pkt.mosi[63:32]   = pkt.wdata;
    else if (cnt == 2)
      ref_ob_pkt.mosi[95:64]   = pkt.wdata;
    else
      ref_ob_pkt.mosi[127:96]  = pkt.wdata;

    if (cnt == 4)
      cnt = 0;
    else
      cnt++;
  endfunction
  function void write_act_ob_imp(REQ pkt);
    if (pkt.mosi == ref_ob_pkt.mosi)
      `uvm_info(my_name, $psprintf("MATCHED MOSI: 0x%h", pkt.mosi), UVM_MEDIUM)
    else
      `uvm_error(my_name, $psprintf("ERROR: MOSI mismatch. ref=0x%h, act=0x%h", ref_ob_pkt.mosi, pkt.mosi))
  endfunction
endclass
