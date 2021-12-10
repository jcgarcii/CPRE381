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
 /*
  -- control signals
  signal  s_signExt, s_link, s_use_shamt, s_regDest, s_memReg, s_branch, s_memRD, s_memWR, s_BEQ  : std_logic;
  signal s_opcode, s_func : std_logic_vector(5 downto 0) := "000000";
  signal s_ALUCtl : std_logic_vector(2 downto 0) := "000";

  signal s_writeReg: std_logic_vector(4 downto 0);
  signal s_oRS,s_oRT: std_logic_vector(31 downto 0);
  signal s_extImm,s_replExt: std_logic_vector(31 downto 0);
  signal s_muxToALU,s_repl: std_logic_vector(31 downto 0);

  signal s_logicCtrl,s_jump,s_ALUSrc: std_logic_vector(1 downto 0);
  signal s_arithCtl,s_shiftDir,s_add_sub,s_o_signed,s_zero: std_logic;
  signal s_toEXT8: std_logic_vector(7 downto 0);
  
  -- Instruction Fetcher Signals: --- 
  signal s_branchEN	: std_logic;
*/
  ------- STAGE SIGNALS: ---------
  --IF Stage: 
  signal s_IF_PC    : std_logic_vector(N-1 downto 0); 

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
    -- Control -- 
  signal s_ID_opCode    : std_logic_vector(5 downto 0); 
  signal s_ID_funct     : std_logic_vector(5 downto 0); 
  signal s_ID_control   : std_logic_vector(14 downto 0);
  
  --EX Stage: 
    --General --- 
    signal s_EX_PC              :  std_logic_vector(N-1 downto 0); 
   --Addresses/I-type:---
    signal s_EX_jumpAddr        : std_logic_vector(N-1 downto 0); 
    signal s_EX_imm32           : std_logic_vector(N-1 downto 0); 
    signal s_EX_imm32_MUX       : std_logic_vector(N-1 downto 0);
    signal s_EX_jumpAddr_final  : std_logic_vector(N-1 downto 0); 
    signal s_EX_branchAddr      : std_logic_vector(N-1 downto 0); 
    --Register Stuff
    signal s_EX_iRS             : std_logic_vector(N-1 downto 0);
    signal s_EX_iRT             : std_logic_vector(N-1 downto 0); 
    signal s_EX_reg_RS          : std_logic_vector(N-1 downto 0); 
    signal s_EX_reg_RT          : std_logic_vector(N-1 downto 0); 
    signal s_EX_reg_DST         : std_logic_vector(4 downto 0); 
    signal s_EX_reg_Wr          : std_logic_vector(4 downto 0);
    --ALU Stuff: 
    signal s_EX_ALU_Src         : std_logic; 
    signal s_EX_ALU_shamt       : std_logic_vector(4 downto 0); 
    signal s_EX_ALU_OP          : std_logic_vector(3 downto 0); 
    signal s_EX_ALU_out         : std_logic_vector(N-1 downto 0); 
    signal s_EX_ALU_branch      : std_logic; 
    signal s_EX_ALU_OF          : std_logic; 
    --Control Stuff: 
    signal s_EX_control         : std_logic_vector(14 downto 0);
    signal s_EX_control_j       : std_logic_vector(1 downto 0); 
    signal s_EX_control_jal     : std_logic;
    signal s_EX_control_memToReg  : std_logic;
    signal s_EX_control_DMem_WR   : std_logic; 
    signal s_EX_control_bramch    : std_logic; 
    signal s_EX_control_halt      : std_logic; 
    signal s_EX_control_regWr     : std_logic; 
  
  ------------------------------------------------------------------------------------------
  -------------Component declaration: -----------------------------------------------------
  -----------------------------------------------------------------------------------------
  component mem is
    generic(ADDR_WIDTH : natural:= 32;
            DATA_WIDTH : natural := 10);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH-1) downto 0));
    end component;

--General components

component regFile is

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

end component;


  component extend16t32 is
  port(i_S          : in std_logic;
       i_A         : in std_logic_vector(15 downto 0);
       o_O          : out std_logic_vector(31 downto 0));

  end component;

component extend8t32 is
  port(i_S          : in std_logic;
       i_A         : in std_logic_vector(7 downto 0);
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
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

  end component;

component mux4t1 is

  port(i_S  : in std_logic_vector (1 downto 0);
	i_R0 : in std_logic_vector(31 downto 0);
	i_R1 : in std_logic_vector(31 downto 0);
	i_R2 : in std_logic_vector(31 downto 0);
	i_R3 : in std_logic_vector(31 downto 0);
	o_Y : out std_logic_vector(31 downto 0));

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
		opcode		: in std_logic_vector(5 downto 0);
		func		: in std_logic_vector(5 downto 0);
	        halt            : out std_logic;
                signExt         : out std_logic;
		link		: out std_logic; --15
		regDest		: out std_logic; --12
		ALUSrc		: out std_logic_vector(1 downto 0); --11
		MemReg		: out std_logic; --10
		RegWr		: out std_logic; --9
		MemRd		: out std_logic; --8
		MemWr		: out std_logic; --7
		Branch		: out std_logic; --6
		BEQ             : out std_logic; --5
		jump		: out std_logic_vector(1 downto 0); --4
		ALUop		: out std_logic_vector(2 downto 0)); -- 3-0

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
end component; 
 ---------------------------------------------------------------------------------------------------------------------
 ------------------------IF STAGE-------------------------------------------------------------------------------------
 --------------------------------------------------------------------------------------------------------------------
begin
 -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
   with iInstLd select
   s_IMemAddr <= s_NextInstAddr when '0',
   iInstAddr when others;
   
   IMem: mem
        generic map(ADDR_WIDTH => 10,
               DATA_WIDTH => N)
        port map(clk  => iCLK,
                addr => s_IMemAddr(11 downto 2),
                data => iInstExt,
                we   => iInstLd,
                q    => s_Inst);
 
  











  


  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

	gBRANCH	: andg2
		port map(i_A	=> s_Branch,
				 i_B	=> s_zero,
				 o_F	=> s_branchEN); 


  instrFetch:inst_fetch
	   port map(iCLK			=> iCLK,
		iRST			=> iRST,
		iMEM_WE			=> '1',
		iBranch			=> s_branchEN,
		iJump			=> s_jump, 
		i_IMM			=> s_extImm,		
		iPCNext			=> s_oRS,	
		iINSTR			=> s_Inst,
		oAddr			=> s_NextInstAddr);	
		
  Mux_ImemToRegFile: mux2t1_5
	port map(
              i_S      => s_regDest,    
              i_D0     => s_Inst(20 downto 16), 
              i_D1     => s_Inst(15 downto 11),  
              o_O      => s_RegWrAddr); 


 gregFile : regFile
 port map(iCLK        	=> iCLK,     -- Clock input
       iRST        	=> iRST,    -- Reset input
       iWRN             => s_RegWrAddr,   
       iWE	    	=> s_RegWr, 
       iWD          	=> s_RegWrData,   
       iDP0	     	=> s_Inst(25 downto 21),
       iDP1	      	=> s_Inst(20 downto 16), 
       oDP0	      	=> s_oRS,
       oDP1          	=> s_DMemData); 

  signExtend: extend16t32
	port map(
              i_S      => s_signExt,    
              i_A     => s_Inst(15 downto 0),  
              o_O      => s_extImm);


replext: extend8t32
  port map(i_S          =>  s_signExt,
       i_A         =>  s_Inst(23 downto 16),
       o_O          =>  s_replExt);

  repl8t32: replqbg
    port map(i_A          => s_replExt,
             o_F          => s_repl);

  control: singleCycleControl 
  port map(	opcode		=> s_Inst(31 downto 26),
		func		=> s_Inst(5 downto 0),
	        halt            => s_halt,
                signExt         => s_signExt,
		link		=> s_link, --15
		regDest		=> s_regDest, --12
		ALUSrc		=> s_ALUSrc, --11
		MemReg		=> s_memReg, --10
		RegWr		=> s_RegWr, --9
		MemRd		=> s_memRd, --8
		MemWr		=> s_DMemWr, --7
		Branch		=> s_branch, --6
		BEQ             => s_BEQ, --5
		jump		=> s_jump, --4
		ALUop		=> s_AlUCtl);

--TODO
  gALUcontrol: ALUControl
  port map(
		func		=> s_Inst(5 downto 0),
		opCode		=> s_Inst(31 downto 26),
		logicCTL	=> s_logicCtrl,
		arithCtl	=> s_arithCtl,
		shiftDir	=> s_shiftDir,
		add_sub		=> s_add_sub,
		o_signed	=> s_o_signed);


--TODO make into 4t1
  Mux_regFileToALU: mux4t1
     port map(i_S => s_ALUSrc,
	i_R0 => s_DMemData,
	i_R1 => s_extImm, 
	i_R2 => s_repl,
	i_R3 => x"00000000",
	o_Y => s_muxToALU);

  ALUcomponent: ALU
	
	port map(iA			=> s_oRS,
	        iB				=> s_muxToALU,
	     iADDSUB			=> s_add_sub,
	     iSIGNED			=> s_o_signed,
	     iSHIFTDIR			=> s_shiftDir,
	     iALULOGIC			=> s_logicCtrl,
	     iALUOP			=> s_AlUCtl, 
	     o_OF			=> s_Ovfl, 
	     o_Zero			=> s_zero,
	     o_ALUOUT			=> s_DMemAddr); 
	
  Mux_DmemToRegFile: mux2t1_N
	port map(
              i_S      => s_memReg,    
              i_D0     => s_DMemAddr, 
              i_D1     => s_DMemOut,  
              o_O      => s_RegWrData); 

end structure;

