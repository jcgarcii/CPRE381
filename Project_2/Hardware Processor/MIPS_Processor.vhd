-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
        use IEEE.std_logic_arith.all;
        use IEEE.numeric_bit.all;
        use IEEE.numeric_std.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated
 
  --Dummy Signal: 
  signal s_x    : std_logic; 
  ------- STAGE SIGNALS: ---------
  --IF Stage: 
  signal s_IF_PC    : std_logic_vector(N-1 downto 0); 
 signal s_IF_stalled_Addr : std_logic_Vector(N-1 downto 0);
 signal s_IF_stalled_instr : std_logic_Vector(N-1 downto 0);  
 signal s_IF_stall      : std_logic;
 signal s_IF_flush      : std_logic;
 signal s_IF_reset      : std_logic;  

  ---ID Stage: 
      -- General-- 
  signal s_ID_PC        : std_logic_vector(N-1 downto 0); --NEXT INSTRUCTION
  signal s_ID_instr     : std_logic_vector(N-1 downto 0); --CURRENT INSTRUCITON 
  signal s_ID_jumpAddr  : std_logic_vector(N-1 downto 0); 
  signal s_ID_imm16     : std_logic_vector(N-1 downto 0); 
  signal s_ID_imm32     : std_logic_vector(N-1 downto 0); 
      -- regFile -- 
  signal s_ID_reg_RS     : std_logic_vector(N-1 downto 0); 
  signal s_ID_reg_RT     : std_logic_vector(N-1 downto 0); 
  signal s_ID_reg_dst    : std_logic_vector(4 downto 0); 
  signal s_ID_RegWr    : std_logic_vector(4 downto 0);   
  
  -- Control -- 
  signal s_ID_opCode    : std_logic_vector(5 downto 0); 
  signal s_ID_funct     : std_logic_vector(5 downto 0); 
  signal s_ID_Halt      : std_logic;
  signal s_ID_extend    : std_logic; 
  signal s_ID_control   : std_logic_vector(14 downto 0);
 
  --Forwarding: -- Essentially, two data wires. 
  signal  s_ID_fwd_RS_sel    : std_logic_vector(N-1 downto 0);
  signal s_ID_fwd_RT_sel      : std_logic_vector(N-1 downto 0); 
  signal s_ID_fwd_data1   : std_logic_vector(N-1 downto 0);
  signal s_ID_fwd_data2   : std_logic_vector(N-1 downto 0); 
-- flush or:
signal s_ID_flush      : std_logic;
signal s_ID_reset      : std_logic; 

  --EX Stage: 
    --General --- 
    signal s_EX_PC              :  std_logic_vector(N-1 downto 0); 
   --Addresses/I-type:---
    signal s_EX_jumpAddr        : std_logic_vector(N-1 downto 0); 
    signal s_EX_imm32           : std_logic_vector(N-1 downto 0); 
    signal s_EX_immj            : std_logic_vector(N-1 downto 0); 
    signal s_EX_imm_mux         : std_logic_vector(N-1 downto 0);
    signal s_EX_jumpAddr_final  : std_logic_vector(N-1 downto 0); 
    signal s_EX_branchAddr      : std_logic_vector(N-1 downto 0); 
    --Register Stuff
    signal s_EX_iRT             : std_logic_vector(4 downto 0);
    signal s_EX_iRD             : std_logic_vector(4 downto 0); 
    signal s_EX_reg_RS          : std_logic_vector(N-1 downto 0); 
    signal s_EX_reg_RT          : std_logic_vector(N-1 downto 0); 
    signal s_EX_reg_Wr          : std_logic_vector(4 downto 0);
    --ALU Stuff: 
    signal s_EX_ALU_Src         : std_logic; 
    signal s_EX_ALU_shamt       : std_logic_vector(4 downto 0); 
    signal s_EX_ALU_OP          : std_logic_vector(3 downto 0); 
    signal s_EX_ALU_out         : std_logic_vector(N-1 downto 0); 
    signal s_EX_ALU_zero        : std_logic; 
    signal s_EX_ALU_OF          : std_logic; 
    signal s_EX_logicCtrl       : std_logic_vector(1 downto 0); 
    signal s_EX_arithCtl        : std_logic; 
    signal s_EX_shiftDir        : std_logic; 
    signal s_EX_add_sub         : std_logic; 
    signal s_EX_signed          : std_logic; 

    --Control Stuff: 
    signal s_EX_control         : std_logic_vector(14 downto 0);
    signal s_EX_control_j       : std_logic_vector(1 downto 0); 
    signal s_EX_control_jal     : std_logic;
    signal s_EX_control_memToReg  : std_logic;
    signal s_EX_control_DMem_WR   : std_logic; 
    signal s_EX_control_branch    : std_logic; 
    signal s_EX_control_dst       : std_logic; 
    signal s_EX_control_halt      : std_logic; 
    signal s_EX_control_regWr     : std_logic;
    signal s_EX_opcode            : std_logic_vector(5 downto 0); 
    signal s_EX_funct             : std_logic_vector(5 downto 0);  

  --MEM Stage:
    --General: 
    signal s_MEM_PC             : std_logic_vector(N-1 downto 0); 
    --Address/I-Type: 
    signal s_MEM_jumpAddr       : std_logic_vector(N-1 downto 0); 
    signal s_MEM_branchAddr     : std_logic_vector(N-1 downto 0); 
    --Register Stuff: 
    signal s_MEM_reg_WR         : std_logic_vector(4 downto 0); 
    signal s_MEM_reg_RD         : std_logic_vector(N-1 downto 0); 
    --ALU Stuff:
    signal s_MEM_ALU_out        : std_logic_vector(N-1 downto 0); 
    signal s_MEM_ALU_branch     : std_logic;
    signal s_MEM_ALU_OF         : std_logic; 
    --Control stuff: 
    signal s_MEM_control_j      : std_logic_vector(1 downto 0); 
    signal s_MEM_control_jal    : std_logic;
    signal s_MEM_control_memToReg : std_logic;
    signal s_MEM_control_DMem_WR  : std_logic; 
    signal s_MEM_control_regWr    : std_logic; 
    signal s_MEM_control_branch   : std_logic; 
    signal s_MEM_control_halt     : std_logic; 
    signal s_MEM_control_zero     : std_logic;  
    
    --FLUSH :
    signal s_MEM_flush      : std_logic;
  signal s_MEM_reset      : std_logic; 

  --WB Stage:
    --General:
    signal s_WB_PC              : std_logic_vector(N-1 downto 0); 
    --Address/I-Type: 
    signal s_WB_jumpAddr        : std_logic_vector(N-1 downto 0); 
    signal s_WB_branchAddr      : std_logic_vector(N-1 downto 0); 
    signal s_WB_PC_next         : std_logic_vector(N-1 downto 0);
    signal s_WB_PC_input         : std_logic_vector(N-1 downto 0); 
    --Register Stuff: 
    signal s_WB_reg_RED         : std_logic_vector(N-1 downto 0);
    signal s_WB_reg_memToReg    : std_logic_vector(4 downto 0);  
    --ALU stuff:
    signal s_WB_ALU_out         : std_logic_vector(N-1 downto 0); 
    --Control: 
    signal s_WB_control_j       : std_logic_vector(1 downto 0);
    signal s_WB_control_jal     : std_logic;
    signal s_WB_control_memToReg  : std_logic;
    signal s_WB_control_regWr     : std_logic; 
    signal s_WB_control_zero      : std_logic;
    signal s_WB_control_halt      : std_logic;
    
  ------------------------------------------------------------------------------------------
  -------------Component declaration: -----------------------------------------------------
  -----------------------------------------------------------------------------------------
  component mem is
    generic(ADDR_WIDTH : natural:= 32;
            DATA_WIDTH : natural := 10);
    port(
          clk           : in std_logic;
          addr          : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data          : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we            : in std_logic := '1';
          q             : out std_logic_vector((DATA_WIDTH-1) downto 0));
    end component;

  component PC is 
    generic(N : integer := 32); 
	  port(iCLK			: in std_logic; 
	       iWE			: in std_logic;
	       iRST			: in std_logic; 
	       iD			  : in std_logic_vector(N-1 downto 0);	
         oQ			  : out std_logic_vector(N-1 downto 0)); 
  end  component;

--General components

component regFile is

  generic(N : Integer := 32); 
  port(iCLK        	  : in std_logic;     -- Clock input
       iRST        	  : in std_logic;     -- Reset input
       iWRN        	  : in std_logic_vector(4 downto 0);    
       iWE	    	    : in std_logic; 
       iWD          	: in std_logic_vector(31 downto 0);    
       iDP0	     	    : in std_logic_vector(4 downto 0);
       iDP1	      	  : in std_logic_vector(4 downto 0); 
       oDP0	      	  : out std_logic_vector(31 downto 0); 
       oDP1          	: out std_logic_vector(31 downto 0)); 

end component;


component org2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;


  component extend16t32 is
  port(i_S          : in std_logic;
       i_A          : in std_logic_vector(15 downto 0);
       o_O          : out std_logic_vector(31 downto 0));

  end component;

component extend8t32 is
  port(i_S          : in std_logic;
       i_A          : in std_logic_vector(7 downto 0);
       o_O          : out std_logic_vector(31 downto 0));

end component;

component andg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;


  component mux2t1_N is
  generic(N : integer := 32);
    port(i_S          : in std_logic;
       i_D0           : in std_logic_vector(N-1 downto 0);
       i_D1           : in std_logic_vector(N-1 downto 0);
       o_O            : out std_logic_vector(N-1 downto 0));

  end component;

component mux4t1 is

  port(i_S          : in std_logic_vector (1 downto 0);
	i_R0              : in std_logic_vector(31 downto 0);
	i_R1              : in std_logic_vector(31 downto 0);
	i_R2              :  in std_logic_vector(31 downto 0);
	i_R3              : in std_logic_vector(31 downto 0);
	o_Y               : out std_logic_vector(31 downto 0));

end component;

component mux2t1_5 is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(4 downto 0);
       i_D1         : in std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(4 downto 0));

end component;
--Control components
component singleCycleControl is
  port(
		opcode		      : in std_logic_vector(5 downto 0);
		func		        : in std_logic_vector(5 downto 0);
	  halt            : out std_logic;
    signExt         : out std_logic;
		link		        : out std_logic; --15
		regDest		      : out std_logic; --12
		ALUSrc		      : out std_logic_vector(1 downto 0); --11
		MemReg		      : out std_logic; --10
		RegWr		        : out std_logic; --9
		MemRd		        : out std_logic; --8
		MemWr		        : out std_logic; --7
		Branch		      : out std_logic; --6
		BEQ             : out std_logic; --5
		jump		        : out std_logic_vector(1 downto 0); --4
		ALUop		        : out std_logic_vector(2 downto 0)); -- 3-0

end component;


component ALUControl is
  port(
		func		: in std_logic_vector(5 downto 0);
		opCode		: in std_logic_vector(5 downto 0);
		logicCTL	: out std_logic_vector(1 downto 0);
		arithCtl	: out std_logic;
		shiftDir	: out std_logic;
		add_sub		: out std_logic;
		o_signed	: out std_logic);

end component;

--Fetcher components

component inst_fetch is

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

end  component;

component AddSub_N is 
  generic(N: integer := 32);
   port(iA	  		  : in std_logic_vector(N-1 downto 0);	
	      iB		  	  : in std_logic_vector (N-1 downto 0); 	
	      nAdd_Sub		: in std_logic;
	      oSum			  : out std_logic_vector(N-1 downto 0);
	      oCarry			: out std_logic);
end component; 

--ALU components

component ALU is
	
	generic(N : integer := 32);
	port(iA				: in std_logic_vector(N-1 downto 0); 
	     iB				: in std_logic_vector(N-1 downto 0);
	     iADDSUB			: in std_logic;
	     iSIGNED			: in std_logic;
	     iSHIFTDIR			: in std_logic; 
	     iALULOGIC			: in std_logic_vector(1 downto 0);
	     iALUOP			: in std_logic_vector(2 downto 0); 
	     o_OF			: out std_logic; 
	     o_Zero			: out std_logic;
	      o_ALUOUT			: out std_logic_vector(N-1 downto 0)); 

end component;

component replqbg is
  generic(N: integer := 32); 
  port(i_A          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));

end component;

-----Stage Register Componenets: 

--IF/ID Stage: ------------------------------------------0
component reg_IF_ID is 
  port(i_CLK          : in std_logic;
       i_RST          : in std_logic; 
       i_WE           : in std_logic; 
       i_PC           : in std_logic_vector(N-1 downto 0); 
       i_instr        : in std_logic_vector(N-1 downto 0); 
       o_PC           : in std_logic_vector(N-1 downto 0); 
       o_instr        : in std_logic_vector(N-1 downto 0));
end component; 

--ID/EX Stage: ------------------------------------------1
component reg_ID_EX is 
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
       i_control       : in std_logic_vector(14 downto 0);    
       i_jumpAddr     : in std_logic_vector(N-1 downto 0); 
       i_signExt      : in std_logic_vector(N-1 downto 0); 
       i_reg_DST      : in std_logic_vector(4 downto 0); 
       i_instr        : in std_logic_vector(N-1 downto 0); 
       --Vector Out Feed ---------1
       o_PC           : out std_logic_vector(N-1 downto 0); 
       o_RS           : out std_logic_vector(N-1 downto 0); 
       o_RT           : out std_logic_vector(N-1 downto 0);
       o_opcode       : out std_logic_vector(5 downto 0);
       o_funct        : out std_logic_vector(5 downto 0);
       o_control      : out std_logic_vector(14 downto 0);     
       o_jumpAddr     : out std_logic_vector(N-1 downto 0); 
       o_signExt      : out std_logic_vector(N-1 downto 0); 
       o_reg_DST      : out std_logic_vector(4 downto 0); 
       o_instr        : out std_logic_vector(N-1 downto 0); );

end component; 
--EX/MEM Stage: ---------------------------------------------1
component reg_EX_MEM is
  port(i_CLK          : in std_logic; 
       i_RST          : in std_logic; --(1 resets the register)
       i_WE           : in std_logic; 
       --one bit feed ins 
       i_overflow     : in std_logic; 
       i_branch       : in std_logic;
       i_jump         : in std_logic;
       i_halt         : in std_logic;
       i_jumpLink     : in std_logic;
       i_zero         : in std_logic;
       i_memReg       : in std_logic;
       i_halt         : in std_logic;
       i_weReg        : in std_logic; 
       i_weMem        : in std_logic; 
       -- vector feed ins 
       i_PC          : in std_logic_vector(N-1 downto 0); --next instruction
       i_branchAddr   : in std_logic_vector(N-1 downto 0); -- branch address
       i_jumpAddr     : in std_logic_vector (N-1 downto 0 ); -- jump address
       i_ALU_out      : in std_logic_vector(N-1 downto 0); -- ALU output 
       i_readData     : in std_logic_vector(N-1 downto 0); 
       i_writeReg     : in std_logic_vector(4 downto 0); 
       --one bit out feeds
       o_overflow     : out std_logic; 
       o_branch       : out std_logic;
       o_jump         : out std_logic;
       o_halt         : out std_logic;
       o_jumpLink     : out std_logic;
       o_zero         : out std_logic;
       o_halt         : out std_logic; 
       o_memReg       : out std_logic;
       o_weReg        : out std_logic; 
       o_weMem        : out std_logic; 
       --vector out feeds 
       o_PC          : out std_logic_vector(N-1 downto 0); -- next instruction
       o_branchAddr   : out std_logic_vector(N-1 downto 0); -- branch address
       o_jumpAddr     : out std_logic_vector (N-1 downto 0 ); -- jump address
       o_ALU_out      : out std_logic_vector(N-1 downto 0); -- ALU output 
       o_readData     : out std_logic_vector(N-1 downto 0); 
       o_writeReg     : out std_logic_vector(4 downto 0));

end component;

--MEM/WB Stage: 
component reg_MEM_WB is
  port(i_CLK          : in std_logic; 
       i_RST          : in std_logic; 
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
end component; 

--- Hardware Componenets ---
component hazard_unit is
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

end component; 

component ForwardingUnit is
  port(
		i_RS				    : in std_logic_vector(4 downto 0);
		i_RT				    : in std_logic_vector(4 downto 0);
		i_EXMEM_RD			: in std_logic_vector(4 downto 0);
		i_MEMWB_RD			: in std_logic_vector(4 downto 0);
		i_EXMEM_regwr		: in std_logic;
		i_MEMWB_regWr		: in std_logic;
		o_RS_select			: out std_logic;
		o_RT_select			: out std_logic);
end component;

 ---------------------------------------------------------------------------------------------------------------------
 ------------------------IF STAGE-------------------------------------------------------------------------------------
 --------------------------------------------------------------------------------------------------------------------
begin
 -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
   with iInstLd select
   s_IMemAddr <= s_NextInstAddr when '0',
   iInstAddr when others;

   g_PC : PC  
    port map (iCLK			=> iCLK,  
              iWE			  => '1',
              iRST			=> iRST,
              iD			 	=> s_WB_PC_next,
              oQ			  => s_NextInstAddr);  
   
   IMem: mem
        generic map(ADDR_WIDTH => 10,
               DATA_WIDTH => N)
        port map(clk  => iCLK,
                addr => s_IMemAddr(11 downto 2),
                data => iInstExt,
                we   => iInstLd,
                q    => s_Inst);

  g_PCplus4 :  AddSub_N  
     port map (iA			    =>  s_IMemAddr,    	
          iB			    =>  x"00000004",	
          nAdd_Sub		=>  '0', 
          oSum			  =>  s_IF_PC, 
          oCarry			=>  s_x); 

  g_hazard:  hazard_unit 
  port(--Read Hazards: 
      i_reg_read_RS      => s_ID_instr(25 downto 21);  
      i_reg_read_RT      => s_ID_instr(20 downto 16); 
  -----ID Stage;
      i_ID_jump          => s_ID_control(4), 
      i_ID_branch        => s_ID_control(6),
      i_ID_writeAddr     => s_ID_RegWr,
      i_ID_writeEN       => s_ID_control(9),                    
      -----EX Stage; 
      i_EX_jump          => s_EX_control(4)
      i_EX_branch        => s_EX_control(6) 
      i_EX_writeAddr     => s_EX_reg_Wr,
      i_EX_writeEN       => s_EX_control_regWr,
      ----MEM Stage;
      i_MEM_jump         => s_MEM_control_j, 
      i_MEM_branch       => s_MEM_control_branch,
      ---WB Stage; 
      i_WB_jump          => s_WB_control_jump,
      i_WB_branch        => s_WB_control_zero,
      --STALL 
      o_stall            => s_IF_stall,
      o_flush           => s_IF_flush); 

end component; 

g_OR_IF_ID_flush :  org2 
port map(i_A         => iRST, 
       i_B           => s_IF_flush,
       o_F           => s_IF_reset);

g_Stall_addr  :  : mux2t1_N
  port map(
            i_S      => s_IF_stall,     
            i_D0     => s_IF_PC,  
            i_D1     => s_IMemAddr,   
            o_O      => s_IF_stalled_Addr;
  
g_Stall_instr  :  : mux2t1_N
  port map(
            i_S      => s_IF_stall,     
            i_D0     => s_IF_instr,   
            i_D1     => x"00000000",   
            o_O      => s_IF_stalled_instr);

    


  g_IF_ID : reg_IF_ID 
      port map(i_CLK          => iCLK,
              i_RST           => s_IF_reset,  
              i_WE            => '1',  
              i_PC            => s_IF_PC,  
              i_instr         => s_IF_stalled_instr,  
              o_PC            => s_ID_PC,  
              o_instr         => s_ID_instr); 

 ---------------------------------------------------------------------------------------------------------------------
 ------------------------ID STAGE-------------------------------------------------------------------------------------
 --------------------------------------------------------------------------------------------------------------------
        -- Instruciton Setup: 
          s_ID_funct(5 downto 0) <= s_ID_instr(5 downto 0); 
          s_ID_opCode(5 downto 0) <= s_ID_instr(31 downto 26); 
          s_ID_imm16 (15 downto 0) <= s_ID_instr(15 downto 0); 
 -- 15 : jal 
-- 14 : register dest
-- 13 : ALU Src 1
-- 12 : ALU Src 0
-- 11 : Mem to reg 
-- 10 : Register Write 
-- 9  : Mem RD 
-- 8  : Mem Wr 
-- 7  : Branch 
-- 6  : BEQ
-- 5  : jr 
-- 4  : j
-- 3  : AlU Op 3
-- 2   : ALU op 2 
-- 1  : ALU op 1
-- 0  : ALU op 0 
---Other Control Signals--
--   : sign EXT 
--   : HALT 
 g_control : singleCycleControl
    port map (
		  opcode			  => s_ID_opCode, 
		  func			    => s_ID_funct, 
	    halt          => s_ID_Halt,
      signExt       => s_ID_extend, 
		  link			    => s_ID_control(14), 
		  regDest			  => s_ID_control(13), 
		  ALUSrc			  => s_ID_control(12 downto 11),  
		  MemReg			  => s_ID_control(10) 
		  RegWr			    => s_ID_control(9),  
		  MemRd			    => s_ID_control(8),  
		  MemWr			    => s_ID_control(7), 
		  Branch			  => s_ID_control(6) 
		  BEQ           => s_ID_control(5), 
		  jump			    => s_ID_control(4), 
		  ALUop			    => s_ID_control(3 downto 0)); 



    g_FU:  ForwardingUnit 
      port(
		    i_RS				      => s_ID_instr(25 downto 21), 
		    i_RT				      => s_ID_instr(20 downto 16),  
		    i_EXMEM_RD			  => s_RegWrAddr,
		    i_MEMWB_RD			  => s_MEM_reg_WR,
		    i_EXMEM_regwr		  => s_EX_control(9),
		    i_MEMWB_regWr		  => s_MEM_control_regWr, 
		    o_RS_select			 => s_ID_fwd_RS_sel,
		    o_RT_select			 => s_ID_fwd_RT_sel);

  g_regFile : regFile
    port map (iCLK        	  => iCLK,      -- Clock input
            iRST        	  => iRST,      -- Reset input
            iWRN        	  => s_RegWrAddr,     
             iWE	    	      => s_ID_control(9),  
            iWD          	  => s_RegWrData,    
            iDP0	     	    => s_ID_instr(25 downto 0), 
            iDP1	      	  => s_ID_instr(20 downto 0),  
            oDP0	      	  => s_ID_reg_RS,  
            oDP1          	=> s_ID_reg_RT); 

  g_signExtend: extend16t32
	  port map(i_S      => s_ID_extend,    
              i_A      => s_ID_imm16,  
              o_O      => s_ID_imm32);

       g_reg_DST : mux2t1_N
        generic map(N => 5)
      port map(
          i_S      => s_ID_control(14),    
          i_D0     => s_ID_instr(20 downto 16), 
          i_D1     => "11111",  
          o_O      => s_ID_reg_dst);      

    g_reg_DST : mux2t1_N
        generic map(N => 5)
      port map(
          i_S      => s_ID_control(13),   
          i_D0     => s_ID_reg_dst, 
          i_D1     => s_ID_instr(15 downto 11),  
          o_O      => s_ID_RegWr);

  

  -- in the event of a jump, we extend from 26 to 28 bits:  
  s_ID_jumpAddr(0) <= '0';
  s_ID_jumpAddr(1) <= '0'; 
  s_ID_jumpAddr(27 downto 2) <= s_ID_instr(25 downto 0); 
  s_ID_jumpAddr(31 downto 28) <= s_ID_PC(31 downto 28); -- these bits should be empty \

  s_EX_immj(31 downto 0) <= s_EX_imm32(29 downto 0); 
  s_EX_immj(1)           <= '0';
  s_EX_immj(0)           <= '0';

  g_fwd_RS  :  : mux2t1_N
  port map(
            i_S      => s_ID_fwd_RS_sel,     
            i_D0     => s_ID_reg_RS,  
            i_D1     => s_RegWrData,   
            o_O      => s_ID_fwd_data1);


  g_fwd_RT :  : mux2t1_N
  port map(
            i_S      => s_ID_fwd_RT_sel,     
            i_D0     => s_ID_reg_RT,  
            i_D1     => s_RegWrData,   
            o_O      => s_ID_fwd_data2);



  g_OR_ID_EX_flush :  org2 
      port map(i_A          => iRST, 
               i_B           => s_ID_flush,
              o_F           => s_ID_reset);          

  g_ID_EX: reg_ID_EX
    port(i_CLK            => iCLK, 
          i_RST           => s_ID_reset,  
          i_WE            => '1',  
      -----VECTOR Feed-in: -----0
          i_PC            => s_ID_PC,  
          i_RS            => s_ID_fwd_data1, 
          i_RT            => s_ID_fwd_data2,  
          i_control       => s_ID_control,
          i_halt          => s_ID_Halt,
          i_funct         => s_ID_funct,
          i_reg_DST       => s_ID_RegWr,  
          i_opCode        => s_ID_opCode,      
          i_jumpAddr      => s_ID_jumpAddr,  
          i_signExt       => s_ID_imm32,  
      --Vector Out Feed ---------1
          o_PC            => s_EX_PC,  
          o_RS            => s_EX_reg_RS,  
          o_RT            => s_EX_reg_RT, 
          i_funct         => s_EX_funct, 
          o_reg_DST       => s_EX_reg_Wr
          o_opCode         => s_EX_opCode, 
          o_control       => s_EX_control,
          o_halt          => s_EX_control_halt,       
          o_jumpAddr      => s_EX_jumpAdr, 
          o_signExt       => s_EX_imm32,  

 ---------------------------------------------------------------------------------------------------------------------
 ------------------------EX STAGE-------------------------------------------------------------------------------------
 --------------------------------------------------------------------------------------------------------------------
   -- Setup Control Bits for the execution stage: 
      s_EX_control_jal        <= s_EX_control(15);
      s_EX_control_dst            <= s_EX_control(13)
      s_EX_ALU_Src            <= s_EX_control(12 downto 11);
      s_EX_control_memToReg   <= s_EX_control(10);
      s_EX_control_regWr      <= s_EX_control(9);
      s_EX_control_DMem_WR    <= s_EX_control(8);
      s_EX_control_branch     <= s_EX_control(6); 
      s_EX_control_j          <= s_EX_control(4 downto 3);
      s_EX_ALU_OP             <= s_EX_control(2 downto 0); 


    -- ALU Operation:
    Mux_regFileToALU: mux4t1
       port map(i_S => s_EX_ALU_Src,
      	i_R0 => s_EX_reg_RT,
	      i_R1 => s_EX_imm32, 
      	i_R2 => s_EX_ALU_repl,
      	i_R3 => x"00000000",
      	o_Y => s_EX_imm_mux);
    
        g_ALUcontrol: ALUControl
      port map(
              func		=> s_EX_funct,
              opCode		=> s_EX_opcode,
              logicCTL	=> s_EX_logicCtrl,
              arithCtl	=> s_EX_arithCtl,
              shiftDir	=> s_EX_shiftDir,
              add_sub		=> s_EX_add_sub,
              o_signed	=> s_EX_signed);
    
    g_ALU : ALU 	
      port map(iA		        =>  s_EX_reg_RS,  
          iB				    =>  s_EX_reg_RT,
          iADDSUB			  => s_EX_add_sub,
          iSIGNED			  => s_EX_signed,
          iSHIFTDIR			=> s_EX_shiftDir,
          iALULOGIC		  => s_EX_logicCtrl, 
          iALUOP			 => s_EX_ALU_OP,  
          o_OF			   => s_EX_ALU_OF, 
          o_Zero			 => s_EX_ALU_zero, 
          o_ALUOUT		 => s_EX_ALU_out); 

    replext: extend8t32
      port map(i_S          =>  s_ID_extend,
       i_A         =>  s_Insts_EX_instr(23 downto 16),
       o_O          =>  s_EX_ALU_replExt);

  repl8t32: replqbg
    port map(i_A          => s_EX_ALU_replExt,
             o_F          => s_EX_ALU_repl);


    g_OR_EX_MEM_flush :  org2 
      port map(i_A          => iRST, 
               i_B           => s_MEM_flush,
              o_F           => s_MEM_reset);  


      g_EX_MEM    : reg_EX_MEM
          port map(i_CLK          => iCLK,  
            i_RST                 => s_MEM_reset, 
            i_WE                  => '1',  
            --one bit feed ins 
            i_overflow            => s_EX_ALU_OF,  
            i_branch              => s_EX_control_branch,               
            i_jump                => s_EX_control_j, 
            i_halt                => s_EX_control_halt, 
            i_jumpLink            => s_EX_control_jal, 
            i_zero                => s_EX_ALU_zero, 
            i_memReg              => s_EX_control_memToReg,
            i_weReg               => s_EX_control_regWr,
            i_weMem               => s_EX_control_DMem_WR,
            -- vector feed ins 
            i_PC                 => s_EX_PC, --next instruction
            i_branchAddr         => s_EX_branchAddr, -- branch address
            i_jumpAddr           => s_EX_jumpAddr_final, -- jump address
            i_ALU_out            => s_EX_ALU_out, -- ALU output 
            i_readData           => s_EX_reg_RT,  
            i_writeReg           => s_EX_reg_Wr; 
            --one bit out feeds
            o_overflow          => s_MEM_ALU_OF, 
            o_branch            => s_MEM_control_branch,
            o_jump              => s_MEM_control_j,
            o_halt              => s_MEM_control_halt, 
            o_jumpLink          => s_MEM_control_jal, 
            o_zero              => s_MEM_ALU_branch, 
            o_memReg            => s_MEM_control_memToReg,
            o_weReg             => s_MEM_control_regWr, 
            o_weMem             => s_MEM_control_DMem_WR,
            --vector out feeds 
            o_PC              => s_MEM_PC, -- next instruction
            o_branchAddr      => s_MEM_branchAddr, -- branch address
            o_jumpAddr        => s_MEM_jumpAddr, -- jump address
            o_ALU_out         => s_MEM_ALU_out, -- ALU output 
            o_readData       => s_MEM_reg_RD,  
            o_writeReg      => s_MEM_reg_WR); 

---------------------------------------------------------------------------------------------------------------------
------------------------MEM STAGE-------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
DMem: mem
generic map(ADDR_WIDTH => 10,
            DATA_WIDTH => N)
port map(clk  => iCLK,
         addr => s_DMemAddr(11 downto 2),
         data => s_DMemData,
         we   => s_DMemWr,
         q    => s_DMemOut);

 g_OR_MEM_WB_flush :  org2 
      port map(i_A          => iRST, 
               i_B           => s_WB_flush,
              o_F           => s_WB_reset);  


g_MEM_WB : reg_MEM_WB
  port map(i_CLK          => iCLK, 
          i_RST           => s_WB_reset, 
          i_WE            => '1',  
          --one bit feed ins 
          i_overflow     => s_MEM_ALU_OF,  
          i_branch       => s_MEM_control_branch, 
          i_jump         => s_MEM_control_j,
          i_halt         => s_MEM_control_halt,
          i_jumpLink     => s_MEM_control_jal,
          i_memReg       => s_MEM_control_memToReg,
          i_weReg        => s_MEM_control_regWr,
        -- vector feed ins 
          i_PC          => s_MEM_PC,
          i_branchAddr  => s_MEM_branchAddr,
          i_jumpAddr    => s_MEM_jumpAddr,
          i_ALU_out     => s_MEM_ALU_out,
          i_readData    => s_DMemOut, 
          i_writeReg    => s_MEM_regWr, 
          --one bit out feeds
          o_overflow    => s_Ovfl,
          o_branch      => s_WB_control_zero,
          o_jump        => s_WB_control_j,
          o_halt        => s_WB_control_halt, 
          o_jumpLink    => s_WB_control_jal,
          o_memReg      => s_WB_control_memToReg,
           o_weReg      => s_WB_control_regWr,
          --vector out feeds 
          o_PC          => s_WB_PC,
          o_branchAddr  => s_WB_branchAddr,
          o_jumpAddr     => s_WB_jumpAddr,
          o_ALU_out     => s_WB_ALU_out,  
          o_readData    => s_WB_reg_RED,  
          o_writeReg    => s_RegWrAddr); 
---------------------------------------------------------------------------------------------------------------------
------------------------WB STAGE-------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

g_jal : mux2t1_N
      port map(
          i_S      => s_WB_control_jal,    
          i_D0     => s_WB_ALU_out, 
          i_D1     => s_WB_PC,  
          o_O      => s_WB_reg_memToReg);

g_memToReg : mux2t1_N
      port map(
          i_S      => s_WB_control_memToReg,    
          i_D0     => s_WB_reg_memToReg, 
          i_D1     => s_WB_reg_RED,  
          o_O      => s_RegWrData);

g_branch : mux2t1_N
    port map(
      i_S      => s_WB_control_zero,    
      i_D0     => s_IF_stalled_Addr, 
      i_D1     => s_WB_branchAddr,  
      o_O      => s_WB_PC_input);

g_jump : mux2t1_N
    port map(
      i_S      => s_WB_control_jump,    
      i_D0     => s_WB_PC_input, 
      i_D1     => s_WB_jumpAddr,  
      o_O      => s_WB_PC_next); 
      
oALUOut <= s_WB_ALU_out; 
s_Halt <= s_WB_control_halt; 

end structure;
