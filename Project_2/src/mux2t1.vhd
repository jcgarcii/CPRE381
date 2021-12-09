-------------------------------------------------------------------------
-- Jose Carlos Garcia
-- CPR E 381 - Lab 1 - Part 3b
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2:1 Mux, using the invg.vhd NOT gate,
-- and the andg2.vhd AND gate, and the org2.vhd OR gate. 
--
-- NOTES:
-- This is my structural VHDL design of the 2:1 Mux design for CPR E 381 Lab 1
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
------------------------------------------------------------------------
-- Description of 2t1 Mux --
------------------------------------------------------------------------
entity mux2t1 is 

   port(i_S		: in std_logic; 
	i_D0		: in std_logic;
	i_D1		: in std_logic;
	o_O 		: out std_logic);
 
end mux2t1; 

architecture structure of mux2t1 is

 -- describe invg.vhd, andg2.vhd, and org2.vhd as used 

 component invg
  port(i_A          : in std_logic;
       o_F          : out std_logic);

 end component;

 component andg2 
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

 end component;

 component org2 
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

 end component;

 -- Signal to carry inverted selector value
 signal s_Si		: std_logic; 
 -- Signals to carry AND output 
 signal sAND1, sAND2	: std_logic;
 


begin 

 ---------------------------------------------------------------------------
  -- Level 0: Initialize NOT Gate and Selector Signals
  ---------------------------------------------------------------------------
 
  g_NOT: invg
    port MAP(i_A              => i_S,
             o_F              => s_Si);
            
  ---------------------------------------------------------------------------
  -- Level 1: Compute AND functions 
  ---------------------------------------------------------------------------
  g_D0AND: andg2
    port MAP(i_A               => i_D0,
             i_B               => s_Si,
   	     o_F              => sAND1);

  g_D1AND: andg2
    port MAP(i_A               => i_D1,
             i_B               => i_S,
   	     o_F              => sAND2);
   
  ---------------------------------------------------------------------------
  -- Level 2: Compute final OR Gate between Level 1's AND gates
  ---------------------------------------------------------------------------
 g_OR: org2
    port MAP(i_A               => sAND1,
             i_B               => sAND2,
   	     o_F              => o_O);
   

  end structure;
 
