library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity parallel_bubble_sort_tb is
end parallel_bubble_sort_tb;

architecture behavioral of parallel_bubble_sort_tb is 
component parallel_bubble_sort
    port(
        clk : in std_logic;
        x0, x1, x2, x3 : in integer range 0 to 17;
        y0, y1, y2, y3 : out integer range 0 to 17
    );
end component;
--Inputs
    signal clk_tb : std_logic := '0';
    signal x0_tb : integer range 0 to 17 := 0;
    signal x1_tb : integer range 0 to 17 := 0;
    signal x2_tb : integer range 0 to 17 := 0;
    signal x3_tb : integer range 0 to 17 := 0;

--Outputs
    signal y0_tb : integer range 0 to 17;
    signal y1_tb : integer range 0 to 17;
    signal y2_tb : integer range 0 to 17;
    signal y3_tb : integer range 0 to 17;

-- Clock period definitions
    constant clk_period : time := 10 ns;
begin
    uut : parallel_bubble_sort port map (clk_tb, x0_tb, x1_tb, x2_tb, x3_tb, y0_tb, y1_tb, y2_tb, y3_tb);
    clk_process : process
    begin
        clk_tb <= '0';
        wait for clk_period/2;
        clk_tb <= '1';
        wait for clk_period/2;
     end process clk_process;
    stim_process : process
    begin
        x0_tb <= 0;
        x1_tb <= 0;
        x2_tb <= 0;
        x3_tb <= 0;
        wait for clk_period*3;

        --three zeros
        x0_tb <= 0;
        x1_tb <= 0;
        x2_tb <= 0;
        x3_tb <= 1;
        wait for clk_period;
        x0_tb <= 0;
        x1_tb <= 0;
        x2_tb <= 1;
        x3_tb <= 0;
        wait for clk_period;
        x0_tb <= 0;
        x1_tb <= 1;
        x2_tb <= 0;
        x3_tb <= 0;
        wait for clk_period;
        x0_tb <= 1;
        x1_tb <= 0;
        x2_tb <= 0;
        x3_tb <= 0;
        wait for clk_period;

        --two zeros
        x0_tb <= 0;
        x1_tb <= 0;
        x2_tb <= 1;
        x3_tb <= 2;
        wait for clk_period;
        x0_tb <= 0;
        x1_tb <= 1;
        x2_tb <= 0;
        x3_tb <= 2;
        wait for clk_period;
        x0_tb <= 0;
        x1_tb <= 1;
        x2_tb <= 2;
        x3_tb <= 0;
        wait for clk_period;
        x0_tb <= 1;
        x1_tb <= 0;
        x2_tb <= 2;
        x3_tb <= 0;
        wait for clk_period;
        x0_tb <= 1;
        x1_tb <= 2;
        x2_tb <= 0;
        x3_tb <= 0;
        wait for clk_period;
        x0_tb <= 1;
        x1_tb <= 0;
        x2_tb <= 0;
        x3_tb <= 2;
        wait for clk_period;
        
        -- one zero
        x0_tb <= 0;
        x1_tb <= 1;
        x2_tb <= 2;
        x3_tb <= 3;
        wait for clk_period;
        x0_tb <= 1;
        x1_tb <= 0;
        x2_tb <= 2;
        x3_tb <= 3;
        wait for clk_period;
        x0_tb <= 1;
        x1_tb <= 2;
        x2_tb <= 0;
        x3_tb <= 3;
        wait for clk_period;
        x0_tb <= 1;
        x1_tb <= 2;
        x2_tb <= 3;
        x3_tb <= 0;
        wait for clk_period;

        --no zero
        x0_tb <= 1;
        x1_tb <= 2;
        x2_tb <= 3;
        x3_tb <= 4;

        --all zero
        wait for clk_period;
        x0_tb <= 0;
        x1_tb <= 0;
        x2_tb <= 0;
        x3_tb <= 0;
        wait for clk_period;
        wait;
    end process stim_process;
end behavioral;
