library IEEE;
use IEEE.std_logic_1164.all;

entity prbs is
port (
  clk_i                 : in    std_logic;
  rst_i                 : in    std_logic;
  load_prbs_i           : in    std_logic;
  next_prbs_i           : in    std_logic;
  seed_i                : in    std_logic_vector(7 downto 0);
  digit_prbs_o          : out   std_logic
);
end prbs;


architecture behavioral of prbs is
    signal clk          : std_logic;
    signal rst          : std_logic;
    signal prbs7_reg    : std_logic_vector(6 downto 0) := "0101101";
    signal prbs8_reg    : std_logic_vector(7 downto 0) := "10001011";
    signal prbs9_reg    : std_logic_vector(8 downto 0) := "100101101";
begin
    clk <= clk_i;
    rst <= rst_i;
    
PRBS8 : process (clk)
begin
    if rising_edge(clk) then
        if (rst = '1') then
            prbs8_reg <= "10001011";
        elsif(load_prbs_i = '1') then
            prbs8_reg <= seed_i;
        elsif(next_prbs_i = '1') then
            prbs8_reg <= prbs8_reg(6 downto 0) & (prbs8_reg(7) xor prbs8_reg(5) xor prbs8_reg(4) xor prbs8_reg(3));
        end if;
    end if;
end process;

PRBS7 : process (clk)
begin
    if rising_edge(clk) then
        if (rst = '1') then
            prbs7_reg <= "0101101";
        elsif(next_prbs_i = '1') then
            prbs7_reg <= prbs7_reg(5 downto 0) & (prbs7_reg(6) xor prbs7_reg(5));
        end if;
    end if;
end process;

PRBS9 : process (clk)
begin
    if rising_edge(clk) then
        if (rst = '1') then
            prbs9_reg <= "100101101";
        elsif(next_prbs_i = '1') then
            prbs9_reg <= prbs9_reg(7 downto 0) & (prbs9_reg(8) xor prbs9_reg(4));
        end if;
    end if;
end process;

digit_prbs_o  <= prbs9_reg(8) xor prbs8_reg(7) xor prbs7_reg(6);
end behavioral;
