library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity spawnram_tb is
end;

architecture bench of spawnram_tb is

  component spawnram
  port (
    clk_i                 : in    std_logic;
    rst_i                 : in    std_logic;
    start_i               : in    std_logic;
    done_o                : out   std_logic
  );
  end component;

  signal clk_i: std_logic;
  signal rst_i: std_logic;
  signal start_i: std_logic;
  signal done_o: std_logic ;
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: spawnram port map ( clk_i   => clk_i,
                           rst_i   => rst_i,
                           start_i => start_i,
                           done_o  => done_o );

  stimulus: process
  begin
  
    -- Put initialisation code here
        rst_i <= '1';
        start_i <= '0';

    -- Put test bench stimulus code here
        wait for clock_period*3;
        rst_i <= '0';
        start_i <= '1';
        wait for clock_period;
        start_i <= '0';
        wait until done_o = '1';
        wait for clock_period/2;
        wait for clock_period;
        start_i <= '1';
        wait for clock_period;
        start_i <= '0';
        wait for clock_period;
        stop_the_clock <= false;
    wait;
  end process;
  
  clocking: process
  begin
    while not stop_the_clock loop
      clk_i <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;