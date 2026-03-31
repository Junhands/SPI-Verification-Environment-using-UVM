//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_env #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_env;

   `uvm_component_param_utils(spi_env #(REQ,RSP))

   typedef apb_agent#(REQ, RSP) apb_agent_t;
   typedef spi_slave_agent#(REQ,RSP) spi_slave_agent_t;
   typedef sb#(REQ) scoreboard_t;

   apb_agent_t apb_agent;
   spi_slave_agent_t spi_slave_agent;
   scoreboard_t scoreboard;
   //
   // NEW
   //
   function new(string name, uvm_component parent);
      super.new(name,parent);
      
   endfunction
   
   //
   // BUILD phase
   //
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      apb_agent = apb_agent_t::type_id::create("agent",this);
      scoreboard = scoreboard_t::type_id::create("scoreboard",this);
      spi_slave_agent = spi_slave_agent_t::type_id::create("spi_slave_agent",this);
   endfunction
   //
   // CONNECT phase
   //
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      apb_agent.ref_ob_ap.connect(scoreboard.ref_ob_imp);
      spi_slave_agent.act_ob_ap.connect(scoreboard.act_ob_imp);
   endfunction
endclass
