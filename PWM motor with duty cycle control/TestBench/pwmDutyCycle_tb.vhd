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
    signal Sw           : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
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
            Sw        => Sw,
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

        -- Test different switch positions
        Sw <= "0001"; -- 25% duty cycle
        wait for 200 ns;
        
        Sw <= "0010"; -- 50% duty cycle
        wait for 200 ns;

        Sw <= "0100"; -- 75% duty cycle
        wait for 200 ns;

        Sw <= "1000"; -- 100% duty cycle
        wait for 200 ns;

        Sw <= "0000"; -- 0% duty cycle (default)
        wait for 200 ns;

        -- End of simulation
        wait;
    end process;



end Behavioral;
