library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;
entity tiles_zero is
port (
  clk_i                 : in    std_logic;
  rst_i                 : in    std_logic;
  start_i               : in    std_logic;
  rdata_i               : in    word;
  raddr_o               : out   address;
  waddr_o               : out   address;
  wdata_o               : out   word;
  wen_o                 : out   std_logic ;
  done_o                : out   std_logic
);
end tiles_zero;


architecture behavioral of tiles_zero is
    type state is (ZERO, TEST, INIT);
    signal wen_p       : std_logic;
    signal waddr_p     : address;
    signal t1_p        : std_logic;
    signal done_p      : std_logic;
    signal cnt_p       : std_logic_vector(3 downto 0);
    
    signal wen_f       : std_logic;
    signal waddr_f     : address;
    signal t1_f        : std_logic;
    signal done_f      : std_logic;
    signal cnt_f       : std_logic_vector(3 downto 0);
    
    signal state_p, state_f        : state ;
begin
    REGISTERED: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (rst_i = '1') then
                state_p         <= INIT;
                done_p          <= '0';
                waddr_p         <= 0;
                wen_p           <= '0';
                t1_p            <= '0';
                cnt_p           <= (others=>'0');
            else
                state_p         <= state_f;
                done_p          <= done_f;
                waddr_p         <= waddr_f;
                wen_p           <= wen_f;
                t1_p            <= t1_f;
                cnt_p           <= cnt_f;
            end if;
        end if;
    end process;

    COMBINATORIAL : process(state_p, waddr_p, wen_p, done_p, t1_p, cnt_p, start_i)
    begin
        state_f         <= state_p;
        done_f          <= done_p;
        waddr_f         <= waddr_p;
        wen_f           <= wen_p;
        t1_f            <= t1_p;
        cnt_f           <= cnt_p;
        case state_p is
            when INIT =>
                done_f <= '0';
                if (start_i = '1') then
                    state_f <= ZERO;
                    cnt_f <= (others=>'0');
                    waddr_f <= 0;
                    wen_f <= '1';
                end if;
            when ZERO =>
                state_f <= TEST;
                wen_f <= '0';
                cnt_f <= std_logic_vector(unsigned(cnt_p) + 1);
                if cnt_p /= std_logic_vector(to_unsigned(2**line_size - 1, cnt_p'length)) then
                    t1_f <= '1';
                else
                    t1_f <= '0';
                end if;
            when TEST =>
                if t1_p = '1' then
                    state_f <= ZERO;
                    wen_f <= '1';
                    waddr_f <= to_integer(unsigned(cnt_p));
                else
                    state_f <= INIT;
                    done_f <= '1';
                end if;
        end case;
    end process;
-- glue logic
  raddr_o               <= 0;
  waddr_o               <= waddr_p;
  wdata_o               <= "00000";
  wen_o                 <= wen_p;
  done_o                <= done_p;
end behavioral;
