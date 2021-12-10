-------------------------------------------------------------------------
-- Jose Carlos Garcia
-- CPR E 381 - Project 2
-- Iowa State University
-------------------------------------------------------------------------
-- Implementation of a Hazard Detection Unit. 
-------------------------------------------------------------------------
library IEEE; 
use IEEE.std_logic_1164.all; 

entity hazard_unit is
    port(--Read Hazards: 
        i_reg_read_RS       : in std_logic_vector(4 downto 0); 
        i_reg_read_RT       : in std_logic_vector(4 downto 0); 
    -----ID Stage;
        i_ID_jump          : in std_loigc; 
        i_ID_branch        : in std_logic; 
        i_ID_writeAddr     : in std_logic_vector(4 downto 0); -- Write Hazard ---- ID
        i_ID_writeEN       : in std_logic;                    -- Write hazard ---- ID
        -----EX Stage; 
        i_EX_jump          : in std_logic;
        i_EX_branch        : in std_logic; 
        i_EX_writeAddr     : in std_logic_vector(4 downto 0); -- Write Hazard ---- EX
        i_EX_writeEN       : in std_logic;                    -- Write Hazard ---- EX
        ----MEM Stage;
        i_MEM_jump          : in std_logic; 
        i_MEM_branch        : in std_logic; 
        ---WB Stage; 
        i_WB_jump           : in std_logic; 
        i_WB_branch         : in std_logic; 
        --STALL 
        o_stall             : out std_logic);                   -- Outputs stall signal
        o_flush
    
end hazard_unit; 

architecture mixed of hazard_unit is 
begin 
    process(--Read hazards: 
        i_reg_read_RS,
        i_reg_read_RT, 
    -----ID Stage;
        i_ID_jump,         
        i_ID_branch,        
        i_ID_writeAddr,  --Write Hazards  
        i_ID_writeEN,     -- Write Hazard 
        -----EX Stage; 
        i_EX_jump,          
        i_EX_branch,        
        i_EX_writeAddr,    --Write Hazard
        i_EX_writeEN,       --Write hazard
        ----MEM Stage;
        i_MEM_jump,         
        i_MEM_branch,        
        ---WB Stage; 
        i_WB_jump,           
        i_WB_branch)
begin 
    -----ID stage read and write hazards:  
    if(i_reg_read_RS = i_ID_writeAddr AND 
        i_reg_read_RS /= "00000" AND 
        i_ID_writeEN = '1')
        --EX STAGE read and write hazards: 
    OR(i_reg_read_RS = i_EX_writeAddr AND 
        i_reg_read_RS /= "00000" AND 
        i_EX_writeEN = '1') then 
        o_stall <= '1'; 

    -- Jump or Branch data hazard across the stages: 
    elsif(
        --ID stage: 
            i_ID_jump = '1' OR
            i_ID_branch = '1' OR
        --EX Stage: 
            i_EX_jump = '1' OR
            i_EX_branch = '1' OR
        --MEM Stage: 
            i_MEM_jump = '1' OR
            i_MEM_branch = '1' OR
        --WB Stage:
        i_MEM_jump = '1' OR
        i_MEM_branch = '1' )then 
            o_stall <= '1'; 
            o_flush <= '1'; 

    --otherwise, there is no hazard: 
            o_stall <= '0';
            o_flush <= '0';
        end if; 
    
    end process;

begin mixed; 