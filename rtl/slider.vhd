library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;
entity slider is
    port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        start_i               : in    std_logic;
        dir_i                 : in    std_logic;
        line_i                : in    line_word;
        line_o                : out   line_word;
        slide_line_o          : out   std_logic;
        done_o                : out   std_logic
    );
end slider;


architecture behavioral of slider is
    type state is (A1, A2, A3, INIT);
    signal line_p      : line_word;
    signal slide_line_p: std_logic;
    signal done_p      : std_logic;

    signal line_f      : line_word;
    signal slide_line_f: std_logic;
    signal done_f      : std_logic;

    signal state_p, state_f        : state ;
    function max_word(  w1 : in word;
                        w2 : in word; 
                        dir : in std_logic) return word is
        variable zero : word;
    begin
        zero := (others=>'0');
        if (w1 = zero and dir = '0') or (w2 = zero and dir = '1') then
            return w2;
        else
            return w1;
        end if;
    end function;

    function min_word(  w1 : in word;
                        w2 : in word; 
                        dir : in std_logic) return word is
        variable zero : word;
    begin
        zero := (others=>'0');
        if (w1 = zero and dir = '0') or (w2 = zero and dir = '1') then
            return w1;
        else
            return w2;
        end if;
    end function;
    
    function has_slide_line(w1 : in word;
                        w2 : in word; 
                        dir : in std_logic) return std_logic is
        variable zero : word;
    begin
        zero := (others=>'0');
        if (w1 = zero and w2 /= zero and dir = '0') or (w2 = zero and w1 /= zero and dir = '1') then
            return '1';
        else
            return '0';
        end if;
    end function;
begin
    REGISTERED: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (rst_i = '1') then
                state_p     <= INIT;
                line_p      <= (others => (others => '0'));
                slide_line_p<= '0';
                done_p      <= '0';
            else
                state_p     <= state_f;
                line_p      <= line_f;
                slide_line_p<= slide_line_f;
                done_p      <= done_f;
            end if;
        end if;
    end process;

    COMBINATORIAL : process(state_p, line_p, slide_line_p, done_p,
                            start_i, dir_i, line_i)
    procedure outer (line_t : in line_word) is
        variable s : std_logic;
    begin
        line_f(3) <= max_word(line_t(3), line_t(2), dir_i);
        line_f(2) <= min_word(line_t(3), line_t(2), dir_i);
        s := has_slide_line(line_t(3), line_t(2), dir_i);
        line_f(1) <= max_word(line_t(1), line_t(0), dir_i);
        line_f(0) <= min_word(line_t(1), line_t(0), dir_i);
        s := s or has_slide_line(line_t(1), line_t(0), dir_i);
        slide_line_f <= slide_line_p or s;
    end procedure;
    
    procedure inner (line_t : in line_word) is
    begin
        line_f(3) <= line_t(3);
        line_f(2) <= max_word(line_t(2), line_t(1), dir_i);
        line_f(1) <= min_word(line_t(2), line_t(1), dir_i);
        slide_line_f <= slide_line_p or has_slide_line(line_t(2), line_t(1), dir_i);
        line_f(0) <= line_t(0);
    end procedure;
    begin
        state_f         <= state_p;
        slide_line_f    <= slide_line_p;
        done_f          <= done_p;
        line_f          <= line_p;
        case state_p is
            when INIT =>
                done_f <= '0';
                slide_line_f <= '0';
                if (start_i = '1') then
                    state_f <= A1;
                    outer(line_i);
                end if;
            when A1 =>
                state_f <= A2;
                inner(line_p);
            when A2 =>
                state_f <= A3;
                outer(line_p);
            when A3 =>
                state_f <= INIT;
                inner(line_p);
                done_f  <= '1';
        end case;
    end process;
-- glue logic

-- outputs
    line_o       <= line_p;
    done_o       <= done_p;
    slide_line_o <= slide_line_p;
end behavioral;