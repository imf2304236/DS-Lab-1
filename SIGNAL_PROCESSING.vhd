-- SIGNAL_PROCESSING
-- dummy module for entering the signal processing algorithms
-- LTL, 12.2.2018
library ieee;
use ieee.std_logic_1164.all;

entity SIGNAL_PROCESSING is
generic(W : integer := 16);
port(
    SRESETN    : in  std_logic;
	CLK        : in  std_logic;
	DATA_IN_L  : in std_logic_vector(W-1 downto 0);
	DATA_IN_R  : in std_logic_vector(W-1 downto 0);
	DATA_OUT_L : out std_logic_vector(W-1 downto 0);
	DATA_OUT_R : out std_logic_vector(W-1 downto 0)
	);
end entity SIGNAL_PROCESSING;

architecture BEHAVIORAL of SIGNAL_PROCESSING is

begin
	DATA_OUT_L <= DATA_IN_L after 2 ns;
	DATA_OUT_R <= DATA_IN_R after 2 ns;
end architecture BEHAVIORAL;

