----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2023 10:23:43 AM
-- Design Name: 
-- Module Name: button_blink_tb - Behavioral
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

entity button_blink_tb is
--  Port ( );
end button_blink_tb;

architecture Behavioral of button_blink_tb is
component button_blink is
    Port ( btn : in STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (3 downto 0);
           sysclk : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

--Inputs
signal btn : STD_LOGIC_VECTOR (3 downto 0);
signal sysclk : STD_LOGIC :='0';
signal reset : STD_LOGIC :='0';

--Outputs
signal led : STD_LOGIC_VECTOR (3 downto 0);

--Clock
constant clk_period : time :=30 ns;
begin

--UUT
uut: button_blink port map (
    btn=>btn,
    led=>led,
    sysclk=>sysclk,
    reset => reset);

 clk_process : process
 begin
    sysclk <='0';
    wait for clk_period/2;
    sysclk <='1';
    wait for clk_period/2;
  end process;
  
  stim_proc: process
  begin
   --wait for clk_period * 10;
    reset <='1';
    wait for 100ns;
    reset <='0';
    wait for 100ns;
    btn(0)<='1';
    btn(0)<='1'; 
    btn(0)<='1'; 
    btn(0)<='1'; 
    btn(0)<='1'; 
    btn(0)<='1'; 
    wait for 100ns;
    btn(1)<='1';
    btn(1)<='1'; 
    btn(1)<='1'; 
    btn(1)<='1'; 
    btn(1)<='1'; 
    btn(1)<='1'; 
    wait for 100ns;
    btn(2)<='1';
    btn(2)<='1'; 
    btn(2)<='1'; 
    btn(2)<='1'; 
    btn(2)<='1'; 
    btn(2)<='1'; 
    wait for 100ns;
    btn(3)<='1';
    btn(3)<='1'; 
    btn(3)<='1'; 
    btn(3)<='1'; 
    btn(3)<='1'; 
    btn(3)<='1'; 
    wait for 100ns;
     
   
  
  --reset <='1';
wait;
end process;    

end Behavioral;

