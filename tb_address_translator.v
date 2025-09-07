
// this is the testbencg for the address_translator
`timescale 1ns/1ps

module tb_address_translator;

  reg SCL, SDA, rst;
  wire SDA1, SDA2;

  address_translator dut (
    .SDA(SDA),
    .SCL(SCL),
    .rst(rst),
    .SDA1(SDA1),
    .SDA2(SDA2)
  );

  always #50 SCL = ~SCL;

  task send_byte(input [7:0] data);
    integer j;
    begin
      for (j = 7; j >= 0; j = j - 1) begin
        SDA = data[j];
        @(posedge SCL);
      end
    end
  endtask

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_address_translator);

    SCL = 1;
    SDA = 1;
    rst = 1;
    #100;
    rst = 0;

    #100;
    SDA = 0;
    #100;
    send_byte({7'h21, 1'b0});
    SDA = 1;
    #2000;
    rst = 1;
    #100;
    rst = 0;
    
    #100
    SDA = 0;
    #100;
    send_byte({7'h22, 1'b0});
    SDA = 1;

    #5000;
    $finish;
  end

endmodule
