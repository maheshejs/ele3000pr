library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
library WORK;
use WORK.game_defs.all;
entity game_test_tb is
end;

architecture bench of game_test_tb is

  component game_test
  port (
    rst_n_i               : in    std_logic;
    clk_i                 : in    std_logic;
    start_game_i          : in    std_logic;
    btn_i                 : in    std_logic_vector(3 downto 0);
    done_o                : out   std_logic
  );
  end component;

  signal rst_n_i: std_logic;
  signal clk_i: std_logic;
  signal start_game_i: std_logic;
  signal btn_i: std_logic_vector(3 downto 0);
  signal done_o: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean := false;

begin

  uut: game_test port map ( rst_n_i      => rst_n_i,
                            clk_i        => clk_i,
                            start_game_i => start_game_i,
                            btn_i        => btn_i,
                            done_o       => done_o );

  stimulus: process
  begin
  
    -- Put initialisation code here
     rst_n_i <= '0';
     start_game_i <= '0';
     btn_i <= "0000";

    -- Put test bench stimulus code here
    wait for clock_period*4;
    rst_n_i <= '1';
    wait for clock_period*2;
    start_game_i <= '1';
    wait for clock_period*3;
    start_game_i <= '0';
    btn_i <= "1000";
    
    wait until done_o = '1';
    wait for clock_period/2;
    btn_i <= "0100";
    wait for clock_period*2;
    start_game_i <= '1';
    wait for clock_period*3;
    start_game_i <= '0';
    
    wait until done_o = '1';
    wait for clock_period/2;
    btn_i <= "0010";
    wait for clock_period*2;
    start_game_i <= '1';
    wait for clock_period*3;
    start_game_i <= '0';
    
    wait until done_o = '1';
    wait for clock_period/2;
    btn_i <= "0001";
    wait for clock_period*2;
    start_game_i <= '1';
    wait for clock_period*3;
    start_game_i <= '0';
    
    wait until done_o = '1';
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