---32 to 1 Mux, for ease we will use structure as I can simply copy my decoder and just change the outputs for each "when" situation easily.
-------------------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;

entity mux32t1 is

  port(i_S	: in std_logic_vector(4 downto 0); 
	iD0	: in std_logic_vector (31 downto 0);
	iD1	: in std_logic_vector (31 downto 0);
	iD2	: in std_logic_vector (31 downto 0);
	iD3	: in std_logic_vector (31 downto 0);
	iD4	: in std_logic_vector (31 downto 0);
	iD5	: in std_logic_vector (31 downto 0);
	iD6	: in std_logic_vector (31 downto 0);
	iD7	: in std_logic_vector (31 downto 0);
	iD8	: in std_logic_vector (31 downto 0);
	iD9	: in std_logic_vector (31 downto 0);
	iD10	: in std_logic_vector (31 downto 0);
	iD11	: in std_logic_vector (31 downto 0);
	iD12	: in std_logic_vector (31 downto 0);
	iD13	: in std_logic_vector (31 downto 0);
	iD14	: in std_logic_vector (31 downto 0);
	iD15	: in std_logic_vector (31 downto 0);
	iD16	: in std_logic_vector (31 downto 0);
	iD17	: in std_logic_vector (31 downto 0);
	iD18	: in std_logic_vector (31 downto 0);
	iD19	: in std_logic_vector (31 downto 0);
	iD20	: in std_logic_vector (31 downto 0);
	iD21	: in std_logic_vector (31 downto 0);
	iD22	: in std_logic_vector (31 downto 0);
	iD23	: in std_logic_vector (31 downto 0);
	iD24	: in std_logic_vector (31 downto 0);
	iD25	: in std_logic_vector (31 downto 0);
	iD26	: in std_logic_vector (31 downto 0);
	iD27	: in std_logic_vector (31 downto 0);
	iD28	: in std_logic_vector (31 downto 0);
	iD29	: in std_logic_vector (31 downto 0);
	iD30	: in std_logic_vector (31 downto 0);
	iD31	: in std_logic_vector (31 downto 0);
	oData   : out std_logic_vector (31 downto 0)); 

end mux32t1;

architecture dataflow of mux32t1 is
 
begin

     oData <=  	iD0 when i_S = "00000" else
		iD1 when i_S = "00001" else
		iD2 when i_S = "00010" else
		iD3 when i_S = "00011" else
 		iD4 when i_S = "00100" else
		iD5 when i_S = "00101" else
		iD6 when i_S = "00110" else
		iD7 when i_S = "00111" else
		iD8 when i_S = "01000" else
		iD9 when i_S = "01001" else
		iD10 when i_S = "01010" else
		iD11 when i_S = "01011" else
		iD12 when i_S = "01100" else
		iD13 when i_S = "01101" else
		iD14 when i_S = "01110" else
		iD15 when i_S = "01111" else	
		iD16 when i_S = "10000" else
		iD17 when i_S = "10001" else
		iD18 when i_S = "10010" else
		iD19 when i_S = "10011" else
		iD20 when i_S = "10100" else
		iD21 when i_S = "10101" else
		iD22 when i_S = "10110" else
		iD23 when i_S = "10111" else
		iD24 when i_S = "11000" else
		iD25 when i_S = "11001" else
		iD26 when i_S = "11010" else
		iD27 when i_S = "11011" else
		iD28 when i_S = "11100" else
		iD29 when i_S = "11101" else
		iD30 when i_S = "11110" else
		iD31 when i_S = "11111";

end dataflow;
