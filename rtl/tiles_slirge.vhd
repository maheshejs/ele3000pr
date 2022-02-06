library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;
entity tiles_slirge is
    port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        dir_i                 : in    std_logic;
        start_i               : in    std_logic;
        mode_i                : in    std_logic;
        rdata_i               : in    word;
        raddr_o               : out   address;
        waddr_o               : out   address;
        wdata_o               : out   word;
        wen_o                 : out   std_logic;
        slide_o               : out   std_logic;
        merge_o               : out   std_logic;
        won_o                 : out   std_logic;
        single_zero_o         : out   std_logic;
        done_o                : out   std_logic
    );
end tiles_slirge;


architecture behavioral of tiles_slirge is
    signal clk          : std_logic;
    signal rst          : std_logic;
    signal wen          : std_logic;
    signal start_line   : std_logic;
    signal start_line_w : std_logic;
    signal start_slide  : std_logic;
    signal done         : std_logic;
    signal done_rdline  : std_logic;
    signal done_wrline  : std_logic;
    signal done_sldline : std_logic;
    signal done_mrgline : std_logic;
    signal slide_line   : std_logic;
    signal merge_line   : std_logic;
    signal won_line     : std_logic;
    signal raddr        : address;
    signal waddr        : address;
    signal readdata     : word;
    signal writedata    : word;
    signal line_read    : line_word;
    signal line_slided  : line_word;
    signal line_merged  : line_word;
    signal no_line      : std_logic_vector(1 downto 0);
    signal no_line_w    : std_logic_vector(1 downto 0);
    signal merge_reg    : std_logic_vector(3 downto 0);
    signal slide_reg    : std_logic_vector(3 downto 0);
    signal won_reg    : std_logic_vector(3 downto 0);
    signal zero_count_reg: integer range 0 to 16;
    component slider
      port (
          clk_i                 : in    std_logic;
          rst_i                 : in    std_logic;
          start_i               : in    std_logic;
          dir_i                 : in    std_logic;
          line_i                : in    line_word;
          line_o                : out   line_word;
          slide_line_o          : out   std_logic;
          done_o                : out   std_logic
      );
    end component;
    component merger
      port (
          clk_i                 : in    std_logic;
          rst_i                 : in    std_logic;
          start_i               : in    std_logic;
          dir_i                 : in    std_logic;
          line_i                : in    line_word;
          line_o                : out   line_word;
          merge_line_o          : out   std_logic;
          won_line_o            : out   std_logic;
          done_o                : out   std_logic
      );
    end component;
    component line_reader
      port (
          clk_i                 : in    std_logic;
          rst_i                 : in    std_logic;
          start_i               : in    std_logic;
          mode_i                : in    std_logic;
          rdata_i               : in    word;
          no_line_i             : in    std_logic_vector(1 downto 0);
          raddr_o               : out   address;
          line_o                : out   line_word;
          done_o                : out   std_logic
      );
    end component;
    component line_writer
      port (
          clk_i                 : in    std_logic;
          rst_i                 : in    std_logic;
          start_i               : in    std_logic;
          mode_i                : in    std_logic;
          line_i                : in    line_word;
          no_line_i             : in    std_logic_vector(1 downto 0);
          waddr_o               : out   address;
          wdata_o               : out   word;
          wen_o                 : out   std_logic;
          done_o                : out   std_logic
      );
    end component;
    component read_manager
      port (
          clk_i                 : in    std_logic;
          rst_i                 : in    std_logic;
          start_i               : in    std_logic;
          done_line_i           : in    std_logic;
          no_line_o             : out   std_logic_vector(1 downto 0);
          start_line_o          : out   std_logic
      );
    end component;
    component write_manager
      port (
          clk_i                 : in    std_logic;
          rst_i                 : in    std_logic;
          start_i               : in    std_logic;
          done_compute_i        : in    std_logic;
          done_line_i           : in    std_logic;
          no_line_o             : out   std_logic_vector(1 downto 0);
          start_line_o          : out   std_logic;
          done_o                : out   std_logic
      );
    end component;
    component shift_reg 
      port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        load_i                : in    std_logic;
        din_i                 : in    std_logic;
        dout_o                : out   std_logic_vector(3 downto 0)
      );
    end component;
begin
  rst <= rst_i;
  clk <= clk_i;
  readdata <= rdata_i;
----------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1' or start_i = '1') then
                zero_count_reg <= 0;
            elsif (wen = '1' and writedata = "00000") then
                zero_count_reg <= zero_count_reg + 1;
            end if;
        end if;
    end process;
--- structural coding
    sr_won_inst : shift_reg port map (    clk_i   => clk,
                         rst_i   => rst,
                         load_i => done_mrgline,
                         din_i   => won_line,
                         dout_o  => won_reg);
    sr_merge_inst : shift_reg port map (    clk_i   => clk,
                         rst_i   => rst,
                         load_i => done_mrgline,
                         din_i   => merge_line,
                         dout_o  => merge_reg);
    sr_slide_inst : shift_reg port map (    clk_i   => clk,
                         rst_i   => rst,
                         load_i => done_sldline,
                         din_i   => slide_line,
                         dout_o  => slide_reg);
    slider_inst : slider port map (    clk_i   => clk,
                         rst_i   => rst,
                         start_i => done_rdline,
                         dir_i   => dir_i,
                         line_i  => line_read,
                         line_o  => line_slided,
                         done_o  => done_sldline,
                         slide_line_o => slide_line);
    merger_inst : merger port map (    clk_i    => clk,
                         rst_i    => rst,
                         start_i  => done_sldline,
                         dir_i    => dir_i,
                         line_i   => line_slided,
                         line_o   => line_merged,
                         merge_line_o => merge_line,
                         won_line_o => won_line,
                         done_o   => done_mrgline);
   
    line_reader_inst : line_reader port map ( clk_i      => clk,
                              rst_i      => rst,
                              start_i    => start_line,
                              mode_i     => mode_i,
                              rdata_i => readdata,
                              no_line_i  => no_line,
                              raddr_o    => raddr,
                              line_o     => line_read,
                              done_o     => done_rdline);
    read_manager_inst : read_manager port map ( clk_i          => clk,
                               rst_i          => rst,
                               start_i        => start_i,
                               done_line_i => done_rdline,
                               no_line_o      => no_line,
                               start_line_o   => start_line);
    write_manager_inst : write_manager port map ( clk_i          => clk,
                               rst_i          => rst,
                               start_i        => done_rdline,
                               done_line_i    => done_wrline,
                               done_compute_i => done_mrgline,
                               no_line_o      => no_line_w,
                               start_line_o   => start_line_w,
                               done_o => done);
    line_writer_inst : line_writer port map ( clk_i     => clk,
                              rst_i     => rst,
                              start_i   => start_line_w,
                              mode_i    => mode_i,
                              line_i    => line_merged,
                              no_line_i => no_line_w,
                              waddr_o   => waddr,
                              wdata_o   => writedata,
                              wen_o     => wen,
                              done_o    => done_wrline);
                              
-- glue logic
     merge_o <= '0' when merge_reg = "0000" else '1';
     slide_o <= '0' when slide_reg = "0000" else '1';
     won_o <= '0' when won_reg = "0000" else '1';
     single_zero_o <= '1' when zero_count_reg = 1 else '0';
-- outputs
     raddr_o               <= raddr;
     waddr_o               <= waddr;
     wdata_o               <= writedata;
     wen_o                 <= wen;
     done_o                <= done;
     
end behavioral;