----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2023 11:04:50 AM
-- Design Name: 
-- Module Name: ha_tb - Behavioral
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

entity ha_tb is
--  Port ( );
end ha_tb;

architecture Behavioral of ha_tb is
component half_adder is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           sum : out STD_LOGIC;
           carry : out STD_LOGIC);
end component;

--Inputs
signal a : STD_LOGIC := '0';
signal b : STD_LOGIC := '0';

--Outputs
signal sum : STD_LOGIC := '0';
signal carry : STD_LOGIC := '0';

--clk
constant clk_period :time := 30ns;

begin

uut: half_adder port map(
    a=>a,
    b=>b,
    sum=>sum,
    carry=>carry);

stim_proc: process
begin
a<='0';
b<='0';
wait for clk_period*10;
a<='0';
b<='1';
wait for clk_period*10;
a<='1';
b<='0';
wait for clk_period*10;
a<='1';
b<='1';
wait for clk_period*10;
a<='0';
b<='0';
wait for clk_period*10;
wait;
end process; 
end Behavioral;
