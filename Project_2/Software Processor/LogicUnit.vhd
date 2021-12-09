library IEEE;
use IEEE.std_logic_1164.all;

entity LogicUnit is
	generic(N : integer := 32);

  port(i_PA 		            :in std_logic_vector(N-1 downto 0);
       i_PB 		            :in std_logic_vector(N-1 downto 0);
       o_AND 		            : out std_logic_vector(N-1 downto 0);
	o_OR 		            : out std_logic_vector(N-1 downto 0);
	o_NOR 		            : out std_logic_vector(N-1 downto 0);
	o_XOR 		            : out std_logic_vector(N-1 downto 0));

end LogicUnit;

architecture structure of LogicUnit is
  
component andg2_N
  --generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A         : in std_logic_vector(N-1 downto 0);
       i_B         : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
end component;

component org2_N
  --generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A         : in std_logic_vector(N-1 downto 0);
       i_B         : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
end component;

component norg2_N
  --generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A         : in std_logic_vector(N-1 downto 0);
       i_B         : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
end component;

component xorg2_N
  --generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A         : in std_logic_vector(N-1 downto 0);
       i_B         : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
end component;


begin

ANDG2N: andg2_N port map(
	i_A => i_PA,
       i_B => i_PB,
       o_F => o_AND);

ORG2N: org2_N port map(
	i_A => i_PA,
       i_B => i_PB,
       o_F => o_OR);

NORG2N: norg2_N port map(
	i_A => i_PA,
       i_B => i_PB,
       o_F => o_NOR);

XORG2N: xorg2_N port map(
	i_A => i_PA,
       i_B => i_PB,
       o_F => o_XOR);


  end structure;