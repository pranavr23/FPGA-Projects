----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/25/2023 01:26:56 PM
-- Design Name: 
-- Module Name: button_blink - Behavioral
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

entity button_blink is
    Port ( btn : in STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (3 downto 0);
           sysclk : in STD_LOGIC; -- 33.33 Mhz
           reset : in STD_LOGIC);
end button_blink;

architecture Behavioral of button_blink is
signal divider: std_logic_vector(24 downto 0);
signal clk_out: std_logic_vector(3 downto 0);
signal temp1: std_logic:='0';
signal temp2: std_logic:='0';
signal temp3: std_logic:='0';
signal temp4: std_logic:='0';

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
clk_out(2) <= divider(23); -- 2 Hz
clk_out(1) <= divider(22); -- 5 Hz
clk_out(0) <= divider(21); -- 10 Hz

--Press button 0 for 1HZ LED BLINKING
process (btn(0),clk_out(3) )
begin
    if btn(0) = '1' then
        if rising_edge(clk_out(3)) then
            temp1 <= not temp1;  
         end if;
            
    end if;
led (0)<= temp1;
end process;
--Press button 1 for 2HZ LED BLINKING
process (btn(1),clk_out(2) )
begin
    if btn(1) = '1' then
        if rising_edge(clk_out(2)) then
            temp2 <= not temp2;  
         end if;
    end if;
led (1)<= temp2;
end process;
--Press button for 5HZ LED BLINKING
process (btn(2),clk_out(1) )
begin
    if btn(2) = '1' then
        if rising_edge(clk_out(1)) then
            temp3 <= not temp3;  
        end if;
    end if;
led (2)<= temp3;
end process;
--Press button for 10HZ LED BLINKING
process (btn(3),clk_out(0) )
begin
    if btn(3) = '1' then
        if rising_edge(clk_out(0)) then
            temp4 <= not temp4;  
        end if;
    end if;
led (3)<= temp4;
end process;

end Behavioral;
