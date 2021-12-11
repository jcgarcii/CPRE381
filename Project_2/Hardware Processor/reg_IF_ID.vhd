-------------------------------------------------------------------------
-- Jose Carlos Garcia
-- CPR E 381 - Project 2
-- Iowa State University
-------------------------------------------------------------------------
library IEEE; 
use IEEE.std_logic_1164.all; 

entity reg_IF_ID is 
    generic(N : integer := 32); 
    port(i_CLK          : in std_logic;
         i_RST          : in std_logic; 
         i_WE           : in std_logic; 
         i_PC           : in std_logic_vector(N-1 downto 0); 
         i_instr        : in std_logic_vector(N-1 downto 0); 
         o_PC           : out std_logic_vector(N-1 downto 0); 
         o_instr        : out std_logic_vector(N-1 downto 0));

end reg_IF_ID; 

architecture strucutal of reg_IF_ID is
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

   gNBit_dffg_INSTR: dffg_N
        port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_instr,
             o_Q => o_instr);
    
end structural;