	

class bist_driver extends uvm_driver#(bist_seq_item);
  
  `uvm_component_utils(bist_driver)
  
  bist_seq_item tx;
  virtual bist_intf intf;
  
  //Constructor
  function new (string name = "bist_driver", uvm_component parent);
    super.new (name, parent);
    `uvm_info("Driver Class", "constructor", UVM_MEDIUM)
  endfunction
  
  //Build phase
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("Driver Class", "build phase", UVM_MEDIUM)
    if (!uvm_config_db#(virtual bist_intf)::get(this,"","v_if",intf))
      begin
      `uvm_fatal("no_inif in driver","virtual interface get failed from config db");
      end
  endfunction
  
  //Run phase
  task run_phase (uvm_phase phase);
       
    forever begin
      `uvm_info("Driver Class", "run phase", UVM_MEDIUM)
      seq_item_port.get_next_item(tx);
      drive_tx(tx);
      seq_item_port.item_done();
    end
    
  endtask
  
  task drive_tx (bist_seq_item tx);
    
    intf.load_seed <= tx.load_seed;
    intf.load_val <= tx.load_val;
    intf.load_en <= tx.load_en;
    
    @(posedge intf.clk);
    //if (intf.load_en) begin
      
      //intf.load_en <= 0;
    //end
  endtask
  
  
endclass