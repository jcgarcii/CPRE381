library IEEE;
use IEEE.std_logic_1164.all;

entity mux4t1 is

  port(i_S  : in std_logic_vector (1 downto 0);
	i_R0 : in std_logic_vector(31 downto 0);
	i_R1 : in std_logic_vector(31 downto 0);
	i_R2 : in std_logic_vector(31 downto 0);
	i_R3 : in std_logic_vector(31 downto 0);
	o_Y : out std_logic_vector(31 downto 0));

end mux4t1;

architecture structure of mux4t1 is
begin

o_Y <=
i_R0 when i_S = "00" else
i_R1 when i_S = "01" else
i_R2 when i_S = "10" else
i_R3 when i_S = "11";
end structure;