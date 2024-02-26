----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2023 12:01:35 PM
-- Design Name: 
-- Module Name: voting_tb1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity voting_tb1 is
end voting_tb1;

architecture behaviour of voting_tb1 is 
component voting is
    Port ( sysclk : in STD_LOGIC;
           rst : in STD_LOGIC;
           party1 : in STD_LOGIC;
           party2 : in STD_LOGIC;
           party3 : in STD_LOGIC;
           select_party : in STD_LOGIC;
           count1 : out STD_LOGIC_VECTOR (5 downto 0);
           count2 : out STD_LOGIC_VECTOR (5 downto 0);
           count3 : out STD_LOGIC_VECTOR (5 downto 0));
end component;

--Inputs
signal sysclk : STD_LOGIC :='0';
signal rst : STD_LOGIC :='0';
signal party1 : STD_LOGIC :='0';
signal party2 : STD_LOGIC :='0';
signal party3 : STD_LOGIC :='0';
signal select_party : STD_LOGIC :='0';


--Outputs
signal count1 : STD_LOGIC_VECTOR (5 downto 0);
signal count2 : STD_LOGIC_VECTOR (5 downto 0);
signal count3 : STD_LOGIC_VECTOR (5 downto 0);

--Clock
constant clk_period : time :=5 ns;

begin
uut: voting PORT MAP(
    sysclk=> sysclk,
    rst=> rst,
    party1=> party1,
    party2=> party2,
    party3=> party3,
    select_party=> select_party,
    count1=> count1,
    count2=> count2,
    count3=> count3
 );  
 
 --clock process
 clk_process :process
 begin
    sysclk<='0';
    wait for clk_period/2;
    sysclk<='1';
    wait for clk_period/2;
 end process;
 
 --Stimulus
 stim_proc:process
 begin
 --Reset fot 100ns
 wait for 100 ns;
 wait for clk_period*10;
 rst <= '1';
 wait for 10 ns;
 rst <= '0';
 party1 <='0';
 party2 <='0';
 party3 <='0';
 
 party1 <='1'; --1
 wait for 10 ns;
 party1 <='0';
 wait for 10 ns;
 select_party<= '1';
 wait for 10 ns;
 select_party<= '0';
 wait for 10 ns;

 party1 <='1'; --2
 wait for 10 ns;
 party1 <='0';
 wait for 10 ns;
 select_party<= '1';
 wait for 10 ns;
 select_party<= '0';
 wait for 10 ns;
 
  party1 <='1'; --3
 wait for 10 ns;
 party1 <='0';
 wait for 10 ns;
 select_party<= '1';
 wait for 10 ns;
 select_party<= '0';
 wait for 10 ns;
 
  party2 <='1';--1
 wait for 10 ns;
 party2 <='0';
 wait for 10 ns;
 select_party<= '1';
 wait for 10 ns;
 select_party<= '0';
 wait for 10 ns;
 
  party2 <='1';--2
 wait for 10 ns;
 party2 <='0';
 wait for 10 ns;
 select_party<= '1';
 wait for 10 ns;
 select_party<= '0';
 wait for 10 ns;
 
  party3 <='1';--1
 wait for 10 ns;
 party3 <='0';
 wait for 10 ns;
 select_party<= '1';
 wait for 10 ns;
 select_party<= '0';
 wait for 10 ns;
 
  party3 <='1';--2
 wait for 10 ns;
 party1 <='0';
 wait for 10 ns;
 select_party<= '1';
 wait for 10 ns;
 select_party<= '0';
 wait for 10 ns;
 
  party3 <='1';--3
 wait for 10 ns;
 party3 <='0';
 wait for 10 ns;
 select_party<= '1';
 wait for 10 ns;
 select_party<= '0';
 wait for 10 ns;
 
  party3 <='1';--4
 wait for 10 ns;
 party3 <='0';
 wait for 10 ns;
 select_party<= '1';
 wait for 10 ns;
 select_party<= '0';
 wait for 10 ns;

end process; 
end behaviour;
