----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2023 10:00:49 AM
-- Design Name: 
-- Module Name: blink_tb - Behavioral
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

entity blink_tb is
--  Port ( );
end blink_tb;

architecture Behavioral of blink_tb is
component blink_led is
    Port ( clk : in STD_LOGIC;
           led : out STD_LOGIC);
end component;

--Inputs
signal clk: std_logic := '0';

--Outputs
signal led: std_logic := '0';
--clk
constant clk_period :time := 30ns;
begin
--UUT
   uut: blink_led port map (
      clk=> clk,
      led => led);
  
   clk_process : process
 begin
    clk <='0';
    wait for clk_period/2;
    clk <='1';
    wait for clk_period/2;
  end process;

stim_proc: process
begin
wait;
end process;    

end Behavioral;


