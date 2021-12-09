library IEEE;
use IEEE.std_logic_1164.all;

entity barrel_shifter is
	--S1 = number of bits to shift
        --S2,S3: 10 = sra, 00 = srl, 01 = sll
        
	port(i_D1	: in std_logic_vector(31 downto 0);
	     i_S1	: in std_logic_vector(4 downto 0);
	     i_S2	: in std_logic;
	     i_S3	: in std_logic;
	     o_F	: out std_logic_vector(31 downto 0));

end barrel_shifter;

architecture structure of barrel_shifter is

   component mux2t1
	port(i_D0	: in std_logic;
	     i_D1	: in std_logic;
	     i_S	: in std_logic;
	     o_O	: out std_logic);
   end component;
   
   component andg2
	port(i_A          : in std_logic;
      	     i_B          : in std_logic;
       	     o_F          : out std_logic);
   end component;
   
   component mux2t1_N
   	port(i_S          : in std_logic;
             i_D0         : in std_logic_vector(31 downto 0);
       	     i_D1         : in std_logic_vector(31 downto 0);
             o_O          : out std_logic_vector(31 downto 0));
   end component;
  signal S_AND1		: std_logic;
  signal S_iD1R		: std_logic_vector(31 downto 0);
  signal S_iD1RR	: std_logic_vector(31 downto 0);
  signal S_iD1		: std_logic_vector(31 downto 0);
  signal S_oF		: std_logic_vector(31 downto 0);
  signal S_Row1		: std_logic_vector(31 downto 0);
  signal S_Row2		: std_logic_vector(31 downto 0);
  signal S_Row3		: std_logic_vector(31 downto 0);
  signal S_Row4		: std_logic_vector(31 downto 0);

begin

    
    REVERSE_IN1: for i in 0 to 31 generate
    
       S_iD1R(31-i) <= i_D1(i); 

    end generate REVERSE_IN1;

  N_BIT_MUX1: mux2t1_N
     port map(i_S	        => i_S3,
	      i_D0(31 downto 0)	=> i_D1(31 downto 0),
 	      i_D1(31 downto 0)	=> S_iD1R(31 downto 0),
	      o_O(31 downto 0)  => S_iD1(31 downto 0));

  AND1: andg2 
     port map(i_A	=> i_S2,
	      i_B	=> S_iD1(31),
     	      o_F	=> S_AND1);
  
  G_MUXROW1: for i in 0 to 30 generate
	
    	MUXROW1: mux2t1 port map(
              i_S      => i_S1(0),    
              i_D0     => S_iD1(i),  
              i_D1     => S_iD1(i+1),  
              o_O    => S_Row1(i));

  end generate G_MUXROW1;

  MUXROW1_31: mux2t1 
       port map(i_S      => i_S1(0),    
                i_D0     => S_iD1(31),  
                i_D1     => S_AND1,  
                o_O      => S_Row1(31));
	       
  G_MUXROW2: for i in 0 to 29 generate
	
    	MUXROW2: mux2t1 port map(
              i_S      => i_S1(1),    
              i_D0     => S_Row1(i),  
              i_D1     => S_Row1(i+2),  
              o_O      => S_Row2(i));

  end generate G_MUXROW2;

  G_MUXROW2_30_31: for i in 30 to 31 generate

        MUXROW2_30_31: mux2t1 port map(
		i_S      => i_S1(1),    
                i_D0     => S_Row1(i),  
                i_D1     => S_AND1,  
                o_O      => S_Row2(i));
  end generate G_MUXROW2_30_31;

  G_MUXROW3: for i in 0 to 27 generate
	
    	MUXROW3: mux2t1 port map(
              i_S      => i_S1(2),    
              i_D0     => S_Row2(i),  
              i_D1     => S_Row2(i+4),  
              o_O      => S_Row3(i));

  end generate G_MUXROW3;

  G_MUXROW3_28_31: for i in 28 to 31 generate

        MUXROW3_28_31: mux2t1 port map(
		i_S      => i_S1(2),    
                i_D0     => S_Row2(i),  
                i_D1     => S_AND1,  
                o_O      => S_Row3(i));

  end generate G_MUXROW3_28_31;

  G_MUXROW4: for i in 0 to 23 generate
	
    	MUXROW4: mux2t1 port map(
              i_S      => i_S1(3),    
              i_D0     => S_Row3(i),  
              i_D1     => S_Row3(i+8),  
              o_O      => S_Row4(i));

  end generate G_MUXROW4;

  G_MUXROW4_24_31: for i in 24 to 31 generate

        MUXROW4_24_31: mux2t1 port map(
		i_S      => i_S1(3),    
                i_D0     => S_Row3(i),  
                i_D1     => S_AND1,  
                o_O      => S_Row4(i));

  end generate G_MUXROW4_24_31;

  G_MUXROW5: for i in 0 to 15 generate
	
    	MUXROW5: mux2t1 port map(
              i_S      => i_S1(4),    
              i_D0     => S_Row4(i),  
              i_D1     => S_Row4(i+16),  
              o_O      => S_oF(i));

  end generate G_MUXROW5;

  G_MUXROW5_16_31: for i in 16 to 31 generate

        MUXROW5_16_31: mux2t1 port map(
		i_S      => i_S1(4),    
                i_D0     => S_Row4(i),  
                i_D1     => S_AND1,  
                o_O      => S_oF(i));

  end generate G_MUXROW5_16_31;  


  REVERSE_IN2: for i in 0 to 31 generate

       S_iD1RR(31-i) <= S_oF(i); 

  end generate REVERSE_IN2;

  N_BIT_MUX2: mux2t1_N
     port map(i_S	        => i_S3,
	      i_D0(31 downto 0)	=> S_oF(31 downto 0),
 	      i_D1(31 downto 0)	=> S_iD1RR(31 downto 0),
	      o_O(31 downto 0)  => o_F(31 downto 0));

end structure;