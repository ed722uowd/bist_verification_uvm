	

class bist_sequence extends uvm_sequence;
  
  `uvm_object_utils(bist_sequence)
  
  bist_seq_item tx;
  
  //Constructor
  function new (string name = "bist_sequence");
    super.new (name);
    `uvm_info("Sequence Class", "constructor", UVM_MEDIUM)
  endfunction  
  
  task body();
    
    repeat(1) begin

      tx = bist_seq_item::type_id::create("tx");
      start_item(tx);
      
      tx.load_seed = 8'b11111111;
      tx.load_val = 8'b00000000;
      tx.load_en = 1'b1;
      
      finish_item(tx);
    end
    
  
  
    repeat(11) begin
    tx = bist_seq_item::type_id::create("tx");
    start_item(tx);
    
    tx.load_en   = 1'b0;

    finish_item(tx);
  end
    
  endtask
  
endclass
    
  