`timescale 1ns/1ps
`include "write_interface.v"

module write_interface_tb;

reg write_en;
reg [31:0] fifo_data;

wire mem_wr_en;
wire [31:0] memory_data;

write_interface DUT(
    .write_en(write_en),
    .fifo_data(fifo_data),
    .mem_wr_en(mem_wr_en),
    .memory_data(memory_data)
);

initial begin
    write_en=0;
    fifo_data=32'hAAAA5555;

    #10 write_en=1;

    #20 fifo_data=32'h12345678;

    #20 write_en=0;

    #20 $finish;
end

initial
$monitor("time=%0t mem_wr_en=%b memory_data=%h",
         $time,mem_wr_en,memory_data);



initial
begin
$fsdbDumpfile("write_interface.fsdb");
$fsdbDumpvars(0,write_interface_tb);
end 

endmodule
