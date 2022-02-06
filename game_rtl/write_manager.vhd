library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;
entity write_manager is
    port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        start_i               : in    std_logic;
        done_line_i           : in    std_logic;
        done_compute_i        : in    std_logic;
        no_line_o             : out   std_logic_vector(1 downto 0);
        start_line_o          : out   std_logic;
        done_o                : out   std_logic
    );
end write_manager;


architecture behavioral of write_manager is
    type state is (C1, C2, C23,  C3, INIT);
    signal start_line_p: std_logic;
    signal no_line_p   : std_logic_vector(1 downto 0);
    signal t1_p        : std_logic;
    signal done_p      : std_logic;

    signal start_line_f: std_logic;
    signal no_line_f   : std_logic_vector(1 downto 0);
    signal t1_f        : std_logic;
    signal done_f      : std_logic;

    signal state_p, state_f        : state ;
begin
    REGISTERED: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (rst_i = '1') then
                state_p     <= INIT;
                start_line_p<= '0';
                no_line_p   <= (others=>'0');
                t1_p        <= '0';
                done_p      <= '0';
            else
                state_p     <= state_f;
                start_line_p<= start_line_f;
                no_line_p   <= no_line_f;
                t1_p        <= t1_f;
                done_p      <= done_f;
            end if;
        end if;
    end process;

    COMBINATORIAL : process(state_p, start_line_p, no_line_p, t1_p, done_p,
                            start_i, done_line_i, done_compute_i)
    begin
        state_f         <= state_p;
        start_line_f    <= start_line_p;
        no_line_f       <= no_line_p;
        t1_f            <= t1_p;
        done_f          <= done_p;
        case state_p is
            when INIT =>
                done_f <= '0';
                if (start_i = '1') then
                    state_f <= C1;
                    no_line_f <= (others=>'0');
                end if;
            when C1 =>
                if done_compute_i = '1' then
                    state_f <= C2;
                    start_line_f <= '1';
                end if;
            when C2 =>
                state_f <= C23;
                start_line_f <= '0';
                no_line_f <= std_logic_vector(unsigned(no_line_p) + 1);
                if no_line_p /= std_logic_vector(to_unsigned(line_size - 1, no_line_p'length)) then
                    t1_f <= '1';
                else
                    t1_f <= '0';
                end if;
            when C23 =>
                if t1_p = '1' then
                    state_f <= C1;
                else
                    state_f <= C3;
                end if;
            when C3 =>
                if done_line_i = '1' then
                    state_f <= INIT;
                    done_f <= '1';
                end if;
        end case;
    end process;
-- glue logic

-- outputs
    done_o <= done_p;
    no_line_o    <= no_line_p;
    start_line_o <= start_line_p;
end behavioral;