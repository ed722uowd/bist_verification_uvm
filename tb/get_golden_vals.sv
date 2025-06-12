
//Converts read golden signature values into binary
function void signature_binary(string line, ref bit [7:0] signature_bin [$]);
  bit [7:0] signature; 
  for (int i = 0; i < 8; ++i) begin
    signature[7-i] = (line[i] == "1") ? 1'b1 : 1'b0;
  end
  signature_bin.push_back(signature);

endfunction

//Gets the signature from the text file
//Calls the above function
function void get_signature(ref int fd, ref string line,ref bit [7:0] signature_bin [$]);
  while (! $feof(fd)) begin

    $fgets(line,fd);
    signature_binary(line,  signature_bin);

  end
endfunction

//Main call function
//Calls the above function
function void read_golden_values(ref bit [7:0] signature_bin [$]);
  string line;
  int fd;
  fd = $fopen("golden_val_file.txt","r");
  if (fd==0)begin
    `uvm_fatal("File Error", "Can't ope the file");
    $finish;
  end
  else begin
    $display("File found", " golden_val_file.txt");
    get_signature(fd, line, signature_bin);
    //$display("%s",line);
    $fclose(fd);
  end
endfunction

//Print the golden values
function void print_golden_values (ref bit [7:0] signature_bin [$]);
  
  foreach (signature_bin[i]) begin
      $display("Signature[%0d] = %08b", i, signature_bin[i]);
    end
  
endfunction

//Compares the simulation result with golden values pushed into queues 
function void compare_out_golden(bit [7:0] signature_bin [$], bist_seq_item tx_q[$]);
  int match_count =0;
  
  //Compares the size of the queues
  //If the test fails no need to compare every single element in the quese
  if (signature_bin.size() != tx_q.size()) begin
    `uvm_error("Scoreboard", $sformatf("Size does not match: DUT length = %0d Golden value length = %0d",
                                       tx_q.size(), signature_bin.size()))
    return;
  end
  else begin
    `uvm_info("Scoreboard", $sformatf("Size mathces: DUT length = %0d Golden value length = %0d",
                                      tx_q.size(), signature_bin.size()),UVM_LOW)
  end

  //If the sizes are equal compare elements of the queues
  for (int i = 0; i < tx_q.size(); ++i) begin
    if (signature_bin[i] === tx_q[i].signature) begin
      `uvm_info("Scoreboard", $sformatf("Index %0d matches: DUT = %0b Golden value = %0b",
                                        i, signature_bin[i], tx_q[i].signature),UVM_LOW)
      ++match_count;
    end
    else begin
      `uvm_error("Scoreboard", $sformatf("Index %0d doesn't match: DUT = %0b Golden value = %0b",
                                         i, signature_bin[i], tx_q[i].signature))
    end

  end
  
  //Displays the percentage of matches and mismatches between simulation and golden values
  if (tx_q.size() == match_count) begin
    `uvm_info("Scoreboard",$sformatf("100%% match with DUT and Golden values"), UVM_MEDIUM)
  end
  else begin
    `uvm_info("Scoreboard", $sformatf("%0d%% match with DUT and Golden values %0d%% match with DUT and Golden values",
                                      (match_count * 100)/tx_q.size(), ((tx_q.size() - match_count)*100)/tx_q.size()),
              UVM_MEDIUM)
  end
endfunction