
module vga_generator(                                    
  input						clk,                
  input						rst,                                                
  input			[11:0]	h_total,           
  input			[11:0]	h_sync,           
  input			[11:0]	h_start,             
  input			[11:0]	h_end,                                                    
  input			[11:0]	v_total,           
  input			[11:0]	v_sync,            
  input			[11:0]	v_start,           
  input			[11:0]	v_end, 
  input         [4:0]   shadow_ram_rdata,
  output        [3:0]   shadow_ram_raddr,
  output	reg				vga_hs,             
  output	reg				vga_vs,           
  output	reg				vga_de,
  output	reg	[7:0]		vga_r,
  output	reg	[7:0]		vga_g,
  output	reg	[7:0]		vga_b
);

//=======================================================
//  Signal declarations
//=======================================================
reg	[11:0]	h_count;
wire [11:0]	h_c;
wire	[16:0]	address;
wire	[23:0]	data;
reg	[11:0]	v_count;
wire [11:0]	v_c;
reg				h_act; 
reg				h_act_d;
reg				v_act; 
reg				v_act_d; 
reg				pre_vga_de;
wire				h_max, hs_end, hr_start, hr_end;
wire				v_max, vs_end, vr_start, vr_end;
reg				boarder;
reg [16:0] m1;
reg [16:0] m2;
reg [16:0] n1;
reg [16:0] n2;
reg [16:0] n1_d;
reg [16:0] n2_d;
reg test_inbounds_d;
reg test_inbounds;
reg test_insquares_d;
reg test_insquares;

tilesrom trom(
    address,
    clk,
    data);

//=======================================================
//  Structural coding
//=======================================================
assign h_max = h_count == h_total;
assign hs_end = h_count >= h_sync;
assign hr_start = h_count == h_start; 
assign hr_end = h_count == h_end;
assign v_max = v_count == v_total;
assign vs_end = v_count >= v_sync;
assign vr_start = v_count == v_start; 
assign vr_end = v_count == v_end;
assign h_c = h_count - h_start;
assign v_c = v_count - v_start;
//100px
//assign m1 = ({5'b00000,h_c} - 105)/110;
//assign m2 = ({5'b00000,v_c} - 25)/110;
assign shadow_ram_raddr = m2*4 + m1;


//assign n1 = ({5'b00000,h_c} - 105)%110;
//assign n2 = ({5'b00000,v_c} - 25)%110;

assign address = ({12'h000,shadow_ram_rdata}*4+{12'h000,shadow_ram_rdata}*32+{12'h000,shadow_ram_rdata}*64 + n2)*4+({12'h000,shadow_ram_rdata}*4+{12'h000,shadow_ram_rdata}*32+{12'h000,shadow_ram_rdata}*64 + n2)*32+({12'h000,shadow_ram_rdata}*4+{12'h000,shadow_ram_rdata}*32+{12'h000,shadow_ram_rdata}*64 + n2)*64 + n1;

//assign address = (4*m2 + m1)*10000 + 100*n2 + n1;


always @ (posedge clk)
	if (rst)
	begin
		test_inbounds <=	1'b0;
        test_inbounds_d <=	1'b0;
	end
    else
    begin
       test_inbounds <= test_inbounds_d;
       if ((h_c >= 105 && h_c < 535) && (v_c >= 25 && v_c < 455))
           test_inbounds_d <=	1'b1;
       else
           test_inbounds_d <=	1'b0;
    end

always @ (posedge clk)
	if (rst)
	begin
		test_insquares_d <=	1'b0;
        test_insquares <=	1'b0;
	end
    else
    begin
       test_insquares <= test_insquares_d;
       if ((n1 >= 0 && n1 <= 99) && (n2 >= 0 && n2 <= 99) && (test_inbounds))
           test_insquares_d <=	1'b1;
       else
           test_insquares_d <=	1'b0;
    end
    
always @ (posedge clk)
	if (rst)
	begin
		m1	<=	17'b0;
		m2	<=	17'b0;
	end
    else
    begin
        m1 <= ({5'b00000,h_c} - 105)/110;
        m2 <= ({5'b00000,v_c} - 25)/110;
    end
    
always @ (posedge clk)
	if (rst)
	begin
		n1 <=	17'b0;
		n2 <=	17'b0;
        n1_d <=	17'b0;
		n2_d <=	17'b0;
	end
    else
    begin
        n1 <= n1_d;
        n2 <= n2_d;
        n1_d <= ({5'b00000,h_c} - 105)%110;
        n2_d <= ({5'b00000,v_c} - 25)%110;
    end

//horizontal control signals
always @ (posedge clk)
	if (rst)
	begin
		h_act_d	<=	1'b0;
		h_count	<=	12'b0;
		vga_hs	<=	1'b1;
		h_act		<=	1'b0;
	end
	else
	begin
		h_act_d	<=	h_act;

		if (h_max)
			h_count	<=	12'b0;
		else
			h_count	<=	h_count + 12'b1;

		if (hs_end && !h_max)
			vga_hs	<=	1'b1;
		else
			vga_hs	<=	1'b0;

		if (hr_start)
			h_act		<=	1'b1;
		else if (hr_end)
			h_act		<=	1'b0;
	end

//vertical control signals
always@(posedge clk)
	if(rst)
	begin
		v_act_d		<=	1'b0;
		v_count		<=	12'b0;
		vga_vs		<=	1'b1;
		v_act		<=	1'b0;
	end
	else 
	begin		
		if (h_max)
		begin		  
			v_act_d	  <=	v_act;
		  
			if (v_max)
				v_count	<=	12'b0;
			else
				v_count	<=	v_count + 12'b1;

			if (vs_end && !v_max)
				vga_vs	<=	1'b1;
			else
				vga_vs	<=	1'b0;

			if (vr_start)
				v_act <=	1'b1;
			else if (vr_end)
				v_act <=	1'b0;
		end
	end

//pattern generator and display enable
always @(posedge clk)
begin
	if (rst)
	begin
		vga_de		<=	1'b0;
		pre_vga_de	<=	1'b0;
		boarder		<=	1'b0;		
	end
	else
	begin
		vga_de		<=	pre_vga_de;
		pre_vga_de	<=	v_act && h_act;
    
		if ((!h_act_d&&h_act) || hr_end || (!v_act_d&&v_act) || vr_end)
			boarder	<=	1'b1;
		else
			boarder	<=	1'b0;   		
		
		if (boarder)
			{vga_r, vga_g, vga_b} <= {8'hFF,8'hFF,8'hFF}; // (data&8'he0)>>5, (data&8'h1c)>>2 , data&8'h3 ; {pixel_x,{1'b0,cnt_col}, 8'h00};
		else
           begin
              if (test_insquares)
                 {vga_r, vga_g, vga_b} <= {data[23:16], data[15:8], data[7:0]};
              else
                 {vga_r, vga_g, vga_b} <= {8'h00,8'h00,8'h00};
           end 
	end
end	

endmodule