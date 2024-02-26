----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2023 12:40:24 PM
-- Design Name: 
-- Module Name: dff - Behavioral
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

entity dff is
    Port ( sysclk : in STD_LOGIC;
           d : in STD_LOGIC;
           q : out STD_LOGIC;
           qn : out STD_LOGIC);
end dff;

architecture Behavioral of dff is
signal temp:std_logic:='0';
begin
process (sysclk,d)
begin
    if rising_edge(sysclk) then
        temp<=d; 
    end if;
end process;
q<=temp;
qn<= not temp;
end Behavioral;
