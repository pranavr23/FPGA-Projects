----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2023 10:35:44 AM
-- Design Name: 
-- Module Name: blink_led - Behavioral
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

entity blink_led is
    Port ( clk : in STD_LOGIC;
           led : out STD_LOGIC);
end blink_led;

architecture Behavioral of blink_led is
signal clk_counter: natural range 0 to 50000000 :=0;
signal temp: std_logic:='0';
begin

    process(clk)
        begin
        if (rising_edge(clk)) then
            clk_counter <= clk_counter+1;
            if clk_counter >= 50000000 then
                        temp <= not temp;
                        clk_counter <=0;
            end if;
        end if;
    end process;
led <= temp;        
--led on
--500ms delay           
end Behavioral;
