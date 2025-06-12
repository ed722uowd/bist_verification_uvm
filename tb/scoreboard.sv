

class bist_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(bist_scoreboard)
  
  uvm_analysis_imp#(bist_seq_item, bist_scoreboard) item_collected_export;
  
  bit [7:0] golden_val [];
  
  bist_seq_item tx_q[$];
  bit [7:0] signature_bin [$];
  int fd;
  
  //Constructor
  function new (string name = "bist_scoreboard", uvm_component parent);
    super.new (name, parent);
    `uvm_info("Scoreboard Class", "constructor", UVM_MEDIUM)
  endfunction
  
  //Build Phase
  function void build_phase (uvm_phase phase);       
    super.build_phase(phase);
    `uvm_info("Scoreboard Class", "build phase", UVM_MEDIUM)    
    item_collected_export = new("item_collected_export", this);
    read_golden_values(signature_bin);
    print_golden_values(signature_bin);
  endfunction
  
  function void check_phase(uvm_phase phase);
    
    super.check_phase(phase);
    `uvm_info("Scoreboard Class", "check phase", UVM_MEDIUM)
    compare_out_golden(signature_bin, tx_q);
  
  endfunction
  
  // write task - recives the pkt from monitor and pushes into queue
  virtual function void write(bist_seq_item tx);
    //pkt.print();
    tx_q.push_back(tx);
  endfunction
 
  
  
endclass