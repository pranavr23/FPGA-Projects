library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Car_Parking_System_tb is
end Car_Parking_System_tb;

architecture Behavioral of Car_Parking_System_tb is
    -- Constants
    constant CLOCK_PERIOD: time := 30 ns;
    
    -- Signals
    signal clk:             std_logic := '0';
    signal reset_n:         std_logic := '0';
    signal front_sensor:    std_logic := '0';
    signal back_sensor:     std_logic := '0';
    signal password_1:      std_logic_vector(1 downto 0) := "00";
    signal password_2:      std_logic_vector(1 downto 0) := "00";
    signal GREEN_LED, RED_LED: std_logic;
    signal c:               std_logic;
    signal HEX_1:           std_logic_vector(6 downto 0);

begin
    -- DUT instance
    dut_Car_Parking_System: entity work.Car_Parking_System
        port map (
            clk         => clk,
            reset_n     => reset_n,
            front_sensor=> front_sensor,
            back_sensor => back_sensor,
            password_1  => password_1,
            password_2  => password_2,
            GREEN_LED   => GREEN_LED,
            RED_LED     => RED_LED,
            c           => c,
            HEX_1       => HEX_1
        );

    -- Clock process
    process
    begin
        while true loop
            clk <= '0';
            wait for CLOCK_PERIOD / 2;
            clk <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin
        -- Reset
        reset_n <= '0';
        wait for 10 ns;
        reset_n <= '1';
        wait for 10 ns;

        -- Example stimulus
        
        -- Front sensor detects a car

        front_sensor <= '1';
        wait for 10 ns;
        -- Provide password (example: 01)
        password_1 <= "01";
        wait for 10 ns;
        password_2 <= "10";
        wait for 10 ns;

        
        -- Next car comes, back sensor detects it
        back_sensor <= '1';
        wait for 10 ns;
        
        -- Provide password (example: 10)
        
        wait for 10 ns;

      

        -- End of simulation
        wait;
    end process;

end Behavioral;
