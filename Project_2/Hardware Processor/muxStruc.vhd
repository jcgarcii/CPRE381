library IEEE;
use IEEE.std_logic_1164.all;

entity muxStruc is
    port(i_S          : in std_logic;
       i_A          : in std_logic;
       i_B          : in std_logic;
       o_O          : out std_logic);

end muxStruc;

architecture structural of muxStruc is


  component andg2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  component invg
    port(i_A          : in std_logic;
         o_F          : out std_logic);
  end component;

  component org2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

signal s_inv  : std_logic;
signal ans  : std_logic;
signal ab  : std_logic;


begin

  -- Instantiate 
  

---------------------------------------------------------------------------
  -- Level 0: invert S
  ---------------------------------------------------------------------------
 notg: invg
	port map(
		i_A       => i_s,
         	o_F       =>  s_inv);

---------------------------------------------------------------------------
  -- Level 1: (A and ~S) ,(B and s)
  ---------------------------------------------------------------------------
 
and_ans: andg2
	port map(
		i_A        => i_A,
        	i_B        => s_inv,
         	o_F        => ans);
	
and_bs: andg2
	port map(
		i_A          => i_B,
         	i_B          => i_s,
         	o_F          => ab);

---------------------------------------------------------------------------
  -- Level 2: (A and ~S) OR (B and s)
  ---------------------------------------------------------------------------
 
or_both: org2
	port map(
		i_A          => ans,
         	i_B          => ab,
         	o_F          => o_O);
 
  
  
end structural;