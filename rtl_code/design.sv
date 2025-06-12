module BIST(
  input clk,
  input [7:0] load_seed,
  input [7:0] load_val,
  input load_en,
  output [7:0] signature,
  output [7:0] M_out
);
  
  reg [7:0] LFSR_out;
  reg [2:0] F;
  reg [0:7] M;

  // Assigning internal MISR output to output port
  assign M_out = M;

  // Mapping comparator output F to M[0:2], zero padding the upper bits
  always @(F) begin
    M[0] = F[0];
    M[1] = F[1];
    M[2] = F[2];
    M[3] = 0;
    M[4] = 0;
    M[5] = 0;
    M[6] = 0;
    M[7] = 0;
  end

  LFSR_PRPG LFSR0 (.clk(clk), .load_seed(load_seed), .load_en(load_en), .pattern(LFSR_out));
  comparator comparator0 (.A(LFSR_out[7:4]), .B(LFSR_out[3:0]), .D(F));
  MISR_compactor MISR0 (.M(M), .load_val(load_val), .clk(clk), .load_en(load_en), .signature(signature));
  
endmodule


// LFSR Module
module LFSR_PRPG (
  
  input clk,
  input [7:0] load_seed,
  input load_en,
  output  [7:0] pattern
);
  
  wire D0, feedback, Q0;
  selector S0 (.A(feedback), .B(load_seed[0]), .select(load_en), .op(D0));
    
  dff dff_0(.D(D0), .clk(clk), .Q(Q0));
  
  wire x1, Q1, D1;
  xor(x1, feedback, Q0);
  
  selector S1 (.A(x1), .B(load_seed[1]), .select(load_en), .op(D1));
  
  dff dff_1(.D(D1), .clk(clk), .Q(Q1));
  
  wire Q2, D2;
  selector S2 (.A(Q1), .B(load_seed[2]), .select(load_en), .op(D2));
  
  dff dff_2(.D(D2), .clk(clk), .Q(Q2));
  
  wire Q3, D3;
  selector S3 (.A(Q2), .B(load_seed[3]), .select(load_en), .op(D3));
  
  dff dff_3(.D(D3), .clk(clk), .Q(Q3));
  
  wire Q4, D4;
  selector S4 (.A(Q3), .B(load_seed[4]), .select(load_en), .op(D4));
  
  dff dff_4(.D(D4), .clk(clk), .Q(Q4));
  
  wire x5, Q5, D5;
  xor(x5, feedback, Q4);
  
  selector S5 (.A(x5), .B(load_seed[5]), .select(load_en), .op(D5));
  
  dff dff_5(.D(D5), .clk(clk), .Q(Q5));
  
  wire x6, D6, Q6;
  xor(x6, feedback, Q5);
  
  selector S6 (.A(x6), .B(load_seed[6]), .select(load_en), .op(D6));
  
  dff dff_6(.D(D6), .clk(clk), .Q(Q6));
  
  wire D7, Q7;
  selector S7 (.A(Q6), .B(load_seed[7]), .select(load_en), .op(D7));
  
  dff dff_7(.D(D7), .clk(clk), .Q(Q7));
  
  assign feedback = Q7;
  
  assign pattern = { Q7, Q6, Q5, Q4, Q3, Q2, Q1, Q0};
  
endmodule

//DFF module
module dff(
  input D,
  input clk,
  output reg Q
);
  
  always @(posedge clk) begin
    Q <= D;
  end
  
endmodule

module selector(
  input A,
  input B,
  input select,
  output reg op
);
  
  always @(*) begin
  
    op = (select == 0) ? A : B;
    
  end
  
endmodule

//CUT module
module comparator(
  input [3:0] A,
  input [3:0] B,
  output reg [2:0] D
);
  
  always @(*) begin
    if (A > B) begin
      D = 3'b010;
    end
    else if (A < B) begin
      D = 3'b100;
    end
    else begin
      D = 3'b001;
    end
  end
  
endmodule
  
//MISR Compactor module
module MISR_compactor(
  input [0:7] M,
  input [7:0] load_val,
  input clk,
  input load_en,
  output [7:0] signature
);
  
  wire feedback, Q7;
  assign feedback = Q7;
  
  wire x0, D0, Q0;
  xor (x0, M[0], feedback);
  selector s0 (.A(x0), .B(load_val[0]), .select(load_en), .op(D0));
  dff d0 (.D(D0), .clk(clk), .Q(Q0));
  
  wire x1, D1, Q1;
  xor (x1, M[1], feedback, Q0);
  selector s1 (.A(x1), .B(load_val[1]), .select(load_en), .op(D1));
  dff d1 (.D(D1), .clk(clk), .Q(Q1));
  
  wire x2, D2, Q2;
  xor (x2, M[2], Q1);
  selector s2 (.A(x2), .B(load_val[2]), .select(load_en), .op(D2));
  dff d2 (.D(D2), .clk(clk), .Q(Q2));
  
  wire x3, D3, Q3;
  xor (x3, M[3], Q2);
  selector s3 (.A(x3), .B(load_val[3]), .select(load_en), .op(D3));
  dff d3 (.D(D3), .clk(clk), .Q(Q3));
  
  wire x4, D4, Q4;
  xor (x4, M[4], Q3);
  selector s4 (.A(x4), .B(load_val[4]), .select(load_en), .op(D4));
  dff d4 (.D(D4), .clk(clk), .Q(Q4));
  
  wire x5, D5, Q5;
  xor (x5, M[5], feedback, Q4);
  selector s5 (.A(x5), .B(load_val[5]), .select(load_en), .op(D5));
  dff d5 (.D(D5), .clk(clk), .Q(Q5));
  
  wire x6, D6, Q6;
  xor (x6, M[6], feedback, Q5);
  selector s6 (.A(x6), .B(load_val[6]), .select(load_en), .op(D6));
  dff d6 (.D(D6), .clk(clk), .Q(Q6));
  
  wire x7, D7;
  xor (x7, M[7], Q6);
  selector s7 (.A(x7), .B(load_val[7]), .select(load_en), .op(D7));
  dff d7 (.D(D7), .clk(clk), .Q(Q7));
  
  
  assign signature = { Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7};
  
endmodule