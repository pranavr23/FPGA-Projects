--Goes straight, turn left, Go straight, then turn left 
--Repeat

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MotorControl_Zybo is
    Port ( STBY : out STD_LOGIC;
           PWM_A, AIN1_A, AIN2_A : out STD_LOGIC;
           PWM_B, BIN1_B, BIN2_B : out STD_LOGIC;
           Clock : in STD_LOGIC;
           Sw : in std_logic_vector (3 downto 0);
           Reset : in STD_LOGIC);
end MotorControl_Zybo;

architecture Behavioral of MotorControl_Zybo is
    signal pwmCounter : integer := 0;
    signal pwmPeriod : integer := 60060; -- (for a PWM frequency of 30KHz)
    signal pwmDuty : integer := 15015;    -- 25% duty cycle for slower turn
    signal movementCounter : integer := 0;
    constant STRAIGHT_DURATION : integer := 100000000; -- 
    constant TURN_DURATION : integer := 75000000;      -- 0.25 seconds (75 million cycles at 3.33 ns period)

begin
    process(Clock, Reset, Sw)
    begin
        if Reset = '1' then
            pwmCounter <= 0;
            movementCounter <= 0;
            STBY <= '0';
            PWM_A <= '0';
            AIN1_A <= '0';
            AIN2_A <= '0';
            PWM_B <= '0';
            BIN1_B <= '0';
            BIN2_B <= '0';
        elsif rising_edge(Clock) then
            pwmCounter <= pwmCounter + 1;
            movementCounter <= movementCounter + 1;

            -- Control movement based on counters
            if movementCounter < STRAIGHT_DURATION then
                -- Go straight (equal speed for both motors)
                PWM_A <= '1';
                AIN1_A <= '0';
                AIN2_A <= '1';

                PWM_B <= '1';
                BIN1_B <= '0';
                BIN2_B <= '1';
            elsif movementCounter < STRAIGHT_DURATION + TURN_DURATION then
                -- Turn right (increase speed of left motor)
                PWM_A <= '1';
                AIN1_A <= '0';
                AIN2_A <= '1';

                PWM_B <= '1';
                BIN1_B <= '1';
                BIN2_B <= '0';
            elsif movementCounter < 2 * STRAIGHT_DURATION + TURN_DURATION then
                -- Go straight again (equal speed for both motors)
                PWM_A <= '1';
                AIN1_A <= '0';
                AIN2_A <= '1';

                PWM_B <= '1';
                BIN1_B <= '0';
                BIN2_B <= '1';
            elsif movementCounter < 2 * (STRAIGHT_DURATION + TURN_DURATION) then
                -- Turn left (increase speed of right motor)
                PWM_A <= '1';
                AIN1_A <= '1';
                AIN2_A <= '0';

                PWM_B <= '1';
                BIN1_B <= '0';
                BIN2_B <= '1';
            else
                -- Reset counters for the next movement cycle
                movementCounter <= 0;
                pwmCounter <= 0;
            end if;

            -- Enable motors
            STBY <= '1';

            if pwmCounter = pwmPeriod then
                pwmCounter <= 0;
            end if;
        end if;
    end process;
end Behavioral;
