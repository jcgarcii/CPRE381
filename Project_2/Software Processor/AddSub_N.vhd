-------------------------------------------------------------------------
-- Jose Carlos Garcia
-- CPR E 381 - Lab 1
-- Iowa State University
-------------------------------------------------------------------------


-- AddSub.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an Adder-Subtractor with Control 
--
-- NOTES:
-- This is my structural VHDL design of the adder-subtractor design with control for CPR E 381 Lab 1
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
------------------------------------------------------------------------
-- Description of a Adder-Subber, updated to fit the first datapath--
------------------------------------------------------------------------
entity AddSub_N is 
  generic(N: integer := 32);
   port(iA			: in std_logic_vector(N-1 downto 0);	
	iB			: in std_logic_vector (N-1 downto 0); 	
	nAdd_Sub		: in std_logic;
	oSum			: out std_logic_vector(N-1 downto 0);
	oCarry			: out std_logic);
 
end AddSub_N; 

architecture structural of AddSub_N is
	
	component mux2t1_N is
	port(i_S          : in std_logic;
      	     i_D0         : in std_logic_vector(N-1 downto 0);
             i_D1         : in std_logic_vector(N-1 downto 0);
             o_O          : out std_logic_vector(N-1 downto 0));
	end component; 
	
	component OnesComp is 
	  port(i_bit : in std_logic_vector(N-1 downto 0);
	       o_neg : out std_logic_vector(N-1 downto 0));
	end component;

	component adder_N is	
	 port(iA 	: in std_logic_vector(N-1 downto 0); 
	      iB 	: in std_logic_vector(N-1 downto 0); 
	      iC 	: in std_logic; 
              oSum 	: out std_logic_vector(N-1 downto 0); 
	      oCarry 	: out std_logic); 
	end component; 

-- signals to be used --
signal notB : std_logic_vector(N-1 downto 0);
signal MUX : std_logic_vector(N-1 downto 0);
signal carry : std_logic_vector(N-1 downto 0); 

begin
  
	g_Comp: onescomp
	 port map(i_bit => iB, 
		  o_neg => notB); 

	g_Mux: mux2t1_N 
	 port map(i_S => nAdd_Sub,
      	     	  i_D0 => iB, 
             	  i_D1 => notB,
             	  o_O  => MUX); 
		
	g_adderN: adder_N
	 port map(iA 		=> iA,
		  iB 		=> MUX, 
		  iC 		=> nAdd_Sub, 
		  oCarry 	=> oCarry,
		  oSum 		=> oSum); 

end structural;
 
