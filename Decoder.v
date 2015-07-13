`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuechuan Xue
// 
// Create Date: 2015/07/10 15:22:30
// Design Name: 
// Module Name: Decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Decoder(Instr, OPTION, SLEEP, CLRWDT, TRIS1, TRIS2, MOVWF, CLR, SUBWF, 
                  RLF, SWAPF, BTFSS, RETLW, CALL, GOTO, bit_mask, Bit_Op, 
                  K8A_sel, K8W_sel, Op_Mux_L, Op_Mux_A, ALU_out_Mux, FSZ, 
                  Z_en, DC_en, C_en, STT_en, Stack_1_wr, W_wr, f_wr, f_rd);
//
    input [11:0] Instr;
    output OPTION;
    output SLEEP;
    output CLRWDT;
    output TRIS1;
    output TRIS2;
    output MOVWF;
    output CLR;
    output SUBWF;
    output RLF;
    output SWAPF;
    output BTFSS;
    output RETLW;
    output CALL;
    output GOTO;
    output [7:0] bit_mask;
    output Bit_Op;
    output K8A_sel;
    output K8W_sel;
    output [1:0] Op_Mux_L;
    output [1:0] Op_Mux_A;
    output [1:0] ALU_out_Mux;
    output FSZ;
    output Z_en;
    output DC_en;
    output C_en;
    output STT_en;
    output Stack_1_wr;
    output W_wr;
    output f_wr;
    output f_rd;

	wire Iw_b00		= (Instr[11:10] == 2'b00);
	wire Iw_b01		= (Instr[11:10] == 2'b01);
	wire Iw_b10		= (Instr[11:10] == 2'b10);
	wire Iw_b11		= (Instr[11:10] == 2'b11);
	wire Iw_bxx0000	= (Instr[9:6] == 4'b0000);

	wire OPTION 	= Iw_b00 && Iw_bxx0000 && (Instr[5:0] == 6'b000010); // 0000 0000 0010		无		装载 OPTION 寄存器
	wire SLEEP		= Iw_b00 && Iw_bxx0000 && (Instr[5:0] == 6'b000011); // 0000 0000 0011	~TO 和 ~PD	进入待机模式
	wire CLRWDT		= Iw_b00 && Iw_bxx0000 && (Instr[5:0] == 6'b000100); // 0000 0000 0100	~TO 和 ~PD	清零看门狗定时器
	wire TRIS1		= Iw_b00 && Iw_bxx0000 && (Instr[5:0] == 6'b000101); //	0000 0000 0fff		无		W 寄存器的内容分别被写入 PORTA
	wire TRIS2		= Iw_b00 && Iw_bxx0000 && (Instr[5:0] == 6'b000110); // 0000 0000 0fff		无		W 寄存器的内容分别被写入 PORTB

	wire MOVWF		= Iw_b00 && Iw_bxx0000 && (Instr[5] == 1'b1);		 // 0000 001f ffff		无		将 f 的内容传送到目标寄存器

	wire CLR		= Iw_b00 && (Instr[9:6] == 4'b0001);	// 00 0001 1f ffff	将 f 清零
															// 00 0001 00 0000	将 W 寄存器清零
	wire SUBWF		= Iw_b00 && (Instr[9:6] == 4'b0010);	// 00 0010 df ffff	f 减去 W
	wire DECF		= Iw_b00 && (Instr[9:6] == 4'b0011);	// 00 0011 df ffff	f 减 1
	wire IORWF		= Iw_b00 && (Instr[9:6] == 4'b0100);	// 00 0100 df ffff	W 和 f 作逻辑或运算
	wire ANDWF		= Iw_b00 && (Instr[9:6] == 4'b0101);	// 00 0101 df ffff	W 和 f 作逻辑与运算
	wire XORWF		= Iw_b00 && (Instr[9:6] == 4'b0110);	// 00 0110 df ffff	W 和 f 作逻辑异或运算
	wire ADDWF		= Iw_b00 && (Instr[9:6] == 4'b0111);	// 00 0111 df ffff	W 和 f 相加
	wire MOVF		= Iw_b00 && (Instr[9:6] == 4'b1000);	// 00 1000 df ffff	将 f 的内容传送到目标寄存器
	wire COMF		= Iw_b00 && (Instr[9:6] == 4'b1001);	// 00 1001 df ffff	f 取反
	wire INCF		= Iw_b00 && (Instr[9:6] == 4'b1010);	// 00 1010 df ffff	f 增 1
	wire DECFSZ		= Iw_b00 && (Instr[9:6] == 4'b1011);	// 00 1011 df ffff	f 减 1,为 0 则跳过
	wire RRF		= Iw_b00 && (Instr[9:6] == 4'b1100);	// 00 1100 df ffff	对 f 执行带进位的循环右移
	wire RLF		= Iw_b00 && (Instr[9:6] == 4'b1101);	// 00 1101 df ffff	对 f 执行带进位的循环左移
	wire SWAPF		= Iw_b00 && (Instr[9:6] == 4'b1110);	// 00 1110 df ffff	将 f 中的两个半字节进行交换
	wire INCFSZ		= Iw_b00 && (Instr[9:6] == 4'b1111);	// 00 1111 df ffff	f 增 1,为 0 则跳过

	// 传入的指令会使相应的 wire 变量为 1，否则为 0
	wire Bit_Op 	= Iw_b01;							// 01-- bbbf ffff   无	对 f 中某位操作，具体包含下面四种情况
	wire BCF		= Iw_b01 && (Instr[9:8] == 2'b00);	// 0100 bbbf ffff	无	将 f 中的某位清零
	wire BSF		= Iw_b01 && (Instr[9:8] == 2'b01);	// 0101 bbbf ffff	无	将 f 中的某位置 1
	wire BTFSC		= Iw_b01 && (Instr[9:8] == 2'b10);	// 0110 bbbf ffff	无	检测 f 中的某位,为 0 则跳过
	wire BTFSS		= Iw_b01 && (Instr[9:8] == 2'b11);	// 0111 bbbf ffff	无	检测 f 中的某位,为 1 则跳过

	wire RETLW		= Iw_b10 && (Instr[9:8] == 2'b00);	// 1000 kkkk kkkk	无	返回并将立即数传送到 W
	wire CALL		= Iw_b10 && (Instr[9:8] == 2'b00);	// 1001 kkkk kkkk	无	调用子程序
	wire GOTO		= Iw_b10 && (Instr[9] == 1'b1);		// 101k kkkk kkkk	无	无条件跳转

	wire MOVLW		= Iw_b11 && (Instr[9:8] == 2'b00);	// 1100 kkkk kkkk	无	将立即数传送到 W
	wire IORLW		= Iw_b11 && (Instr[9:8] == 2'b01);	// 1101 kkkk kkkk	Z	立即数与 W 作逻辑或运算
	wire ANDLW		= Iw_b11 && (Instr[9:8] == 2'b10);	// 1110 kkkk kkkk	Z	立即数和 W 相与
	wire XORLW		= Iw_b11 && (Instr[9:8] == 2'b11);	// 1111 kkkk kkkk	Z	立即数与 W 作逻辑异或运算

	wire K8W_sel	= MOVLW || RETLW;					// 立即数传送到 W
	wire K8A_sel	= IORLW || ANDLW || XORLW;			// 与 W 作逻辑运算
	wire K8_Op		= K8W_sel || K8A_sel;				// 操作 W 寄存器

	reg  [1:0]	Op_Mux_L, Op_Mux_A, ALU_out_Mux;

	always @(IORWF, IORLW, BSF, BCF, BTFSC, BTFSS, ANDWF, ANDLW, XORWF, XORLW, COMF) begin
		case ({IORWF, IORLW, BSF, BCF, BTFSC, BTFSS, ANDWF, ANDLW, XORWF, XORLW, COMF})
			
			// Op_Mux_L = 11 取反
			11'b00000000001: Op_Mux_L = 2'b11; // COMF		f 取反
			
			// Op_Mux_L = 10 异或
			11'b00000000010: Op_Mux_L = 2'b10; // XORLW		立即数与 W 作逻辑异或运算
			11'b00000000100: Op_Mux_L = 2'b10; // XORWF		W 和 f 作逻辑异或运算

			// Op_Mux_L = 01 与
			11'b00000001000: Op_Mux_L = 2'b01; // ANDLW		立即数和 W 相与
			11'b00000010000: Op_Mux_L = 2'b01; // ANDWF		W 和 f 作逻辑与运算
			11'b00000100000: Op_Mux_L = 2'b01; // BTFSS		检测 f 中的某位,为 1 则跳过
			11'b00001000000: Op_Mux_L = 2'b01; // BTFSC		检测 f 中的某位,为 0 则跳过
			11'b00010000000: Op_Mux_L = 2'b01; // BCF		将 f 中的某位置 0（将 f 中的某位置与 0）

			// Op_Mux_L = 00 或
			11'b00100000000: Op_Mux_L = 2'b00; // BSF		将 f 中的某位置 1（将 f 中的某位置或 1）
			11'b01000000000: Op_Mux_L = 2'b00; // IORLW		立即数与 W 作逻辑或运算
			11'b10000000000: Op_Mux_L = 2'b00; // IORWF		W 和 f 作逻辑或运算

			default:		 Op_Mux_L = 2'b00; // 然而并没有什么卵用
		endcase
	end

	always @(ADDWF, SUBWF, INCF, INCFSZ, DECF, DECFSZ) begin
		case ({ADDWF, SUBWF, INCF, INCFSZ, DECF, DECFSZ})

			// Op_Mux_A = 11 减1
			6'b000001: Op_Mux_A = 2'b11;		// DECFSZ	f 减 1,为 0 则跳过
			6'b000010: Op_Mux_A = 2'b11;		// DECF		f 减 1

			// Op_Mux_A = 10 加1
			6'b000100: Op_Mux_A = 2'b10;		// INCFSZ	f 增 1,为 0 则跳过
			6'b001000: Op_Mux_A = 2'b10;		// INCF		f 增 1

			// Op_Mux_A = 01 减W
			6'b010000: Op_Mux_A = 2'b01;		// SUBWF	f 减去 W

			// Op_Mux_A = 00 加W
			6'b100000: Op_Mux_A = 2'b00;		// ADDWF	f 加上 W

			default:   Op_Mux_A = 2'b00;		// 然而并没有什么卵用
		endcase
	end

	wire Group0		= MOVF	|| SWAPF || CLR;
	wire Group1		= RRF	|| RLF;	
	wire Group2a	= (IORWF || IORLW) || (ANDWF || ANDLW) || (XORWF || XORLW);	//
	wire Group2b	= COMF || BCF || BSF || BTFSC || BTFSS;
	wire Group2		= Group2a || Group2b;
	wire Group3		= ADDWF || SUBWF || (INCF || INCFSZ) || (DECF || DECFSZ);

	// ALU_out_Mux	|	ALU_out 	C_new	Mux		Group		Instruct
	// ---------------------------------------------------------------------------------------------------------
    //			00	|	T_out		C_out	Throu	Group0		MOVF,  SWAPF, CLR
    //			01	|	S_out		C_out	Shift	Group1		RRF,   RLF
    //			10	|	Func		C_wire	Logic	Group2		IORWF, IORLW, ANDWF, ANDLW, XORWF, XORLW, COMF ...
    //			11	|	Sum			C_wire	Adder	Group3		ADDWF, SUBWF, INCF,  INCFSZ ...

    // if (ALU_out = 8'b00000000)	Z_new = 1;
    // else							Z_new = 0;

	always @(Group0, Group1, Group2, Group3) begin
		case({Group0, Group1, Group2, Group3})
			4'b0001:	ALU_out_Mux = 2'b11;	// Group3
			4'b0010:	ALU_out_Mux = 2'b10;	// Group2
			4'b0100:	ALU_out_Mux = 2'b01;	// Group1
			4'b1000:	ALU_out_Mux = 2'b00;	// Group0
		endcase
	end


	// 对如 01xx bbbf ffff 中 bbb 位操作的掩码
	reg [7:0] bit_loc;

	always @(Instr[7:5]) begin
		case(Instr[7:5])
			3'b000: bit_loc = 8'b00000001;
			3'b001: bit_loc = 8'b00000010;
			3'b010: bit_loc = 8'b00000100;
			3'b011: bit_loc = 8'b00001000;
			3'b100: bit_loc = 8'b00010000;
			3'b101: bit_loc = 8'b00100000;
			3'b110: bit_loc = 8'b01000000;
			3'b111: bit_loc = 8'b10000000;
		endcase
	end

	wire [7:0] bit_mask = BCF ? ~bit_loc : bit_loc;


	//
	wire f_rd = Bit_Op || (Iw_b00 && Instr[9:7] != 3'b000);
	wire f_wr = (BCF || BSF) || (Iw_b00 && (Instr[5] == 1'b1));

	wire W_wr = K8_Op || (Iw_b00 && !Iw_bxx0000 && (Instr[5] == 1'b0));
	wire Stack_l_wr = CALL || RETLW;

	//
	wire FSZ	= DECFSZ || INCFSZ || BTFSC;
	wire DC_en	= ADDWF || SUBWF;
	wire C_en	= DC_en || Group1;
	wire Z_en	= DC_en || Group2a || CLR || DECF || MOVF || COMF || INCF;
	wire STT_en	= Z_en	|| DC_en   || C_en; 

endmodule
