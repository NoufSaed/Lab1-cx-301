

module mem_test ( input logic clk, 
                  output logic read, 
                  output logic write, 
                  output logic [4:0] addr, 
                  output logic [7:0] data_in,     // data TO memory
                  input  wire [7:0] data_out     // data FROM memory
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking

// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

initial
  begin: memtest
  int error_status; //  the error recoerd**
  // initial signal **
   read =0;
   write =0;
   addr =0;
   data_in =0;
   error_status=0;
  

   //_______________________//
    $display("Clear Memory Test");

    for (int i = 0; i< 32; i++) 
       // Write zero data to every address location
        @(negedge clk);
          read =0;
          write =1;
          addr =i;
          data_in =8'h00;

      if (debug)
      $display ("writing 0  to address %0d  : ",i);
      end

    for (int i = 0; i<32; i++)
      begin 
       // Read every address location
        @(negedge clk);
        read=1;        
        write=0;
        addr=i;
        @(negedge clk);
      $display("data out = %0d",data_out);
      
            read = 0;
        end


       // check each memory location for data = 'h00
       if (data_out !== 8'h00) begin
        $display("Error at address %0d: Expected 0x%h, Found 0x%h", i, data_out);
        error_status++;
    end else if (debug) begin
        $display("Address %0d verified: Contains 0x%h", i, data_out);
    end

   

    for (int i = 0; i< 32; i++)
       // Write data = address to every address location
    @(negedge clk)  ;
    read=0;
    write=1;
    addr=i;
    data_in=i;

   if (debug)
      $display ("writing 0x%h  to address %0d  : ",i,i);
    for (int i = 0; i<32; i++)
      begin
       // Read every address location
         read=1;        
        write=0;
        addr=i;
        @(negedge clk);
          $display("data out = %0d",data_out);

            read = 0;

       // check each memory location for data = address
        if (data_out !== i) begin
        $display("Error at address %0d: Expected 0x%h, Found 0x%h", i,i,data_out);
        error_status++;
    end else if (debug) begin
        $display("Address %0d verified: Contains 0x%h", i, data_out);
    end

      end

   // print results of test
    $display("Data = Address Test Results");
        if(error_status == 0)
            $display("PASS - All memory locations contain correct address values");
        else
            $display("FAIL - %0d errors detected", error_status);
    $finish;
  end

// add read_mem and write_mem tasks

// add result print function

endmodule
