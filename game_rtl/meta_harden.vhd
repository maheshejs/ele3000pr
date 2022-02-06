----------------------------------------------------------------------------------
-- POLYTECHNIQUE MONTREAL
-- ELE3311 - Systemes logiques programmables 
-- 
-- Module Name:    meta_harden 
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

entity meta_harden is	
generic (
  GENERIC_IO_LOGIC : std_logic := '1'; -- 1=POSITIVE 0=NEGATIVE
  WIDTH            : integer   := 1
);
port ( 
  --source clock-domain
  sig_src_i  : in  std_logic_vector(WIDTH-1 downto 0);
  --destination clock-domain 
  rst_dst_i  : in  std_logic;
  clk_dst_i  : in  std_logic;
  sig_dst_o  : out std_logic_vector(WIDTH-1 downto 0)
);
end meta_harden;

architecture arch_meta_harden of meta_harden is

  signal sig_meta : std_logic_vector(WIDTH-1 downto 0);
  signal sig_dst  : std_logic_vector(WIDTH-1 downto 0);
     
begin

  sig_dst_o <= sig_dst;

  resynchronisation: process(clk_dst_i, rst_dst_i)
  begin
    if rst_dst_i='1' then
      sig_meta <= (others => not(GENERIC_IO_LOGIC));
      sig_dst  <= (others => not(GENERIC_IO_LOGIC));
    elsif rising_edge(clk_dst_i) then
      sig_meta <= sig_src_i;
      sig_dst  <= sig_meta;
    end if;
  end process;

end arch_meta_harden;
