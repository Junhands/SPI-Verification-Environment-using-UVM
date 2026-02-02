//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
//***************************************************************************************************************
class apb_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

   `uvm_component_param_utils(apb_agent #(REQ,RSP))

   string                   my_name;

   typedef uvm_sequencer #(REQ,RSP) sequencer_t;
   typedef apb_driver    #(REQ,RSP) driver_t;

   sequencer_t sequencer;
   driver_t    driver;

   uvm_analysis_port#(REQ) ref_ob_ap;

   //
   // NEW
   //
   function new(string name, uvm_component parent);
      super.new(name,parent);
      my_name = get_name();
   endfunction
   
   //
   // BUILD phase
   // Create sequencer and driver and ports
   //
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      driver = driver_t::type_id::create("driver",this);
      sequencer = sequencer_t::type_id::create("sequencer",this);
      ref_ob_ap = new($psprintf("%s_ref_ob_ap", my_name),this);
   endfunction
   //
   // CONNECT phase
   // Connect sequencer and driver and driver ports
   //
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
      driver.ref_ob_ap.connect(ref_ob_ap);
   endfunction

endclass