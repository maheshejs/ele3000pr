library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;
entity shift_reg is
    port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        load_i                : in    std_logic;
        din_i                 : in    std_logic;
        dout_o                : out   std_logic_vector(3 downto 0)
    );
end shift_reg;


architecture behavioral of shift_reg is
    signal dout_reg           : std_logic_vector(3 downto 0);
begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (rst_i = '1') then
               dout_reg <= (others=>'0');
            elsif (load_i = '1') then
               dout_reg <= dout_reg(2 downto 0) & din_i;
            end if;
        end if;
    end process;
    dout_o <= dout_reg;
end behavioral;