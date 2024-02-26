----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2023 02:15:55 PM
-- Design Name: 
-- Module Name: blink_all - Behavioral
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

entity clkdiv is
    Port ( sysclk : in STD_LOGIC; -- 33.33 Mhz
           reset : in STD_LOGIC;
           clk_out : out std_logic_vector (3 downto 0));
end clkdiv;

architecture Behavioral of clkdiv is
signal divider: std_logic_vector(24 downto 0);
begin
process (sysclk,reset)
    begin
        if reset='1' then
            divider <="0000000000000000000000000";
        elsif rising_edge(sysclk) then
            divider<= divider+'1';  
          
        end if;
end process;

clk_out(3) <= divider(24); -- 1 Hz
clk_out(2) <= divider(23); --2 Hz
clk_out(1) <= divider(22); -- 5 Hz
clk_out(0) <= divider(21); -- 10 Hz

end Behavioral;
