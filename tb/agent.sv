

class bist_agent extends uvm_agent;
  
  `uvm_component_utils(bist_agent)
  
  bist_monitor monitor;
  bist_driver driver;
  bist_sequencer sequencer;  
  
  //Constructor
  function new (string name = "bist_agent", uvm_component parent);
    super.new (name, parent);
    `uvm_info("Agent Class", "constructor", UVM_MEDIUM)
  endfunction
  
  //Build Phase
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("Agent Class", "build phase", UVM_MEDIUM)
    monitor = bist_monitor::type_id::create("monitor", this);
    driver = bist_driver::type_id::create("driver", this);
    sequencer = bist_sequencer::type_id::create("sequencer", this);
  endfunction
  
  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("Agent Class", "connect phase", UVM_MEDIUM)
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
  
  
endclass