----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2023 02:33:37 PM
-- Design Name: 
-- Module Name: srff_tb - Behavioral
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

entity srff_tb is
--  Port ( );
end srff_tb;

architecture Behavioral of srff_tb is
component srff is
    Port ( sysclk : in STD_LOGIC;
           SR : in std_logic_vector (1 downto 0);
           Q : out STD_LOGIC;
           Qn : out STD_LOGIC);
end component;

--Inputs
signal sysclk : STD_LOGIC :='0';
signal SR: std_logic_vector(1 downto 0);

--Outputs
signal Q: std_logic:='0';
signal Qn: std_logic:='0';

--clk
constant clk_period: time:= 30ns;

begin
--UUt
uut: srff port map (
    sysclk=>sysclk,
    SR=>SR,
    Q=>Q,
    Qn=>Qn);
    
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
SR<="00";
wait for clk_period*10;
SR<="01";
wait for clk_period*10;
SR<="10";
wait for clk_period*10;
SR<="11";
wait for clk_period*10;
SR<="10";
wait for clk_period*10;
SR<="00";
wait for clk_period*10;
wait;
end process;


end Behavioral;
