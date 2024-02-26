----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2023 11:57:53 AM
-- Design Name: 
-- Module Name: full_added_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity full_added_tb is
--  Port ( );
end full_added_tb;

architecture Behavioral of full_added_tb is
component full_adder is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           c : in STD_LOGIC;
           sum : out STD_LOGIC;
           carry : out STD_LOGIC);
end component;

--Inputs
signal a: std_logic:= '0';
signal b: std_logic:= '0';
signal c: std_logic:= '0';
--Outputs
signal sum: std_logic:= '0';
signal carry: std_logic:= '0';
--CLK
constant clk_period : time :=30 ns;
begin
--UUT
uut: full_adder port map(
    a=>a,
    b=>b,
    c=>c,
    sum=>sum,
    carry=>carry);

stim_proc:process
begin
    a<='0';
    b<='0';
    c<='0';
    wait for clk_period*10;
    
    a<='0';
    b<='0';
    c<='1';
    wait for clk_period*10;
    
    a<='0';
    b<='1';
    c<='0';
    wait for clk_period*10;
    
    a<='0';
    b<='1';
    c<='1';
    wait for clk_period*10;
    
    a<='1';
    b<='0';
    c<='0';
    wait for clk_period*10;
    
    a<='1';
    b<='0';
    c<='1';
    wait for clk_period*10;
    
    a<='1';
    b<='1';
    c<='0';
    wait for clk_period*10;
    
    a<='1';
    b<='1';
    c<='1';
    wait for clk_period*10;
    
    a<='0';
    b<='0';
    c<='0';
    wait for clk_period*10;
              
wait;
end process;
end Behavioral;
