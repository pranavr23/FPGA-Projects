----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2023 02:55:18 PM
-- Design Name: 
-- Module Name: jkff - Behavioral
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

entity jkff is
    Port ( sysclk : in STD_LOGIC;
           JK : in STD_LOGIC_VECTOR (1 downto 0);
           Q : out STD_LOGIC;
           Qn : out STD_LOGIC);
end jkff;

architecture Behavioral of jkff is
signal temp: std_logic :='0';
begin
process(sysclk, JK)
begin
    if rising_edge(sysclk) then
        case(JK) is
            when "00" => temp<=temp ;
            when "01" => temp<='0' ;
            when "10" => temp<='1' ;
            when "11" => temp<=not temp;
            when others => temp <= '0';
        end case;
    end if;    
end process;
Q<=temp;
Qn<= not temp;
end Behavioral;
