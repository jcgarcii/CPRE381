-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- org2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2-input OR 
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 1/16/19 by H3::Changed name to avoid name conflict with Quartus 
--         primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity slt is
  generic(N : integer := 32); 
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));

end slt;

architecture structural of slt is

	component org2 is
		port(i_A 	: in std_logic; 
		     i_B	: in std_logic;
		     o_F	: out std_logic); 
	end component; 

begin

	gOR_N: for i in 0 to N-1 generate
	 gOR:	org2
		port map(i_A => i_A(i),
			 i_B => i_B(i),
			 o_F => o_F(i)); 
	end generate gOR_N; 
  
end structural;
