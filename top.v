`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Mahesh Kumar Sahoo
// 
// Create Date: 18.02.2026 22:30:00
// Design Name: 
// Module Name: top
// Project Name: UART
// Additional Comments:
// This is the top module of UART , this defines the interconnection between different modules.
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk,rst,rdy_clear,tx_start,
    input [7:0] data_in,
    output busy,rdy,
    output [7:0] data_out
    );
    wire tx_enb,rx_enb;
    wire tx_rx;
    
    baud_rate_generator bd (clk,rst,tx_enb,rx_enb);
    Transmitter tx (clk,tx_enb,rst,tx_start,data_in,busy,tx_rx);
    Receiver rx (clk,rst,tx_rx,rdy_clear,rx_enb,rdy,data_out);
    
endmodule
