library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
library WORK;
use WORK.game_defs.all;
entity slider_tb is
end;

architecture bench of slider_tb is

  component slider
      port (
          clk_i                 : in    std_logic;
          rst_i                 : in    std_logic;
          start_i               : in    std_logic;
          dir_i                 : in    std_logic;
          line_i                : in    line_word;
          line_o                : out   line_word;
          done_o                : out   std_logic
      );
  end component;

  signal clk_i: std_logic;
  signal rst_i: std_logic;
  signal start_i: std_logic;
  signal dir_i: std_logic;
  signal line_i: line_word;
  signal line_o: line_word;
  signal done_o: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: slider port map ( clk_i   => clk_i,
                         rst_i   => rst_i,
                         start_i => start_i,
                         dir_i   => dir_i,
                         line_i  => line_i,
                         line_o  => line_o,
                         done_o  => done_o );

  stimulus: process
  begin
  
    -- Put initialisation code here
        rst_i <= '1';
        dir_i <= '1';
        start_i <= '1';

    -- Put test bench stimulus code here
        wait for clock_period*3;
        rst_i <= '0';
        start_i <= '1';
        line_i(3) <= '0'&X"0";
        line_i(2) <= '0'&X"0";
        line_i(1) <= '0'&X"0";
        line_i(0) <= '0'&X"0";
        wait until done_o = '1';
        wait for clock_period/2;

        --three zeros
        line_i(3) <= '0'&X"0";
        line_i(2) <= '0'&X"0";
        line_i(1) <= '0'&X"0";
        line_i(0) <= '0'&X"1";
        wait until done_o = '1';
        wait for clock_period/2;
        line_i(3) <= '0'&X"0";
        line_i(2) <= '0'&X"0";
        line_i(1) <= '0'&X"1";
        line_i(0) <= '0'&X"0";
        wait until done_o = '1';
        wait for clock_period/2;
        line_i(3) <= '0'&X"0";
        line_i(2) <= '0'&X"1";
        line_i(1) <= '0'&X"0";
        line_i(0) <= '0'&X"0";
        wait until done_o = '1';
        wait for clock_period/2;
        line_i(3) <= '0'&X"1";
        line_i(2) <= '0'&X"0";
        line_i(1) <= '0'&X"0";
        line_i(0) <= '0'&X"0";
        wait until done_o = '1';
        wait for clock_period/2;

        --two zeros
        line_i(3) <= '0'&X"0";
        line_i(2) <= '0'&X"0";
        line_i(1) <= '0'&X"1";
        line_i(0) <= '0'&X"2";
        wait until done_o = '1';
        wait for clock_period/2;
        line_i(3) <= '0'&X"0";
        line_i(2) <= '0'&X"1";
        line_i(1) <= '0'&X"0";
        line_i(0) <= '0'&X"2";
        wait until done_o = '1';
        wait for clock_period/2;
        line_i(3) <= '0'&X"0";
        line_i(2) <= '0'&X"1";
        line_i(1) <= '0'&X"2";
        line_i(0) <= '0'&X"0";
        wait until done_o = '1';
        wait for clock_period/2;
        line_i(3) <= '0'&X"1";
        line_i(2) <= '0'&X"0";
        line_i(1) <= '0'&X"2";
        line_i(0) <= '0'&X"0";
        wait until done_o = '1';
        wait for clock_period/2;
        line_i(3) <= '0'&X"1";
        line_i(2) <= '0'&X"2";
        line_i(1) <= '0'&X"0";
        line_i(0) <= '0'&X"0";
        wait until done_o = '1';
        wait for clock_period/2;
        line_i(3) <= '0'&X"1";
        line_i(2) <= '0'&X"0";
        line_i(1) <= '0'&X"0";
        line_i(0) <= '0'&X"2";
        wait until done_o = '1';
        wait for clock_period/2;
        
        -- one zero
        line_i(3) <= '0'&X"0";
        line_i(2) <= '0'&X"1";
        line_i(1) <= '0'&X"2";
        line_i(0) <= '0'&X"3";
        wait until done_o = '1';
        wait for clock_period/2;
        line_i(3) <= '0'&X"1";
        line_i(2) <= '0'&X"0";
        line_i(1) <= '0'&X"2";
        line_i(0) <= '0'&X"3";
        wait until done_o = '1';
        wait for clock_period/2;
        line_i(3) <= '0'&X"1";
        line_i(2) <= '0'&X"2";
        line_i(1) <= '0'&X"0";
        line_i(0) <= '0'&X"3";
        wait until done_o = '1';
        wait for clock_period/2;
        line_i(3) <= '0'&X"1";
        line_i(2) <= '0'&X"2";
        line_i(1) <= '0'&X"3";
        line_i(0) <= '0'&X"0";
        wait until done_o = '1';
        wait for clock_period/2;

        --no zero
        line_i(3) <= '0'&X"1";
        line_i(2) <= '0'&X"2";
        line_i(1) <= '0'&X"3";
        line_i(0) <= '0'&X"4";

        --all zero
        wait until done_o = '1';
        wait for clock_period/2;
        line_i(3) <= '0'&X"0";
        line_i(2) <= '0'&X"0";
        line_i(1) <= '0'&X"0";
        line_i(0) <= '0'&X"0";
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