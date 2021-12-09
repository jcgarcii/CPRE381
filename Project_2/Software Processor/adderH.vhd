-------------------------------------------------------------------------
-- Jose Carlos Garcia
-- CPR E 381 - Lab 1
-- Iowa State University
-------------------------------------------------------------------------


-- adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a three input, two output full adder 
--
-- NOTES:
-- This is my dataflow VHDL design of the 2:1 Mux design for CPR E 381 Lab 1
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
------------------------------------------------------------------------
-- Description of an Adder --
------------------------------------------------------------------------
entity adderH is 

   port(iA		: in std_logic;	
	iB		: in std_logic;
	iC		: in std_logic;
	oSum		: out std_logic;
	oCarry		: out std_logic);
 
end adderH; 

architecture structural of adderH is

	component andg2 is
	 port(i_A	: in std_logic; 
	      i_B	: in std_logic;
	      o_F 	: out std_logic); 
	end component; 
	
	component org2 is
	 port(i_A	: in std_logic;
	      i_B 	: in std_logic; 
	      o_F	: out std_logic); 
	end component; 	

	component xorg2 is
	 port(i_A	: in std_logic;
	      i_B	: in std_logic; 
	      o_F	: out std_logic); 
	end component; 

-- Signals to be used (mux 0)-- 
 signal xor0 : std_logic; 
 signal or0 : std_logic; 
--Signals to be used (mux 1)--
 signal xor1 : std_logic;
 signal and0 : std_logic; 
 signal and1 : std_logic; 
 signal and2 : std_logic; 
 signal and3 : std_logic;  
 signal and4 : std_logic; 

begin

-----------------------------------------------------------------------
-- Level 0: Carry  -- 
----------------------------------------------------------------------
 gAND0 : andg2
 	port map(i_A => iA, 
		  i_B => iB, 
	 	   o_F => and0);

 gAND1 : andg2
 	port map(i_A => iA, 
		  i_B => iC, 
	 	   o_F => and1);
 gAND2 : andg2
 	port map(i_A => iB, 
		  i_B => iC, 
	 	   o_F => and2);
 gOR1 : org2
 	port map(i_A => and0, 
		  i_B => and1, 
	 	   o_F => or0);
 gCarry : org2
 	port map(i_A => or0, 
		  i_B => and2, 
	 	   o_F => oCarry);


----------------------------------------------------------------------
-- Level 1: Sum --
----------------------------------------------------------------------
gAND3: andg2
	port map(i_A => iA,
		 i_B => iB, 
		 o_F => and3); 

gAND4: andg2 
	port map(i_A => and3, 
		 i_B => iC, 
		 o_F => and4); 

gXOR0: xorg2
	port map (i_A => iA,
		  i_B => iB, 
		  o_F => xor0); 
gXOR1: xorg2
	port map (i_A => xor0,
		  i_B => iC, 
		  o_F => xor1); 
 gSum : org2
 	port map(i_A => and4, 
		  i_B => xor1, 
	 	   o_F => oSum);

end structural;
 
