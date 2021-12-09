-------------------------------------------------------------------------

-- Program Counter File

library IEEE;
use IEEE.std_logic_1164.all;

entity PC is

	generic(N : integer := 32); 
	  port(iCLK			: in std_logic; 
	       iWE			: in std_logic;
	       iRST			: in std_logic; 
	       iD			: in std_logic_vector(N-1 downto 0);	
               oQ			: out std_logic_vector(N-1 downto 0)); 

end  PC;


architecture structure of PC is

---Signals to be used ----
signal sD, sQ :  std_logic_vector(N-1 downto 0); 
	
begin 
	oQ <= sQ; 

	with iWE select 
	sD <= iD when '1', 
	sQ when others; 
  
	process (iCLK, iRST)
		begin 
			if(iRST = '1') then
			sQ <= x"00400000";
			elsif (rising_edge(iCLK)) then 
				sQ <= sD; 
			end IF ;
	end process; 


end structure; 
