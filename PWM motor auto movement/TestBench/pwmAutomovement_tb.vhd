library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MotorControl_Zybo_tb is
end MotorControl_Zybo_tb;

architecture Behavioral of MotorControl_Zybo_tb is
    -- Component declaration for DUT (Design Under Test)
    component MotorControl_Zybo
        Port (
            STBY      : out STD_LOGIC;
            PWM_A     : out STD_LOGIC;
            AIN1_A    : out STD_LOGIC;
            AIN2_A    : out STD_LOGIC;
            PWM_B     : out STD_LOGIC;
            BIN1_B    : out STD_LOGIC;
            BIN2_B    : out STD_LOGIC;
            Clock     : in STD_LOGIC;
            Sw        : in STD_LOGIC_VECTOR (3 downto 0);
            Reset     : in STD_LOGIC
        );
    end component;

    -- Signals for connecting the testbench to the DUT
    signal Clock        : STD_LOGIC := '0';
    signal Reset        : STD_LOGIC := '0';
    signal STBY, PWM_A, AIN1_A, AIN2_A, PWM_B, BIN1_B, BIN2_B : STD_LOGIC;

    constant Clock_period : time := 30 ns; -- Clock period is 30 ns

begin
    -- Instantiate the DUT
    DUT: MotorControl_Zybo
        port map (
            STBY      => STBY,
            PWM_A     => PWM_A,
            AIN1_A    => AIN1_A,
            AIN2_A    => AIN2_A,
            PWM_B     => PWM_B,
            BIN1_B    => BIN1_B,
            BIN2_B    => BIN2_B,
            Clock     => Clock,
            Sw        => (others => '0'),  -- All switches set to 0 (not used)
            Reset     => Reset
        );

    -- Clock generation process
    Clock_process: process
    begin
 
            Clock <= '0';
            wait for Clock_period / 2;
            Clock <= '1';
            wait for Clock_period / 2;
    end process;

    -- Stimulus process
    Stimulus_process: process
    begin
        -- Reset and wait for a while
        Reset <= '1';
        wait for 20 ns;
        Reset <= '0';
        wait for 50 ns;

        loop
            -- Go straight for 0.25 seconds (assuming 8.33 million cycles at 30 ns period)
            wait for 25000000 ns;

            -- Turn left for 0.25 seconds


            -- Go straight for 0.25 seconds


            -- Turn right for 0.25 seconds


  

 

        end loop;

        -- End of simulation
        wait;
    end process;

end Behavioral;
