-------------------------------------------------------------------------

-- instruction_fetcher.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity inst_fetch is

	generic(N : integer := 32); 
	   port(iCLK			: in std_logic;
		iRST			: in std_logic;
		iMEM_WE			: in std_logic;
		iBranch			: in std_logic;
		iJump			: in std_logic_vector(1 downto 0); 
		i_IMM			: in std_logic_vector(N-1 downto 0); 		
		iPCNext			: in std_logic_vector(N-1 downto 0);	
		iINSTR			: in std_logic_vector(N-1 downto 0);
		oAddr			: out std_logic_vector(N-1 downto 0));	

end  inst_fetch;


architecture structure of inst_fetch is


	component PC is 
	 port(iCLK			: in std_logic; 
	       iWE			: in std_logic;
	       iRST			: in std_logic; 
	       iD			: in std_logic_vector(N-1 downto 0);	
               oQ			: out std_logic_vector(N-1 downto 0)); 	
	end component;

	component mux2t1_N is 
	port(i_S 	: in std_logic; 
	     i_D0 	: in std_logic_vector(N-1 downto 0);
	     i_D1 	: in std_logic_vector(N-1 downto 0); 
	     o_O	: out std_logic_vector(N-1 downto 0)); 
	end component; 
	
	component adder_N is
	   port(iA		: in std_logic_vector(N-1 downto 0);	
		iB		: in std_logic_vector (N-1 downto 0);
		iC		: in std_logic;
		oSum		: out std_logic_vector(N-1 downto 0);
		oCarry		: out std_logic);
 	
	end component;


---Signals to be used ----
signal sPC, sAdder_Result		: std_logic_vector(N-1 downto 0); --
signal sCarry				: std_logic; 
--Branch Signals: -------
signal s_branchAddress			: std_logic_vector(N-1 downto 0);
signal s_branchAdder			: std_logic_vector(N-1 downto 0); 
signal s_branchCarry			: std_logic; 
signal s_branchMUX			: std_logic_vector(N-1 downto 0); 
---Jump Signals: ----
signal s_jumpAddress			: std_logic_vector(N-1 downto 0); 
signal s_jumpMUX			: std_logic_vector(N-1 downto 0); 
signal s_jumpRE				: std_logic_vector(N-1 downto 0);  --  


begin 

	gProgamCounter0: PC
		port map(iCLK		=> 	iCLK, 
	     	      iWE		=> 	iMEM_WE, 
	       	      iRST		=> 	iRST, 
	              iD	 	=> 	s_jumpRE, --Jump Mux selector (PC + 4 by default) 	
                      oQ		=>	sPC); 
	
		-- Case 1: Standard +4 incrementation --
	gPC_4	: adder_N  
		 port map(iA		=> 	sPC, 	
			iB		=> 	x"00000004",
			iC		=> 	'0',
			oSum	        => 	sAdder_Result,
			oCarry		=> 	sCarry);
	
		-- Case 2: Branch -----
		s_branchAddress	<=	i_IMM(29 downto 0) & '0' & '0';

	gPC_Branch: Adder_N
		port map(iA		=> 	sAdder_Result,
			iB		=> 	s_branchAddress,
			iC		=> 	'0', 		
			oSum	        => 	s_branchAdder, 
			oCarry		=> 	s_branchCarry); 


	gMUX_Branch : mux2t1_N
		port map(i_S 	=> iBranch,  
	     		i_D0 	=> sAdder_Result, 
	     		i_D1 	=> s_branchAdder, 
	     		o_O	=> s_branchMUX);


		-- Case 3: Jump ------- 
	s_jumpAddress <= sAdder_Result(31 downto 28) & iINSTR(25 downto 0) & '0' & '0'; 		

		gMUX_JUMP : mux2t1_N
		port map(i_S 	=> iJump(0),  
	     		i_D0 	=> s_branchMUX, 
	     		i_D1 	=> s_jumpAddress, 
	     		o_O	=> s_jumpMUX);

		gMUX_Return : mux2t1_N
		port map(i_S 	=> iJump(1),  
	     		i_D0 	=> s_jumpMUX, 
	     		i_D1 	=> iPCNext, 
	     		o_O	=> s_jumpRE);
	
	oAddr	<= sPC;
			
end structure; 
