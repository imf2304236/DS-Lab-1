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

signal SHIFT_REG_L_NEXT, SHIFT_REG_L : std_logic_vector( W-1 downto 0);
signal SHIFT_REG_R_NEXT, SHIFT_REG_R : std_logic_vector( W-1 downto 0);

begin

-- sequential process for shift registers
P2S_REGS: process(CLK)
begin
	if CLK = '1' and CLK'event then
		if SRESETN = '0' then
			SHIFT_REG_L <= (others=>'0') after 2 ns;
			SHIFT_REG_R <= (others=>'0') after 2 ns;
		else 
			SHIFT_REG_L <= SHIFT_REG_L_NEXT after 2 ns;
			SHIFT_REG_R <= SHIFT_REG_R_NEXT after 2 ns;
		end if;
	end if;
end process;



end BEHAVIORAL;