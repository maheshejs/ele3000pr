-- Quartus Prime VHDL Template
-- Simple Dual-Port RAM with different read/write addresses and
-- different read/write clock

library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;


entity tiles_ram is
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
end tiles_ram;

architecture rtl of tiles_ram is

    -- Build a 2-D array type for the RAM
    type memory_t is array(2**line_size-1 downto 0) of word;

    -- Declare the RAM signal.  
    signal ram : memory_t;

begin
    process(wclk_i)
    begin
    if(rising_edge(wclk_i)) then 
        if(wen_i = '1') then
            ram(waddr_i) <= wdata_i;
        end if;
    end if;
    end process;

    process(rclk_i)
    begin
    if(rising_edge(rclk_i)) then 
        rdata_o <= ram(raddr_i);
    end if;
    end process;
end rtl;
