module address_translator (
    input  wire SDA,input  wire SCL,input  wire rst,
    output reg  SDA1,output reg  SDA2
);

  reg [2:0] state;
  reg [3:0] cnt;
  reg [7:0] address_reg,out_reg;
  reg target; 

  localparam IDLE=3'b000;
  localparam ADDR_CAP=3'b001;
  localparam TRANSLATE=3'b010;
  localparam DATA_PASS=3'b011;
  localparam STOP =3'b100;
  localparam VIRTUAL_ADDR1=7'h21;
  localparam VIRTUAL_ADDR2=7'h22;
  localparam PHYS_ADDR=7'h48;

  always @(posedge SCL or posedge rst) begin
    
    if (rst) begin
      state <= IDLE;
      SDA1 <= 1'b1;
      SDA2 <= 1'b1;
      address_reg <= 8'h00;
      out_reg <= 8'h00;
      
      cnt <= 4'd0;
      target <= 1'b0;
      
    end else begin
      
      // this is the start of FSM for the address_translator 
      
      
      case (state)
        IDLE: begin
          SDA1 <=1'b1;
          SDA2 <=1'b1;
          cnt <=0;
          target <=0;
          if (SDA==0)
            state<=ADDR_CAP;
        end

        ADDR_CAP: begin
          address_reg<={address_reg[6:0], SDA};
          cnt<=cnt + 1;
          
          if (cnt==7) begin
            if (address_reg[7:1]==VIRTUAL_ADDR1) begin
              out_reg<={PHYS_ADDR, address_reg[0]};
              target<=0;
              state<=TRANSLATE;
              
            end else if (address_reg[7:1]==VIRTUAL_ADDR2) begin
              out_reg <= {PHYS_ADDR, address_reg[0]};
              target<= 1; 
              state<=TRANSLATE;
              
            end else begin
              
              state<=STOP; 
            end
            cnt<= 0;
          end
        end

        TRANSLATE: begin
          if (target== 0) begin
            SDA1<=out_reg[7];
            SDA2<= 1'b1;
          end else if (target== 1) begin
            SDA2 <=out_reg[7];
            SDA1<=1'b1;
          end
          out_reg <= {out_reg[6:0], 1'b0};
          
          cnt <= cnt + 1;
          
          
          if (cnt==7) begin
            cnt<=0;
            state <=DATA_PASS;
          end
        end

        DATA_PASS: begin
          if (target==0) begin
            SDA1<=SDA;
            SDA2<=1'b1;
          end else if (target== 1) begin
            SDA2 <= SDA;
            SDA1 <= 1'b1;
          end
        end

        STOP: begin
          SDA1 <= 1'b1;
          SDA2 <= 1'b1;
          state <= IDLE;
        end
        
      endcase
    end
  end

endmodule


