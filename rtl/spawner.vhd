library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;
entity spawner is
    port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        start_i               : in    std_logic;
        done_rnd_i            : in    std_logic;
        result_rnd_i          : in    std_logic_vector(3 downto 0);
        rdata_i               : in    word;
        waddr_o               : out   address;
        raddr_o               : out   address;
        wdata_o               : out   word;
        upper_o               : out    std_logic_vector(3 downto 0);
        wen_o                 : out   std_logic;
        start_rnd_o           : out   std_logic;
        done_o                : out   std_logic
    );
end spawner;


architecture behavioral of spawner is
    type state is (E1, E2, E3, E4, E5, INIT);
    signal start_rnd_p : std_logic;
    signal wdata_p     : word;
    signal wen_p       : std_logic;
    signal waddr_p     : address;
    signal raddr_p     : address;
    signal upper_p     : std_logic_vector(3 downto 0);
    signal road_p      : std_logic;
    signal t1_p        : std_logic;
    signal t2_p        : std_logic;
    signal done_p      : std_logic;

    signal start_rnd_f : std_logic;
    signal wdata_f     : word;
    signal wen_f       : std_logic;
    signal waddr_f     : address;
    signal raddr_f     : address;
    signal upper_f     : std_logic_vector(3 downto 0);
    signal road_f      : std_logic;
    signal t1_f        : std_logic;
    signal t2_f        : std_logic;
    signal done_f      : std_logic;

    signal state_p, state_f        : state ;
begin
    REGISTERED: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (rst_i = '1') then
                state_p         <= INIT;
                start_rnd_p     <= '0';
                done_p          <= '0';
                wdata_p         <= (others=>'0');
                waddr_p         <= 0;
                raddr_p         <= 0;
                wen_p           <= '0';
                t1_p            <= '0';
                t2_p            <= '0';
                road_p          <= '0';
                upper_p         <= (others=>'0');
            else
                state_p         <= state_f;
                start_rnd_p     <= start_rnd_f;
                done_p          <= done_f;
                wdata_p         <= wdata_f;
                waddr_p         <= waddr_f;
                raddr_p         <= raddr_f;
                wen_p           <= wen_f;
                t1_p            <= t1_f;
                t2_p            <= t2_f;
                road_p          <= road_f;
                upper_p         <= upper_f;
            end if;
        end if;
    end process;

    COMBINATORIAL : process(state_p, start_rnd_p, done_p, wdata_p, waddr_p, raddr_p, wen_p, road_p, upper_p, t1_p, t2_p,
                            start_i, done_rnd_i, rdata_i, result_rnd_i)
        variable t : std_logic_vector(1 downto 0);
    begin
        state_f         <= state_p;
        done_f          <= done_p;
        start_rnd_f     <= start_rnd_p;
        wdata_f         <= wdata_p;
        waddr_f         <= waddr_p;
        raddr_f         <= raddr_p;
        wen_f           <= wen_p;
        t1_f            <= t1_p;
        t2_f            <= t2_p;
        road_f          <= road_p;
        upper_f         <= upper_p;
        case state_p is
            when INIT =>
                done_f <= '0';
                if (start_i = '1') then
                    state_f <= E1;
                    road_f <= '0';
                    start_rnd_f <= '1';
                    upper_f <= X"F";
                end if;
            when E1 =>
                start_rnd_f <= '0';
                t := road_p & done_rnd_i;
                case t is
                    when "01" =>
                        state_f <= E2;
                        raddr_f <= to_integer(unsigned(result_rnd_i));
                    when "11" =>
                        state_f <= E4;
                        if result_rnd_i = X"0" then
                            t1_f <= '1';
                        else
                            t1_f <= '0';
                        end if;
                    when others =>
                        null;
                end case;
            when E2 =>
                state_f <= E3;
            when E3 =>
                state_f <= E4;
                if rdata_i = "00000" then
                    t2_f <= '1';
                else
                    t2_f <= '0';
                end if;
            when E4 =>
                if road_p = '1' then
                    state_f <= E5;
                    wen_f <= '1';
                    waddr_f <= raddr_p;
                    if t1_p = '1' then
                        wdata_f <= "00010"; -- write 4
                    else
                        wdata_f <= "00001"; -- write 2
                    end if;
                else
                    state_f <= E1;
                    start_rnd_f <= '1';
                    if t2_p = '1' then
                        upper_f <= X"9";
                        road_f <= '1';
                    else
                        upper_f <= X"F";
                    end if;
                end if;
            when E5 =>
                state_f <= INIT;
                wen_f <= '0';
                done_f <= '1';
        end case;
    end process;
-- glue logic

-- outputs
   start_rnd_o     <= start_rnd_p;
   wdata_o         <= wdata_p;
   waddr_o         <= waddr_p;
   raddr_o         <= raddr_p;
   wen_o           <= wen_p;
   done_o          <= done_p;
   upper_o         <= upper_p;
end behavioral;