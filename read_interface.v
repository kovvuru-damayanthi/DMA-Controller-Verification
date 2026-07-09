module read_interface(
    input read_en,
    input [31:0] memory_data,

    output reg fifo_wr_en,
    output reg [31:0] fifo_data
);

always @(*)
begin
    if(read_en)
    begin
        fifo_wr_en = 1;
        fifo_data = memory_data;
    end
    else
    begin
        fifo_wr_en = 0;
        fifo_data = 0;
    end
end

endmodule
