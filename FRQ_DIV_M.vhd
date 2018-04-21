-- FRQ_DIV_M
-- frequency divider by power of 2 up to 2^(M-1) with enable
-- LTL, 7.2.2018

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FRQ_DIV_M is
generic(M : integer := 9);
port(
    SRESETN: in  std_logic;
	CLK:     in  std_logic;
	EN_CLK:  in  std_logic;
	CLK_DIV_M: out std_logic_vector(M-1 downto 0)
	);
end FRQ_DIV_M;

architecture BEHAVIORAL of FRQ_DIV_M is
-- counter state reg
signal Q, Q_NEXT: unsigned(M-1 downto 0);

begin
-- counter 
CLK_DIV_M_REG: process(CLK)
begin
	if CLK='1' and CLK'event then
		if SRESETN = '0' then
			Q <= (others =>'0'); 
		else
			Q <= Q_NEXT after 2 ns;
		end if;
	end if;
end process;

-- increment when enabled
CLK_DIV_M_CMB: process(Q,EN_CLK)
begin
	-- output logic
	CLK_DIV_M <= std_logic_vector(Q) after 2 ns;
	-- next state logic
	Q_NEXT <= Q after 2 ns;
	if EN_CLK = '1' then
		Q_NEXT <= Q + 1 after 2 ns;
	end if;		
end process;

end BEHAVIORAL;