----Register File

library IEEE;
use IEEE.std_logic_1164.all;

entity regFile is

  generic(N : Integer := 32); 
  port(iCLK        	: in std_logic;     -- Clock input
       iRST        	: in std_logic;     -- Reset input
       iWRN        	: in std_logic_vector(4 downto 0);    
       iWE	    	: in std_logic; 
       iWD          	: in std_logic_vector(31 downto 0);    
       iDP0	     	: in std_logic_vector(4 downto 0);
       iDP1	      	: in std_logic_vector(4 downto 0); 
       oDP0	      	: out std_logic_vector(31 downto 0); 
       oDP1          	: out std_logic_vector(31 downto 0)); 

end regFile;

architecture structural of regFile is
  
   component dffg_N is 
	port(i_CLK      	  : in std_logic;     -- Clock input
   	    i_RST              	 : in std_logic;     -- Reset input
       	    i_WE        	 : in std_logic;     -- Write enable input
            i_D        		  : in std_logic_vector(N-1 downto 0);     -- Data value input
            o_Q         	 : out std_logic_vector(N-1 downto 0));   -- Data value output

	end component;


   component mux32t1 is

 	 port(i_S	: in std_logic_vector(4 downto 0); 
		iD0	: in std_logic_vector (31 downto 0);
		iD1	: in std_logic_vector (31 downto 0);
		iD2	: in std_logic_vector (31 downto 0);
		iD3	: in std_logic_vector (31 downto 0);
		iD4	: in std_logic_vector (31 downto 0);
		iD5	: in std_logic_vector (31 downto 0);
		iD6	: in std_logic_vector (31 downto 0);
		iD7	: in std_logic_vector (31 downto 0);
		iD8	: in std_logic_vector (31 downto 0);
		iD9	: in std_logic_vector (31 downto 0);
		iD10	: in std_logic_vector (31 downto 0);
		iD11	: in std_logic_vector (31 downto 0);
		iD12	: in std_logic_vector (31 downto 0);
		iD13	: in std_logic_vector (31 downto 0);
		iD14	: in std_logic_vector (31 downto 0);
		iD15	: in std_logic_vector (31 downto 0);
		iD16	: in std_logic_vector (31 downto 0);
		iD17	: in std_logic_vector (31 downto 0);
		iD18	: in std_logic_vector (31 downto 0);
		iD19	: in std_logic_vector (31 downto 0);
		iD20	: in std_logic_vector (31 downto 0);
		iD21	: in std_logic_vector (31 downto 0);
		iD22	: in std_logic_vector (31 downto 0);
		iD23	: in std_logic_vector (31 downto 0);
		iD24	: in std_logic_vector (31 downto 0);
		iD25	: in std_logic_vector (31 downto 0);
		iD26	: in std_logic_vector (31 downto 0);
		iD27	: in std_logic_vector (31 downto 0);
		iD28	: in std_logic_vector (31 downto 0);
		iD29	: in std_logic_vector (31 downto 0);
		iD30	: in std_logic_vector (31 downto 0);
		iD31	: in std_logic_vector (31 downto 0);
		oData   : out std_logic_vector (31 downto 0)); 

	end component;

   component decoder5t32 is 
	 port(i_S    	  	: in std_logic_vector(4 downto 0); 
  	       o_F        	: out std_logic_vector(31 downto 0)); 

	end component;  

	component andg2 is 
		port(i_A 	: in std_logic; 
		     i_B 	: in std_logic; 
		     o_F	: out std_logic); 
	
	end component; 

-- Signals to be used: -----------------
type s_regBus is array (0 to 31) of std_logic_vector(31 downto 0); 
signal sBus : s_regBus; 

type sWR is array (0 to 31) of std_logic; 
signal sWrite : sWR; 

type s_Decoder is array (0 to 31) of std_logic;
signal sDecoder : s_Decoder; 

signal oDecoder : std_logic_vector(31 downto 0); 

begin 


	g_inDecoder: decoder5t32 
		port map(i_S => iWRN, 
			 o_F => oDecoder); 
	
	g_andWR: for i in 0 to N-1 generate
	    gand0: andg2
		port map(i_A => oDecoder(i),
			 i_B => iWE, 
			 o_F => sWrite(i)); 
		end generate g_andWR; 


	gREGIST0: dffg_N 
		port map(i_CLK        => iClk, 
   		   	 i_RST        => '1', 
       			 i_WE         => '0',
       			 i_D          => iWD, 
       			 o_Q          => sBus(0)); 

	gREGIST1: for i in 1 to N-1 generate
		repREG: dffg_N
			port map(i_CLK        => iClk, 
   		   		 i_RST        => iRST, 
       				 i_WE         => sWrite(i),
       				 i_D          => iWD, 
       				 o_Q          => sBus(i));
	end generate gREGIST1; 

----------Level 2: The data ---------
   gMUXD0: mux32t1 
	port map(i_S => iDP0,
    		 iD0	=> sBus(0), 
    		 iD1	=> sBus(1), 
    		 iD2	=> sBus(2), 
    		 iD3	=> sBus(3), 
    		 iD4	=> sBus(4), 
    		 iD5	=> sBus(5), 
    		 iD6	=> sBus(6), 
    		 iD7	=> sBus(7), 
    		 iD8	=> sBus(8), 
    		 iD9	=> sBus(9), 
    		 iD10	=> sBus(10), 
    		 iD11	=> sBus(11), 
    		 iD12	=> sBus(12), 
    		 iD13	=> sBus(13), 
    		 iD14	=> sBus(14), 
    		 iD15	=> sBus(15), 
    		 iD16	=> sBus(16), 
    		 iD17	=> sBus(17),
    		 iD18	=> sBus(18), 
    		 iD19	=> sBus(19), 
    		 iD20	=> sBus(20), 
    		 iD21	=> sBus(21), 
    		 iD22	=> sBus(22), 
    		 iD23	=> sBus(23), 
     		 iD24	=> sBus(24), 
    		 iD25	=> sBus(25), 
    		 iD26	=> sBus(26), 
    		 iD27	=> sBus(27), 
    		 iD28	=> sBus(28), 
    		 iD29	=> sBus(29), 
    		 iD30	=> sBus(30), 
    		 iD31	=> sBus(31), 
		 oData => oDP0); 

   gMUXD1: mux32t1 
	port map(i_S => iDP1,
    		 iD0	=> sBus(0), 
    		 iD1	=> sBus(1), 
    		 iD2	=> sBus(2), 
    		 iD3	=> sBus(3), 
    		 iD4	=> sBus(4), 
    		 iD5	=> sBus(5), 
    		 iD6	=> sBus(6), 
    		 iD7	=> sBus(7), 
    		 iD8	=> sBus(8), 
    		 iD9	=> sBus(9), 
    		 iD10	=> sBus(10), 
    		 iD11	=> sBus(11), 
    		 iD12	=> sBus(12), 
    		 iD13	=> sBus(13), 
    		 iD14	=> sBus(14), 
    		 iD15	=> sBus(15), 
    		 iD16	=> sBus(16), 
    		 iD17	=> sBus(17),
    		 iD18	=> sBus(18), 
    		 iD19	=> sBus(19), 
    		 iD20	=> sBus(20), 
    		 iD21	=> sBus(21), 
    		 iD22	=> sBus(22), 
    		 iD23	=> sBus(23), 
     		 iD24	=> sBus(24), 
    		 iD25	=> sBus(25), 
    		 iD26	=> sBus(26), 
    		 iD27	=> sBus(27), 
    		 iD28	=> sBus(28), 
    		 iD29	=> sBus(29), 
    		 iD30	=> sBus(30), 
    		 iD31	=> sBus(31), 
		 oData => oDP1); 
  
end structural;
