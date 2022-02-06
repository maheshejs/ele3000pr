library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity prbs_tb is
end;

architecture bench of prbs_tb is

  component prbs
  port (
    clk_i                 : in    std_logic;
    load_prbs_i           : in    std_logic;
    next_prbs_i           : in    std_logic;
    seed_i                : in    std_logic_vector(7 downto 0);
    digit_o               : out   std_logic
  );
  end component;

  signal clk_i: std_logic;
  signal load_prbs_i: std_logic;
  signal next_prbs_i: std_logic;
  signal seed_i: std_logic_vector(4 downto 0);
  signal digit_o: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: prbs port map ( clk_i       => clk_i,
                       load_prbs_i => load_prbs_i,
                       next_prbs_i => next_prbs_i,
                       seed_i      => seed_i,
                       digit_o     => digit_o );

  stimulus: process
  begin
  
    -- Put initialisation code here
    seed_i <= (others=>'0');
    next_prbs_i <= '0';
    load_prbs_i <= '0';

    -- Put test bench stimulus code here
    
    wait for clock_period*3;
    next_prbs_i <= '1';
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