

class bist_env extends uvm_env;
  
  `uvm_component_utils(bist_env)  
  
  bist_scoreboard scoreboard;
  bist_agent agent;
  
  function new (string name = "bist_env", uvm_component parent);
    super.new (name, parent);
    `uvm_info("Environment class", "constructor", UVM_MEDIUM)
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("Environment class", "build phase", UVM_MEDIUM)
    agent = bist_agent::type_id::create("agent", this);
    scoreboard = bist_scoreboard::type_id::create("scoreboard", this);
  endfunction
  
  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("Environment class", "connect phase", UVM_MEDIUM)
    agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
  endfunction
  
  
endclass