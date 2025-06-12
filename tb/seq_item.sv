	

class bist_seq_item extends uvm_sequence_item;
  
  `uvm_object_utils(bist_seq_item)
  
  //Data
  rand logic [7:0] load_seed;
  rand logic [7:0] load_val;
  rand logic load_en;
  logic [7:0] signature;
  logic [7:0] M_out;
  
  //Constructor
  function new (string name = "bist_seq_item");
    super.new (name);
    `uvm_info("Sequence Item Class", "constructor", UVM_MEDIUM)
  endfunction  
  
endclass