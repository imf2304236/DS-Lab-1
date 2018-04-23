-- AUDIO SYSTEM TOP level module
-- includes clock generation, audio codec communication module 
-- and signal processing module
-- LTL, 12.02.2018 

library ieee;
use ieee.std_logic_1164.all;

entity AUDIO_SYSTEM_TOP is
port(
	CLK, SRESETN : in std_logic;
	-- clock signals (to audio codec)
	SYSCLK, BCK, LRC: out std_logic;
	-- serial data in
	DIN: in std_logic;
	-- serial data out
	DOUT: out std_logic
	);
end AUDIO_SYSTEM_TOP;

architecture BEHAVIORAL of AUDIO_SYSTEM_TOP is

component AUDIO_CODEC_COM 
port(
	CLK, SRESETN : in std_logic;
    EN_CLK : in std_logic;
	-- clock signals (to audio codec)
	SYSCLK, BCK, LRC: out std_logic;
	-- ADC path (from audio codec to signal processing)
	DIN: in std_logic;
	PAR_OUT_L: out std_logic_vector(15 downto 0);
	PAR_OUT_R: out std_logic_vector(15 downto 0);
	-- DAC path (from signal processing to audio codec)
	PAR_IN_L: in std_logic_vector(15 downto 0);
	PAR_IN_R: in std_logic_vector(15 downto 0);
	DOUT: out std_logic
	);
end component AUDIO_CODEC_COM;

component FRQ_PRE_DIV 
generic(P : integer := 2);
port(
    SRESETN: in  std_logic;
	CLK:     in  std_logic;
	EN_CLK : out std_logic
	);
end component FRQ_PRE_DIV;

component SIGNAL_PROCESSING is
generic(W : integer := 16);
port(
    SRESETN    : in  std_logic;
	CLK        : in  std_logic;
	DATA_IN_L  : in std_logic_vector(W-1 downto 0);
	DATA_IN_R  : in std_logic_vector(W-1 downto 0);
	DATA_OUT_L : out std_logic_vector(W-1 downto 0);
	DATA_OUT_R : out std_logic_vector(W-1 downto 0)
	);
end component SIGNAL_PROCESSING;

signal DATA_IN_L, DATA_IN_R, DATA_OUT_L, DATA_OUT_R : std_logic_vector(15 downto 0);
signal EN_CLK : std_logic;
begin
INST_AUDIO_CODEC_COM : AUDIO_CODEC_COM
	port map (CLK, SRESETN,EN_CLK,SYSCLK, BCK, LRC,DIN,DATA_IN_L,DATA_IN_R,DATA_OUT_L,DATA_OUT_R,DOUT);
	
INST_SIGNAL_PROCESSING : SIGNAL_PROCESSING 
    port map(SRESETN,CLK,DATA_IN_L,DATA_IN_R,DATA_OUT_L,DATA_OUT_R);

INT_FRQ_PRE_DIV : FRQ_PRE_DIV 
    generic map(P => 2)
    port map(SRESETN,CLK,EN_CLK);
		
end BEHAVIORAL;