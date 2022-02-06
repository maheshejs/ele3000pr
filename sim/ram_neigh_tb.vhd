library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

library WORK;
use WORK.game_defs.all;
entity ram_neigh_tb is
end;

architecture bench of ram_neigh_tb is

  component ram_neigh
  port (
          clk_i                 : in    std_logic;
          rst_i                 : in    std_logic;
          start_i               : in    std_logic;
          found_neigh_o           : out   std_logic;
          done_o                : out   std_logic
  );
  end component;

  signal clk_i: std_logic;
  signal rst_i: std_logic;
  signal start_i: std_logic;
--  signal tile_value_i: word;
--  signal tile_addr_i: address;
  signal found_neigh_o: std_logic;
  signal done_o: std_logic ;
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean := false;

begin

  uut: ram_neigh port map ( clk_i        => clk_i,
                            rst_i        => rst_i,
                            start_i      => start_i,
                            found_neigh_o  => found_neigh_o,
                            done_o       => done_o );

  stimulus: process
  begin
  
    -- Put initialisation code here
    rst_i <= '1';
    wait for clock_period*2;
    rst_i <= '0';
    -- Put test bench stimulus code here
    start_i <= '1';
--    tile_value_i <= '0' & X"1";
--    tile_addr_i <= 0;
    wait until done_o = '1';
    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--    start_i <= '1';
--    tile_value_i <= '0' & X"1";
--    tile_addr_i <= 1;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--    start_i <= '1';
--    tile_value_i <= '0' & X"4";
--    tile_addr_i <= 2;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--    start_i <= '1';
--    tile_value_i <= '0' & X"2";
--    tile_addr_i <= 3;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--        start_i <= '1';
--    tile_value_i <= '0' & X"6";
--    tile_addr_i <= 4;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--    start_i <= '1';
--    tile_value_i <= '0' & X"5";
--    tile_addr_i <= 5;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--    start_i <= '1';
--    tile_value_i <= '0' & X"4";
--    tile_addr_i <= 6;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--    start_i <= '1';
--    tile_value_i <= '0' & X"2";
--    tile_addr_i <= 7;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--    start_i <= '1';
--    tile_value_i <= '0' & X"6";
--    tile_addr_i <= 8;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--    start_i <= '1';
--    tile_value_i <= '0' & X"3";
--    tile_addr_i <= 9;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--    start_i <= '1';
--    tile_value_i <= '0' & X"2";
--    tile_addr_i <= 10;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--    start_i <= '1';
--    tile_value_i <= '0' & X"2";
--    tile_addr_i <= 11;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--        start_i <= '1';
--    tile_value_i <= '0' & X"3";
--    tile_addr_i <= 12;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--    start_i <= '1';
--    tile_value_i <= '0' & X"6";
--    tile_addr_i <= 13;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--    start_i <= '1';
--    tile_value_i <= '0' & X"2";
--    tile_addr_i <= 14;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
--    
--    start_i <= '1';
--    tile_value_i <= '0' & X"4";
--    tile_addr_i <= 15;
--    wait until done_o = '1';
--    wait for clock_period/2;
--    start_i <= '0';
--    wait for clock_period*2;
    
    stop_the_clock <= true;
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