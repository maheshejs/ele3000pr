library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;
entity tiles_neighbour is
    port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        start_i               : in    std_logic;
        rdata_i               : in    word;
        raddr_o               : out   address;
        found_neigh_o         : out   std_logic;
        done_o                : out   std_logic
    );
end tiles_neighbour;


architecture behavioral of tiles_neighbour is
    type state is (J1, J2, J3, J4, J5, K1, K2, K3, INIT);
    signal raddr_p     : address;
    signal tile_value_p: word;
    signal tile_addr_p : unsigned(3 downto 0);
    signal t1_p        : std_logic;
    signal t2_p        : std_logic;
    signal t3_p        : std_logic;
    signal t4_p        : std_logic;
    signal found_neigh_p : std_logic;
    signal done_p      : std_logic;
    signal tile_addr_col_p  : unsigned(1 downto 0);
    signal tile_addr_line_p : unsigned(1 downto 0);
    signal iter_p      : integer range 0 to 3;
    signal iter2_p     : address;

    signal raddr_f     : address;
    signal tile_value_f: word;
    signal tile_addr_f : unsigned(3 downto 0);
    signal t1_f        : std_logic;
    signal t2_f        : std_logic;
    signal t3_f        : std_logic;
    signal t4_f        : std_logic;
    signal found_neigh_f : std_logic;
    signal done_f      : std_logic;
    signal tile_addr_col_f  : unsigned(1 downto 0);
    signal tile_addr_line_f : unsigned(1 downto 0);
    signal iter_f      : integer range 0 to 3;
    signal iter2_f     : address;
    signal state_p, state_f : state ;
begin
    REGISTERED: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (rst_i = '1') then
                state_p         <= INIT;
                done_p          <= '0';
                found_neigh_p   <= '0';
                raddr_p         <= 0;
                tile_addr_p     <= (others=>'0');
                t1_p            <= '0';
                t2_p            <= '0';
                t3_p            <= '0';
                t4_p            <= '0';
                tile_value_p    <= (others=>'0');
                tile_addr_col_p <= (others=>'0');
                tile_addr_line_p <=(others=>'0');
                iter_p          <= 0;  
                iter2_p         <= 0;   
            else
                state_p         <= state_f;
                done_p          <= done_f;
                found_neigh_p   <= found_neigh_f;
                raddr_p         <= raddr_f;
                tile_addr_p     <= tile_addr_f;
                t1_p            <= t1_f;
                t2_p            <= t2_f;
                t3_p            <= t3_f;
                t4_p            <= t4_f;
                tile_value_p    <= tile_value_f;
                tile_addr_col_p <= tile_addr_col_f;
                tile_addr_line_p <= tile_addr_line_f;
                iter_p          <= iter_f; 
                iter2_p         <= iter2_f; 
            end if;
        end if;
    end process;

    COMBINATORIAL : process(state_p, done_p, raddr_p, found_neigh_p, tile_value_p, tile_addr_p, tile_addr_col_p, tile_addr_line_p, t1_p, t2_p, t3_p, t4_p, start_i, rdata_i, iter_p, iter2_p)
    begin
        state_f         <= state_p;
        done_f          <= done_p;
        found_neigh_f   <= found_neigh_p;
        raddr_f         <= raddr_p;
        tile_addr_f     <= tile_addr_p;
        t1_f            <= t1_p;
        t2_f            <= t2_p;
        t3_f            <= t3_p;
        t4_f            <= t4_p;
        tile_value_f    <= tile_value_p;
        tile_addr_col_f <= tile_addr_col_p;
        tile_addr_line_f <= tile_addr_line_p;
        iter_f          <= iter_p; 
        iter2_f         <= iter2_p; 
        case state_p is
            when INIT =>
                done_f <= '0';
                found_neigh_f <= '0';
                if (start_i = '1') then
                    state_f <= K1;
                    iter2_f <= 0;
                    t4_f <= '1';
                end if;
            when K1 =>
                if (t4_p = '1') then
                    state_f <= K2;
                    raddr_f <= iter2_p;
                    if iter2_p /= 15 then
                        iter2_f <= iter2_p + 1;
                        t4_f <= '1';
                    else
                        t4_f <= '0';
                    end if;
                else
                    state_f <= INIT;
                    done_f <= '1';
                end if;
            when K2 =>
                state_f <= K3;
            when K3 =>
                state_f <= J1;
                tile_value_f <= rdata_i;
                tile_addr_f <= to_unsigned(raddr_p, tile_addr_f'length);
                tile_addr_col_f <= (others=>'0');
                tile_addr_line_f <= (others=>'0');
                iter_f <= 0;
                t1_f <= '1';
            when J1 =>
                if (t1_p = '1') then
                    state_f <= J2; 
                    if iter_p /= 3 then
                        iter_f <= iter_p + 1;
                        t1_f <= '1';
                    else
                        t1_f <= '0';
                    end if;
                    case iter_p is
                        when 0 => 
                            if tile_addr_p(3 downto 2) = 3 then
                                t2_f <= '1';
                            else
                                t2_f <= '0';
                                tile_addr_col_f <= tile_addr_p(3 downto 2) + 1;
                                tile_addr_line_f <= tile_addr_p(1 downto 0);
                            end if;
                        when 1 =>
                            if tile_addr_p(3 downto 2) = 0 then
                                t2_f <= '1';
                            else
                                t2_f <= '0';
                                tile_addr_col_f <= tile_addr_p(3 downto 2) - 1;
                                tile_addr_line_f <= tile_addr_p(1 downto 0);
                            end if;
                        when 2 =>
                           if tile_addr_p(1 downto 0) = 3 then
                                t2_f <= '1';
                           else
                                t2_f <= '0';
                                tile_addr_col_f <= tile_addr_p(3 downto 2);
                                tile_addr_line_f <= tile_addr_p(1 downto 0) + 1;
                           end if;
                        when 3 =>
                            if tile_addr_p(1 downto 0) = 0 then
                                t2_f <= '1';
                            else
                                t2_f <= '0';
                                tile_addr_col_f <= tile_addr_p(3 downto 2);
                                tile_addr_line_f <= tile_addr_p(1 downto 0) - 1; 
                            end if;
                    end case;
                
                else
                    state_f <= K1;
                end if;
            when J2 =>
                if t2_p = '1' then
                    state_f <= J1;
                else
                    state_f <= J3;
                    raddr_f <= to_integer(tile_addr_col_p & tile_addr_line_p ); 
                end if;
            when J3 =>
                state_f <= J4;
            when J4 =>
                state_f <= J5;
                if rdata_i = tile_value_p then
                    t3_f <= '1';
                else
                    t3_f <= '0';
                end if;
            when J5 =>
                if t3_p = '1' then
                    state_f <= INIT;
                    done_f <= '1';
                    found_neigh_f <= '1';
                else
                    state_f <= J1;
                end if;
        end case;
    end process;
-- glue logic

-- outputs
   raddr_o         <= raddr_p;
   found_neigh_o   <= found_neigh_p;
   done_o          <= done_p;
end behavioral;