library IEEE;
use IEEE.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use IEEE.numeric_std.all;
library WORK;
use WORK.game_defs.all;
entity tiles_spawn is
port (
  clk_i                 : in    std_logic;
  rst_i                 : in    std_logic;
  start_i               : in    std_logic;
  load_prbs_i           : in    std_logic;
  seed_i                : in    std_logic_vector(7 downto 0);
  rdata_i               : in word;
  raddr_o               : out address;
  waddr_o               : out address;
  wdata_o               : out word;
  wen_o                 : out std_logic ;
  done_o                : out   std_logic

);
end tiles_spawn;


architecture behavioral of tiles_spawn is
-- ###########################################################################
-- Entete de l'architecture
-- ###########################################################################

    signal clk                    : std_logic;
    signal rst                    : std_logic;
    signal done                   : std_logic;
    signal digit                  : std_logic;
    signal next_prbs              : std_logic;
    signal wen                    : std_logic;
    signal done_rnd               : std_logic;
    signal start_rnd              : std_logic;
    signal result_rnd             : std_logic_vector(3 downto 0);
    signal upper                  : std_logic_vector(3 downto 0);
    signal raddr                  : address;
    signal waddr                  : address;
    signal readdata               : word;
    signal writedata              : word;
  component randint
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
  end component;
  
  component prbs
      port (
        clk_i                 : in    std_logic;
        rst_i                 : in    std_logic;
        load_prbs_i           : in    std_logic;
        next_prbs_i           : in    std_logic;
        seed_i                : in    std_logic_vector(7 downto 0);
        digit_prbs_o          : out   std_logic
      );
  end component;
  
    component spawner
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
    end component;

-- ###########################################################################
-- Debut de l'architecture
-- ###########################################################################
begin
  rst <= rst_i;
  clk <= clk_i;
  readdata <= rdata_i;
  ----------------------------------------------------------------------------
   randint_inst : randint port map (clk_i        => clk,
                          rst_i        => rst,
                          start_i      => start_rnd,
                          digit_prbs_i => digit,
                          upper_i      => upper,
                          result_o     => result_rnd,
                          next_prbs_o  => next_prbs,
                          done_o       => done_rnd );
   prbs_inst :  prbs port map(clk_i       => clk,
                       rst_i        => rst,
                       load_prbs_i =>  load_prbs_i,
                       next_prbs_i => next_prbs,
                       seed_i      => seed_i,
                       digit_prbs_o     => digit );

  spawner_inst: spawner port map ( clk_i        => clk,
                          rst_i        => rst,
                          start_i      => start_i,
                          done_rnd_i   => done_rnd,
                          result_rnd_i => result_rnd,
                          rdata_i      => readdata,
                          waddr_o      => waddr,
                          raddr_o      => raddr,
                          wdata_o      => writedata,
                          upper_o      => upper,
                          wen_o        => wen,
                          start_rnd_o  => start_rnd,
                          done_o       => done );

  raddr_o               <= raddr;
  waddr_o               <= waddr;
  wdata_o               <= writedata;
  wen_o                 <= wen;
  done_o                <= done;

end behavioral;
