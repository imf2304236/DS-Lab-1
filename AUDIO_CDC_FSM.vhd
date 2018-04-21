-- VHDL Code of the AUDIO CODEC FSM module
-- TI PCM3006 Audio Codec
-- LL, 9.2.2018

library IEEE;
use IEEE.std_logic_1164.all;

entity AUDIO_CDC_FSM is
    port(SRESETN, CLK : in std_logic;
         BCK, LRC : in std_logic;
	 -- control signals for serial 2 parallel converter
         SHIFT_IN_L, SHIFT_IN_R 	: out std_logic; 
	 -- control signals for parallel 2 serial converter
	 SHIFT_OUT_L, SHIFT_OUT_R 	: out std_logic;
	 -- control signals for save to/ load from parallel register
         SAVE_R_LOAD_L, SAVE_L_LOAD_R   : out std_logic
        );
end AUDIO_CDC_FSM;

architecture BEHAVIORAL of AUDIO_CDC_FSM is
    -- definition of states and state register
    type STATE_TYPE is (LEFT_BCKHI, LEFT_BCKLO, RIGHT_BCKHI, RIGHT_BCKLO);
    signal S, S_NEXT : STATE_TYPE;
begin

-- process for state register S    
FSM_SREG: process (CLK)
begin
    if CLK='1' and CLK'event then
	if SRESETN='0' then
		S <= RIGHT_BCKLO after 2 ns;
	else
		-- registers for states
		S <= S_NEXT after 2 ns;
	end if; 
    end if;		
end process FSM_SREG;

-- process for transition and output logic (combinational)
FSM_COMBIN: process (S,BCK, LRC)
begin
    -- default values for outputs and next state 
    S_NEXT  <=  S  after 2 ns;
    SHIFT_IN_L    <= '0' after 2 ns; SHIFT_IN_R    <= '0' after 2 ns;	
    SHIFT_OUT_L   <= '0' after 2 ns; SHIFT_OUT_R   <= '0' after 2 ns;	
    SAVE_R_LOAD_L <= '0' after 2 ns; SAVE_L_LOAD_R <= '0' after 2 ns;  

    case S is
      	-- left channel, bit clk high
        when LEFT_BCKHI =>
		-- falling edge of BCK 
		if LRC = '1' and BCK = '0' then
			SHIFT_OUT_L   <= '1' after 2 ns;
			S_NEXT  <=  LEFT_BCKLO  after 2 ns; 
                elsif LRC = '0' and BCK = '0' then	
			S_NEXT  <=  RIGHT_BCKLO  after 2 ns; 
 			SHIFT_OUT_L   <= '1' after 2 ns; 
 			SAVE_L_LOAD_R <= '1' after 2 ns;
		end if;
        -- left channel, bit clk low
        when LEFT_BCKLO => 
		-- rising edge of BCK 
		if LRC = '1' and BCK = '1' then
			S_NEXT  <=  LEFT_BCKHI  after 2 ns; 
			SHIFT_IN_L   <= '1' after 2 ns; 
		end if;
        -- right channel, bit clk high
        when RIGHT_BCKHI =>
		-- falling edge of BCK  
 		if LRC = '0' and BCK = '0' then
			S_NEXT  <=  RIGHT_BCKLO  after 2 ns; 
			SHIFT_OUT_R   <= '1' after 2 ns; 
                elsif LRC = '1' and BCK = '0' then	
			S_NEXT  <=  LEFT_BCKLO  after 2 ns; 
			SHIFT_OUT_R   <= '1' after 2 ns; 
 			SAVE_R_LOAD_L <= '1' after 2 ns;
		end if;
       -- right channel, bit clk low
        when RIGHT_BCKLO => 
		-- rising edge of BCK 
		if LRC = '0' and BCK = '1' then
			SHIFT_IN_R   <= '1' after 2 ns; 
			S_NEXT  <=  RIGHT_BCKHI  after 2 ns; 
		end if;
    end case;
end process FSM_COMBIN;
end architecture BEHAVIORAL;



