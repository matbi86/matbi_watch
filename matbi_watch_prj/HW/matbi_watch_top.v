//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: Matbi / Austin
//
// Create Date: 2023.9.24
// License : https://github.com/matbi86/matbi_fpga_season_1/blob/master/LICENSE
// Design Name: 
// Module Name: matbi_watch_top
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Top module matbi_watch_top
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module matbi_watch_top(
    clk,
    reset,
	i_run_en,
	i_freq,
    o_sec,
    o_min,
    o_hour
    );
parameter P_COUNT_BIT = 30; // (default) 30b, under 1GHz. 2^30 = 1073741824
parameter P_SEC_BIT	 = 6; // 2^6 = 64
parameter P_MIN_BIT	 = 6; // 2^6 = 64 
parameter P_HOUR_BIT = 5; // 2^5 = 32 

input 							clk;
input 							reset;
input 							i_run_en;
input		[P_COUNT_BIT-1:0]	i_freq;
output reg 	[P_SEC_BIT-1:0]		o_sec;
output reg 	[P_MIN_BIT-1:0]		o_min;
output reg 	[P_HOUR_BIT-1:0]	o_hour;

wire w_one_sec_tick;

// Gen one sec
matbi_one_sec_gen 
# (
	.P_COUNT_BIT	(P_COUNT_BIT) 
) u_matbi_one_sec_gen(
	.clk 				(clk			),
	.reset 				(reset			),
	.i_run_en			(i_run_en		),
	.i_freq				(i_freq			),
	.o_one_sec_tick 	(w_one_sec_tick	)
);

reg [6-1:0] r_min_cnt;
reg [12-1:0] r_hour_cnt;
wire sec_tick = o_sec == 60-1;
wire min_tick = o_min == 60-1;
wire hour_tick = o_hour == 24-1;
	always @(posedge clk) begin
	    if(reset) begin
			o_sec		<= 0;
		end else if(w_one_sec_tick) begin
			if(sec_tick) begin
				o_sec		<= 0;
			end else begin
				o_sec	<= o_sec + 1'b1;
			end
		end
	end

	always @(posedge clk) begin
	    if(reset) begin
			r_min_cnt 	<= 0;
			o_min		<= 0;
		end else if(w_one_sec_tick) begin
			if(sec_tick & min_tick) begin
				o_min		<= 0;
				r_min_cnt 	<= 0;
			end else if (r_min_cnt == 60-1)  begin
				o_min	<= o_min + 1'b1;
				r_min_cnt 	<= 0;
			end else begin
				r_min_cnt <= r_min_cnt + 1'b1;
			end
		end
	end

	always @(posedge clk) begin
	    if(reset) begin
			r_hour_cnt 	<= 0;
			o_hour		<= 0;
		end else if(w_one_sec_tick) begin
			if(sec_tick & min_tick & hour_tick) begin
				o_hour		<= 0;
				r_hour_cnt 	<= 0;
			end else if (r_hour_cnt == 60*60-1)  begin
				o_hour	<= o_hour + 1'b1;
				r_hour_cnt 	<= 0;
			end else begin
				r_hour_cnt <= r_hour_cnt + 1'b1;
			end
		end
	end
endmodule


