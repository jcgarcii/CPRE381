-------------------------------------------------------------------------
-- Jose Carlos Garcia
-- CPR E 381 - Lab 1
-- Iowa State University
-------------------------------------------------------------------------


-- adder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a three input, ripple carry adder 
--
-- NOTES:
-- This is my structural VHDL design of the adder ripple carry design for CPR E 381 Lab 1
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
------------------------------------------------------------------------
-- Description of a N-Bit Ripple Carry Adder --
------------------------------------------------------------------------
entity adder_N is 

  generic(N : integer := 32);
   port(iA		: in std_logic_vector(N-1 downto 0);	
	iB		: in std_logic_vector (N-1 downto 0);
	iC		: in std_logic;
	oSum		: out std_logic_vector(N-1 downto 0);
	oCarry		: out std_logic);
 
end adder_N; 

architecture structural of adder_N is

	component adderH is
	 port(iA 	: in std_logic; 
	      iB 	: in std_logic; 
	      iC 	: in std_logic; 
              oSum 	: out std_logic; 
	      oCarry 	: out std_logic); 
	end component; 

-- Signals to be used -- 
 signal carry : std_logic_vector(N-1 downto 0);

begin
	g_Adder1: adderH
	 port map(iA 		=> iA(0),
		  iB 		=> iB(0), 
		  iC 		=> iC, 
		  oSum 		=> oSum(0),
		  oCarry	=> carry(0));
--------------------------------------------------
	g_Adder_nBit : for i in 1 to N-2 generate 
	ADDER: adderH
	port map( 
			iA	 => iA (i), 
			iB 	=> iB(i), 
			iC 	=> carry(i-1), 
			oSum 	=> oSum(i), 
			oCarry 	=> carry(i)); 
	end generate g_Adder_nBit; 
--------------------------------------------------
	g_adder2: adderH
	 port map(iA 		=> iA(N-1),
		  iB 		=> iB(N-1), 
		  iC 		=> carry(N-2),
		  oCarry 	=> oCarry,
		 oSum 		=> oSum(N-1)); 

end structural;
 
