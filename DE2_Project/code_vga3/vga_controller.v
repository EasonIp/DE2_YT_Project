module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data);
input iRST_n;
input iVGA_CLK;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;
output [7:0] r_data;
///////// ////
reg [14:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
////
`define VGA_640_480
//`define VGA_800_600
    // wire clk;
//parameter
`ifdef VGA_640_480                              
  // assign clk = vga_clk;
    
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



////
assign rst = ~iRST_n;
// video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
//                               .reset(rst),
//                               .blank_n(cBLANK_n),
//                               .HS(cHS),
//                               .VS(cVS));
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=15'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=15'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
assign VGA_CLK_n = ~iVGA_CLK;  
	img_pic inst_img_pic (.address(ADDR), .clock(iVGA_CLK), .q(bgr_data_raw));

// img_pic inst_img_pic (.address(ADDR), .clock(iVGA_CLK), .q(bgr_data_raw));
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0];
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  // oBLANK_n<=cBLANK_n;
end

////
/*////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;    

// rom: 8bit 307200words   M9K   img_data_logo.mif
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
//////Color table output
// rom: 24bit 256words   M9K   index_logo.mif
img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	
//////





//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0];
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end*/





/*******function 2 ********/
//YT   color block
//-----------------------------------------------------------       
//video_sync_generator 
reg [11:0] h_cnt;
reg [11:0]  v_cnt;
wire cHD,cVD,cDEN,hori_valid,vert_valid;
///////
always@(negedge iVGA_CLK,posedge iRST_n)
begin
  if (iRST_n)
  begin
     h_cnt<=12'd0;
     v_cnt<=12'd0;
  end
    else
    begin
      if (h_cnt==Hs_t-1)
      begin 
         h_cnt<=12'd0;
         if (v_cnt==Vs_t-1)
            v_cnt<=12'd0;
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
//video_sync_generator 


// // `define Disp_160_120
// `define Disp_800_600

// //parameter
// `ifdef Disp_160_120                              
//   parameter Disp_Ha = 0;                           
//   parameter Disp_Hb = 640;//800-160
//   parameter Disp_Va = 0;                           
//   parameter Disp_Vb = 680; //800-120
// `endif
// //parameter
// `ifdef Disp_800_600                             
    
//   parameter Disp_Ha = 0;                           
//   parameter Disp_Hb = 0;
//   parameter Disp_Va = 0;                           
//   parameter Disp_Vb = 0;
  
// `endif



// assign hori_valid = (h_cnt<(Hs_t-Hs_d -Disp_Hb)&& h_cnt>=Hs_b + Disp_Ha)?1'b1:1'b0;
// assign vert_valid = (v_cnt<(Vs_t-Vs_d -Disp_Vb)&& v_cnt>=Vs_b + Disp_Va)?1'b1:1'b0;

assign hori_valid = (h_cnt<(Hs_t-Hs_d )&& h_cnt>=Hs_b )?1'b1:1'b0;
assign vert_valid = (v_cnt<(Vs_t-Vs_d )&& v_cnt>=Vs_b)?1'b1:1'b0;
assign cDEN = hori_valid && vert_valid;

always@(negedge iVGA_CLK)
begin
  oBLANK_n<=cDEN;  //有效区域的电平flag
end

//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0];
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  // oBLANK_n<=cBLANK_n;
end








/*******function 1 ********/
//YT   color block
// //-----------------------------------------------------------       
// reg[7:0] vga_rdb;
// reg[7:0] vga_gdb;
// reg[7:0] vga_bdb;

// always @(posedge iVGA_CLK or negedge iRST_n)
//   if(!iRST_n) begin
//     vga_rdb <= 8'd0;
//     vga_gdb <= 8'd0;
//     vga_bdb <= 8'd0;
//   end
//   else if(xcnt == (VGA_HST+VGA_HBP-1)) begin                
//     vga_rdb <= 8'h0;
//     vga_gdb <= 8'h3f;
//     vga_bdb <= 8'd0;    
//   end
//   else if(xcnt == (VGA_HST+VGA_HBP+VGA_HVT-1'b1)) begin         
//     vga_rdb <= 8'h0;
//     vga_gdb <= 8'h3f;
//     vga_bdb <= 8'd0;    
//   end
//   else if(ycnt == (VGA_VST+VGA_VBP-1)) begin                
//     vga_rdb <= 8'h0;
//     vga_gdb <= 8'h3f;
//     vga_bdb <= 8'd0;    
//   end
//   else if(ycnt == (VGA_VST+VGA_VBP+VGA_VVT-1'b1)) begin         
//     vga_rdb <= 8'h0;
//     vga_gdb <= 8'h3f;
//     vga_bdb <= 8'd0;    
//   end
//   else begin                                
//     vga_rdb <= 8'h1f;
//     vga_gdb <= 8'd0;
//     vga_bdb <= 8'd0;  
//   end

// //-----------------------------------------------------------       
// assign r_data = cBLANK_n ? vga_rdb:8'd0;
// assign g_data = cBLANK_n ? vga_gdb:8'd0;  
// assign b_data = cBLANK_n ? vga_bdb:8'd0;  



endmodule
 	
















