-- Quartus Prime VHDL Template
-- Simple Dual-Port RAM with different read/write addresses but
-- single read/write clock

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;
entity dp_ram is
  port 
  (
    clk_i       : in std_logic;
    raddr_i     : in address;
    waddr_i     : in address;
    wdata_i     : in word;
    wen_i       : in std_logic ;
    rdata_o     : out word
  );

end dp_ram;

architecture rtl of dp_ram is

  -- Build a 2-D array type for the RAM
  type memory_t is array(2**line_size-1 downto 0) of word;
  function init_ram
  return memory_t is 
  variable tmp : memory_t := (others => (others => '0'));
  begin 
    -- 1 0 0 2
    -- 3 3 0 4
    -- 0 0 2 5
    -- 5 5 3 0
    tmp(0) := '0' & X"1";
    tmp(1) := '0' & X"4";
    tmp(2) := '0' & X"2";
    tmp(3) := '0' & X"3";
    
    tmp(4) := '0' & X"4";
    tmp(5) := '0' & X"5";
    tmp(6) := '0' & X"4";
    tmp(7) := '0' & X"6";
    
    tmp(8) := '0' & X"2";
    tmp(9) := '0' & X"6";
    tmp(10) := '0' & X"2";
    tmp(11) := '0' & X"1";
    
    tmp(12) := '0' & X"1";
    tmp(13) := '0' & X"3";
    tmp(14) := '0' & X"1";
    tmp(15) := '0' & X"2";
    return tmp;
  end init_ram;

  -- Declare the RAM signal.  
  signal ram : memory_t := init_ram;

begin

  process(clk_i)
  begin
    if(rising_edge(clk_i)) then 
      if(wen_i = '1') then
        ram(waddr_i) <= wdata_i;
      end if;

      -- On a read during a write to the same address, the read will
      -- return the OLD data at the address
      rdata_o <= ram(raddr_i);
    end if;
  end process;
end rtl;
