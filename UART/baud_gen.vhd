-- Importing standard logic types
library ieee;
use ieee.std_logic_1164.all;
-- Importing numeric types
use ieee.numeric_std.all;
-- Defining the entity
entity baud_gen is
    port(
        clk   : in std_logic; -- Input clock signal
        reset : in std_logic; -- Input reset signal
        dvsr: in std_logic_vector(10 downto 0); -- Input divisor value
        tick  : out std_logic -- Output tick signal
    );
end baud_gen;

-- Defining the architecture for the baud generator entity
architecture arch of baud_gen is

    constant N: integer := 11; -- Constant integer value N
    -- Unsigned signal r_reg
    signal r_reg  : unsigned(N - 1 downto 0); 
    -- Unsigned signal r_next
    signal r_next : unsigned(N - 1 downto 0);

begin

    process(clk, reset)  -- Process for registering the inputs
    begin
        if (reset = '1') then
            r_reg <= (others => '0'); -- Reset r_reg signal to all zeros
        elsif (clk'event and clk = '1') then
            r_reg <= r_next; -- Update r_reg signal to r_next signal
        end if;
    end process;
 
    -- Next-state logic
    r_next <= (others=>'0') when r_reg=unsigned(dvsr) else r_reg + 1; -- Update r_next signal
 
    -- Output logic
    tick <= '1' when r_reg=1 else '0'; -- Output tick signal
    -- Not using 0 because of reset
end arch;