-- clock generation module for PCM3006 audio codec
library ieee;
use ieee.std_logic_1164.all;

entity CODEC_CLK_GEN is
generic(M : integer := 9);
port(
	CLK       : in std_logic;
	EN_CLK    : in  std_logic;
	SRESETN   : in std_logic;
	SYSCLK, BCK, LRC : out std_logic
	);
end CODEC_CLK_GEN;

architecture BEHAVIORAL of CODEC_CLK_GEN is

component FRQ_DIV_M
generic(M : integer := 9);
port(
    SRESETN: in  std_logic;
	CLK:     in  std_logic;
	EN_CLK:  in  std_logic;
	CLK_DIV_M: out std_logic_vector(M-1 downto 0)
	);
end component FRQ_DIV_M;

signal CLK_DIV_M : std_logic_vector(M-1 downto 0);

begin

FRQ_DIV_M_CODEC: FRQ_DIV_M
generic map (M => 9)
port map(SRESETN,CLK,EN_CLK,CLK_DIV_M);

-- audio codec clocks
SYSCLK <= CLK_DIV_M(0) after 2 ns;
BCK  <= CLK_DIV_M(3) after 2 ns;
LRC  <= CLK_DIV_M(8) after 2 ns;


end BEHAVIORAL;
