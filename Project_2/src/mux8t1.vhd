library IEEE;
use IEEE.std_logic_1164.all;

entity mux8t1 is

  port(i_S  : in std_logic_vector (2 downto 0);
	i_R0 : in std_logic_vector(31 downto 0);
	i_R1 : in std_logic_vector(31 downto 0);
	i_R2 : in std_logic_vector(31 downto 0);
	i_R3 : in std_logic_vector(31 downto 0);
	i_R4 : in std_logic_vector(31 downto 0);
	i_R5 : in std_logic_vector(31 downto 0);
	i_R6 : in std_logic_vector(31 downto 0);
	i_R7 : in std_logic_vector(31 downto 0);
	o_Y : out std_logic_vector(31 downto 0));

end mux8t1;

architecture structure of mux8t1 is
begin

o_Y <=
i_R0 when i_S = "000" else
i_R1 when i_S = "001" else
i_R2 when i_S = "010" else
i_R3 when i_S = "011" else
i_R4 when i_S = "100" else
i_R5 when i_S = "101" else
i_R6 when i_S = "110" else
i_R7 when i_S = "111";
end structure;