module video_sync_generator(reset,
                            vga_clk,
                            blank_n,
                            HS,
                            VS);
                            
input reset;
input vga_clk;
output reg blank_n;
output reg HS;
output reg VS;
///////////////////
/*
--VGA Timing
--Horizontal :
--                ______________                 _____________
--               |              |               |
--_______________|  VIDEO       |_______________|  VIDEO (next line)

--___________   _____________________   ______________________
--           |_|                     |_|
--            A <-B-><----C----><-D->
--           <------------T--------->
--The Unit used below are pixels;  
--  A->Sync_cycle                   :Hs_a==vh_a
--  B->Back_porch                   :Hs_b==vh_b
--  C->Visable Area
--  D->Front porch                  :Hs_d==vh_d
--  T->horizontal line total length :Hs_t==  vh_total
--Vertical :
--               ______________                 _____________
--              |              |               |          
--______________|  VIDEO       |_______________|  VIDEO (next frame)
--
--__________   _____________________   ______________________
--          |_|                     |_|
--           A <-B-><----C----><-D->
--          <-----------T---------->
--The Unit used below are horizontal lines;  
--  A->Sync_cycle                   :Vs_a
--  B->Back_porch                   :Vs_b
--  C->Visable Area
--  D->Front porch                  :Vs_d
--  T->vertical line total length :Vs_t
*////////////////////////////////////////////
////////////////////////                          
//-----------------------------------------------------------       

`define VGA_640_480
//`define VGA_800_600
    wire clk;
//parameter
`ifdef VGA_640_480                              
  assign clk = vga_clk;
    
  parameter Hs_t = 800;                           
  parameter Hs_b = 144;
  parameter Hs_d = 16;

  parameter Vs_t = 525;
  parameter Vs_b = 34;
  parameter Vs_d = 11;

  parameter Hs_a = 96;
  parameter Vs_a = 2;
`endif

`ifdef VGA_800_600                              
  // assign clk = vga_clk2;   //可以加一个输入clk2，切换两种VGA格式  
    
  parameter Hs_t  = 800;                           
  parameter Hs_b  = 144;
  parameter Hs_d = 16;

  parameter Vs_t  = 525;
  parameter Vs_b  = 34;
  parameter Vs_d = 11;

  parameter Hs_a = 96;
  parameter Vs_a = 2;
`endif


//////////////////////////
reg [10:0] h_cnt;
reg [9:0]  v_cnt;
wire cHD,cVD,cDEN,hori_valid,vert_valid;
///////
always@(negedge vga_clk,posedge reset)
begin
  if (reset)
  begin
     h_cnt<=11'd0;
     v_cnt<=10'd0;
  end
    else
    begin
      if (h_cnt==Hs_t-1)
      begin 
         h_cnt<=11'd0;
         if (v_cnt==Vs_t-1)
            v_cnt<=10'd0;
         else
            v_cnt<=v_cnt+1;
      end
      else
         h_cnt<=h_cnt+1;
    end
end
/////
assign cHD = (h_cnt<Hs_a)?1'b0:1'b1;    
assign cVD = (v_cnt<Vs_a)?1'b0:1'b1;


`define Disp_160_120
//`define Disp_800_600

//parameter
`ifdef Disp_160_120                              
  parameter Disp_Ha = 0;                           
  parameter Disp_Hb = 640;//800-160
  parameter Disp_Va = 0;                           
  parameter Disp_Vb = 680; //800-120
`endif
//parameter
`ifdef Disp_800_600                             
    
  parameter Disp_Ha = 0;                           
  parameter Disp_Hb = 0;
  parameter Disp_Va = 0;                           
  parameter Disp_Vb = 0;
  
`endif

assign hori_valid = (h_cnt<(Hs_t-Hs_d -Disp_Hb)&& h_cnt>=Hs_b + Disp_Ha)?1'b1:1'b0;
assign vert_valid = (v_cnt<(Vs_t-Vs_d -Disp_Vb)&& v_cnt>=Vs_b + Disp_Va)?1'b1:1'b0;

assign cDEN = hori_valid && vert_valid;

always@(negedge vga_clk)
begin
  HS<=cHD;   
  VS<=cVD;
  blank_n<=cDEN;  //有效区域的电平flag
end

endmodule


