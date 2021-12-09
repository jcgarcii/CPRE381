library IEEE;
use IEEE.std_logic_1164.all;

entity ALUControl is
  port(
		func		: in std_logic_vector(5 downto 0);
		opCode		: in std_logic_vector(5 downto 0);
		logicCTL	: out std_logic_vector(1 downto 0);
		arithCtl	: out std_logic;
		shiftDir	: out std_logic;
		add_sub		: out std_logic;
		o_signed	: out std_logic);

end ALUControl;

architecture dataflow of ALUControl is
begin
--MISSING funct cases

	
	arithCtl <= '1' when (opcode = "000000" AND func = "000011") else	--type of shift 1 = arith shift, 0 = logical
		 '0';
	shiftDir <= '1' when (opcode = "000000" AND func = "000000") else	--left = 1, right - 0
		'0';

	add_sub <= '1' when ((opcode = "000000" AND func = "100010") OR (opcode = "000000" AND func = "100011")) else	--1 = sub, 0 = add
		'0';

	logicCTL <= "00" when ((opcode = "000000" AND func = "100100") OR opCode = "001100") else --and
			"01" when((opcode = "000000" AND func = "100101") OR opCode = "001101") else --or
			"10" when(opcode = "000000" AND func = "100111") else --nor
			"11";   --xor when((opcode = "000000" AND func = "100110") OR opCode = "001110")
			

	o_signed <= '1' when ((opcode = "000000" AND func = "100001") OR (opCode = "101001") OR (opcode = "000000" AND func = "100011"))else
			'0';

end dataflow;