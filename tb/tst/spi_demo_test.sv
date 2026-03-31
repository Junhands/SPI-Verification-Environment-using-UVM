//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// A demo test case.
//***************************************************************************************************************
class spi_demo_test extends uvm_test;

	`uvm_component_utils(spi_demo_test)

  typedef apb_demo_seq#(spi_tlm, spi_tlm) sequence_t;
  typedef spi_env     #(spi_tlm, spi_tlm) env_t;

  sequence_t sequence_h;
  spi_cfg    spi_cfg_h;
  env_t      env_h;
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

    // Create an instance of env
    env_h = env_t::type_id::create("spi_env",this);

    // Create an instance of spi_cfg_h
    spi_cfg_h = spi_cfg::type_id::create("spi_cfg");

    // Create an instance of the apb_demo_seq
    sequence_h = sequence_t::type_id::create("apb_demo_seq",this);

    // Use uvm_config_db::set to place spi_cfg_h in the resource database
    uvm_resource_db #(spi_cfg)::set("*", "TB_CONFIG", spi_cfg_h);

  endfunction
  //
  // RUN phase
  //
	task run_phase(uvm_phase phase);

    phase.raise_objection(this,"Objection raised by spi_demo_test");

    sequence_h.start(env_h.apb_agent.sequencer); // start the APB sequence

    #50ms; // wait for some time to complete transactions

    phase.drop_objection(this,"Objection dropped by spi_demo_test");
	endtask
	
endclass
   
