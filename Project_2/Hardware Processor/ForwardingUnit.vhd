library IEEE;
use IEEE.std_logic_1164.all;

entity ForwardingUnit is
  port(
		i_RS				: in std_logic_vector(4 downto 0);
		i_RT				: in std_logic_vector(4 downto 0);
		i_EXMEM_RD			: in std_logic_vector(4 downto 0);
		i_MEMWB_RD			: in std_logic_vector(4 downto 0);
		i_EXMEM_regwr		: in std_logic;
		i_MEMWB_regWr		: in std_logic;
		o_RS_select			: out std_logic;
		o_RT_select			: out std_logic);

end ForwardingUnit;

architecture dataflow of ForwardingUnit is
begin

	o_RS_select <= "01" when (i_EXMEM_regwr = '1') AND (i_RS = i_EXMEM_RD)   else --EXMEM forward
		    "10" when(i_MEMWB_regWr = '1') AND (i_RS = i_MEMWB_RD) else --MEMWB forward
		    "00";   
	o_RT_select <= "01" when (i_EXMEM_regwr = '1') AND (i_RT = i_EXMEM_RD) else --EXMEM forward
		    "10" when(i_MEMWB_regWr = '1') AND (i_RT = i_MEMWB_RD) else --MEMWB forward
		    "00"; 
			

end dataflow;