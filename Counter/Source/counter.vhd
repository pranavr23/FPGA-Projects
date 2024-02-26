----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/02/2023 11:51:42 AM
-- Design Name: 
-- Module Name: test - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    Port ( sysclk : in STD_LOGIC;
           reset : in STD_LOGIC;
           counter : out STD_LOGIC_vector(3 downto 0));
end counter;

architecture Behavioral of counter is

signal count: std_logic_vector (3 downto 0) := "0000";

begin
process (sysclk, reset)
begin

    if reset='1' or count = "1111" then
        count<= "0000";
    elsif (rising_edge(sysclk)) then
        count<= count+1;
    end if;
   
end process;
 counter<=count;
end Behavioral;
