-------------------------------------------------------------------------
-- Jose Carlos Garcia
-- CPR E 381 - Project 2
-- Iowa State University
-------------------------------------------------------------------------
library IEEE; 
use IEEE.std_logic_1164.all; 

entity reg_MEM_WB is
    generic(N : integer := 32); 
    port(i_CLK          : in std_logic; 
         i_RST          : in std_logic; //(1 resets the register)
         i_WE           : in std_logic; 
         --one bit feed ins 
         i_overflow     : in std_logic; 
         i_branch       : in std_logic; --if branch
         i_jump         : in std_logic;
         i_halt         : in std_logic;
         i_jumpLink     : in std_logic;
         i_memReg       : in std_logic;
         i_weReg        : in std_logic;  
         -- vector feed ins 
         i_PC          : in std_logic_vector(N-1 downto 0); -- next instruction
         i_branchAddr   : in std_logic_vector(N-1 downto 0); -- branch Addr
         i_jumpAddr     : in std_logic_vector (N-1 downto 0 ); --jump address
         i_ALU_out      : in std_logic_vector(N-1 downto 0); --ALU output 
         i_readData     : in std_logic_vector(N-1 downto 0); 
         i_writeReg     : in std_logic_vector(4 downto 0); 
         --one bit out feeds
         o_overflow     : out std_logic; 
         o_branch       : out std_logic; -- if branch
         o_jump         : out std_logic;
         o_halt         : out std_logic;
         o_jumpLink     : out std_logic;
         o_memReg       : out std_logic;
         o_weReg        : out std_logic; 
         --vector out feeds 
         o_PC          : out std_logic_vector(N-1 downto 0); --next instruction
         o_branchAddr   : out std_logic_vector(N-1 downto 0); -- branch address
         o_jumpAddr     : out std_logic_vector (N-1 downto 0 ); --jump address
         o_ALU_out      : out std_logic_vector(N-1 downto 0); -- ALU output 
         o_readData     : out std_logic_vector(N-1 downto 0); 
         o_writeReg     : out std_logic_vector(4 downto 0));

end reg_MEM_WB; 

architecture strucutal of reg_MEM_WB is 

    component dffg is 
         port(i_CLK        : in std_logic;     -- Clock input
               i_RST        : in std_logic;     -- Reset input
                   i_WE         : in std_logic;     -- Write enable input
                   i_D          : in std_logic;     -- Data value input
                   o_Q          : out std_logic);
        end component; 
    
    
    component dffg_N is 
        generic(N : Integer := 32); 
        port(i_CLK        : in std_logic;     -- Clock inputs
           i_RST        : in std_logic;     -- Reset input
           i_WE         : in std_logic;     -- Write enable input
           i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
           o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
        end component;
--------------------------------------------------------------------------------------
begin
--------- One bit: ------------------------------
g_dffg_OF: dffg
    port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_overflow,
             o_Q => o_overflow);

g_dffg_br: dffg
    port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_branch,
             o_Q => o_branch);

g_dffg_j: dffg
    port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_jump,
             o_Q => o_jump);
--
g_dffg_halt: dffg
    port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_halt,
             o_Q => o_halt);

g_dffg_jal: dffg
    port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_jumpLink,
             o_Q => o_jumpLink);

g_dffg_memReg: dffg
    port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_memReg,
             o_Q => o_memReg);

g_dffg_WE_Reg: dffg
    port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_weReg,
             o_Q => o_weReg);

---N-Bit Vectors: ----
gNBit_dffg_PC: dffg_N
    port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_PC,
             o_Q => o_PC); 

gNBit_dffg_branch: dffg_N
    port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_branchAddr,
             o_Q => o_branchAddr); 

gNBit_dffg_j: dffg_N
    port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_jumpAddr,
             o_Q => o_jumpAddr);  

gNBit_dffg_ALU: dffg_N
    port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_ALU_out,
             o_Q => o_ALU_out);

gNBit_dffg_RD: dffg_N
    port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_readData,
             o_Q => o_readData);

gNBit_dffg_WD: dffg_N
    generic map(N => 5)
    port map(i_CLK => i_CLK, 
             i_RST=> i_RST, 
             i_WE => i_WE,
             i_D => i_writeReg,
             o_Q => o_writeReg);
             
end structrual;