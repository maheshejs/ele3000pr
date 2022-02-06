`define ENABLE_GPIO
module DE10_Nano_HDMI_TX(
 
      `ifdef ENABLE_ADC_ARDUINO
      ///////// ADC /////////
      output             ADC_CONVST,
      output             ADC_SCK,
      output             ADC_SDI,
      input              ADC_SDO,

      ///////// ARDUINO /////////
      inout       [15:0] ARDUINO_IO,
      inout              ARDUINO_RESET_N,
      `endif 
      ///////// FPGA /////////
      input              FPGA_CLK1_50,
      `ifdef ENABLE_MULTIPLE_CLKS
      input              FPGA_CLK2_50,
      input              FPGA_CLK3_50,
       `endif 
      ///////// GPIO /////////
      `ifdef ENABLE_GPIO
      input       [35:0] GPIO_0,
      input       [35:0] GPIO_1,
      `endif 
      ///////// HDMI ///////// Uncomment for audio output
      inout              HDMI_I2C_SCL,
      inout              HDMI_I2C_SDA,
      //inout              HDMI_I2S,
      //inout              HDMI_LRCLK,
      //inout              HDMI_MCLK,
      //inout              HDMI_SCLK,
      output             HDMI_TX_CLK,
      output      [23:0] HDMI_TX_D,
      output             HDMI_TX_DE,
      output             HDMI_TX_HS,
      input              HDMI_TX_INT,
      output             HDMI_TX_VS,

`ifdef ENABLE_HPS
      ///////// HPS /////////
      inout              HPS_CONV_USB_N,
      output      [14:0] HPS_DDR3_ADDR,
      output      [2:0]  HPS_DDR3_BA,
      output             HPS_DDR3_CAS_N,
      output             HPS_DDR3_CKE,
      output             HPS_DDR3_CK_N,
      output             HPS_DDR3_CK_P,
      output             HPS_DDR3_CS_N,
      output      [3:0]  HPS_DDR3_DM,
      inout       [31:0] HPS_DDR3_DQ,
      inout       [3:0]  HPS_DDR3_DQS_N,
      inout       [3:0]  HPS_DDR3_DQS_P,
      output             HPS_DDR3_ODT,
      output             HPS_DDR3_RAS_N,
      output             HPS_DDR3_RESET_N,
      input              HPS_DDR3_RZQ,
      output             HPS_DDR3_WE_N,
      output             HPS_ENET_GTX_CLK,
      inout              HPS_ENET_INT_N,
      output             HPS_ENET_MDC,
      inout              HPS_ENET_MDIO,
      input              HPS_ENET_RX_CLK,
      input       [3:0]  HPS_ENET_RX_DATA,
      input              HPS_ENET_RX_DV,
      output      [3:0]  HPS_ENET_TX_DATA,
      output             HPS_ENET_TX_EN,
      inout              HPS_GSENSOR_INT,
      inout              HPS_I2C0_SCLK,
      inout              HPS_I2C0_SDAT,
      inout              HPS_I2C1_SCLK,
      inout              HPS_I2C1_SDAT,
      inout              HPS_KEY,
      inout              HPS_LED,
      inout              HPS_LTC_GPIO,
      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout       [3:0]  HPS_SD_DATA,
      output             HPS_SPIM_CLK,
      input              HPS_SPIM_MISO,
      output             HPS_SPIM_MOSI,
      inout              HPS_SPIM_SS,
      input              HPS_UART_RX,
      output             HPS_UART_TX,
      input              HPS_USB_CLKOUT,
      inout       [7:0]  HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,
`endif /*ENABLE_HPS*/

      ///////// KEY /////////
      input       [1:0]  KEY,

      ///////// LED /////////
      output      [7:0]  LED,

      ///////// SW /////////
      input       [3:0]  SW
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
wire				reset_n;
wire				game_clk;
wire				i2c_clk;
wire				render_clk;
wire				game_rst;
wire				i2c_rst;
wire				render_rst;
wire         [4:0]   rd_data;
wire         [3:0]   rd_addr;
wire        gen_clk_locked;
wire ongoing;
wire lost;
wire won;
//Video Pattern Generator

//assign dcdp_wdata = 5'b0;
//assign dcdp_waddr = 4'b0;
//assign dcdp_wen = 1'b0;

assign LED[0] = lost;
assign LED[1] = lost;
assign LED[2] = 1'b0;
assign LED[3] = 1'b0;
assign LED[4] = 1'b0;
assign LED[5] = 1'b0;
assign LED[6] = won;
assign LED[7] = won;




//=======================================================
//  Structural coding
//=======================================================
//assign reset_n = 1'b1;
//system clock
//game_pll game_pll_inst (
//	.refclk(FPGA_CLK1_50),
//	.rst(1'b0),
//	.outclk_0(game_clk),
//	.locked(reset_n) );
//vga_pll vga_pll_inst (
//	.refclk(FPGA_CLK2_50),
//	.rst(!reset_n),
//	.outclk_0(render_clk),
//	.locked(gen_clk_locked) );

//clk_gen clk_gen_inst (
//	.refclk(FPGA_CLK1_50),
//	.rst(!KEY[0]),
//	.outclk_0(game_clk),
//    .outclk_1(i2c_clk),
//    .outclk_2(render_clk),
//	.locked(gen_clk_locked) );

clk_rst_gen clk_rst_gen_inst (
	.ref_clk_i(FPGA_CLK1_50),
	.pll_rst_n_i(SW[0]),
    .sys_rst_n_i(KEY[0]),
	.game_clk_o(game_clk),
    .i2c_clk_o(i2c_clk),
    .render_clk_o(render_clk),
    .game_rst_o(game_rst),
    .i2c_rst_o(i2c_rst),
    .render_rst_o(render_rst)
    );

//dual clcok dual port ram

//dcdp_ram dcdp_ram_inst(
//    render_clk,
//    game_clk,
//    dcdp_raddr,
//    dcdp_waddr,
//    dcdp_wdata,
//    dcdp_wen,
//    dcdp_rdata
//); 

game game_inst(
   .btn_i({!GPIO_0[27],!GPIO_0[29],!GPIO_0[31],!GPIO_0[33]}),
   .game_rst_i(game_rst),
   .game_clk_i(game_clk),
   .game_start_i(!KEY[1]),
   .rd_clk_i(render_clk),
   .rd_addr_i(rd_addr),
   .rd_data_o(rd_data),
   .lost_o(lost),
   .won_o(won)
);
       
//pattern generator
render render_inst (
	.render_clk_i(render_clk),
	.render_rst_i(render_rst),
    .rd_data_i(rd_data),
    .rd_addr_o(rd_addr),
	.data_en_o(HDMI_TX_DE),
	.h_sync_o(HDMI_TX_HS),
	.v_sync_o(HDMI_TX_VS),
	.red_o(HDMI_TX_D[23:16]),
	.green_o(HDMI_TX_D[15:8]),
	.blue_o(HDMI_TX_D[7:0]) );

assign HDMI_TX_CLK = render_clk;

//HDMI I2C
//.iRST_N(reset_n),
i2c_hdmi_config i2c_hdmi_config_inst(
	.i2c_clk_i(i2c_clk),
	.i2c_rst_i(i2c_rst),
	.i2c_sclk_o(HDMI_I2C_SCL),
	.i2c_sdat_o(HDMI_I2C_SDA),
	.hdmi_tx_int_i(HDMI_TX_INT)
	 );

endmodule
