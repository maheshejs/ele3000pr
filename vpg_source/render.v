
module render(
	render_clk_i,
	render_rst_i,
    rd_data_i,
    rd_addr_o,
	data_en_o,
	h_sync_o,
	v_sync_o,
	red_o,
	green_o,
	blue_o
);

input			    render_clk_i;
input				render_rst_i;
input         [4:0]   rd_data_i;
output        [3:0]   rd_addr_o;
output				data_en_o;
output				h_sync_o;
output				v_sync_o;
output	[7:0]		red_o;
output	[7:0]		green_o;
output	[7:0]		blue_o;

//=======================================================
//  Signal declarations
//=======================================================

//============= assign timing constant  
//reg  [11:0] h_total, h_sync, h_start, h_end; 
//reg  [11:0] v_total, v_sync, v_start, v_end; 

wire render_rst;

assign render_rst = render_rst_i;
//=======================================================
//  Sub-module
//=======================================================



//=============== pattern generator according to vga timing
vga_generator u_vga_generator (                                    
	.clk(render_clk_i),                
	.rst(render_rst),
    .shadow_ram_raddr(rd_addr_o),
    .shadow_ram_rdata(rd_data_i),
	.h_total(12'd799),           
	.h_sync(12'd95),           
	.h_start(12'd141),             
	.h_end(12'd781),                                                    
	.v_total(12'd524),           
	.v_sync(12'd1),            
	.v_start(12'd34),           
	.v_end(12'd514),  
	.vga_hs(h_sync_o),
	.vga_vs(v_sync_o),           
	.vga_de(data_en_o),
	.vga_r(red_o),
	.vga_g(green_o),
	.vga_b(blue_o));


//=======================================================
//  Structural coding
//=======================================================
//============= assign timing constant  
//h_total : total - 1
//h_sync : sync - 1
//h_start : sync + back porch - 1 - 2(delay)
//h_end : h_start + active
//v_total : total - 1
//v_sync : sync - 1
//v_start : sync + back porch - 1
//v_end : v_start + active

endmodule