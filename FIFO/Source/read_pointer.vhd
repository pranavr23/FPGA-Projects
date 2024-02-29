Library IEEE;
USE IEEE.Std_logic_1164.all;
USE ieee.std_logic_arith.all;  
USE ieee.std_logic_unsigned.all; 

entity read_pointer is 
   port(
      rptr : out std_logic_vector(4 downto 0);    
   fifo_rd: out std_logic;
      clk :in std_logic;  
   rst_n: in std_logic;  
      rd :in  std_logic;
   fifo_empty: in std_logic
   );
end read_pointer;

architecture Behavioral of read_pointer is  

signal re: std_logic;
signal read_addr:std_logic_vector(4 downto 0);   
 
begin  
 rptr <= read_addr;
 fifo_rd <= re ;
 re <= (not fifo_empty) and rd;
 process(clk,rst_n)
 begin 
     if(rst_n='0') then 
   read_addr <= (others => '0');
     elsif(rising_edge(clk)) then
   if(re='1') then 
    read_addr <= read_addr + "00001"; 
   end if;
  end if;      
 end process;  
 
end Behavioral;