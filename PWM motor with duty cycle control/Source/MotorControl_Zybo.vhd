--Different switches change duty cycle of motors

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
   
   
    signal pwmPeriod : integer := 50050; -- (for a PWM frequency of 30 KHz) 30Khz so it is outside audible frequency
    --Actual PWM frequency observed on CRO is 25Khz
    signal pwmDuty : integer := 0;   -- 50% duty cycle for simplicity

begin
    process(Clock, Reset,Sw)
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
            
            case Sw is
                when "0001" =>
                    pwmDuty <= pwmPeriod / 4; -- 25% duty cycle
                when "0010" =>
                    pwmDuty <= pwmPeriod / 2; -- 50% duty cycle
                when "0100" =>
                    pwmDuty <= 3 * pwmPeriod / 4; -- 75% duty cycle
                when "1000" =>
                    pwmDuty <= pwmPeriod; -- 100% duty cycle
                when others =>
                    pwmDuty <= 0; -- Default to 0% duty cycle
            end case;
           
            if pwmCounter < pwmDuty then
                -- Counter-clockwise mode
                PWM_A <= '1';
                AIN1_A <= '0';
                AIN2_A <= '1';
               
                PWM_B <= '1';
                BIN1_B <= '0';
                BIN2_B <= '1';
            else
                -- Turn off PWM and keep direction
                PWM_A <= '0';
                PWM_B <= '0';
            end if;

            -- Enable motors
            STBY <= '1';
           
            if pwmCounter = pwmPeriod then
                pwmCounter <= 0;
            end if;
        end if;
    end process;
end Behavioral;
