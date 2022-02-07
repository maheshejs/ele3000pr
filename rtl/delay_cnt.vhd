----------------------------------------------------------------------------------
-- POLYTECHNIQUE MONTREAL
-- ELE3311 - Systemes logiques programmables 
-- 
-- Module Name:    delay_cnt 
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

entity delay_cnt is
  generic (
            COUNT_VAL             : unsigned(13 downto 0) := to_unsigned(12500, 14)
          );
  port (
         rst_i                 : in    std_logic;
         clk_i                 : in    std_logic;
         start_delay_i         : in    std_logic;
         end_delay_o           : out   std_logic
       );
end delay_cnt;


architecture behavioral of delay_cnt is

  signal rst                   : std_logic;
  signal clk                   : std_logic;

  signal delay_cnt_p           : unsigned(13 downto 0);
  signal end_delay_p           : std_logic;

  signal delay_cnt_f           : unsigned(13 downto 0);
  signal end_delay_f           : std_logic;

begin
  rst <= rst_i;
  clk <= clk_i;


  REGISTERED: process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        delay_cnt_p   <= (1 => '1', others => '0');
        end_delay_p   <= '0';
      else
        delay_cnt_p   <= delay_cnt_f;
        end_delay_p   <= end_delay_f;
      end if;
    end if;
  end process;


  COMBINATORIAL: process(start_delay_i, delay_cnt_p)
  begin
    if (start_delay_i = '1') then
      delay_cnt_f <= COUNT_VAL;
    elsif (delay_cnt_p /= 0) then
      delay_cnt_f   <= delay_cnt_p - 1;
    else
      delay_cnt_f   <= delay_cnt_p;
    end if;

    if (delay_cnt_p = 1) then
      -- activate for 1 cycle
      end_delay_f   <= '1';
    else
      end_delay_f   <= '0';
    end if;
  end process;


  -- Assign outputs
  end_delay_o <= end_delay_p;

end behavioral;
