`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: MAHESH KUMAR SAHOO
// 
// Create Date: 18.02.2026 22:47:02
// Design Name: 
// Module Name: UART_tb
// Project Name: UART
// Test bench for UART module
//////////////////////////////////////////////////////////////////////////////////


module UART_tb();

    reg clk,rst,tx_start;
    reg [7:0] data_in;
    reg rdy_clr;
    
    wire busy,rdy;
    wire [7:0] data_out;
    
    top dut(clk,rst,rdy_clr,tx_start,data_in,busy,rdy,data_out);
    
//    initial begin
//        {clk,rst,data_in,rdy_clr} = 0;
//    end
    
//    #100 rst = 1'b1;
//    #100 rst = 1'b0;
    
    always #5 clk = ~clk; // 1Ghz clock signal
    
    task send_data(input [7:0] din);
        begin
            @(negedge clk);
            data_in = din;
            tx_start = 1'b1;
            
        end
    endtask
    
    task clr_rdy;
        begin 
            @(negedge clk);
            rdy_clr = 1'b1;
            @(negedge clk);
            rdy_clr = 1'b0;
         end   
    endtask
    
    initial begin
       clk = 0;
            rst = 0;
            data_in = 0;
            rdy_clr = 0;
             tx_start = 1'b0;
    
            // 2. APPLY RESET PULSE (Critical for removing Red 'X' signals)
            #100 rst = 1;
            #100 rst = 0; // Release reset
            
            // Wait for a bit after reset
            #1000;
    
            // --- Send First Byte ---
            $display("Sending 0x13...");
            send_data(8'h13);
    
            // 3. Wait for Transmission to Actually Start
            // Because your baud rate is slow, 'busy' won't go high immediately.
            // We wait for the 'busy' signal to go HIGH first.
            wait(busy); 
            
            // 4. Wait for Transmission to Finish
            // Now we can wait for 'busy' to go LOW.
            wait(!busy);
            
            // 5. Check Ready signal
            wait(rdy);
            $display("Received Data is %h", data_out);
            tx_start = 1'b0;
            clr_rdy;
            
            // --- Send Second Byte ---
            #20000; // Give some delay between bytes
            $display("Sending 0x50...");
            send_data(8'h50);
            
            
            wait(busy);  // Wait for start
            wait(!busy); // Wait for finish
            wait(rdy);   // Wait for receiver ready
            $display("Received Data is %h", data_out);
            tx_start = 1'b0;
            clr_rdy;
            
            #20000; // Give some delay between bytes
            $display("Sending 0x00...");
            send_data(8'h00);
            
            
            wait(busy);  // Wait for start
            wait(!busy); // Wait for finish
            wait(rdy);   // Wait for receiver ready
            $display("Received Data is %h", data_out);
            tx_start = 1'b0;
            clr_rdy;
            
            // 6. Increase Simulation Time
            // A full UART byte at 9600 baud takes ~1ms (1,000,000 ns).
            // We need a large delay to see the result.
           #600000 $finish;
        
    end

endmodule
