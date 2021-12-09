library IEEE;
use IEEE.std_logic_1164.all;

entity norg2_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A         : in std_logic_vector(N-1 downto 0);
       i_B         : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));

end norg2_N;

architecture structural of norg2_N is

  component org2_N is
    port(i_A                 : in std_logic_vector(N-1 downto 0);
         i_B                 : in std_logic_vector(N-1 downto 0);
         o_F                  : out std_logic_vector(N-1 downto 0));
  end component;

  component invg is
	port(i_A 	: in std_logic;
	     o_F	: out std_logic);
	end component;	
	signal not_OR 	: std_logic_vector(N-1 downto 0);  

begin

  -- Instantiate N mux instances.
ORG_N: org2_N port map(
	i_A => i_A,
	i_B => i_B,
	o_F => not_OR);

  G_NBit_NOR: for i in 0 to N-1 generate
    DUT1: invg port map(
              i_A     => not_OR(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              o_F      => o_F(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_NOR;
  
end structural;