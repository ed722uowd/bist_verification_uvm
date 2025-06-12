interface bist_intf (input logic clk);
  

  logic [7:0] load_seed;
  logic [7:0] load_val;
  logic load_en;
  logic [7:0] signature;
  logic [7:0] M_out;
  
endinterface