----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2023 12:44:04 PM
-- Design Name: 
-- Module Name: dff_tb - Behavioral
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

entity dff_tb is
--  Port ( );
end dff_tb;

architecture Behavioral of dff_tb is
component dff is
    Port ( sysclk : in STD_LOGIC;
           d : in STD_LOGIC;
           q : out STD_LOGIC;
           qn : out STD_LOGIC);
end component;

--Inputs
signal sysclk : STD_LOGIC :='0';
signal d: std_logic:='0';

--Outputs
signal q: std_logic:='0';
signal qn: std_logic:='0';

--clk
constant clk_period: time:= 30ns;

begin
--UUt
uut: dff port map (
    sysclk=>sysclk,
    d=>d,
    q=>q,
    qn=>qn);
    
--clk process
 clk_process : process
 begin
    sysclk <='0';
    wait for clk_period/2;
    sysclk <='1';
    wait for clk_period/2;
  end process;
  
--Stimulus
stim_proc: process
begin
d<='0';
wait for clk_period*10;
d<='1';
wait for clk_period*10;
d<='0';
wait for clk_period*10;
wait;
end process;


end Behavioral;
