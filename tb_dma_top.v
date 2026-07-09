`timescale 1ns/1ps
`include "dma_top.v"
module tb_dma_top;

    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;

    reg clk;
    reg rst;
    reg dma_req;
    reg [ADDR_WIDTH-1:0] src_addr;
    reg [ADDR_WIDTH-1:0] dst_addr;
    reg [7:0] transfer_len;
    wire dma_done;
    
    reg bus_grant;
    reg [DATA_WIDTH-1:0] bus_rdata;
    wire [ADDR_WIDTH-1:0] bus_addr;
    wire [DATA_WIDTH-1:0] bus_wdata;
    wire bus_read_en;
    wire bus_write_en;

    // Simple memory model
    reg [DATA_WIDTH-1:0] memory [0:255];
    integer i;

    dma_top dut (
       .clk(clk),
       .rst(rst),
       .dma_req(dma_req),
       .src_addr(src_addr),
       .dst_addr(dst_addr),
       .transfer_len(transfer_len),
       .dma_done(dma_done),
       .bus_grant(bus_grant),
       .bus_rdata(bus_rdata),
       .bus_addr(bus_addr),
       .bus_wdata(bus_wdata),
       .bus_read_en(bus_read_en),
       .bus_write_en(bus_write_en)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz
    end

    // Memory read model
    always @(posedge clk) begin
        if(bus_read_en)
            bus_rdata <= memory[bus_addr[7:0]]; // Use lower 8 bits as index
    end

    // Memory write model
    always @(posedge clk) begin
        if(bus_write_en)
            memory[bus_addr[7:0]] <= bus_wdata;
    end

    // FSDB dump
    initial begin
        $fsdbDumpfile("dma_top_tb.fsdb");
        $fsdbDumpvars(0, tb_dma_top);
    end

    // Test sequence
    initial begin
        // Init memory with test data
        for(i = 0; i < 256; i = i + 1) begin
            memory[i] = i + 32'hA000_0000;
        end

        // Reset
        rst = 1;
        dma_req = 0;
        bus_grant = 0;
        src_addr = 0;
        dst_addr = 0;
        transfer_len = 0;
        #20;
        rst = 0;
        #20;

        // Test 1: Transfer 8 words from 0x00 to 0x80
        $display("Starting DMA: 8 words from 0x00 to 0x80");
        src_addr = 32'h0000_0000;
        dst_addr = 32'h0000_0080;
        transfer_len = 8;
        dma_req = 1;
        #10;
        dma_req = 0;
        
        // Grant bus after 2 cycles
        #20;
        bus_grant = 1;
        #10;
        bus_grant = 0;

        // Wait for done
        wait(dma_done == 1'b1);
        #20;
        $display("DMA Done!");

        // Check results
        for(i = 0; i < 8; i = i + 1) begin
            if(memory[i + 8'h80]!== memory[i])
                $display("ERROR: mem[0x%0h] = 0x%0h, expected 0x%0h", 
                          i+8'h80, memory[i+8'h80], memory[i]);
            else
                $display("OK: mem[0x%0h] = 0x%0h", i+8'h80, memory[i+8'h80]);
        end

        #100;
        $finish;
    end

endmodule
