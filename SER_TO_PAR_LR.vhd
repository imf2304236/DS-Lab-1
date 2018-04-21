library ieee;
use ieee.std_logic_1164.all;

entity SER_TO_PAR_LR is
generic(W : integer := 16);
port(
	CLK, SRESETN: in std_logic;
	-- serial bit stream in
	SER_IN: in std_logic;
	 -- control signals for shifting a bit in
        SHIFT_IN_L, SHIFT_IN_R 	: in std_logic; 
	 -- control signals for save to parallel register
        SAVE_R_LOAD_L, SAVE_L_LOAD_R   : in std_logic;        
	-- parallel word out
	PAR_OUT_L, PAR_OUT_R: out std_logic_vector(W-1 downto 0)
	);
end SER_TO_PAR_LR;

architecture BEHAVIORAL of SER_TO_PAR_LR is

signal SHIFT_REG_L_NEXT,SHIFT_REG_L : std_logic_vector( W-1 downto 0);
signal SHIFT_REG_R_NEXT,SHIFT_REG_R : std_logic_vector( W-1 downto 0);
signal PAR_REG_L_NEXT,PAR_REG_L : std_logic_vector( W-1 downto 0);
signal PAR_REG_R_NEXT,PAR_REG_R : std_logic_vector( W-1 downto 0); 

begin

-- process defining 2 shift regs and 2 parallel output regs
S2P_REGS: process(CLK)
begin
	if CLK = '1' and CLK'event then
		if SRESETN = '0' then
			SHIFT_REG_L <= (others=>'0') after 2 ns;
			SHIFT_REG_R <= (others=>'0') after 2 ns;
 			PAR_REG_L   <= (others=>'0') after 2 ns;
			PAR_REG_R   <= (others=>'0') after 2 ns;
        else
			SHIFT_REG_L <= SHIFT_REG_L_NEXT after 2 ns;
			SHIFT_REG_R <= SHIFT_REG_R_NEXT after 2 ns;
			PAR_REG_L   <= PAR_REG_L_NEXT   after 2 ns;
			PAR_REG_R   <= PAR_REG_R_NEXT   after 2 ns;
		end if;
	end if;
end process;

S2P_COMBIN: process(SER_IN,SHIFT_REG_L,SHIFT_REG_R,PAR_REG_L,PAR_REG_R, 
		    SHIFT_IN_L,SHIFT_IN_R,SAVE_R_LOAD_L, SAVE_L_LOAD_R)
begin		
	-- default operation for all regs is "keep your value"
	SHIFT_REG_L_NEXT <= SHIFT_REG_L after 2 ns;
	SHIFT_REG_R_NEXT <= SHIFT_REG_R after 2 ns;
	PAR_REG_L_NEXT   <= PAR_REG_L   after 2 ns;
	PAR_REG_R_NEXT   <= PAR_REG_R   after 2 ns;

        -- shift into shift register
	if SHIFT_IN_L = '1' then
	   SHIFT_REG_L_NEXT <= SHIFT_REG_L(W-2 downto 0) & SER_IN after 2 ns;
	end if;
	if SHIFT_IN_R = '1' then
	   SHIFT_REG_R_NEXT <= SHIFT_REG_R(W-2 downto 0) & SER_IN after 2 ns;
	end if;
	-- shift into shift register and copy to parallel our register
	if SAVE_L_LOAD_R = '1' then
	   PAR_REG_L_NEXT <= SHIFT_REG_L after 2 ns;
	end if;
	if SAVE_R_LOAD_L = '1' then
	   PAR_REG_R_NEXT <= SHIFT_REG_R after 2 ns;
	end if;
end process;

-- concurrently forward parallel reg values to port outputs
PAR_OUT_L <= PAR_REG_L  after 2 ns; 
PAR_OUT_R <= PAR_REG_R  after 2 ns;

end BEHAVIORAL;