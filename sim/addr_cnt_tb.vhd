library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity addr_cnt_tb is
end addr_cnt_tb;

architecture behavioral of addr_cnt_tb  is 
component addr_cnt
    port(
        clk : in std_logic;
      start : in std_logic;
      mode : in std_logic;
      rst : in std_logic;
      addr : out std_logic_vector (3 downto 0);
      done : out std_logic
    );
end component;

component single_port_ram 

  generic 
  (
    DATA_WIDTH : natural := 5;
    ADDR_WIDTH : natural := 4
  );

  port 
  (
    clk_i    : in std_logic;
    addr_i  : in natural range 0 to 2**ADDR_WIDTH - 1;
    data_i  : in std_logic_vector((DATA_WIDTH-1) downto 0);
    we_i    : in std_logic ;
    q_o    : out std_logic_vector((DATA_WIDTH -1) downto 0)
  );

end component;

component game
port (
  clk_i                 : in    std_logic;
  rst_i                 : in    std_logic;
  inputs_i              : in    std_logic_vector(3 downto 0);
  done_o                : out   std_logic
);
end component;
--Inputs
    signal clk_tb : std_logic := '0';
   signal rst_tb :   std_logic;
   signal inputs_tb : std_logic_vector(3 downto 0);

--Outputs
   signal done_tb :   std_logic;

-- Clock period definitions
    constant clk_period : time := 10 ns;
begin
  uut : game port map (
    clk_i                 => clk_tb,
    rst_i                 => rst_tb,
    inputs_i              => inputs_tb,
    done_o                => done_tb
  );
    clk_process : process
    begin
        clk_tb <= '0';
        wait for clk_period/2;
        clk_tb <= '1';
        wait for clk_period/2;
     end process clk_process;
    stim_process : process
    begin
   rst_tb <= '1';
   wait for clk_period*5;
    rst_tb <= '0';
   wait for clk_period;
   inputs_tb <= "0010";
   wait for clk_period*3;
    inputs_tb <= "0000";
   
   wait for clk_period; 
   wait;
   
   
--   data_tb <= "00000";
--   WAIT FOR clk_period;
--   we_tb <= '1';
--   for i in 0 to 15 loop
--    
--    addr_tb_2 <= i;
--    data_tb <= STD_LOGIC_VECTOR (unsigned(data_tb) + 1);
--    
--    WAIT FOR clk_period;
--    
--  END LOOP;
--  we_tb <= '0';
--  WAIT FOR clk_period*2;
--  
--  for i in 0 to 15 loop
--    
--    addr_tb_2 <= i;
--    
--    WAIT FOR clk_period;
--    
--  END LOOP;
   
   
   
   
--        rst_tb <= '1';
--        wait for clk_period*5;
--      rst_tb <= '0';
--      
--      mode_tb <= '1';
--        start_tb <= '1';
--      wait for clk_period;
--      wait until done_tb = '1';
--      wait for clk_period/2;
--      mode_tb <= '0';
--      wait until done_tb = '1';
--      wait for clk_period/2;
--      start_tb <= '0';
--      wait for clk_period;
--      rst_tb <= '0';
--        wait for clk_period;
--        wait;
    end process stim_process;
end behavioral;
