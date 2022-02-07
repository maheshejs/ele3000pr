----------------------------------------------------------------------------------
-- POLYTECHNIQUE MONTREAL
-- ELE3311 - Systemes logiques programmables 
-- 
-- Module Name:    dbnc 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dbnc is
  port (
         rst_i                 : in    std_logic;
         clk_i                 : in    std_logic;
         sample_i              : in    std_logic;  -- sample signal should be around 8 kHz
         sig_i                 : in    std_logic;
         dbnc_sig_o            : out   std_logic
       );
end dbnc;


architecture behavioral of dbnc is
  signal rst                  : std_logic;
  signal clk                  : std_logic;
  signal dbnc_reg             : std_logic_vector(7 downto 0);
  signal dbnc_sig             : std_logic;

begin
  rst <= rst_i;
  clk <= clk_i;

  REGISTERED: process(clk)
  begin
    if rising_edge(clk) then
      if (rst='1') then
        dbnc_reg <= (others => '0');
      elsif (sample_i = '1') then
        dbnc_reg <= dbnc_reg(6 downto 0) & sig_i;
      end if;

      if (dbnc_reg = X"FF") then
        dbnc_sig_o <= '1';
      else
        dbnc_sig_o <= '0';
      end if;
    end if; 
  end process;

end behavioral;
