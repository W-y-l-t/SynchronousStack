module stack_behaviour_normal(input wire RESET, input wire CLK,
                              input wire[1:0] COMMAND,
                              input wire[2:0] INDEX,
                              inout wire[3:0] IO_DATA);

    wire COMMAND0 = COMMAND[0];
    wire COMMAND1 = COMMAND[1];

    reg[3:0] OUTPUT;

    reg [4:0][3:0] Stack;
    integer Top = 0;

    always @* begin
        if (RESET == 1'b1) begin
            Top = 0;
            OUTPUT = 4'bZ;
            Stack = 0;
        end
        else begin
            if (CLK == 1'b1) begin
                if (COMMAND1 == 1'b0) begin
                    if (COMMAND0 == 1'b0) begin
                        //Nothing happens, operation = nop
                    end
                    else begin
                        Stack[Top] = IO_DATA;
                        Top = (Top + 1) % 5;
                    end
                end
                else begin
                    if (COMMAND0 == 1'b0) begin
                        Top = (Top == 0) ? 4 : Top - 1;
                        OUTPUT = Stack[Top];
                    end
                    else begin
                        OUTPUT = Stack[(((Top % 5) - (INDEX % 5)) + 4) % 5];
                    end
                end
            end
            else begin
                OUTPUT = 4'bZ;
            end
        end
    end

    assign IO_DATA = OUTPUT;

endmodule : stack_behaviour_normal
