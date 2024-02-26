----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2023 02:22:59 PM
-- Design Name: 
-- Module Name: srff - Behavioral
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
-- Switch 4 is s, Switch 3 is R, Led 0 is qn and led 1 is q
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

entity srff is
    Port ( sysclk : in STD_LOGIC;
           SR : in std_logic_vector (1 downto 0);
           Q : out STD_LOGIC;
           Qn : out STD_LOGIC);
end srff;

architecture Behavioral of srff is
signal temp: std_logic :='0';
begin
process(sysclk, SR)
begin
    if rising_edge(sysclk) then
        case(SR) is
            when "00" => temp<=temp ;
            when "01" => temp<='0' ;
            when "10" => temp<='1' ;
            when "11" => temp<='Z';
            when others => temp <= '0';
        end case;
    end if;    
end process;
Q<=temp;
Qn<= not temp;
end Behavioral;
