`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Mahesh Kumar Sahoo
// 
// Create Date: 17.02.2026 19:49:58
// Design Name: 
// Module Name: Receiver
// Project Name: UART 
// Additional Comments:
// This is the receiver module which receives the data from Tx serialy and convert it to parallel output.
// this has a over sampling factor of 16 to ensure the received data is correct.
//////////////////////////////////////////////////////////////////////////////////


module Receiver(
                input clk,rst,rx,rdy_clr,rx_enb,
                output reg rdy,
                output reg [7:0] data_out
    );
    
    parameter idle_state = 2'b00,start_state = 2'b01, data_state = 2'b10, stop_state = 2'b11;
    
    reg [1:0] state = start_state;
    reg [3:0] sample = 0;
    reg [3:0] index = 0;
    reg [7:0] temp_register = 8'b0;
    
    always @(posedge clk) begin
        if(rst) begin
            rdy <= 0;
            data_out <= 0;
            state <= idle_state;
            sample <= 0;
            index <= 0;
            temp_register <= 0;
        end
        else begin
            if (rx_enb) begin // 
                case (state)
                
                    idle_state : begin
                        if(rx == 1'b0)begin
                            state <= start_state;
                            sample <= 0;
                        end    
                    end
                    
                    start_state : begin
                        if(sample == 7 && rx != 1'b0)begin // handles glitch due to noise or any external factor
                            sample <= 0;
                            state <= idle_state;
                        end
                        else if (sample ==15) begin // goes to next state
                            state <= data_state;
                            sample <= 0;
                            index <= 0;
                           // temp_register <= 0;
                        end
                        else begin
                            sample <= sample + 1'b1;
                        end
                    end        
                    
                    data_state : begin
                        if (sample == 7) begin
                            temp_register[index] <= rx;
                            sample <= sample + 1'b1;
                        end
                        else if(sample ==15) begin
                             sample <= 0;
                             if(index == 7) state <= stop_state;
                             else index <= index + 1'b1; 
                        end     
                        else begin
                            sample <= sample + 1'b1;
                        end   
                    end   
                    
                    stop_state : begin
                        if(sample == 15) begin
                            state <= idle_state;
                            data_out <= temp_register;
                            rdy <= 1'b1;
                            sample <= 0;
                        end
                        else begin
                            sample <= sample + 1'b1;
                        end   
                    end
                    
                    default : state <= idle_state;
                 endcase  
             end
             if (rx_enb && state == stop_state && sample == 15) begin
                 rdy <= 1'b1; // for CPU to avoid double read of same data
             end
             else if (rdy_clr) begin
                 rdy <= 1'b0;
             end
          end       
    end

endmodule