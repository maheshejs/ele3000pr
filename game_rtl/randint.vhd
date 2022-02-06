library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
entity randint is
    port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        start_i               : in    std_logic;
        digit_prbs_i          : in    std_logic;
        upper_i               : in    std_logic_vector(3 downto 0);
        result_o              : out   std_logic_vector(3 downto 0);
        next_prbs_o           : out   std_logic;
        done_o                : out   std_logic
    );
end randint;


architecture behavioral of randint is

    type state is (W1, W2, INIT);
    subtype halfbyte  is std_logic_vector(3 downto 0);
    signal count_p     : std_logic_vector(3 downto 0);
    signal bits_p      : std_logic_vector(3 downto 0);
    signal result_p    : std_logic_vector(3 downto 0);
    signal upper_p     : std_logic_vector(3 downto 0);
    signal done_p      : std_logic;
    signal next_prbs_p : std_logic;
    signal t1_p        : std_logic;
    signal t2_p        : std_logic;

    signal count_f     : std_logic_vector(3 downto 0);
    signal bits_f      : std_logic_vector(3 downto 0);
    signal upper_f     : std_logic_vector(3 downto 0);
    signal result_f    : std_logic_vector(3 downto 0);
    signal done_f      : std_logic;
    signal next_prbs_f : std_logic;
    signal t1_f        : std_logic;
    signal t2_f        : std_logic;

    signal state_p, state_f        : state ;
    
    function get_nb_bits(dec_nb : in halfbyte) return halfbyte is
        variable output : halfbyte := (others=>'0');
    begin
        case dec_nb is
            when X"0" | X"1" =>
                output := X"1";
            when X"2" | X"3" =>
                output := X"2";
            when X"4" | X"5" | X"6" | X"7" =>
                output := X"3";
            when X"8" | X"9" | X"A" | X"B" | X"C" | X"D" | X"E" | X"F" =>
                output := X"4";
            when others =>
                output := X"0";
        end case;
        return output;
    end function;

begin

    REGISTERED: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (rst_i = '1') then
                state_p     <= INIT;
                count_p     <= (others => '0');
                bits_p      <= (others => '0');
                upper_p     <= (others => '0');
                result_p    <= (others => '0');
                next_prbs_p <= '0';
                done_p      <= '0';
                t1_p        <= '0';
                t2_p        <= '0';
            else
                state_p     <= state_f;
                count_p     <= count_f;
                bits_p      <= bits_f;
                upper_p    <= upper_f;
                result_p    <= result_f;
                next_prbs_p <= next_prbs_f;
                done_p      <= done_f;
                t1_p        <= t1_f;
                t2_p        <= t2_f;
            end if;
        end if;
    end process;

    COMBINATORIAL : process(state_p, count_p, bits_p, next_prbs_p, done_p, upper_p, result_p, t1_p, t2_p,
                            start_i, digit_prbs_i, upper_i)
    begin
        state_f         <= state_p;
        done_f          <= done_p;
        count_f         <= count_p;
        bits_f          <= bits_p;
        upper_f         <= upper_p;
        result_f        <= result_p;
        next_prbs_f     <= next_prbs_p;
        t1_f            <= t1_p;
        t2_f            <= t2_p;
        case state_p is
            when INIT =>
                done_f <= '0';
                if (start_i = '1') then
                    state_f <= W1;
                    bits_f  <= get_nb_bits(upper_i);
                    upper_f <= upper_i;
                    result_f <= (others=>'0');
                    count_f  <= (others=>'0');
                    if X"0" < get_nb_bits(upper_i) then
                        t1_f <= '1';
                        next_prbs_f <= '1';
                    else
                        t1_f <= '0';
                        next_prbs_f <= '0';
                    end if;
                end if;
            when W1 =>
                if t1_p = '1' then
                    state_f <= W1;
                    result_f <= result_p(2 downto 0) & digit_prbs_i;
                    count_f <= std_logic_vector(unsigned(count_p) + 1);
                    if std_logic_vector(unsigned(count_p) + 1) < bits_p then
                        t1_f <= '1';
                        next_prbs_f <= '1';
                    else
                        t1_f <= '0';
                        next_prbs_f <= '0';
                    end if;
                else
                    state_f <= W2;
                    if result_p > upper_p then
                        t2_f <= '1';
                    else
                        t2_f <= '0';
                    end if;
                end if;
            when W2 =>
                if t2_p = '1' then
                    state_f <= W1;
                    result_f <= (others=>'0');
                    count_f  <= (others=>'0');
                    t1_f <= '1';
                    next_prbs_f <= '1';
                else
                    state_f <= INIT;
                    done_f <= '1';
                end if;
        end case;
    end process;
-- glue logic

-- outputs
    result_o     <= result_p;
    done_o       <= done_p;
    next_prbs_o  <= next_prbs_p;
end behavioral;