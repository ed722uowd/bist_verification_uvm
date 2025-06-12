// Code your testbench here
// or browse Examples
`timescale 1ns/1ns

`include "uvm_macros.svh"
`include "interface.sv"
`include "seq_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"

`include "get_golden_vals.sv"

`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"

module top;
  
  logic clk;
  
  bist_intf intf (.clk(clk));
  
  BIST dut (.clk(intf.clk),
            .load_seed(intf.load_seed),
            .load_val(intf.load_val),
            .load_en(intf.load_en),
            .signature(intf.signature),
            .M_out(intf.M_out)
           );
  
  initial begin
    uvm_config_db#(virtual bist_intf)::set(null, "*", "v_if", intf);
  end
  
  initial begin
    clk = 0;
  end
  
  always #10 clk = ~clk;
  
  initial begin
    $monitor($time, "clk = %d", clk);
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
   
  initial begin 
    run_test("bist_test");
  end
  
  
  
endmodule