/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : V-2023.12
// Date      : Sat Jun 20 10:24:10 2026
/////////////////////////////////////////////////////////////


module dma_top ( clk, rst, dma_req, bus_grant, memory_data_in, done, mem_wr_en, 
        memory_data_out );
  input [31:0] memory_data_in;
  output [31:0] memory_data_out;
  input clk, rst, dma_req, bus_grant;
  output done, mem_wr_en;

  tri   clk;
  tri   rst;
  tri   dma_req;
  tri   bus_grant;
  tri   [31:0] memory_data_in;
  tri   done;
  tri   mem_wr_en;
  tri   [31:0] memory_data_out;
  tri   read_en;
  tri   write_en;
  tri   fifo_wr_en;
  tri   [31:0] fifo_data;
  tri   [31:0] fifo_out;
  tri   empty;

  dma_fsm U1 ( .clk(clk), .rst(rst), .dma_req(dma_req), .bus_grant(bus_grant), 
        .transfer_done(empty), .read_en(read_en), .write_en(write_en), .done(
        done) );
  read_interface U2 ( .read_en(read_en), .memory_data(memory_data_in), 
        .fifo_wr_en(fifo_wr_en), .fifo_data(fifo_data) );
  fifo U3 ( .clk(clk), .rst(rst), .wr_en(fifo_wr_en), .rd_en(write_en), 
        .data_in(fifo_data), .data_out(fifo_out), .empty(empty) );
  write_interface U4 ( .write_en(write_en), .fifo_data(fifo_out), .mem_wr_en(
        mem_wr_en), .memory_data(memory_data_out) );
endmodule

