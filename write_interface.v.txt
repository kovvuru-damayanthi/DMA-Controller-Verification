module write_interface(
    input write_en,
    input [31:0] fifo_data,

    output reg mem_wr_en,
    output reg [31:0] memory_data
);

always @(*)
begin
    if(write_en)
    begin
        mem_wr_en = 1;
        memory_data = fifo_data;
    end
    else
    begin
        mem_wr_en = 0;
        memory_data = 0;
    end
end

endmodule
