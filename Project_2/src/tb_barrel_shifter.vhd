Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
use std.env.all;
use std.textio.all;

entity tb_barrel_shifter is
	generic(gCLK_HPER  : time := 10 ns);
end tb_barrel_shifter;

architecture mixed of tb_barrel_shifter is

constant cCLK_PER  : time := gCLK_HPER * 2;

component barrel_shifter is

	port(i_D1	: in std_logic_vector(31 downto 0);
	     i_S1	: in std_logic_vector(4 downto 0);
	     i_S2	: in std_logic;
	     i_S3	: in std_logic;
	     o_F	: out std_logic_vector(31 downto 0));

end component;

signal CLK, reset : std_logic := '0';

signal s_iS3	: std_logic;
signal s_iS2	: std_logic;
signal s_iS1	: std_logic_vector(4 downto 0);
signal s_iD1	: std_logic_vector(31 downto 0);
signal s_O	: std_logic_vector(31 downto 0);

begin

  DUT0: barrel_shifter
  port map(i_S1	=> s_iS1,
           i_S2	=> s_iS2,
	   i_S3 => s_iS3,
	   i_D1	=> s_iD1,
	   o_F	=> s_O);

  P_CLK: process
  begin
    CLK <= '1';
    wait for gCLK_HPER;
    CLK <= '0';
    wait for gCLK_HPER;
  end process;

  P_RST: process
  begin
  	reset <= '0';
    wait for gCLK_HPER/2;
  	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
  	wait;
  end process;

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2;

    --Test Case 1: 0 followed by 31 1's expected
    s_iS2 <= '0';
    s_iS3 <= '0';
    s_iS1 <= "00001";
    s_iD1 <= "11111111111111111111111111111111";
    wait for gCLK_HPER*2;

    --Test Case 2:
    s_iS2 <= '1';
    s_iS3 <= '0';
    s_iS1 <= "00001";
    s_iD1 <= "11111111111111111111111111111111";
    wait for gCLK_HPER*2;

    --Test Case 3:
    s_iS2 <= '0';
    s_iS3 <= '1';
    s_iS1 <= "00001";
    s_iD1 <= "11111111111111111111111111110000";
    wait for gCLK_HPER*2;

    --Test Case 4:
    s_iS2 <= '1';
    s_iS3 <= '0';
    s_iS1 <= "00001";
    s_iD1 <= "01111111111111111111111111111111";
    wait for gCLK_HPER*2;

  end process;

end mixed;