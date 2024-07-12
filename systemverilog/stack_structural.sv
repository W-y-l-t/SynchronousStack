module RSTrigger(input wire R, input wire S,
                 output wire Q);

    wire not_quit;

    nor NOR_RESET(Q, R, not_quit);
    nor NOR_SET(not_quit, S, Q);

endmodule : RSTrigger

module DTrigger(input wire D, input wire C,
                output wire Q);

    wire not_d;
    wire click_and;
    wire data_and;

    not not_d_gate(not_d, D);
    and and_click(click_and, C, not_d);
    and and_data(data_and, D, C);

    RSTrigger rs_trigger(.R(click_and), .S(data_and), .Q(Q));

endmodule : DTrigger

module ThreeBitsToDecMod(input wire I0, input wire I1, input wire I2,
                         output wire O0, output wire O1, output wire O2, output wire O3, output wire O4);

    wire not_I0;
    wire not_I1;
    wire not_I2;
    not not_I0_gate(not_I0, I0);
    not not_I1_gate(not_I1, I1);
    not not_I2_gate(not_I2, I2);

    wire and_O0_first;
    wire and_O0_second;
    and and_O0_first_gate(and_O0_first, not_I0, not_I1, not_I2);
    and and_O0_second_gate(and_O0_second, I0, not_I1, I2);
    or or_O0_gate(O0, and_O0_first, and_O0_second);

    wire and_O1_first;
    wire and_O1_second;
    and and_O1_first_gate(and_O1_first, I0, not_I1, not_I2);
    and and_O1_second_gate(and_O1_second, not_I0, I1, I2);
    or or_O1_gate(O1, and_O1_first, and_O1_second);

    wire and_O2_first;
    wire and_O2_second;
    and and_O2_first_gate(and_O2_first, not_I0, I1, not_I2);
    and and_O2_second_gate(and_O2_second, I0, I1, I2);
    or or_O2_gate(O2, and_O2_first, and_O2_second);

    and and_O3_gate(O3, I0, I1, not_I2);

    and and_O4_gate(O4, not_I0, not_I1, I2);

endmodule : ThreeBitsToDecMod

module DecModToThreeBits(output wire I0, output wire I1, output wire I2,
                         input wire O0, input wire O1, input wire O2, input wire O3, input wire O4);

    or or_I0_gate(I0, O1, O3);
    or or_I1_gate(I1, O2, O3);
    assign I2 = O4;

endmodule : DecModToThreeBits

module FourBitMemoryCell(input wire C, input wire Reset,
                         input wire D0, input wire D1, input wire D2, input wire D3,
                         output wire Q0, output wire Q1, output wire Q2, output wire Q3);

    wire not_Reset;
    not not_Reset_gate(not_Reset, Reset);

    wire conditional_D0;
    wire conditional_D1;
    wire conditional_D2;
    wire conditional_D3;
    and and_conditional_D0(conditional_D0, not_Reset, D0);
    and and_conditional_D1(conditional_D1, not_Reset, D1);
    and and_conditional_D2(conditional_D2, not_Reset, D2);
    and and_conditional_D3(conditional_D3, not_Reset, D3);

    wire conditional_C;
    or or_conditional_C(conditional_C, C, Reset);

    DTrigger d_trigger_first(.D(conditional_D0), .C(conditional_C), .Q(Q0));
    DTrigger d_trigger_second(.D(conditional_D1), .C(conditional_C), .Q(Q1));
    DTrigger d_trigger_third(.D(conditional_D2), .C(conditional_C), .Q(Q2));
    DTrigger d_trigger_fourth(.D(conditional_D3), .C(conditional_C), .Q(Q3));

endmodule : FourBitMemoryCell

module MemoryLogic(input wire I0, input wire I1, input wire I2,
                   input wire Cell00, input wire Cell01, input wire Cell02, input wire Cell03,
                   input wire Cell10, input wire Cell11, input wire Cell12, input wire Cell13,
                   input wire Cell20, input wire Cell21, input wire Cell22, input wire Cell23,
                   input wire Cell30, input wire Cell31, input wire Cell32, input wire Cell33,
                   input wire Cell40, input wire Cell41, input wire Cell42, input wire Cell43,
                   output wire O0, output wire O1, output wire O2, output wire O3);

    wire Value0; wire Value1; wire Value2; wire Value3; wire Value4;
    ThreeBitsToDecMod three_to_five(.I0(I0), .I1(I1), .I2(I2), .O0(Value0), .O1(Value1), .O2(Value2), .O3(Value3), .O4(Value4));

    wire Flag00; wire Flag01; wire Flag02; wire Flag03;
    wire Flag10; wire Flag11; wire Flag12; wire Flag13;
    wire Flag20; wire Flag21; wire Flag22; wire Flag23;
    wire Flag30; wire Flag31; wire Flag32; wire Flag33;
    wire Flag40; wire Flag41; wire Flag42; wire Flag43;

    and flag00_and_gate(Flag00, Cell00, Value0);
    and flag01_and_gate(Flag01, Cell01, Value0);
    and flag02_and_gate(Flag02, Cell02, Value0);
    and flag03_and_gate(Flag03, Cell03, Value0);
    and flag10_and_gate(Flag10, Cell10, Value1);
    and flag11_and_gate(Flag11, Cell11, Value1);
    and flag12_and_gate(Flag12, Cell12, Value1);
    and flag13_and_gate(Flag13, Cell13, Value1);
    and flag20_and_gate(Flag20, Cell20, Value2);
    and flag21_and_gate(Flag21, Cell21, Value2);
    and flag22_and_gate(Flag22, Cell22, Value2);
    and flag23_and_gate(Flag23, Cell23, Value2);
    and flag30_and_gate(Flag30, Cell30, Value3);
    and flag31_and_gate(Flag31, Cell31, Value3);
    and flag32_and_gate(Flag32, Cell32, Value3);
    and flag33_and_gate(Flag33, Cell33, Value3);
    and flag40_and_gate(Flag40, Cell40, Value4);
    and flag41_and_gate(Flag41, Cell41, Value4);
    and flag42_and_gate(Flag42, Cell42, Value4);
    and flag43_and_gate(Flag43, Cell43, Value4);

    or o0_or_gate(O0, Flag00, Flag10, Flag20, Flag30, Flag40);
    or o1_or_gate(O1, Flag01, Flag11, Flag21, Flag31, Flag41);
    or o2_or_gate(O2, Flag02, Flag12, Flag22, Flag32, Flag42);
    or o3_or_gate(O3, Flag03, Flag13, Flag23, Flag33, Flag43);

endmodule : MemoryLogic

module Memory(input wire I0, input wire I1, input wire I2,
              input wire IsWrite, input wire C,
              input wire D0, input wire D1, input wire D2, input wire D3, input wire Reset,
              output wire O0, output wire O1, output wire O2, output wire O3);

    wire Value0_temp; wire Value1_temp; wire Value2_temp; wire Value3_temp; wire Value4_temp;
    ThreeBitsToDecMod three_to_five_mux(.I0(I0), .I1(I1), .I2(I2), .O0(Value0_temp), .O1(Value1_temp), .O2(Value2_temp), .O3(Value3_temp), .O4(Value4_temp));

    and value0_and_gate(Value0, IsWrite, C, Value0_temp);
    and value1_and_gate(Value1, IsWrite, C, Value1_temp);
    and value2_and_gate(Value2, IsWrite, C, Value2_temp);
    and value3_and_gate(Value3, IsWrite, C, Value3_temp);
    and value4_and_gate(Value4, IsWrite, C, Value4_temp);

    wire Cell00; wire Cell01; wire Cell02; wire Cell03;
    wire Cell10; wire Cell11; wire Cell12; wire Cell13;
    wire Cell20; wire Cell21; wire Cell22; wire Cell23;
    wire Cell30; wire Cell31; wire Cell32; wire Cell33;
    wire Cell40; wire Cell41; wire Cell42; wire Cell43;

    FourBitMemoryCell first_cell(.C(Value0), .Reset(Reset), .D0(D0), .D1(D1), .D2(D2), .D3(D3), .Q0(Cell00), .Q1(Cell01), .Q2(Cell02), .Q3(Cell03));
    FourBitMemoryCell second_cell(.C(Value1), .Reset(Reset), .D0(D0), .D1(D1), .D2(D2), .D3(D3), .Q0(Cell10), .Q1(Cell11), .Q2(Cell12), .Q3(Cell13));
    FourBitMemoryCell third_cell(.C(Value2), .Reset(Reset), .D0(D0), .D1(D1), .D2(D2), .D3(D3), .Q0(Cell20), .Q1(Cell21), .Q2(Cell22), .Q3(Cell23));
    FourBitMemoryCell fourth_cell(.C(Value3), .Reset(Reset), .D0(D0), .D1(D1), .D2(D2), .D3(D3), .Q0(Cell30), .Q1(Cell31), .Q2(Cell32), .Q3(Cell33));
    FourBitMemoryCell fifth_cell(.C(Value4), .Reset(Reset), .D0(D0), .D1(D1), .D2(D2), .D3(D3), .Q0(Cell40), .Q1(Cell41), .Q2(Cell42), .Q3(Cell43));

    MemoryLogic memory_logic(.I0(I0), .I1(I1), .I2(I2), .Cell00(Cell00), .Cell01(Cell01), .Cell02(Cell02), .Cell03(Cell03), .Cell10(Cell10), .Cell11(Cell11), .Cell12(Cell12), .Cell13(Cell13), .Cell20(Cell20), .Cell21(Cell21), .Cell22(Cell22), .Cell23(Cell23), .Cell30(Cell30), .Cell31(Cell31), .Cell32(Cell32), .Cell33(Cell33), .Cell40(Cell40), .Cell41(Cell41), .Cell42(Cell42), .Cell43(Cell43), .O0(O0), .O1(O1), .O2(O2), .O3(O3));

endmodule : Memory

module PlusPlus(input wire I0, input wire I1, input wire I2,
                output wire I0Plus, output wire I1Plus, output wire I2Plus);

    wire O0; wire O1; wire O2; wire O3; wire O4;
    ThreeBitsToDecMod three_to_five(.I0(I0), .I1(I1), .I2(I2), .O0(O0), .O1(O1), .O2(O2), .O3(O3), .O4(O4));
    DecModToThreeBits five_to_three(.I0(I0Plus), .I1(I1Plus), .I2(I2Plus), .O0(O4), .O1(O0), .O2(O1), .O3(O2), .O4(O3));

endmodule : PlusPlus

module MinusMinus(input wire I0, input wire I1, input wire I2,
                  output wire I0Minus, output wire I1Minus, output wire I2Minus);

    wire O0; wire O1; wire O2; wire O3; wire O4;
    ThreeBitsToDecMod three_to_five(.I0(I0), .I1(I1), .I2(I2), .O0(O0), .O1(O1), .O2(O2), .O3(O3), .O4(O4));
    DecModToThreeBits five_to_three(.I0(I0Minus), .I1(I1Minus), .I2(I2Minus), .O0(O1), .O1(O2), .O2(O3), .O3(O4), .O4(O0));

endmodule : MinusMinus

module ThreeBitSubstructor(input wire Cur0, input wire Cur1, input wire Cur2,
                           input wire Sub0, input wire Sub1, input wire Sub2,
                           output wire O0, output wire O1, output wire O2);

    wire IsSub0; wire IsSub1; wire IsSub2; wire IsSub3; wire IsSub4;
    ThreeBitsToDecMod three_to_five(.I0(Sub0), .I1(Sub1), .I2(Sub2), .O0(IsSub0), .O1(IsSub1), .O2(IsSub2), .O3(IsSub3), .O4(IsSub4));

    wire Cur0Minus1; wire Cur1Minus1; wire Cur2Minus1;
    MinusMinus minus_minus0(.I0(Cur0), .I1(Cur1), .I2(Cur2), .I0Minus(Cur0Minus1), .I1Minus(Cur1Minus1), .I2Minus(Cur2Minus1));

    wire Cur0Minus2; wire Cur1Minus2; wire Cur2Minus2;
    MinusMinus minus_minus1(.I0(Cur0Minus1), .I1(Cur1Minus1), .I2(Cur2Minus1), .I0Minus(Cur0Minus2), .I1Minus(Cur1Minus2), .I2Minus(Cur2Minus2));

    wire Cur0Minus3; wire Cur1Minus3; wire Cur2Minus3;
    MinusMinus minus_minus2(.I0(Cur0Minus2), .I1(Cur1Minus2), .I2(Cur2Minus2), .I0Minus(Cur0Minus3), .I1Minus(Cur1Minus3), .I2Minus(Cur2Minus3));

    wire Cur0Minus4; wire Cur1Minus4; wire Cur2Minus4;
    MinusMinus minus_minus3(.I0(Cur0Minus3), .I1(Cur1Minus3), .I2(Cur2Minus3), .I0Minus(Cur0Minus4), .I1Minus(Cur1Minus4), .I2Minus(Cur2Minus4));

    wire Cur0andIsSub0; wire Cur0Minus1andIsSub1; wire Cur0Minus2andIsSub2; wire Cur0Minus3andIsSub3; wire Cur0Minus4andIsSub4;
    and and_Cur0andIsSub0(Cur0andIsSub0, Cur0, IsSub0);
    and and_Cur0Minus1andIsSub1(Cur0Minus1andIsSub1, Cur0Minus1, IsSub1);
    and and_Cur0Minus2andIsSub2(Cur0Minus2andIsSub2, Cur0Minus2, IsSub2);
    and and_Cur0Minus3andIsSub3(Cur0Minus3andIsSub3, Cur0Minus3, IsSub3);
    and and_Cur0Minus4andIsSub4(Cur0Minus4andIsSub4, Cur0Minus4, IsSub4);

    or or_O0_gate(O0, Cur0andIsSub0, Cur0Minus1andIsSub1, Cur0Minus2andIsSub2, Cur0Minus3andIsSub3, Cur0Minus4andIsSub4);

    wire Cur1andIsSub0; wire Cur1Minus1andIsSub1; wire Cur1Minus2andIsSub2; wire Cur1Minus3andIsSub3; wire Cur1Minus4andIsSub4;
    and and_Cur1andIsSub0(Cur1andIsSub0, Cur1, IsSub0);
    and and_Cur1Minus1andIsSub1(Cur1Minus1andIsSub1, Cur1Minus1, IsSub1);
    and and_Cur1Minus2andIsSub2(Cur1Minus2andIsSub2, Cur1Minus2, IsSub2);
    and and_Cur1Minus3andIsSub3(Cur1Minus3andIsSub3, Cur1Minus3, IsSub3);
    and and_Cur1Minus4andIsSub4(Cur1Minus4andIsSub4, Cur1Minus4, IsSub4);

    or or_O1_gate(O1, Cur1andIsSub0, Cur1Minus1andIsSub1, Cur1Minus2andIsSub2, Cur1Minus3andIsSub3, Cur1Minus4andIsSub4);

    wire Cur2andIsSub0; wire Cur2Minus1andIsSub1; wire Cur2Minus2andIsSub2; wire Cur2Minus3andIsSub3; wire Cur2Minus4andIsSub4;
    and and_Cur2andIsSub0(Cur2andIsSub0, Cur2, IsSub0);
    and and_Cur2Minus1andIsSub1(Cur2Minus1andIsSub1, Cur2Minus1, IsSub1);
    and and_Cur2Minus2andIsSub2(Cur2Minus2andIsSub2, Cur2Minus2, IsSub2);
    and and_Cur2Minus3andIsSub3(Cur2Minus3andIsSub3, Cur2Minus3, IsSub3);
    and and_Cur2Minus4andIsSub4(Cur2Minus4andIsSub4, Cur2Minus4, IsSub4);

    or or_O2_gate(O2, Cur2andIsSub0, Cur2Minus1andIsSub1, Cur2Minus2andIsSub2, Cur2Minus3andIsSub3, Cur2Minus4andIsSub4);

endmodule : ThreeBitSubstructor

module ConditionalOperator(input wire I0, input wire I1, input wire I2, input wire BoolFlag,
                           output wire O0, output wire O1, output wire O2);

    and and_O0_gate(O0, I0, BoolFlag);
    and and_O1_gate(O1, I1, BoolFlag);
    and and_O2_gate(O2, I2, BoolFlag);

endmodule : ConditionalOperator

module IOBitParser(input wire IsRead, input wire DataBit,
                   output wire OutputBit);

    wire not_IsRead;
    not not_IsRead_gate(not_IsRead, IsRead);

    cmos cmos_gate(OutputBit, DataBit, IsRead, not_IsRead);

endmodule : IOBitParser

module IOParser(input wire IsRead, input wire DataBit0, input wire DataBit1, input wire DataBit2, input wire DataBit3,
                output wire OutputBit0, output wire OutputBit1, output wire OutputBit2, output wire OutputBit3);

    IOBitParser io_bit_parser0(.IsRead(IsRead), .DataBit(DataBit0), .OutputBit(OutputBit0));
    IOBitParser io_bit_parser1(.IsRead(IsRead), .DataBit(DataBit1), .OutputBit(OutputBit1));
    IOBitParser io_bit_parser2(.IsRead(IsRead), .DataBit(DataBit2), .OutputBit(OutputBit2));
    IOBitParser io_bit_parser3(.IsRead(IsRead), .DataBit(DataBit3), .OutputBit(OutputBit3));

endmodule : IOParser

module StackElementOutHelper(input wire O0, input wire O1, input wire O2, input wire O3,
                             input wire IsCurrent,
                             input wire push, input wire CLK, input wire RESET,
                             output wire dx0, output wire dx1, output wire dx2, output wire dx3);

    wire IsPush;
    and and_IsPush_gate(IsPush, CLK, push);

    wire C;
    or or_C_gate(C, IsPush, IsCurrent);

    FourBitMemoryCell four_bit_memory_cell(.C(C), .Reset(RESET), .D0(O0), .D1(O1), .D2(O2), .D3(O3), .Q0(dx0), .Q1(dx1), .Q2(dx2), .Q3(dx3));

endmodule : StackElementOutHelper

module CommandParser(input wire Command0, input wire Command1,
                     output wire nop, output wire push, output wire pop, output wire get);

    wire not_Command0;
    not not_Command0_gate(not_Command0, Command0);

    wire not_Command1;
    not not_Command1_gate(not_Command1, Command1);

    and nop_and_gate(nop, not_Command0, not_Command1);
    and push_and_gate(push, Command0, not_Command1);
    and pop_and_gate(pop, not_Command0, Command1);
    and get_and_gate(get, Command0, Command1);

endmodule : CommandParser

module TopTransform(input wire Top0, input wire Top1, input wire Top2,
                    input wire Operation0, input wire Operation1,
                    input wire Reset,
                    output wire NewTop0, output wire NewTop1, output wire NewTop2);

    wire not_Reset;
    not not_Reset_gate(not_Reset, Reset);

    wire PlusTop0; wire PlusTop1; wire PlusTop2;
    PlusPlus plus_plus(.I0(Top0), .I1(Top1), .I2(Top2), .I0Plus(PlusTop0), .I1Plus(PlusTop1), .I2Plus(PlusTop2));

    wire MinusTop0; wire MinusTop1; wire MinusTop2;
    MinusMinus minus_minus(.I0(Top0), .I1(Top1), .I2(Top2), .I0Minus(MinusTop0), .I1Minus(MinusTop1), .I2Minus(MinusTop2));

    wire not_Operation0; wire not_Operation1;
    not not_Operation0_gate(not_Operation0, Operation0);
    not not_Operation1_gate(not_Operation1, Operation1);

    wire IsGetOrNop; wire not_IsGetOrNop;
    xor xor_IsGetOrNop_gate(not_IsGetOrNop, Operation0, Operation1);
    not IsGetOrNop_gate(IsGetOrNop, not_IsGetOrNop);

    wire Top0Temp; wire PlusTop0Temp; wire MinusTop0Temp; wire TempTop0;
    and and_Top0Temp_gate(Top0Temp, Top0, IsGetOrNop);
    and and_PlusTop0Temp_gate(PlusTop0Temp, PlusTop0, Operation0, not_Operation1);
    and and_MinusTop0Temp_gate(MinusTop0Temp, MinusTop0, not_Operation0, Operation1);
    or or_TempTop0_gate(TempTop0, Top0Temp, PlusTop0Temp, MinusTop0Temp);

    wire Top1Temp; wire PlusTop1Temp; wire MinusTop1Temp; wire TempTop1;
    and and_Top1Temp_gate(Top1Temp, Top1, IsGetOrNop);
    and and_PlusTop1Temp_gate(PlusTop1Temp, PlusTop1, Operation0, not_Operation1);
    and and_MinusTop1Temp_gate(MinusTop1Temp, MinusTop1, not_Operation0, Operation1);
    or or_TempTop1_gate(TempTop1, Top1Temp, PlusTop1Temp, MinusTop1Temp);

    wire Top2Temp; wire PlusTop2Temp; wire MinusTop2Temp; wire TempTop2;
    and and_Top2Temp_gate(Top2Temp, Top2, IsGetOrNop);
    and and_PlusTop2Temp_gate(PlusTop2Temp, PlusTop2, Operation0, not_Operation1);
    and and_MinusTop2Temp_gate(MinusTop2Temp, MinusTop2, not_Operation0, Operation1);
    or or_TempTop2_gate(TempTop2, Top2Temp, PlusTop2Temp, MinusTop2Temp);

    and and_NewTop0_gate(NewTop0, TempTop0, not_Reset);
    and and_NewTop1_gate(NewTop1, TempTop1, not_Reset);
    and and_NewTop2_gate(NewTop2, TempTop2, not_Reset);

endmodule : TopTransform

module TopUpdate(input wire Operation0, input wire Operation1,
                 input wire Reset, input wire C,
                 output wire NewTop0, output wire NewTop1, output wire NewTop2,
                 output wire OldTop0, output wire OldTop1, output wire OldTop2);

    wire TempNewTop0; wire TempNewTop1; wire TempNewTop2;
    TopTransform top_transform(.Top0(OldTop0), .Top1(OldTop1), .Top2(OldTop2), .Operation0(Operation0), .Operation1(Operation1), .Reset(Reset), .NewTop0(TempNewTop0), .NewTop1(TempNewTop1), .NewTop2(TempNewTop2));

    wire not_C;
    not not_C_gate(not_C, C);

    wire NewC; wire UpdateC;
    or or_NewC_gate(NewC, C, Reset);
    or or_UpdateC_gate(UpdateC, not_C, Reset);

    DTrigger d_trigger_new0(.D(TempNewTop0), .C(NewC), .Q(NewTop0));
    DTrigger d_trigger_new1(.D(TempNewTop1), .C(NewC), .Q(NewTop1));
    DTrigger d_trigger_new2(.D(TempNewTop2), .C(NewC), .Q(NewTop2));

    DTrigger d_trigger_old0(.D(NewTop0), .C(UpdateC), .Q(OldTop0));
    DTrigger d_trigger_old1(.D(NewTop1), .C(UpdateC), .Q(OldTop1));
    DTrigger d_trigger_old2(.D(NewTop2), .C(UpdateC), .Q(OldTop2));

endmodule : TopUpdate

module stack_structural_normal(inout wire[3:0] IO_DATA,
                               input wire RESET,
                               input wire CLK,
                               input wire[1:0] COMMAND,
                               input wire[2:0] INDEX);

    wire COMMAND0; wire COMMAND1;
    assign COMMAND0 = COMMAND[0];
    assign COMMAND1 = COMMAND[1];

    wire INDEX0; wire INDEX1; wire INDEX2;
    assign INDEX0 = INDEX[0];
    assign INDEX1 = INDEX[1];
    assign INDEX2 = INDEX[2];

    wire nop; wire push; wire pop; wire get;
    CommandParser command_parser(.Command0(COMMAND0), .Command1(COMMAND1), .nop(nop), .push(push), .pop(pop), .get(get));

    wire IsRead_temp; wire IsRead;
    or or_IsRead_gate(IsRead_temp, pop, get);
    and and_IsRead_gate(IsRead, IsRead_temp, CLK);

    wire NewTop0; wire NewTop1; wire NewTop2;
    wire OldTop0; wire OldTop1; wire OldTop2;
    TopUpdate top_update(.Operation0(COMMAND0), .Operation1(COMMAND1), .Reset(RESET), .C(CLK), .NewTop0(NewTop0), .NewTop1(NewTop1), .NewTop2(NewTop2), .OldTop0(OldTop0), .OldTop1(OldTop1), .OldTop2(OldTop2));

    wire PushPointer0; wire PushPointer1; wire PushPointer2;
    wire PopPointer0; wire PopPointer1; wire PopPointer2;
    wire GetPointer0; wire GetPointer1; wire GetPointer2;

    ConditionalOperator conditional_operator_push(.I0(OldTop0), .I1(OldTop1), .I2(OldTop2), .BoolFlag(push), .O0(PushPointer0), .O1(PushPointer1), .O2(PushPointer2));
    ConditionalOperator conditional_operator_pop(.I0(NewTop0), .I1(NewTop1), .I2(NewTop2), .BoolFlag(pop), .O0(PopPointer0), .O1(PopPointer1), .O2(PopPointer2));

    wire NewTop0Sub; wire NewTop1Sub; wire NewTop2Sub;
    ThreeBitSubstructor three_bit_substructor(.Cur0(NewTop0), .Cur1(NewTop1), .Cur2(NewTop2), .Sub0(INDEX0), .Sub1(INDEX1), .Sub2(INDEX2), .O0(NewTop0Sub), .O1(NewTop1Sub), .O2(NewTop2Sub));

    wire NewTop0SubMinus1; wire NewTop1SubMinus1; wire NewTop2SubMinus1;
    MinusMinus minus_minus(.I0(NewTop0Sub), .I1(NewTop1Sub), .I2(NewTop2Sub), .I0Minus(NewTop0SubMinus1), .I1Minus(NewTop1SubMinus1), .I2Minus(NewTop2SubMinus1));

    ConditionalOperator conditional_operator_get(.I0(NewTop0SubMinus1), .I1(NewTop1SubMinus1), .I2(NewTop2SubMinus1), .BoolFlag(get), .O0(GetPointer0), .O1(GetPointer1), .O2(GetPointer2));

    wire MemCell0; wire MemCell1; wire MemCell2;

    or or_MemCell0_gate(MemCell0, PushPointer0, PopPointer0, GetPointer0);
    or or_MemCell1_gate(MemCell1, PushPointer1, PopPointer1, GetPointer1);
    or or_MemCell2_gate(MemCell2, PushPointer2, PopPointer2, GetPointer2);

    wire O0; wire O1; wire O2; wire O3;
    wire InputBit0; wire InputBit1; wire InputBit2; wire InputBit3;
    assign InputBit0 = IO_DATA[0];
    assign InputBit1 = IO_DATA[1];
    assign InputBit2 = IO_DATA[2];
    assign InputBit3 = IO_DATA[3];

    Memory memory(.I0(MemCell0), .I1(MemCell1), .I2(MemCell2), .IsWrite(push), .C(CLK), .D0(InputBit0), .D1(InputBit1), .D2(InputBit2), .D3(InputBit3), .Reset(RESET), .O0(O0), .O1(O1), .O2(O2), .O3(O3));

    IOParser io_parser(.IsRead(IsRead), .DataBit0(O0), .DataBit1(O1), .DataBit2(O2), .DataBit3(O3), .OutputBit0(IO_DATA[0]), .OutputBit1(IO_DATA[1]), .OutputBit2(IO_DATA[2]), .OutputBit3(IO_DATA[3]));

endmodule : stack_structural_normal
