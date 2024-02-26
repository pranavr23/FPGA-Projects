----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2023 10:23:12 AM
-- Design Name: 
-- Module Name: voting - Behavioral
-- Project Name: Voting Machine
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity voting is
    Port ( sysclk : in STD_LOGIC;
           rst : in STD_LOGIC;
           party1 : in STD_LOGIC;
           party2 : in STD_LOGIC;
           party3 : in STD_LOGIC;
           select_party : in STD_LOGIC;
           count1 : out STD_LOGIC_VECTOR (5 downto 0);
           count2 : out STD_LOGIC_VECTOR (5 downto 0);
           count3 : out STD_LOGIC_VECTOR (5 downto 0));
end voting;

architecture Behavioral of voting is
signal c1,c2,c3 : STD_LOGIC_VECTOR (5 downto 0);
signal state : STD_LOGIC_VECTOR (5 downto 0);
constant initial : STD_LOGIC_VECTOR (5 downto 0):="000001"; -- 1 shot programming
constant check : STD_LOGIC_VECTOR (5 downto 0):="000010";
constant p1_out : STD_LOGIC_VECTOR (5 downto 0):="000100";
constant p2_out : STD_LOGIC_VECTOR (5 downto 0):="001000";
constant p3_out : STD_LOGIC_VECTOR (5 downto 0):="010000";
constant done : STD_LOGIC_VECTOR (5 downto 0):="100000";
begin

process (sysclk,rst,party1,party2,party3)
begin
    if(rst='1') then
        c1<= (others=>'0');
        c2<= (others=>'0');
        c3<= (others=>'0');
        state<= initial;
     else
        if (rising_edge(sysclk) and rst='0') then
            case state is 
                when initial=>
                --NSL
                    if (party1='1' or party2='1' or party3='1') then
                        state<= check; --If button is pressed then the state transitions to next state
                    else
                         state<= initial; -- Else it stays in the same state
                    end if;  
                --OFL
                
                when check =>
                --NSL
                    if (party1='1') then
                        state <= p1_out; -- if party1 is pressed then state transitions to p1_out
                    elsif (party2='1') then
                        state <= p2_out; --if party2 is pressed then state transitions to p2_out
                    elsif (party3='1') then
                        state <= p3_out;  --if party3 is pressed then state transitions to p3_out   
                    else
                        state<= check;  -- If nothing is pressed it stays in the same state   
                    end if;
                  --OFL
                  
                  when p1_out=>
                  --NSL
                    if (select_party='1') then --State transitions to done state after counting
                        state <= done;
                    else
                        state <= p1_out; 
                    end if;
                   --OFL
                   if (select_party='1') then
                     c1<= c1+'1'; -- Increment count of party 1 if it was selected
                    end if; 
                   when p2_out=>
                  --NSL
                    if (select_party='1') then --State transitions to done state after counting
                        state <= done;
                    else
                        state <= p2_out;  
                    end if;
                   --OFL
                   if (select_party='1') then
                     c2<= c2+'1'; -- Increment count of party 2 if it was selected
                   end if; 
                   when p3_out=>
                  --NSL
                    if (select_party='1') then --State transitions to done state after counting
                        state <= done;
                    else
                        state <= p3_out; 
                    end if;
                   --OFL
                   if (select_party='1') then
                     c3<= c3+'1'; -- Increment count of party 3 if it was selected
                   end if; 
                    when done=>
                        state<=initial; -- After counting the state returns to initial state
                    when others=>
                        state<=initial; -- When something different is pressed state goes to initial state
    
            end case;
        end if;
    end if;
 end process;                 
 count1<= c1;
 count2<= c2;
 count3<= c3;                    
 end Behavioral;
