library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;
entity line_reader is
    port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        start_i               : in    std_logic;
        mode_i                : in    std_logic;
        rdata_i               : in    word;
        no_line_i             : in    std_logic_vector(1 downto 0);
        raddr_o               : out   address;
        line_o                : out   line_word;
        done_o                : out   std_logic
    );
end line_reader;


architecture behavioral of line_reader is
    type state is (B1, B12, B2, INIT);
    signal line_p      : line_word;
    signal done_p      : std_logic;
    signal no_line_p   : std_logic_vector(1 downto 0);
    signal no_col_p    : std_logic_vector(1 downto 0);
    signal raddr_p     : address;
    signal t1_p        : std_logic;

    signal line_f      : line_word;
    signal done_f      : std_logic;
    signal no_line_f   : std_logic_vector(1 downto 0);
    signal no_col_f    : std_logic_vector(1 downto 0);
    signal raddr_f     : address;
    signal t1_f        : std_logic;

    signal state_p, state_f        : state ;
begin
    REGISTERED: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (rst_i = '1') then
                state_p     <= INIT;
                line_p      <= (others => (others => '0'));
                done_p      <= '0';
                no_line_p   <= (others=>'0');
                no_col_p    <= (others=>'0');
                raddr_p     <= 0;
                t1_p        <= '0';
            else
                state_p     <= state_f;
                line_p      <= line_f;
                done_p      <= done_f;
                no_line_p   <= no_line_f;
                no_col_p    <= no_col_f;
                raddr_p     <= raddr_f;
                t1_p        <= t1_f;
            end if;
        end if;
    end process;

    COMBINATORIAL : process(state_p, line_p, done_p, no_line_p, no_col_p, raddr_p, t1_p,
                            start_i, mode_i, rdata_i, no_line_i)
    begin
        state_f         <= state_p;
        done_f          <= done_p;
        line_f          <= line_p;
        no_line_f       <= no_line_p;
        no_col_f        <= no_col_p;
        raddr_f         <= raddr_p;
        t1_f            <= t1_p;
        case state_p is
            when INIT =>
                done_f <= '0';
                if (start_i = '1') then
                    state_f <= B1;
                    no_line_f <= no_line_i;
                    no_col_f <= (others=>'0');
                    raddr_f <= to_integer(unsigned(get_addr("00", no_line_i, mode_i)));
                end if;
            when B1 =>
                state_f <= B12;
            when B12 =>
                state_f <= B2;
                line_f(to_integer(3 - unsigned(no_col_p))) <= rdata_i;
                no_col_f <= std_logic_vector(unsigned(no_col_p) + 1);
                if no_col_p /= std_logic_vector(to_unsigned(line_size - 1, no_col_p'length)) then
                    t1_f <= '1';
                else
                    t1_f <= '0';
                end if;
            when B2 =>
                if t1_p = '1' then
                    state_f <= B1;
                    raddr_f <= to_integer(unsigned(get_addr(no_col_p, no_line_p, mode_i)));
                else
                    state_f <= INIT;
                    done_f <= '1';
                end if;
        end case;
    end process;
-- glue logic

-- outputs
    line_o       <= line_p;
    done_o       <= done_p;
    raddr_o      <= raddr_p;
end behavioral;