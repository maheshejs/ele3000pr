library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
library WORK;
use WORK.game_defs.all;
entity slirge_tb is
end;

architecture bench of slirge_tb is

  component slirge
      port (
          clk_i                 : in    std_logic;
          rst_i                 : in    std_logic;
          dir_i                 : in    std_logic;
          mode_i                : in    std_logic;
          start_i               : in    std_logic;
          done_o                : out   std_logic;
          slide_o               : out   std_logic;
          merge_o               : out   std_logic
      );
  end component;

  signal clk_i: std_logic;
  signal rst_i: std_logic;
  signal dir_i: std_logic;
  signal start_i: std_logic;
  signal mode_i: std_logic;
  signal done_o: std_logic;
  signal slide_o: std_logic;
  signal merge_o: std_logic;
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;


begin

  uut: slirge port map ( clk_i    => clk_i,
                         rst_i    => rst_i,
                         dir_i    => dir_i,
                         start_i  => start_i,
                         mode_i   => mode_i,
                         done_o   => done_o,
                         slide_o => slide_o,
                         merge_o => merge_o);

  stimulus: process
  begin
  
    -- Put initialisation code here
        rst_i <= '1';
        dir_i <= '0';
        mode_i <= '0';
        start_i <= '0';

    -- Put test bench stimulus code here
        wait for clock_period*2;
        rst_i <= '0';
        start_i <= '1';
        wait for clock_period*2;
        start_i <= '0';
--        
--        rst_i <= '0';
--        start_i <= '1';
--        line_i(3) <= '0'&X"0";
--        line_i(2) <= '0'&X"0";
--        line_i(1) <= '0'&X"0";
--        line_i(0) <= '0'&X"0";
--        wait for clock_period;
--        start_i <= '0';
--        wait until done_o = '1';
--        wait for clock_period/2;
--        wait for clock_period*2;
--
--        --three zeros
--        start_i <= '1';
--        line_i(3) <= '0'&X"0";
--        line_i(2) <= '0'&X"1";
--        line_i(1) <= '0'&X"0";
--        line_i(0) <= '0'&X"1";
--        wait for clock_period;
--        start_i <= '0';
--        wait until done_o = '1';
--        wait for clock_period/2;
--        wait for clock_period*2;
--        start_i <= '1';
--        line_i(3) <= '0'&X"1";
--        line_i(2) <= '0'&X"0";
--        line_i(1) <= '0'&X"1";
--        line_i(0) <= '0'&X"2";
--        wait for clock_period;
--        start_i <= '0';
--        wait until done_o = '1';
--        wait for clock_period/2;
--        wait for clock_period*2;
--        start_i <= '1';
--        line_i(3) <= '0'&X"0";
--        line_i(2) <= '0'&X"1";
--        line_i(1) <= '0'&X"0";
--        line_i(0) <= '0'&X"0";
--        wait for clock_period;
--        start_i <= '0';
--        wait until done_o = '1';
--        wait for clock_period/2;
--        wait for clock_period*2;
--        start_i <= '1';
--        line_i(3) <= '0'&X"1";
--        line_i(2) <= '0'&X"2";
--        line_i(1) <= '0'&X"2";
--        line_i(0) <= '0'&X"1";
--        wait for clock_period;
--        start_i <= '0';
--        wait until done_o = '1';
--        wait for clock_period/2;
--        wait for clock_period*2;
--        --two zeros
--        start_i <= '1';
--        line_i(3) <= '0'&X"1";
--        line_i(2) <= '0'&X"1";
--        line_i(1) <= '0'&X"1";
--        line_i(0) <= '0'&X"2";
--        wait for clock_period;
--        start_i <= '0';
--        wait until done_o = '1';
--        wait for clock_period/2;
--        wait for clock_period*2;
--        start_i <= '1';
--        line_i(3) <= '0'&X"1";
--        line_i(2) <= '0'&X"0";
--        line_i(1) <= '0'&X"2";
--        line_i(0) <= '0'&X"2";
--        wait for clock_period;
--        start_i <= '0';
--        wait until done_o = '1';
--        wait for clock_period/2;
--        wait for clock_period*2;
--        start_i <= '1';
--        line_i(3) <= '0'&X"1";
--        line_i(2) <= '0'&X"1";
--        line_i(1) <= '0'&X"2";
--        line_i(0) <= '0'&X"2";
--        wait for clock_period;
--        start_i <= '0';
--        wait until done_o = '1';
--        wait for clock_period/2;
--        wait for clock_period*2;
--        start_i <= '1';
--        line_i(3) <= '0'&X"4";
--        line_i(2) <= '0'&X"0";
--        line_i(1) <= '0'&X"2";
--        line_i(0) <= '0'&X"4";
--        wait for clock_period;
--        start_i <= '0';
--        wait until done_o = '1';
--        wait for clock_period/2;
--        wait for clock_period*2;
--        start_i <= '1';
--        line_i(3) <= '0'&X"3";
--        line_i(2) <= '0'&X"9";
--        line_i(1) <= '0'&X"0";
--        line_i(0) <= '0'&X"9";
--        wait for clock_period;
--        start_i <= '0';
--        wait until done_o = '1';
--        wait for clock_period/2;
--        wait for clock_period*2;
--        start_i <= '1';
--        line_i(3) <= '0'&X"1";
--        line_i(2) <= '0'&X"0";
--        line_i(1) <= '0'&X"2";
--        line_i(0) <= '0'&X"2";
--        wait for clock_period;
--        start_i <= '0';
--        wait until done_o = '1';
--        wait for clock_period/2;
--        wait for clock_period*2;
--        
--        -- one zero
--        start_i <= '1';
--        line_i(3) <= '0'&X"0";
--        line_i(2) <= '0'&X"1";
--        line_i(1) <= '0'&X"2";
--        line_i(0) <= '0'&X"3";
--        wait for clock_period;
--        start_i <= '0';
--        wait until done_o = '1';
--        wait for clock_period/2;
--        wait for clock_period*2;
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