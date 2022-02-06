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

entity ram_neigh is
port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        start_i               : in    std_logic;
        found_neigh_o           : out   std_logic;
        done_o                : out   std_logic
);
end ram_neigh;


architecture behavioral of ram_neigh is
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
  signal neighbour_s            : std_logic;
  signal done_spawn             : std_logic;
  signal done_slirge            : std_logic;
  signal done                   : std_logic;
  signal start_zero             : std_logic;
  signal start_spawn            : std_logic;
  signal start_slirge           : std_logic;
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
  
  
  component tiles_neighbour
    port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        start_i               : in    std_logic;
        rdata_i               : in    word;
        raddr_o               : out   address;
        found_neigh_o           : out   std_logic;
        done_o                : out   std_logic
    );
  end component;

-- ###########################################################################
-- Debut de l'architecture
-- ###########################################################################
begin
  clk <= clk_i;
  rst <= rst_i;
  dp_ram_inst : dp_ram
  port map (
    clk_i   => clk,
    raddr_i => raddr,
    waddr_i => 0,
    wdata_i  => "00000",
    wen_i    => '0',
    rdata_o  => rdata
  );

  neigh_inst : tiles_neighbour
  port map(
        clk_i                 => clk,
        rst_i                 => rst,
        start_i               => start_i,
        rdata_i               => rdata,
        raddr_o               => raddr,
        found_neigh_o           => neighbour_s,
        done_o                => done
    );

  ----------------------------------------------------------------------------

  ----------------------------------------------------------------------------
  -- Glue logic
  ----------------------------------------------------------------------------

  ----------------------------------------------------------------------------
  -- Assign outputs
  ----------------------------------------------------------------------------
  done_o <= done;
  found_neigh_o <= neighbour_s;

end behavioral;

