-- Quartus Prime VHDL Template
-- Simple Dual-Port RAM with different read/write addresses and
-- different read/write clock

library ieee;
use ieee.std_logic_1164.all;

entity dcdp_ram is

    generic 
    (
        DATA_WIDTH : natural := 5;
        ADDR_WIDTH : natural := 4
    );

    port 
    (
        rclk    : in std_logic;
        wclk    : in std_logic;
        raddr   : in natural range 0 to 2**ADDR_WIDTH - 1;
        waddr   : in natural range 0 to 2**ADDR_WIDTH - 1;
        data    : in std_logic_vector((DATA_WIDTH-1) downto 0);
        we      : in std_logic := '1';
        q       : out std_logic_vector((DATA_WIDTH -1) downto 0)
    );

end dcdp_ram;

architecture rtl of dcdp_ram is

    -- Build a 2-D array type for the RAM
    subtype word is std_logic_vector(DATA_WIDTH - 1 downto 0);
    type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word;
    function init_ram
        return memory_t is 
        variable tmp : memory_t := (others => (others => '0'));
    begin 
        -- 1 0 0 2
        -- 3 3 0 4
        -- 0 0 2 5
        -- 5 5 3 0
        tmp(0) := '0' & X"1";
        tmp(1) := '0' & X"0";
        tmp(2) := '0' & X"0";
        tmp(3) := '0' & X"2";
        
        tmp(4) := '0' & X"3";
        tmp(5) := '0' & X"3";
        tmp(6) := '0' & X"0";
        tmp(7) := '0' & X"4";
        
        tmp(8) := '0' & X"0";
        tmp(9) := '0' & X"0";
        tmp(10) := '0' & X"2";
        tmp(11) := '0' & X"5";
        
        tmp(12) := '0' & X"5";
        tmp(13) := '0' & X"5";
        tmp(14) := '0' & X"3";
        tmp(15) := '0' & X"0";
        return tmp;
    end init_ram;

    -- Declare the RAM signal.  
    signal ram : memory_t := init_ram;

begin

    process(wclk)
    begin
    if(rising_edge(wclk)) then 
        if(we = '1') then
            ram(waddr) <= data;
        end if;
    end if;
    end process;

    process(rclk)
    begin
    if(rising_edge(rclk)) then 
        q <= ram(raddr);
    end if;
    end process;

end rtl;
