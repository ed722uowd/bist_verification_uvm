	

class bist_sequencer extends uvm_sequencer#(bist_seq_item);
  
  `uvm_component_utils(bist_sequencer)
  
  //Constructor
  function new (string name = "bist_sequencer", uvm_component parent);
    super.new (name, parent);
    `uvm_info("Sequencer Class", "constructor", UVM_MEDIUM)
  endfunction
  
  
endclass