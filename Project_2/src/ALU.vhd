library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
	
	generic(N : integer := 32);
	port(iA				: in std_logic_vector(N-1 downto 0); 
	     iB				: in std_logic_vector(N-1 downto 0);
	     iHalt			: in std_logic; 
	     iADDSUB			: in std_logic;
	     iSIGNED			: in std_logic;
	     iSHIFTDIR			: in std_logic; 
	     iALULOGIC			: in std_logic_vector(1 downto 0);
	     iALUOP			: in std_logic_vector(2 downto 0); 
	     o_OF			: out std_logic; 
	     o_Zero			: out std_logic;
	     o_Halt			: out std_logic; 
	     o_ALUOUT			: out std_logic_vector(N-1 downto 0)); 

end ALU;

architecture structure of ALU is
----------------------------------LOGICAL UNITS: --------------------------------------------------
	component andg2_N is
  		port(i_A          		: in std_logic_vector(N-1 downto 0);
       		     i_B          		: in std_logic_vector(N-1 downto 0);
       		     o_F          		: out std_logic_vector(N-1 downto 0));
	end component;

	component mux4t1 is
	  	port(	i_S  : in std_logic_vector (1 downto 0);
			i_R0 : in std_logic_vector(31 downto 0);
			i_R1 : in std_logic_vector(31 downto 0);
			i_R2 : in std_logic_vector(31 downto 0);
			i_R3 : in std_logic_vector(31 downto 0);
			o_Y : out std_logic_vector(31 downto 0));
	end component;

	component mux8t1 is
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
	end component;



	component org2_N is
  		port(i_A          		: in std_logic_vector(N-1 downto 0);
       		     i_B          		: in std_logic_vector(N-1 downto 0);
       		     o_F          		: out std_logic_vector(N-1 downto 0));
	end component;

	component invg is
  		port(i_A          		: in std_logic;
	             o_F          		: out std_logic);
	end component;

	component xorg2_N is
  		port(i_A          		: in std_logic_vector(N-1 downto 0);
       		     i_B          		: in std_logic_vector(N-1 downto 0);
       		     o_F          		: out std_logic_vector(N-1 downto 0));
	end component;

	
----------------------------Arithmetic Functions-----------
	component AddSub_N is 
   		port(iA				: in std_logic_vector(N-1 downto 0);	
		     iB				: in std_logic_vector (N-1 downto 0); 	
		     nAdd_Sub			: in std_logic;
		     oSum			: out std_logic_vector(N-1 downto 0);
		     oCarry			: out std_logic);
	end component; 

	component OnesComp is 
   		port(i_bit			: in std_logic_vector(N-1 downto 0);
		     o_neg			: out std_logic_vector(N-1 downto 0));
	end component; 

	component barrel_shifter is
		--S1 = number of bits to shift
        	--S2,S3: 10 = sra, 00 = srl, 01 = sll
		port(i_D1			: in std_logic_vector(31 downto 0);
	 	   i_S1				: in std_logic_vector(4 downto 0);
	 	    i_S2			: in std_logic;
	 	    i_S3			: in std_logic;
	 	    o_F				: out std_logic_vector(31 downto 0));
	end component;

----------------------------Repl.QB Instruction -------------
	component replqbg is
  		port(i_A          : in std_logic_vector(N-1 downto 0);
       		     o_F          : out std_logic_vector(N-1 downto 0));
	end component;

----------------------------Signals to be used: -------------------------------

--Outputs: 
signal s_LOGICOUT, sOUTPUT : std_logic_vector(N-1 downto 0); 
--ALU's element outputs: 
signal s_aluADDEROUT	: std_logic_vector(N-1 downto 0);
signal s_aluOROUT	: std_logic_vector(N-1 downto 0); 
signal s_aluANDOUT	: std_logic_vector(N-1 downto 0);
signal s_aluXOROUT	: std_logic_vector(N-1 downto 0); 
signal s_aluREPUBOUT	: std_logic_vector(N-1 downto 0); 
signal s_aluSLTOUT	: std_logic_vector(N-1 downto 0); 
signal s_aluNOROUT	: std_logic_vector(N-1 downto 0); 
signal s_aluBSOUT	: std_logic_vector(N-1 downto 0);
signal s_LUI		: std_logic_vector(N-1 downto 0); 


begin

---------------------------------------------------------------------------------------------------------------------------
----ELEMENTS:
--------------------------------------------------------------------------------------------------------------------------

	gBarrelShifter : barrel_shifter
		port map (i_D1				=> iA,
	 	   	i_S1				=> iB(10 downto 6),
	 	   	 i_S2			        => iSIGNED,
	 	   	 i_S3			        => iSHIFTDIR,
	 	    	o_F				=> s_aluBSOUT); 

	gAdderSub : AddSub_N  
   		port map(iA				=> iA, 	
		  	 iB				=> iB, 	
		   	 nAdd_Sub			=> iADDSUB,
		     	 oSum			=> s_aluADDEROUT,
		     	 oCarry			=> o_OF);

	gNOR	: OnesComp
		port map(i_bit			=> s_aluOROUT,
		    	o_neg			=> s_aluNOROUT); 

      s_aluSLTOUT <= ("0000000000000000000000000000000" & s_aluADDEROUT(31)); 

	gAND: andg2_N 
  		port map(i_A          		=> iA, 
       		     i_B          		=> iB,
       		     o_F          		=> s_aluANDOUT);
	
	gOR:  org2_N 
  		port map(i_A          		=> iA,
       		     i_B          		=> iB,
       		     o_F          		=> s_aluOROUT); 
	
	gXOR	: xorg2_N 
  		port map(i_A          		=> iA,
       		     i_B          		=> iB,
       		     o_F          		=> s_aluXOROUT);
	
	gREPLQB	: replqbg 
  		port map(i_A          		=> iB, 
       		    	 o_F          		=> s_aluREPUBOUT);


	s_LUI <= (iB(15 downto 0) & x"0000");

--------------------------------------------------------------------------------------------------------------------------
---ZERO:
--------------------------------------------------------------------------------------------------------------------------
	o_ZERO <= not(s_aluADDEROUT(0) or s_aluADDEROUT(1) or s_aluADDEROUT(2) or
		s_aluADDEROUT(3) or s_aluADDEROUT(4) or s_aluADDEROUT(5) or
		s_aluADDEROUT(6) or s_aluADDEROUT(7) or s_aluADDEROUT(8) or
		s_aluADDEROUT(9) or s_aluADDEROUT(10) or s_aluADDEROUT(11) or
		s_aluADDEROUT(12) or s_aluADDEROUT(13) or s_aluADDEROUT(14) or
		s_aluADDEROUT(15) or s_aluADDEROUT(16) or s_aluADDEROUT(17) or
		s_aluADDEROUT(18) or s_aluADDEROUT(19) or s_aluADDEROUT(20) or
		s_aluADDEROUT(21) or s_aluADDEROUT(22) or s_aluADDEROUT(23) or
		s_aluADDEROUT(24) or s_aluADDEROUT(25) or s_aluADDEROUT(26) or
		s_aluADDEROUT(27) or s_aluADDEROUT(28) or s_aluADDEROUT(29) or
		s_aluADDEROUT(30) or s_aluADDEROUT(31));



---------------------------------------------------------------------------------------------------------------------------
---OUTPUT:
--------------------------------------------------------------------------------------------------------------------------

	gLOGICSEL: mux4t1 
		port map( i_S	=> iALULOGIC,
			  i_R0	=> s_aluANDOUT,
			  i_R1 	=> s_aluOROUT,
			  i_R2	=> s_aluNOROUT,
			  i_R3 	=> s_aluXOROUT, 
			  o_Y	=> s_LOGICOUT); 

	gALUOUT	: mux8t1
		port map( i_S	=> iALUOP,
			  i_R0  => s_aluBSOUT,
			  i_R1	=> s_aluSLTOUT,
			  i_R2	=> s_aluADDEROUT,
			  i_R3 	=> s_LOGICOUT,
			  i_R4  => s_LUI,
			  i_R5   => s_aluREPUBOUT,
			  i_R6 	=> x"00000000",
			  i_R7	=> x"00000000",
			 o_Y	=> o_ALUOUT); 
	o_Halt <= iHALT; 
	



end structure;
