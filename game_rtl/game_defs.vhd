library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
package game_defs is
    constant word_size : positive := 5;
    constant line_size : positive := 4;
    
    subtype word is std_logic_vector(word_size - 1 downto 0);
    subtype address is natural range 0 to 2**line_size - 1;
    
    type line_word is array (line_size - 1 downto 0) of word;
    type game_status is (GAME_ONGOING, GAME_WON, GAME_LOST);
    function get_addr(no_col : in std_logic_vector(1 downto 0); no_line : in std_logic_vector(1 downto 0); mode : in std_logic)
        return std_logic_vector;
end package game_defs;

package body game_defs is
    function get_addr(no_col : in std_logic_vector(1 downto 0); no_line : in std_logic_vector(1 downto 0); mode : in std_logic)
        return std_logic_vector is
    begin
        if mode = '1' then
            return no_col & no_line ;
        else
            return no_line & no_col ;
        end if;
    end function get_addr;
end package body game_defs;