`define ENABLE_GPIO
module top(
      ///////// FPGA /////////
      input              FPGA_CLK1_50,
      ///////// GPIO /////////
      `ifdef ENABLE_GPIO
      input       [35:0] GPIO_0,
      `endif 
      ///////// HDMI /////////
      inout              HDMI_I2C_SCL,
      inout              HDMI_I2C_SDA,
      output             HDMI_TX_CLK,
      output      [23:0] HDMI_TX_D,
      output             HDMI_TX_DE,
      output             HDMI_TX_HS,
      input              HDMI_TX_INT,
      output             HDMI_TX_VS,

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


assign LED[0] = lost;
assign LED[1] = lost;
assign LED[2] = 1'b0;
assign LED[3] = 1'b0;
assign LED[4] = 1'b0;
assign LED[5] = 1'b0;
assign LED[6] = won;
assign LED[7] = won;



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

i2c_hdmi_config i2c_hdmi_config_inst(
	.i2c_clk_i(i2c_clk),
	.i2c_rst_i(i2c_rst),
	.i2c_sclk_o(HDMI_I2C_SCL),
	.i2c_sdat_o(HDMI_I2C_SDA),
	.hdmi_tx_int_i(HDMI_TX_INT)
	 );

endmodule
