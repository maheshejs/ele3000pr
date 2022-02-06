library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
library std;
use std.textio.all;
entity choice_tb is
end;

architecture bench of choice_tb is

  component choice
  port (
    clk_i                 : in    std_logic;
    rst_i                 : in    std_logic;
    start_i               : in    std_logic;
    upper_i               : in    std_logic_vector(3 downto 0);
    result_o              : out   std_logic_vector(3 downto 0);
    done_o                : out   std_logic
  );
  end component;

  signal clk_i: std_logic;
  signal rst_i: std_logic;
  signal start_i: std_logic;
  signal upper_i: std_logic_vector(3 downto 0);
  signal result_o: std_logic_vector(3 downto 0);
  signal done_o: std_logic ;
  signal    linenumber : integer:=1;
  signal endoffile : bit := '0';

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;
begin

  uut: choice port map ( clk_i    => clk_i,
                         rst_i    => rst_i,
                         start_i  => start_i,
                         upper_i  => upper_i,
                         result_o => result_o,
                         done_o   => done_o );


writing :
process
    file      outfile  : text is out "fifteens.txt";  --declare output file
    variable  outline  : line;   --line number declaration  
    variable  res : integer;
begin
wait until done_o = '1';
if(endoffile='0') then   --if the file end is not reached.
--write(linenumber,value(real type),justified(side),field(width),digits(natural));
res := to_integer(unsigned(result_o));
write(outline, res, right, 1);
-- write line to external file.
writeline(outfile, outline);
linenumber <= linenumber + 1;
else
null;
end if;
end process writing;
  stimulus: process
  begin
  
    -- Put initialisation code here
    rst_i <= '1';
    start_i <= '0';
    upper_i <= X"F";

    -- Put test bench stimulus code here
    wait for clock_period * 3;
    rst_i <= '0';
    start_i <= '1';
--    wait for clock_period * 3;
--    start_i <= '0';
--    wait until done_o = '1';
--    wait for clock_period/2;
--    wait for clock_period;
--    upper_i <= X"4";
--    start_i <= '1';
--    wait for clock_period * 3;
--    start_i <= '0';
--    wait until done_o = '1';
--    wait for clock_period/2;
--    wait for clock_period;
--    upper_i <= X"2";
--    start_i <= '1';
--    wait for clock_period * 3;
--    start_i <= '0';
--    wait until done_o = '1';
--    wait for clock_period/2;
--    wait for clock_period ;
--    upper_i <= X"7";
--    start_i <= '1';
--    wait for clock_period * 3;
--    start_i <= '0';
--    wait until done_o = '1';
--    wait for clock_period/2;
--    wait for clock_period ;
--    upper_i <= X"3";
--    start_i <= '1';
--    wait for clock_period * 3;
--    start_i <= '0';
--    wait until done_o = '1';
--    wait for clock_period/2;
--    wait for clock_period;
--    upper_i <= X"F";
--    start_i <= '1';
--    wait for clock_period * 3;
--    start_i <= '0';
--    wait until done_o = '1';
--    wait for clock_period/2;
--    wait for clock_period ;
--    upper_i <= X"1";
--    start_i <= '1';
--    wait for clock_period * 3;
--    start_i <= '0';
--    wait until done_o = '1';
--    wait for clock_period/2;
--    wait for clock_period ;
--    upper_i <= X"6";
--    start_i <= '1';
--    wait for clock_period * 3;
--    start_i <= '0';
--    wait until done_o = '1';
--    wait for clock_period/2;
--    wait for clock_period;
--    upper_i <= X"D";
--    start_i <= '1';
--    wait for clock_period * 3;
--    start_i <= '0';
--    wait until done_o = '1';
--    wait for clock_period/2;
--    wait for clock_period;
--    upper_i <= X"3";
--    start_i <= '1';
--    wait for clock_period * 3;
--    start_i <= '0';
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