----------------------------------------------------------------------------------
-- POLYTECHNIQUE MONTREAL
-- ELE3311 - Systemes logiques programmables 
-- 
-- Module Name:    simon_affichage_del 
-- Description: 
--
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;

entity game is
  port (
         btn_i                 : in    std_logic_vector(3 downto 0);
         game_rst_i            : in    std_logic;
         game_clk_i            : in    std_logic;
         game_start_i          : in    std_logic;
         rd_clk_i              : in    std_logic;
         rd_addr_i             : in    address;
         rd_data_o             : out   word;
         won_o                 : out   std_logic;
         lost_o                : out   std_logic
       );
end game;


architecture behavioral of game is
  -- ###########################################################################
  -- Entete de l'architecture
  -- ###########################################################################

  signal rst                    : std_logic;
  signal clk                    : std_logic;
  signal rd_clk                 : std_logic;
  signal sample_8khz            : std_logic;
  signal game_start_clk         : std_logic;
  signal btn_clk                : std_logic_vector(3 downto 0);
  signal dbnc_game_start        : std_logic;
  signal dbnc_btn               : std_logic_vector(3 downto 0);
  signal seed                   : std_logic_vector(7 downto 0);
  signal mode                   : std_logic;
  signal dir                    : std_logic;
  signal encod_mode             : std_logic;
  signal encod_dir              : std_logic;
  signal encod_key_pressed      : std_logic;
  signal load_prbs              : std_logic;
  signal load_param             : std_logic;
  signal merge                  : std_logic;
  signal slide                  : std_logic;
  signal won                    : std_logic;
  signal single_zero            : std_logic;
  signal found_neigh            : std_logic;
  signal done_zero              : std_logic;
  signal done_spawn             : std_logic;
  signal done_slirge            : std_logic;
  signal done_neigh             : std_logic;
  signal done                   : std_logic;
  signal start_zero             : std_logic;
  signal start_spawn            : std_logic;
  signal start_slirge           : std_logic;
  signal start_neigh            : std_logic;
  signal selection              : std_logic_vector(1 downto 0);
  signal rd_addr                : address;
  signal raddr                  : address;
  signal waddr                  : address;
  signal rdata                  : word;
  signal rd_data                : word;
  signal wdata                  : word;
  signal wen                    : std_logic;
  signal raddr_slirge           : address;
  signal waddr_slirge           : address;
  signal wdata_slirge           : word;
  signal wen_slirge             : std_logic;
  signal raddr_spawn            : address;
  signal waddr_spawn            : address;
  signal wdata_spawn            : word;
  signal wen_spawn              : std_logic;
  signal raddr_zero             : address;
  signal waddr_zero             : address;
  signal wdata_zero             : word;
  signal wen_zero               : std_logic;
  signal raddr_neigh            : address;
  signal game_state             : game_status;

  component meta_harden
    generic (
              GENERIC_IO_LOGIC : std_logic := '1'; -- 1=POSITIVE 0=NEGATIVE
              WIDTH            : integer   := 1
            );
    port ( 
           sig_src_i  : in  std_logic_vector(WIDTH-1 downto 0);
           rst_dst_i  : in  std_logic;
           clk_dst_i  : in  std_logic;
           sig_dst_o  : out std_logic_vector(WIDTH-1 downto 0)
         );
  end component;

  component dbnc
    port (
           rst_i                 : in    std_logic;
           clk_i                 : in    std_logic;
           sample_i              : in    std_logic;  -- sample signal should be around 8 kHz
           sig_i                 : in    std_logic;
           dbnc_sig_o            : out   std_logic
         );
  end component;

  component tiles_zero
    port (
           clk_i                 : in    std_logic;
           rst_i                 : in    std_logic;
           start_i               : in    std_logic;
           rdata_i               : in    word;
           raddr_o               : out   address;
           waddr_o               : out   address;
           wdata_o               : out   word;
           wen_o                 : out   std_logic ;
           done_o                : out   std_logic
         );
  end component;

  component tiles_slirge
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
  end component;

  component tiles_spawn
    port (
           clk_i                 : in    std_logic;
           rst_i                 : in    std_logic;
           start_i               : in    std_logic;
           load_prbs_i           : in    std_logic;
           seed_i                : in    std_logic_vector(7 downto 0);
           rdata_i               : in word;
           raddr_o               : out address;
           waddr_o               : out address;
           wdata_o               : out word;
           wen_o                 : out std_logic ;
           done_o                : out std_logic
         );
  end component;

  component tiles_neighbour
    port (
           clk_i                 : in    std_logic;
           rst_i                 : in    std_logic;
           start_i               : in    std_logic;
           rdata_i               : in    word;
           raddr_o               : out   address;
           found_neigh_o         : out   std_logic;
           done_o                : out   std_logic
         );
  end component;

  component cnt
    generic (
              WIDTH                 : integer := 8
            );
    port (
           clk_i                 : in    std_logic;
           rst_i                 : in    std_logic;
           inc_i                 : in    std_logic;
           cnt_o                 : out   std_logic_vector(WIDTH-1 downto 0)
         );
  end component;

  component msa_game
    port (
           clk_i                 : in    std_logic;
           rst_i                 : in    std_logic;
           start_i               : in    std_logic;
           key_pressed_i         : in    std_logic;
           merge_i               : in    std_logic;
           slide_i               : in    std_logic;
           won_i                 : in    std_logic;
           single_zero_i         : in    std_logic;
           found_neigh_i         : in    std_logic;
           done_zero_i           : in    std_logic;
           done_spawn_i          : in    std_logic;
           done_slirge_i         : in    std_logic;
           done_neigh_i          : in    std_logic;
           start_zero_o          : out   std_logic;
           start_spawn_o         : out   std_logic;
           start_slirge_o        : out   std_logic;
           start_neigh_o         : out   std_logic;
           load_param_o          : out   std_logic;
           load_prbs_o           : out   std_logic;
           selection_o           : out   std_logic_vector(1 downto 0);
           done_o                : out   std_logic;
           game_status_o         : out   game_status
         );
  end component;

  component delay_cnt
    generic (
              COUNT_VAL             : unsigned(13 downto 0) := to_unsigned(12500, 14)
            );
    port (
           rst_i                 : in    std_logic;
           clk_i                 : in    std_logic;
           start_delay_i         : in    std_logic;
           end_delay_o           : out   std_logic
         );
  end component;

  component dp_ram
    port (
           clk_i      : in std_logic;
           raddr_i    : in address;
           waddr_i    : in address;
           wdata_i    : in word;
           wen_i      : in std_logic;
           rdata_o    : out word
         );
  end component;

  component tiles_ram
    port 
    (
      rclk_i      : in std_logic;
      wclk_i      : in std_logic;
      raddr_i     : in address;
      waddr_i     : in address;
      wdata_i     : in word;
      wen_i       : in std_logic ;
      rdata_o     : out word
    );
  end component;

-- ###########################################################################
-- Debut de l'architecture
-- ###########################################################################
begin
  clk      <= game_clk_i;
  rd_clk   <= rd_clk_i;
  rd_addr   <= rd_addr_i;

  sample_8khz_inst : delay_cnt
  generic map(
               COUNT_VAL               => to_unsigned(12500, 14)
             )
  port map(
            rst_i                   => rst,
            clk_i                   => clk,
            start_delay_i           => sample_8khz,
            end_delay_o             => sample_8khz
          );



  ----------------------------------------------------------------------------
  resynchronisation_inst : meta_harden
  generic map(
               WIDTH                   => 5 
             )
  port map(
            sig_src_i(4)            => game_start_i,
            sig_src_i(3 downto 0)   => btn_i,
            rst_dst_i               => rst,
            clk_dst_i               => clk,
            sig_dst_o(4)            => game_start_clk,
            sig_dst_o(3 downto 0)   => btn_clk
          );

  ----------------------------------------------------------------------------
  rst <= game_rst_i;

  ----------------------------------------------------------------------------
  dbnc_game_start_inst : dbnc
  port map(
            rst_i                   => rst,
            clk_i                   => clk,
            sample_i                => sample_8khz,
            sig_i                   => game_start_clk,
            dbnc_sig_o              => dbnc_game_start
          );

  dbnc_gen: 
  for W in 0 to 3 generate
    dbnc_btn_inst : dbnc
    port map(
              rst_i                   => rst,
              clk_i                   => clk,
              sample_i                => sample_8khz,
              sig_i                   => btn_clk(W),
              dbnc_sig_o              => dbnc_btn(W)
            );
  end generate dbnc_gen;

  ----------------------------------------------------------------------------
  tiles_neigh_inst : tiles_neighbour
  port map(
            clk_i                 => clk,
            rst_i                 => rst,
            start_i               => start_neigh,
            rdata_i               => rdata,
            raddr_o               => raddr_neigh,
            found_neigh_o         => found_neigh,
            done_o                => done_neigh
          );
  tiles_slirge_inst : tiles_slirge 
  port map (
             clk_i   => clk,
             rst_i   => rst,
             dir_i   => dir,
             start_i => start_slirge,
             mode_i  => mode,
             rdata_i => rdata,
             raddr_o => raddr_slirge,
             waddr_o => waddr_slirge,
             wdata_o => wdata_slirge,
             wen_o   => wen_slirge,
             slide_o => slide,
             merge_o => merge,
             won_o   => won,
             single_zero_o => single_zero,
             done_o  => done_slirge);

  tiles_spawn_inst : tiles_spawn 
  port map (
             clk_i       => clk,
             rst_i       => rst,
             start_i     => start_spawn,
             load_prbs_i => load_prbs,
             seed_i      => seed,
             rdata_i     => rdata,
             raddr_o     => raddr_spawn,
             waddr_o     => waddr_spawn,
             wdata_o     => wdata_spawn,
             wen_o       => wen_spawn,
             done_o      => done_spawn
           );

  tiles_zero_inst : tiles_zero
  port map (
             clk_i   => clk,
             rst_i   => rst,
             start_i => start_zero,
             rdata_i => rdata,
             raddr_o => raddr_zero,
             waddr_o => waddr_zero,
             wdata_o => wdata_zero,
             wen_o   => wen_zero,
             done_o  => done_zero
           );

  dp_ram_inst : dp_ram
  port map (
             clk_i   => clk,
             raddr_i => raddr,
             waddr_i => waddr,
             wdata_i  => wdata,
             wen_i    => wen,
             rdata_o  => rdata
           );

  tiles_ram_inst : tiles_ram
  port map (
             rclk_i   => rd_clk,
             wclk_i   => clk,
             raddr_i  => rd_addr,
             waddr_i  => waddr,
             wdata_i  => wdata,
             wen_i    => wen,
             rdata_o  => rd_data
           );
  ----------------------------------------------------------------------------
  msa_game_inst : msa_game 
  port map (
             clk_i          => clk,
             rst_i          => rst,
             start_i        => dbnc_game_start,
             key_pressed_i  => encod_key_pressed,
             merge_i        => merge,
             slide_i        => slide,
             won_i          => won,
             found_neigh_i  => found_neigh,
             single_zero_i  => single_zero,
             done_zero_i    => done_zero,
             done_spawn_i   => done_spawn,
             done_slirge_i  => done_slirge,
             done_neigh_i   => done_neigh,
             start_zero_o   => start_zero,
             start_spawn_o  => start_spawn,
             start_slirge_o => start_slirge,
             start_neigh_o  => start_neigh,
             load_param_o   => load_param,
             load_prbs_o    => load_prbs,
             selection_o    => selection,
             done_o         => done,
             game_status_o  => game_state
           );
  seed_inst : cnt
  port map(
            clk_i                   => clk,
            rst_i                   => '0',
            inc_i                   => '1',
            cnt_o                   => seed
          );

  ------------------------------------------------------------------------------
  -- encodeurs 4 a 1 HBGD
  ------------------------------------------------------------------------------
  encod_mode         <= '1' when dbnc_btn(3) = '1' or dbnc_btn(2) = '1' else
                        '0';
  encod_dir          <= '1' when dbnc_btn(2) = '1' or dbnc_btn(0) = '1' else
                        '0';
  encod_key_pressed  <= dbnc_btn(3) or dbnc_btn(2) or dbnc_btn(1) or dbnc_btn(0);
  --------------------------------------------------------------------------------
  reg_param : process(clk)
  begin
    if (rising_edge(clk)) then
      if (rst = '1') then
        mode <= '0';
        dir <= '0';
      elsif (load_param = '1') then
        mode <= encod_mode;
        dir <= encod_dir;
      end if;
    end if;
  end process;
  ----------------------------------------------------------------------------
  raddr              <= raddr_slirge    when selection = "11" else
                        raddr_spawn     when selection = "10" else
                        raddr_zero      when selection = "01" else
                        raddr_neigh;
  waddr              <= waddr_slirge    when selection = "11" else
                        waddr_spawn     when selection = "10" else
                        waddr_zero      when selection = "01" else
                        0;
  wen                <= wen_slirge      when selection = "11" else
                        wen_spawn       when selection = "10" else
                        wen_zero        when selection = "01" else
                        '0';
  wdata              <= wdata_slirge    when selection = "11" else
                        wdata_spawn     when selection = "10" else
                        wdata_zero      when selection = "01" else
                        "00000";
  ----------------------------------------------------------------------------

  ----------------------------------------------------------------------------
  -- Glue logic
  ----------------------------------------------------------------------------

  ----------------------------------------------------------------------------
  -- Assign outputs
  ----------------------------------------------------------------------------
  rd_data_o <= rd_data;
  won_o <= '1' when game_state = GAME_WON else '0';
  lost_o <= '1' when game_state = GAME_LOST else '0';

end behavioral;

