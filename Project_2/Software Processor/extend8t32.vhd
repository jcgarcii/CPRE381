library IEEE;
use IEEE.std_logic_1164.all;

entity extend8t32 is
  port(i_S          : in std_logic;
       i_A         : in std_logic_vector(7 downto 0);
       o_O          : out std_logic_vector(31 downto 0));

end extend8t32;

architecture structural of extend8t32 is

  component muxStruc is
    port(i_S                  : in std_logic;
         i_A                 : in std_logic;
         i_B                 : in std_logic;
         o_O                  : out std_logic);
  end component;

begin

  -- Instantiate N mux instances.
  G_extend8t32_1: for i in 0 to 7 generate
    MUXI: muxStruc port map(
              i_S      => '1',      -- All instances share the same select input.
              i_A     => '0',  -- ith instance's data 0 input hooked up to ith data 0 input.
	      i_B      => i_A(i), 
              o_O      => o_O(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_extend8t32_1;

  -- Instantiate N mux instances.
  G_extend8t32_2: for i in 8 to 31 generate
    MUXI: muxStruc port map(
              i_S      => i_S,      -- All instances share the same select input.
              i_A     => '0',         -- ith instance's data 0 input hooked up to ith data 0 input.
	      i_B      => i_A(7), 
              o_O      => o_O(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_extend8t32_2;
  
end structural;