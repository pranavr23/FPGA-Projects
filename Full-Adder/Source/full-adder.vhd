----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2023 11:55:25 AM
-- Design Name: 
-- Module Name: full-adder - Behavioral
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

entity full_adder is
    Port ( a : in STD_LOGIC; --switch 3
           b : in STD_LOGIC; --switch 2
           c : in STD_LOGIC; -- switch 1
           sum : out STD_LOGIC; --led 1
           carry : out STD_LOGIC); --led 0
end full_adder;

architecture Behavioral of full_adder is
begin
sum<= a xor b xor c;
carry <= (a and b) or (b and c) or (c and a);

end Behavioral;
