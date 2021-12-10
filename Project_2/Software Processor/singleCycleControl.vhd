library IEEE;
use IEEE.std_logic_1164.all;

entity singleCycleControl is
  port(
		opcode			: in std_logic_vector(5 downto 0);
		func			: in std_logic_vector(5 downto 0);
	    halt            : out std_logic;
        signExt         : out std_logic;
		link			: out std_logic; --15
		regDest			: out std_logic; --12
		ALUSrc			: out std_logic_vector(1 downto 0); --11
		MemReg			: out std_logic; --10
		RegWr			: out std_logic; --9
		MemRd			: out std_logic; --8
		MemWr			: out std_logic; --7
		Branch			: out std_logic; --6
		BEQ             : out std_logic; --5
		jump			: out std_logic_vector(1 downto 0); --4
		ALUop			: out std_logic_vector(2 downto 0));
		


end singleCycleControl;

architecture dataflow of singleCycleControl is
begin

	ALUSrc <= "01" when ((opcode = "001000") OR 
		(opcode = "001001" ) OR 
		(opcode = "001100" ) OR
		(opcode = "001111" ) OR
		(opcode = "100011" ) OR
		(opcode = "001110" ) OR
		(opcode = "001101" ) OR
		(opcode = "001010" ) OR
		(opcode = "101011" )) else
		"10" when (opcode = "011111") else
		"00";



	MemReg <= '1' when (
		(opcode = "100011" )) else
		'0';

	MemWr <= '1' when (opcode = "101011" ) else
		'0';

	RegWr <= '1' when ((opcode = "001000") OR 
		(opcode = "001001" ) OR 
		(opcode = "001100" ) OR
		(opcode = "001111" ) OR
		(opcode = "100011" ) OR
		(opcode = "001110" AND func = "001000") OR --double check this one(jr)
		(opcode = "001101" )OR --double check this one(jr)
		(opcode = "001110" )OR --double check this one(jr)
		(opcode = "001010" )OR --double check this one(jr)
		(opcode = "011111" )OR
		(opcode = "000000" AND func = "100000")OR
		(opcode = "000000" AND func = "100001")OR
		(opcode = "000000" AND func = "100100")OR
		(opcode = "000000" AND func = "100111")OR
		(opcode = "000000" AND func = "100110")OR
		(opcode = "000000" AND func = "100101")OR
		(opcode = "000000" AND func = "101010")OR
		(opcode = "000000" AND func = "000000")OR
		(opcode = "000000" AND func = "000010")OR
		(opcode = "000000" AND func = "000011")OR
		(opcode = "000000" AND func = "100010")OR
		(opcode = "000000" AND func = "100011")) else
		'0';

	regDest <= '1' when ((opcode = "000000" AND func = "100000") OR 
		(opcode = "000000" AND func = "100001") OR 
		(opcode = "000000" AND func = "100100") OR
		(opcode = "000000" AND func = "100111") OR
		(opcode = "000000" AND func = "100110") OR
		(opcode = "000000" AND func = "100101") OR
		(opcode = "000000" AND func = "101010") OR
		(opcode = "000000" AND func = "000000") OR
		(opcode = "000000" AND func = "000010") OR
		(opcode = "000000" AND func = "000011") OR
		(opcode = "000000" AND func = "100010") OR
		(opcode = "000000" AND func = "100011")) else
		'0';

	MemRd <= '1' when ((opcode = "001111" AND func = "000000") OR 
		(opcode = "100011" AND func = "000000")) else
		'0';

	ALUop <= "000" when ((opcode = "000000" AND func = "000000") OR	--sll
		(opcode = "000000" AND func = "000010") OR			--srl
		(opcode = "000000" AND func = "000010")) else			--sra
		
		"001" when ((opcode = "000000" AND func = "101010") OR 		--slt
		(opcode = "001010" ))else					--slti
		
		"011" when ((opcode = "000000" AND func = "100100") OR opCode = "001100") OR 	--AND
		(opcode = "000000" AND func = "100101") OR (opCode = "001101") OR		--or
		(opcode = "000000" AND func = "100111") OR					--nor
		(opcode = "000000" AND func = "100110") OR (opCode = "001110")else			--xor

		"100" when (opcode = "001111") else	--lui

		"101" when (opcode = "011111") else	--repl

		"010";					--add as default

	halt <= '1' when (opcode = "010100") else
		'0';

	signExt <= '1' when ((opcode = "001000" ) OR 
		(opcode = "001001" ) OR 
		(opcode = "001100" ) OR
		(opcode = "001111" ) OR
		(opcode = "100011" ) OR
		(opcode = "001110" ) OR
		(opcode = "001101" ) OR
		(opcode = "001010" )) else
		'0';

	link <= '1' when (opcode = "000011") else
		'0';

	Branch <= '1' when ((opcode = "000100" ) OR 
		(opcode = "000101" )) else
		'0';

	BEQ <= '1' when ((opcode = "000100" ) OR 
		(opcode = "000101" )) else
		'0';

	jump <= "01" when ((opcode = "000010" ) OR 
		(opcode = "000011" )) else
		"11" when (opcode = "000000" AND func = "001000") else
		"00";





end dataflow;