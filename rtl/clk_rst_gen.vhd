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

entity clk_rst_gen is
port (
  
  ref_clk_i             : in    std_logic;
  pll_rst_n_i           : in    std_logic;
  sys_rst_n_i           : in    std_logic;
  game_clk_o            : out   std_logic;
  game_rst_o            : out   std_logic;
  render_clk_o          : out   std_logic;
  render_rst_o          : out   std_logic;
  i2c_clk_o             : out   std_logic;
  i2c_rst_o             : out   std_logic
);
end clk_rst_gen;


architecture behavioral of clk_rst_gen is
  signal ref_clk                    : std_logic;
  signal pll_rst                    : std_logic;
  signal sys_rst_n                  : std_logic;
  signal game_clk                   : std_logic;
  signal game_rst                   : std_logic;
  signal i2c_clk                    : std_logic;
  signal i2c_rst                    : std_logic;
  signal render_clk                 : std_logic;
  signal render_rst                 : std_logic;
  signal locked                     : std_logic;
  
  
  component rst_bridge
  generic (
    GENERIC_IO_LOGIC : std_logic := '1' -- 1=POSITIVE 0=NEGATIVE
  );
  port ( 
    rst_n_i    : in  std_logic;
    clk_i      : in  std_logic;
    rst_clk_o  : out std_logic
  );
  end component;
  
  component clk_gen
  port ( 
    refclk    : in  std_logic;
    rst       : in  std_logic;
    outclk_0  : out std_logic;
    outclk_1  : out std_logic;
    outclk_2  : out std_logic;
    locked    : out std_logic
  );
  end component;
  
begin
  ref_clk <= ref_clk_i;
  pll_rst <= not pll_rst_n_i;
  sys_rst_n <= sys_rst_n_i;
  ----------------------------------------------------------------------------

  rst_bridge_game_inst : rst_bridge
  port map( 
    rst_n_i                 => sys_rst_n and locked,
    clk_i                   => game_clk,
    rst_clk_o               => game_rst
  );
 
  rst_bridge_i2c_inst : rst_bridge
  port map( 
    rst_n_i                 => sys_rst_n and locked,
    clk_i                   => i2c_clk,
    rst_clk_o               => i2c_rst
  );
 
  rst_bridge_render_inst : rst_bridge
  port map( 
    rst_n_i                 => sys_rst_n and locked,
    clk_i                   => render_clk,
    rst_clk_o               => render_rst
  ); 
  

  ----------------------------------------------------------------------------
  clk_gen_inst : clk_gen
  port map( 
    refclk    => ref_clk,
    rst       => pll_rst,
    outclk_0  => game_clk,
    outclk_1  => i2c_clk,
    outclk_2  => render_clk,
    locked    => locked
  );
  -----------------------------------------------------------------------------
  --Assign outputs
  game_clk_o <= game_clk;
  game_rst_o <= game_rst;
  i2c_clk_o <= i2c_clk;
  i2c_rst_o <= i2c_rst;
  render_clk_o <= render_clk;
  render_rst_o <= render_rst;
end behavioral;

