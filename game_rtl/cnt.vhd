library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;


entity cnt is
generic (
  WIDTH                 : integer := 2
);
port (
  clk_i                 : in    std_logic;
  rst_i                 : in    std_logic;  -- synchrone
  inc_i                 : in    std_logic;  -- increment
  cnt_o                 : out   std_logic_vector(WIDTH-1 downto 0)
);
end cnt;


architecture behavioral of cnt is

  signal clk                  : std_logic;

  signal cnt_p                : unsigned(WIDTH-1 downto 0) := (others => '0');

  signal cnt_f                : unsigned(WIDTH-1 downto 0);

begin
  clk <= clk_i;

  -- Remise  zro synchrone
  REGISTERED: process(clk)
  begin
    if rising_edge(clk) then
      if (rst_i = '1') then
        cnt_p <= to_unsigned(0, cnt_p'length);
      else
        cnt_p <= cnt_f;
      end if;
    end if;
  end process;


  COMBINATORIAL: process(inc_i, cnt_p)
  begin
    if (inc_i = '1') then
      cnt_f <= cnt_p + 1;
    else
      cnt_f <= cnt_p;
    end if;
  end process;


  -- Assign outputs
  cnt_o <= std_logic_vector(cnt_p);

end behavioral;
