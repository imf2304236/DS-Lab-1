library ieee;
use ieee.std_logic_1164.all;

entity PAR_TO_SER_LR is
generic(W : integer := 16);
port(
	CLK, SRESETN: in std_logic;
	PAR_IN_L, PAR_IN_R: in std_logic_vector(W-1 downto 0);
    LRC : in std_logic;
	 -- control signals for shifting bit out
	SHIFT_OUT_L, SHIFT_OUT_R 	: in std_logic;
	 -- control signals for load in parallel word
    SAVE_R_LOAD_L, SAVE_L_LOAD_R   : in std_logic;        
	SER_OUT: out std_logic
	);
end PAR_TO_SER_LR;

architecture BEHAVIORAL of PAR_TO_SER_LR is

begin

-- dummy output
P_DUMMY: process(CLK)
begin
	SER_OUT <= LRC after 2 ns;	
end process;

end BEHAVIORAL;