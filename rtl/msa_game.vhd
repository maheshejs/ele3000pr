library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;
entity msa_game is
    port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        start_i               : in    std_logic;
        key_pressed_i         : in    std_logic;
        merge_i               : in    std_logic;
        slide_i               : in    std_logic;
        won_i                 : in    std_logic;
        single_zero_i         : in    std_logic;
        found_neigh_i         : in    std_logic;
        done_zero_i           : in    std_logic;
        done_spawn_i          : in    std_logic;
        done_slirge_i         : in    std_logic;
        done_neigh_i          : in    std_logic;
        start_zero_o          : out   std_logic;
        start_spawn_o         : out   std_logic;
        start_slirge_o        : out   std_logic;
        start_neigh_o         : out   std_logic;
        load_param_o          : out   std_logic;
        load_prbs_o           : out   std_logic;
        selection_o           : out   std_logic_vector(1 downto 0);
        done_o                : out   std_logic;
        game_status_o         : out   game_status
    );
end msa_game;


architecture behavioral of msa_game is
    type state is (RESET, WAIT_ZERO, PRET_A_JOUER, SPAWN1, SPAWN2, WAIT_ACTION, RELEASE, SLIRGE, NEIGHBOUR);
    signal start_zero_p     : std_logic;
    signal start_spawn_p    : std_logic;
    signal start_slirge_p   : std_logic;
    signal start_neigh_p    : std_logic;
    signal load_param_p     : std_logic;
    signal load_prbs_p      : std_logic;
    signal t_p              : std_logic;
    signal done_p           : std_logic;
    signal selection_p      : std_logic_vector(1 downto 0);

    signal start_zero_f     : std_logic;
    signal start_spawn_f    : std_logic;
    signal start_slirge_f   : std_logic;
    signal start_neigh_f    : std_logic;
    signal load_param_f     : std_logic;
    signal load_mode_f      : std_logic;
    signal load_prbs_f      : std_logic;
    signal t_f              : std_logic;
    signal done_f           : std_logic;
    signal selection_f      : std_logic_vector(1 downto 0);
    signal game_status_p, game_status_f : game_status;
    signal state_p, state_f        : state ;
begin
    REGISTERED: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (rst_i = '1') then
                state_p          <= RESET;
                game_status_p    <= GAME_ONGOING;
                start_zero_p     <= '0';
                start_spawn_p    <= '0';
                start_slirge_p   <= '0';
                start_neigh_p    <= '0';
                load_param_p     <= '0';
                load_prbs_p      <= '0';
                t_p              <= '0';
                done_p           <= '0';
                selection_p      <= (others=>'0');
            else
                state_p          <= state_f          ;
                game_status_p    <= game_status_f    ;
                start_zero_p     <= start_zero_f     ;
                start_spawn_p    <= start_spawn_f    ;
                start_slirge_p   <= start_slirge_f   ;
                start_neigh_p    <= start_neigh_f    ;
                load_param_p     <= load_param_f     ;
                load_prbs_p      <= load_prbs_f      ;
                t_p              <= t_f              ;
                done_p           <= done_f           ;
                selection_p      <= selection_f      ;
            end if;
        end if;
    end process;

    COMBINATORIAL : process(state_p, game_status_p, start_zero_p, start_spawn_p, start_slirge_p, start_neigh_p, load_param_p, load_prbs_p, t_p, done_p, selection_p,
                            done_zero_i, done_spawn_i, done_slirge_i, done_neigh_i, found_neigh_i,  key_pressed_i, start_i, slide_i, merge_i, single_zero_i, won_i)
    begin
        state_f          <= state_p          ;
        game_status_f    <= game_status_p    ;
        start_zero_f     <= start_zero_p     ;
        start_spawn_f    <= start_spawn_p    ;
        start_slirge_f   <= start_slirge_p   ;
        start_neigh_f    <= start_neigh_p    ;
        load_param_f     <= load_param_p     ;
        load_prbs_f      <= load_prbs_p      ;
        t_f              <= t_p              ;
        done_f           <= done_p           ;
        selection_f      <= selection_p      ;
        case state_p is
            when RESET =>
                state_f <= WAIT_ZERO;
                game_status_f <= GAME_ONGOING;
                start_zero_f <= '1';
                selection_f  <= "01";
                done_f <= '0';
            when WAIT_ZERO =>
                start_zero_f <= '0';
                if (done_zero_i = '1') then
                    state_f <= PRET_A_JOUER;
                end if;
            when PRET_A_JOUER =>
                if (start_i = '1') then
                    state_f <= SPAWN1;
                    start_spawn_f <= '1';
                    selection_f  <= "10";
                    load_prbs_f <= '1';
                end if;
            when SPAWN1 =>
                load_prbs_f <= '0';
                if (done_spawn_i = '1') then
                    state_f <= SPAWN2;
                end if;
            when SPAWN2 =>
                start_spawn_f <= '0';
                if (done_spawn_i = '1') then
                    if (single_zero_i = '1') then
                        state_f <= NEIGHBOUR;
                        start_neigh_f <= '1';
                        selection_f <= "00";
                    else
                        state_f <= WAIT_ACTION;
                        selection_f  <= "11";
                    end if;
                end if;
            when NEIGHBOUR =>
                start_neigh_f <= '0';
                if (done_neigh_i = '1') then
                    if (found_neigh_i = '1') then
                        state_f <= WAIT_ACTION;
                        selection_f  <= "11";
                    else
                        done_f <= '1';
                        game_status_f <= GAME_LOST;
                    end if;
                end if;
            when WAIT_ACTION =>
                if (key_pressed_i = '1') then
                    state_f <= RELEASE;
                    load_param_f <= '1';
                end if;
            when RELEASE =>
                load_param_f <= '0';
                if (key_pressed_i = '0') then
                    state_f <= SLIRGE;
                    start_slirge_f <= '1';
                end if;
            when SLIRGE =>
                start_slirge_f <= '0';
                if (done_slirge_i = '1') then
                    if (won_i = '1') then
                        done_f <= '1';
                        game_status_f <= GAME_WON;
                    else
                        if (slide_i = '1' or merge_i = '1') then
                            state_f <= SPAWN2;
                            start_spawn_f <= '1';
                            selection_f  <= "10";
                        else
                            state_f  <= WAIT_ACTION;
                        end if;
                    end if;  
                end if;
--            when TEST_SLIRGE =>
--                if (t_p = '1') then
--                    state_f <= SPAWN2;
--                    start_spawn_f <= '1';
--                    selection_f  <= "10";
--                else
--                    ---- changes goes to WAIT_ACTION normally
--                    --state_f <= RESET;
--                    --done_f <= '1';
--                    state_f  <= WAIT_ACTION;
--                end if;
        end case;
    end process;
-- glue logic

-- outputs
    start_zero_o     <= start_zero_p     ;
    start_spawn_o    <= start_spawn_p    ;
    start_slirge_o   <= start_slirge_p   ;
    start_neigh_o    <= start_neigh_p    ;
    load_param_o     <= load_param_p     ;
    load_prbs_o      <= load_prbs_p      ;
    selection_o      <= selection_p      ;
    game_status_o    <= game_status_p    ;
    done_o           <= done_p           ;
end behavioral;