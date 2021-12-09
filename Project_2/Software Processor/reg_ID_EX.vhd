-------------------------------------------------------------------------
-- Jose Carlos Garcia
-- CPR E 381 - Project 2
-- Iowa State University
-------------------------------------------------------------------------
library IEEE; 
use IEEE.std_logic_1164.all; 

entity reg_ID_EX is 
    generic(N : integer := 32); 
    port(i_CLK          : in std_logic; 
         i_RST          : in std_logic; 
         i_WE           : in std_logic; 
         -----VECTOR Feed-in: -----0
         i_PC           : in std_logic_vector(N-1 downto 0); 
         i_RS           : in std_logic_vector(N-1 downto 0); 
         i_RT           : in std_logic_vector(N-1 downto 0); 
         i_opcode       : in std_logic_vector(5 downto 0);
         i_funct        : in std_logic_vector(5 downto 0);  
         i_jumpAddr     : in std_logic_vector(N-1 downto 0); 
         i_signExt      : in std_logic_vector(N-1 downto 0); 
         i_inst15to11   : in std_logic_vector(4 downto 0); 
         i_inst 20to16  : in std_logic_vector(4 downto 0); 
         --Vector Out Feed ---------1
         o_PC           : out std_logic_vector(N-1 downto 0); 
         o_RS           : out std_logic_vector(N-1 downto 0); 
         o_RT           : out std_logic_vector(N-1 downto 0);
         o_opcode       : out std_logic_vector(5 downto 0);
         o_funct        : out std_logic_vector(5 downto 0);   
         o_jumpAddr     : out std_logic_vector(N-1 downto 0); 
         o_signExt      : out std_logic_vector(N-1 downto 0); 
         o_inst15to11   : out std_logic_vector(4 downto 0); 
         o_inst20to16   : out std_logic_vector(4 downto 0));

end reg_ID_EX; 

architecture strucutal of reg_ID_EX is 

    component dffg_N is 
        generic(N : Integer := 32); 
        port(i_CLK        : in std_logic;     -- Clock inputs
           i_RST        : in std_logic;     -- Reset input
           i_WE         : in std_logic;     -- Write enable input
           i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
           o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
        end component;

begin 
    
    gNBit_dffg_PC: dffg_N
        port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_PC,
             o_Q => o_PC);

    gNBit_dffg_RS: dffg_N
        port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_RS,
             o_Q => o_RS);

    gNBit_dffg_RT: dffg_N
        port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_RT,
             o_Q => o_RT);

--------- CONTROL STUFF
    gNBit_dffg_opCODE: dffg_N
    generic(N => 6)
        port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_opcode,
             o_Q => o_opcode);

    gNBit_dffg_functCODE: dffg_N
        generic(N => 6)
        port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_funct,
             o_Q => o_funct);
--Jump stuff
    gNBit_dffg_jADDR: dffg_N
        port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_jumpAddr,
             o_Q => o_jumpAddr);

    gNBit_dffg_SE: dffg_N
        port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_signExt,
             o_Q => o_signExt);
--15 or 20
    gNBit_dffg_15to11: dffg_N
    generic(N => 5)
        port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_inst15to11,
             o_Q => o_inst15to11);

    gNBit_dffg_20to16: dffg_N
    generic(N => 5)
        port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_inst20to16,
             o_Q => o_inst20to16);
        
end structural; 