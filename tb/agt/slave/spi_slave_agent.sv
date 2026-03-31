//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
//***************************************************************************************************************
class spi_slave_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

   `uvm_component_param_utils(spi_slave_agent #(REQ,RSP))

   typedef spi_slave_monitor #(REQ) monitor_t;
   monitor_t monitor;
   uvm_analysis_port #(REQ) act_ob_ap;

   //
   // NEW
   //
   function new(string name, uvm_component parent);
      super.new(name,parent);
      act_ob_ap = new($psprintf("%s_act_ob_ap", name), this);
   endfunction

   //
   // BUILD phase
   //
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      monitor = monitor_t::type_id::create("monitor",this);
   endfunction

   //
   // CONNECT phase
   //
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      monitor.act_ob_ap.connect(act_ob_ap);
   endfunction
endclass
