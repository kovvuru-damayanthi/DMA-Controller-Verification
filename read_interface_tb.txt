`timescale 1ns/1ps
`include "read_interface.v"

module read_interface_tb;

reg read_en;
reg [31:0] memory_data;

wire fifo_wr_en;
wire [31:0] fifo_data;

read_interface DUT(
    .read_en(read_en),
    .memory_data(memory_data),
    .fifo_wr_en(fifo_wr_en),
    .fifo_data(fifo_data)
);

initial begin
    read_en=0;
    memory_data=32'h12345678;

    #10 read_en=1;

    #20 memory_data=32'hABCDEF12;

    #20 read_en=0;

    #20 $finish;
end

initial
$monitor("time=%0t fifo_wr_en=%b fifo_data=%h",
         $time,fifo_wr_en,fifo_data);


initial
begin
$fsdbDumpfile("read_interface.fsdb");
$fsdbDumpvars(0,read_interface_tb);
end 

endmodule
