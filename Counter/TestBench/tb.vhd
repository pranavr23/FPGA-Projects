----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/02/2023 11:58:25 AM
-- Design Name: 
-- Module Name: tb - Behavioral
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

entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is

component counter is
    Port ( sysclk : in STD_LOGIC;
           reset : in STD_LOGIC;
           counter : out std_logic_vector (3 downto 0)
            );
end component;

--inputs
signal sysclk: std_logic := '0';
signal reset: std_logic := '0';

--outputs
signal count : std_logic_vector (3 downto 0);

constant clk_period :time := 30ns;

begin
--uut

   uut: counter port map (
      sysclk=> sysclk,
      reset => reset,
      counter=> count
      );
      
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
   
  
  --reset <='1';
wait;
end process;    

end Behavioral;