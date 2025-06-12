

class bist_monitor extends uvm_monitor;
  
  `uvm_component_utils(bist_monitor)
  
  uvm_analysis_port#(bist_seq_item) item_collected_port;
  
  virtual bist_intf intf;
  bist_seq_item tx;
  
  //Constructor
  function new (string name = "bist_monitor", uvm_component parent);
    super.new (name, parent);
    `uvm_info("Monitor Class", "constructor", UVM_MEDIUM)
  endfunction
  
  //Build Phase
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("Monitor Class", "build phase", UVM_MEDIUM)
    item_collected_port = new("item_collected_port", this);
    
    if (!uvm_config_db#(virtual bist_intf)::get(this,"","v_if",intf))
      begin
      `uvm_fatal("no_inif in monitor","virtual interface get failed from config db");
      end
  endfunction
  
  //Run phase
  task run_phase (uvm_phase phase);
    
    forever begin
      `uvm_info("Monitor Class", "run phase", UVM_MEDIUM)
      tx = bist_seq_item::type_id::create("tx");

      @(posedge intf.clk)
      tx.load_seed = intf.load_seed;
      tx.load_val = intf.load_val;
      tx.load_en = intf.load_en;
      tx.signature = intf.signature;
      tx.M_out     = intf.M_out;
      //`uvm_info("MONITOR", $sformatf("M_out: %08b, Signature: %08b", tx.M_out, tx.signature), UVM_MEDIUM)
      //send to scoreboard
      if (!$isunknown(tx.signature)) begin
        `uvm_info("MONITOR", $sformatf("M_out: %08b, Signature: %08b", tx.M_out, tx.signature), UVM_MEDIUM)
        item_collected_port.write(tx);
      end
    end
  
  endtask  
  
endclass