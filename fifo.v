module fifo #(parameter WIDTH=32, DEPTH=16)
(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [WIDTH-1:0] data_in,

    output reg [WIDTH-1:0] data_out,
    output full,
    output empty
);

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [4:0] wr_ptr, rd_ptr;
reg [5:0] count;

assign full = (count == DEPTH);
assign empty = (count == 0);

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        count <= 0;
    end

    else
    begin
        if(wr_en && !full)
        begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
            count <= count + 1;
        end

        if(rd_en && !empty)
        begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            count <= count - 1;
        end
    end
end

endmodule
