--Switch positions control direction of motors

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
    signal pwmPeriod : integer := 50050; -- (for a PWM frequency of 30 KHz)
    signal pwmDuty : integer := 25025;   -- 50% duty cycle for simplicity

begin
    process(Clock, Reset, Sw)
    begin
        if Reset = '1' then
            pwmCounter <= 0;
            STBY <= '0';
            PWM_A <= '0';
            AIN1_A <= '0';
            AIN2_A <= '0';
            PWM_B <= '0';
            BIN1_B <= '0';
            BIN2_B <= '0';
        elsif rising_edge(Clock) then
            pwmCounter <= pwmCounter + 1;

            -- Adjust duty cycle based on switches (Sw)
            case Sw is
                when "0001" =>
                    -- Turn left (increase speed of right motor)
                    PWM_A <= '1';
                    AIN1_A <= '1';
                    AIN2_A <= '0';
                    
                    PWM_B <= '1';
                    BIN1_B <= '0';
                    BIN2_B <= '1';
                when "0010" =>
                    -- Turn right (increase speed of left motor)
                    PWM_A <= '1';
                    AIN1_A <= '0';
                    AIN2_A <= '1';
                    
                    PWM_B <= '1';
                    BIN1_B <= '1';
                    BIN2_B <= '0';
                when "0100" =>
                    -- Reverse for both motors
                    PWM_A <= '1';
                    AIN1_A <= '1';
                    AIN2_A <= '0';
                    
                    PWM_B <= '1';
                    BIN1_B <= '1';
                    BIN2_B <= '0';
                when "1000" =>
    -- Go straight (equal speed for both motors)
                    PWM_A <= '1';
                    AIN1_A <= '0';
                    AIN2_A <= '1';

                    PWM_B <= '1';
                    BIN1_B <= '0';
                    BIN2_B <= '1';
                when others =>
                    -- Default to stop mode
                    PWM_A <= '0';
                    PWM_B <= '0';
                    STBY <= '0';
            end case;

            -- Enable motors
            STBY <= '1';

            if pwmCounter = pwmPeriod then
                pwmCounter <= 0;
            end if;
        end if;
    end process;
end Behavioral;
