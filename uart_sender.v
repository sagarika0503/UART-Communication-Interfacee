`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: SAGARIKA MERUGU
// 
// Create Date: 04/10/2025 10:02:32 AM
// Design Name: UART TRANSMITTER LOGIC FOR SENDING THE DATA
// Module Name: UART_SENDER
// Project Name: UART PROTOCOL 
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


module uart_sender(input clk,wr_en,enb,rst,input [7:0] data_in,output reg tx,output tx_busy);

always @(posedge clk)
    begin
        if(rst)
            tx = 1'b1;
            
    end
    
    parameter STATE_IDLE	= 2'b00;
parameter STATE_START	= 2'b01;
parameter STATE_DATA	= 2'b10;
parameter STATE_STOP	= 2'b11;

reg [7:0] data = 8'h00;
reg [2:0] bitpos = 3'h0;
reg [1:0] state = STATE_IDLE;

always@(posedge clk)
    begin
        case (state)
	STATE_IDLE: begin
		if (wr_en) begin
			state <= STATE_START;
			data <= data_in;
			bitpos <= 3'h0;
		end
	end
	STATE_START: begin
		if (enb) begin
			tx <= 1'b0;
			state <= STATE_DATA;
		end
	end
	STATE_DATA: begin
		if (enb) begin
			if (bitpos == 3'h7)
				state <= STATE_STOP;
			else
				bitpos <= bitpos + 3'h1;
			tx <= data[bitpos];
		end
	end
	STATE_STOP: begin
		if (enb) begin
			tx <= 1'b1;
			state <= STATE_IDLE;
		end
	end
	default: begin
		tx <= 1'b1;
		state <= STATE_IDLE;
	end
	endcase
end

assign tx_busy = (state != STATE_IDLE);

endmodule