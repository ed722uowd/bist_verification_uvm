

class bist_test extends uvm_test;
  
  `uvm_component_utils(bist_test)
  
  bist_env env;
  bist_sequence seq;
  
  function new(string name = "bist_test", uvm_component parent);
    super.new(name, parent);
    `uvm_info("Test Class", "constructor", UVM_MEDIUM)
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("Test Class", "build phase", UVM_MEDIUM)
    env = bist_env::type_id::create("env" , this);
    seq = bist_sequence::type_id::create("seq", this);
  endfunction
  
  
  //end of elaboration phase
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    `uvm_info("Test Class", "elaboration phase", UVM_MEDIUM)
    this.print();
  endfunction
  
  task run_phase(uvm_phase phase);
    `uvm_info("Test Class", "run_phase", UVM_MEDIUM)

    phase.raise_objection(this); //stay in run_phase untill the Test drop the objection
    seq.start(env.agent.sequencer); 
    phase.drop_objection(this);
    
  endtask 
  
endclass