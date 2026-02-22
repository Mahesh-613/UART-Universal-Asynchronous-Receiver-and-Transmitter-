`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Mahesh Kumar Sahoo
// 
// Create Date: 16.02.2026 21:14:06
// Module Name: baud_rate_generator
// Project Name: UART
//
// Additional Comments:
// It acts as a synchornizer for both master and slave modules in UART protocol.
// The following baudrate generator ensures both master and slave modules were compatible to operate at 9600 bits/sec.
//////////////////////////////////////////////////////////////////////////////////


module baud_rate_generator(
    input clk,rst,
    output tx_enb, rx_enb
    );
    
    reg [12:0] tx_counter;
    reg [10:0] rx_counter;
    
    always @ (posedge clk)
        begin
            if (rst) begin
                    tx_counter <= 0; // Initialize to 0 on reset
            end
            else begin
                if(tx_counter == 5208)
                   tx_counter <= 0;
                else
                   tx_counter <= tx_counter + 1'b1;
            end       
        end
    always @ (posedge clk)
        begin
            if (rst) begin
                    rx_counter <= 0; // Initialize to 0 on reset
            end
            else begin
                if(rx_counter == 325)
                   rx_counter <= 0;
                else
                   rx_counter <= rx_counter + 1'b1;
             end      
        end
    assign tx_enb = (tx_counter == 0) ? 1'b1 : 1'b0;
    assign rx_enb = (rx_counter == 0) ? 1'b1 : 1'b0;
    
endmodule