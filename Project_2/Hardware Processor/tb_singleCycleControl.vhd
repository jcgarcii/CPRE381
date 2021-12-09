library IEEE;
use IEEE.std_logic_1164.all;

entity tb_singleCycleControl is
  generic(gCLK_HPER   : time := 50 ns);
end tb_singleCycleControl;

architecture behavior of tb_singleCycleControl is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component singleCycleControl

    port(
       		opcode		: in std_logic_vector(5 downto 0);
		func		: in std_logic_vector(5 downto 0);
	        halt            : out std_logic;
                signExt         : out std_logic;
		link		: out std_logic; --15
		jumpReg		: out std_logic; --14

		regDest		: out std_logic; --12
		ALUSrc		: out std_logic; --11
		MemReg		: out std_logic; --10
		RegWr		: out std_logic; --9
		MemRd		: out std_logic; --8
		MemWr		: out std_logic; --7
		Branch		: out std_logic; --6
		BEQ             : out std_logic; --5
		jump		: out std_logic; --4
		ALUop		: out std_logic_vector(2 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_halt, s_signExt, s_link, s_jumpReg, s_use_shamt, s_regDest, s_ALUSrc, s_memReg, s_regWr, s_branch, s_memRD, s_memWR, s_BEQ, s_jump  : std_logic;
  signal s_opcode, s_func : std_logic_vector(5 downto 0) := "000000";
  signal s_ALUCtl : std_logic_vector(2 downto 0) := "000";

begin

  DUT0: singleCycleControl 
  port map(	opcode		=> s_opcode,
		func		=> s_func,
	        halt            => s_halt,
                signExt         => s_signExt,
		link		=> s_link, --15
		jumpReg		=> s_jumpReg, --14
		regDest		=> s_regDest, --12
		ALUSrc		=> s_ALUSrc, --11
		MemReg		=> s_memReg, --10
		RegWr		=> s_regWr, --9
		MemRd		=> s_memRd, --8
		MemWr		=> s_memWr, --7
		Branch		=> s_branch, --6
		BEQ             => s_BEQ, --5
		jump		=> s_jump, --4
		ALUop		=> s_AlUCtl);
  
  -- Testbench process  
  P_TB: process
  begin

    -- Test addi
    s_opcode <= "001000" ;
    s_func <= "000000"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"

    -- Test add
    s_opcode <= "000000" ;
    s_func <= "100000"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"

-- Test addiu
    s_opcode <= "101001"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"

-- Test andi
    s_opcode <= "001100"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"


    -- Test lui
    s_opcode <= "001111" ;
    s_func <= "000000"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"

-- Test lw
    s_opcode <= "100011"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"

-- Test xori
    s_opcode <= "001110"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"


    -- Test ori
    s_opcode <= "001101" ;
    s_func <= "000000"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"

-- Test stli
    s_opcode <= "001010"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"

-- Test sw
    s_opcode <= "101011"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"


    -- Test beq
    s_opcode <= "000100" ;
    s_func <= "000000"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"

-- Test bne
    s_opcode <= "000101"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"

-- Test j
    s_opcode <= "000010"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"

    -- Test jal
    s_opcode <= "000011" ;
    s_func <= "000000"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"

-- Test jr
    s_opcode <= "001000"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"

-- Test halt
    s_opcode <= "010100"  ;
    wait for cCLK_PER;
    --s_O = x"00000001"


wait;
  end process;
  
end behavior;