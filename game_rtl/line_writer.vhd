library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;
entity line_writer is
    port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        start_i               : in    std_logic;
        mode_i                : in    std_logic;
        line_i                : in    line_word;
        no_line_i             : in    std_logic_vector(1 downto 0);
        waddr_o               : out   address;
        wdata_o               : out   word;
        wen_o                 : out   std_logic;
        done_o                : out   std_logic
    );
end line_writer;


architecture behavioral of line_writer is
    type state is (B1, B2, INIT);
    signal wdata_p     : word;
    signal done_p      : std_logic;
    signal wen_p       : std_logic;
    signal no_line_p   : std_logic_vector(1 downto 0);
    signal no_col_p    : std_logic_vector(1 downto 0);
    signal waddr_p     : address;
    signal t1_p        : std_logic;

    signal wdata_f     : word;
    signal done_f      : std_logic;
    signal wen_f       : std_logic;
    signal no_line_f   : std_logic_vector(1 downto 0);
    signal no_col_f    : std_logic_vector(1 downto 0);
    signal waddr_f     : address;
    signal t1_f        : std_logic;

    signal state_p, state_f        : state ;
begin
    REGISTERED: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (rst_i = '1') then
                state_p     <= INIT;
                wdata_p     <= (others => '0');
                done_p      <= '0';
                wen_p       <= '0';
                no_line_p   <= (others=>'0');
                no_col_p    <= (others=>'0');
                waddr_p     <= 0;
                t1_p        <= '0';
            else
                state_p     <= state_f;
                wdata_p     <= wdata_f;
                done_p      <= done_f;
                wen_p       <= wen_f;
                no_line_p   <= no_line_f;
                no_col_p    <= no_col_f;
                waddr_p     <= waddr_f;
                t1_p        <= t1_f;
            end if;
        end if;
    end process;

    COMBINATORIAL : process(state_p, wdata_p, done_p, no_line_p, no_col_p, waddr_p, t1_p, wen_p,
                            start_i, mode_i, line_i, no_line_i)
    begin
        state_f         <= state_p;
        done_f          <= done_p;
        wdata_f         <= wdata_p;
        no_line_f       <= no_line_p;
        no_col_f        <= no_col_p;
        waddr_f         <= waddr_p;
        wen_f           <= wen_p;
        t1_f            <= t1_p;
        case state_p is
            when INIT =>
                done_f <= '0';
                if (start_i = '1') then
                    state_f <= B1;
                    no_col_f <= (others=>'0');
                    no_line_f <= no_line_i;
                    wdata_f <= line_i(line_size - 1);
                    wen_f <= '1'; 
                    waddr_f <= to_integer(unsigned(get_addr("00", no_line_i, mode_i)));
                end if;
            when B1 =>
                wen_f <= '0'; 
                state_f <= B2;
                no_col_f <= std_logic_vector(unsigned(no_col_p) + 1);
                if no_col_p /= std_logic_vector(to_unsigned(line_size - 1, no_col_p'length)) then
                    t1_f <= '1';
                else
                    t1_f <= '0';
                end if;
            when B2 =>
                if t1_p = '1' then
                    state_f <= B1;
                    wdata_f <= line_i(to_integer(3 - unsigned(no_col_p)));
                    wen_f <= '1';
                    waddr_f <= to_integer(unsigned(get_addr(no_col_p, no_line_p, mode_i)));
                else
                    state_f <= INIT;
                    done_f <= '1';
                end if;
        end case;
    end process;
-- glue logic

-- outputs
    wdata_o      <= wdata_p;
    done_o       <= done_p;
    waddr_o      <= waddr_p;
    wen_o        <= wen_p;
end behavioral;