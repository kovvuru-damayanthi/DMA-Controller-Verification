module address_generator(
    input clk,
    input rst,
    input enable,

    input [31:0] src_addr,
    input [31:0] dst_addr,
    input [7:0] transfer_len,

    output reg [31:0] src_out,
    output reg [31:0] dst_out,
    output reg transfer_done
);

reg [7:0] count;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        src_out <= src_addr;
        dst_out <= dst_addr;
        count <= 0;
        transfer_done <= 0;
    end

    else if(enable)
    begin
        if(count < transfer_len)
        begin
            src_out <= src_out + 1;
            dst_out <= dst_out + 1;
            count <= count + 1;
            transfer_done <= 0;
        end

        else
            transfer_done <= 1;
    end
end

endmodule
