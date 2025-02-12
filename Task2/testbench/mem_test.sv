module mem_test ( 
    input logic clk, 
    output logic read, 
    output logic write, 
    output logic [4:0] addr, 
    output logic [7:0] data_in,     // data TO memory
    input  wire [7:0] data_out      // data FROM memory
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

initial begin: memtest
    int error_status = 0; //  the error record**

    // initial signal **
    read = 0;
    write = 0;
    addr = 0;
    data_in = 0;

    //_______________________//
    $display("Clear Memory Test");

    for (int i = 0; i < 32; i++) begin
        // Write zero data to every address location
        write_mem(i, 8'h00, debug);
    end

    for (int i = 0; i < 32; i++) begin 
        // Read every address location
        read_mem(i, rdata, debug);
        // check each Memory 
        error_status = check(i, rdata, 8'h00);
    end
    printstatus(error_status);
    
    $display("---Data = Address Test");
    for (int i = 0; i < 32; i++) begin
        // Write data = address to every address location
        write_mem(i, i, debug);
    end

    for (int i = 0; i < 32; i++) begin
        // Read every address location
        read_mem(i, rdata, debug);

        // check each memory location for data = address
        error_status = check(i, rdata, i);
    end
    printstatus(error_status);

    $finish;
end

// add read_mem and write_mem tasks
task write_mem (input [4:0] addr1, input [7:0] data, input debug = 0);
    @(negedge clk);
    write = 1;
    read = 0;
    addr = addr1;
    data_in = data; 
    @(negedge clk);
    write = 0;
    if (debug)
        $display("writing - Address :%d  Data :%d ", addr1,data); 
endtask

task read_mem (input [4:0] addr0, output [7:0] rdata, input debug = 0);
    @(negedge clk);
    write = 0;
    read = 1;
    addr = addr0;
    @(negedge clk);
    read = 0;
    rdata = data_out;
    if (debug)
        $display("Read from address %0d Data: 0x%d", addr0, rdata); 
endtask

// add result print function
function int check (input [4:0] addre, input [7:0] actual, input [7:0] expected); 
    static int error_status = 0;
    if (actual !== expected) begin
        $display("Error: address: %d data: %d expected: %d", addre, actual, expected); 
        error_status++;
    end
    return error_status;
endfunction

function void printstatus (int status);
    if (status == 0)
        $display("The test passed");
    else 
        $display("Test failed with %0d errors", status);
endfunction

endmodule
