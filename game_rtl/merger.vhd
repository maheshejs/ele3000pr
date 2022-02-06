library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;
entity merger is
    port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        dir_i                 : in    std_logic;
        start_i               : in    std_logic;
        line_i                : in    line_word;
        line_o                : out   line_word;
        merge_line_o          : out   std_logic;
        won_line_o            : out   std_logic;
        done_o                : out   std_logic
    );
end merger;


architecture behavioral of merger is
    type state is (K1, INIT);
    signal line_p      : line_word;
    signal merge_line_p: std_logic;
    signal won_line_p  : std_logic;
    signal done_p      : std_logic;
    signal t1_p        : std_logic;
    signal t2_p        : std_logic;
    signal t3_p        : std_logic;

    signal line_f      : line_word;
    signal merge_line_f: std_logic;
    signal won_line_f  : std_logic;
    signal done_f      : std_logic;
    signal t1_f        : std_logic;
    signal t2_f        : std_logic;
    signal t3_f        : std_logic;

    signal state_p, state_f        : state ;
begin
    REGISTERED: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (rst_i = '1') then
                state_p     <= INIT;
                line_p      <= (others => (others => '0'));
                merge_line_p<= '0';
                won_line_p  <= '0';
                done_p      <= '0';
                t1_p        <= '0';
                t2_p        <= '0';
                t3_p        <= '0';
            else
                state_p     <= state_f;
                line_p      <= line_f;
                merge_line_p<= merge_line_f;
                won_line_p  <= won_line_f;
                done_p      <= done_f;
                t1_p        <= t1_f;
                t2_p        <= t2_f;
                t3_p        <= t3_f;
            end if;
        end if;
    end process;

    COMBINATORIAL : process(state_p, line_p, merge_line_p, won_line_p, done_p, t1_p, t2_p, t3_p,
                            start_i, dir_i, line_i)
        variable t : std_logic_vector(2 downto 0);
        variable zero : word;
    begin
        zero := (others=>'0');
        state_f         <= state_p;
        merge_line_f    <= merge_line_p;
        won_line_f      <= won_line_p;
        done_f          <= done_p;
        line_f          <= line_p;
        t1_f            <= t1_p;
        t2_f            <= t2_p;
        t3_f            <= t3_p;
        case state_p is
            when INIT =>
                done_f <= '0';
                merge_line_f <= '0';
                won_line_f <= '0';
                if (start_i = '1') then
                    state_f <= K1;
                    if (dir_i = '1') then
                        if (line_i(0) = line_i(1)) and (line_i(1) /= zero) then
                            t1_f <= '1';
                        else
                            t1_f <= '0';
                        end if;
                        if (line_i(1) = line_i(2)) and (line_i(2) /= zero) then
                            t2_f <= '1';
                        else
                            t2_f <= '0';
                        end if;
                        if (line_i(2) = line_i(3)) and (line_i(3) /= zero) then
                            t3_f <= '1';
                        else
                            t3_f <= '0';
                        end if;
                    else
                        if (line_i(3) = line_i(2)) and (line_i(3) /= zero) then
                            t1_f <= '1';
                        else
                            t1_f <= '0';
                        end if;
                        if (line_i(2) = line_i(1)) and (line_i(2) /= zero) then
                            t2_f <= '1';
                        else
                            t2_f <= '0';
                        end if;
                        if (line_i(1) = line_i(0)) and (line_i(1) /= zero) then
                            t3_f <= '1';
                        else
                            t3_f <= '0';
                        end if;
                    end if;
                    
                end if;
            when K1 =>
                state_f <= INIT;
                done_f  <= '1';
                merge_line_f <= '1';
                t := t1_p & t2_p & t3_p;
                case t is
                    when "100" | "101" | "110" | "111" =>
                        if (dir_i = '1') then
                            line_f(3) <= zero;
                            line_f(2) <= line_i(3);
                            line_f(1) <= line_i(2);
                            line_f(0) <= std_logic_vector(unsigned(line_i(0)) + 1) ;
                            if (line_i(0) = "01010") then
                                won_line_f <= '1';
                            end if;
                        else
                            line_f(3) <= std_logic_vector(unsigned(line_i(3)) + 1);
                            line_f(2) <= line_i(1);
                            line_f(1) <= line_i(0);
                            line_f(0) <= zero ;
                            if (line_i(3) = "01010") then
                                won_line_f <= '1';
                            end if;
                        end if;
                    when "010" | "011" =>
                        if (dir_i = '1') then
                            line_f(3) <= zero;
                            line_f(2) <= line_i(3);
                            line_f(1) <= std_logic_vector(unsigned(line_i(1)) + 1);
                            line_f(0) <= line_i(0);
                            if (line_i(1) = "01010") then
                                won_line_f <= '1';
                            end if;
                        else
                            line_f(3) <= line_i(3);
                            line_f(2) <= std_logic_vector(unsigned(line_i(2)) + 1);
                            line_f(1) <= line_i(0);
                            line_f(0) <= zero ;
                            if (line_i(2) = "01010") then
                                won_line_f <= '1';
                            end if;
                        end if;
                    when "001" =>
                        if (dir_i = '1') then
                            line_f(3) <= zero;
                            line_f(2) <= std_logic_vector(unsigned(line_i(2)) + 1);
                            line_f(1) <= line_i(1);
                            line_f(0) <= line_i(0);
                            if (line_i(2) = "01010") then
                                won_line_f <= '1';
                            end if;
                        else
                            line_f(3) <= line_i(3);
                            line_f(2) <= line_i(2);
                            line_f(1) <= std_logic_vector(unsigned(line_i(1)) + 1);
                            line_f(0) <= zero ;
                            if (line_i(1) = "01010") then
                                won_line_f <= '1';
                            end if;
                        end if;
                    when others => ---000
                        merge_line_f <= '0';
                        line_f(3) <= line_i(3);
                        line_f(2) <= line_i(2);
                        line_f(1) <= line_i(1);
                        line_f(0) <= line_i(0);
                end case;
        end case;
    end process;
-- glue logic
    
-- outputs
    line_o          <= line_p;
    merge_line_o    <= merge_line_p;
    won_line_o      <= won_line_p;
    done_o          <= done_p;
end behavioral;