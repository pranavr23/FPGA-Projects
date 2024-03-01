-- Description: Initially, the FSM is in IDLE state. 
--If there is a vehicle coming detected by the front sensor, FSM is switched to WAIT_PASSWORD state for 4 cycles. The car will input the password in this state; if the password is correct, the gate is opened to let the car get in the car park and FSM turns to RIGHT_PASS state; a Green LED will be blinking. 
--Otherwise, FSM turns to WRONG_PASS state; a Red LED will be blinking and it requires the car to enter the password again until the password is correct.
-- When the current car gets into the car park detected by the back sensor and there is the next car coming, the FSM is switched to STOP state and the Red LED will be blinking so that the next car will be noticed to stop and enter the password. 
--After the car passes the gate and gets into the car park, the FSM returns to IDLE state.

library  IEEE ;
use  IEEE.STD_LOGIC_1164.ALL ;
use  IEEE.std_logic_unsigned.all ;


entity  Car_Parking_System  is 
port 
(
  clk,reset_n :  in  std_logic ; -- clock and reset of the car parking system 
  front_sensor, back_sensor :  in  std_logic ; -- two sensors in front and behind the gate of the car parking system 
  password_1, password_2 :  in  std_logic_vector ( 1  downto  0 ); -- input password 
  GREEN_LED,RED_LED :  out  std_logic ; -- signaling LEDs 
  HEX_1 :  out  std_logic_vector ( 6  downto  0 ) -- 7-segment display
);
end  Car_Parking_System ;

architecture Behavioral of Car_Parking_System is
    -- FSM States
    type FSM_States is (IDLE, WAIT_PASSWORD, WRONG_PASS, RIGHT_PASS, STOP);
    signal current_state, next_state : FSM_States;
    signal counter_wait : std_logic_vector(31 downto 0);
    signal red_tmp, green_tmp : std_logic;

begin
    -- Sequential circuits
    process(clk, reset_n)
    begin
        if (reset_n = '0') then
            current_state <= IDLE;
        elsif (rising_edge(clk)) then
            current_state <= next_state;
        end if;
    end process;

    -- Combinational logic
    process(current_state, front_sensor, password_1, password_2, back_sensor, counter_wait)
    begin
        case current_state is
            when IDLE =>
                if (front_sensor = '1') then
                    next_state <= WAIT_PASSWORD;
                else
                    next_state <= IDLE;
                end if;
                
            when WAIT_PASSWORD =>
                if (counter_wait <= x"00000003") then
                    next_state <= WAIT_PASSWORD;
                else
                    if ((password_1 = "01") and (password_2 = "10")) then
                        next_state <= RIGHT_PASS;
                    else
                        next_state <= WRONG_PASS;
                    end if;
                end if;
                
            when WRONG_PASS =>
                if ((password_1 = "01") and (password_2 = "10")) then
                    next_state <= RIGHT_PASS;
                else
                    next_state <= WRONG_PASS;
                end if;
                
            when RIGHT_PASS =>
                if (front_sensor = '1' and back_sensor = '1') then
                    next_state <= STOP;
                elsif (back_sensor = '1') then
                    next_state <= IDLE;
                else
                    next_state <= RIGHT_PASS;
                end if;
                
            when STOP =>
                if ((password_1 = "01") and (password_2 = "10")) then
                    next_state <= RIGHT_PASS;
                else
                    next_state <= STOP;
                end if;
                
            when others =>
                next_state <= IDLE;
        end case;
    end process;

    -- Wait for password
    process(clk, reset_n)
    begin
        if (reset_n = '0') then
            counter_wait <= (others => '0');
        elsif (rising_edge(clk)) then
            if (current_state = WAIT_PASSWORD) then
                counter_wait <= counter_wait + x"00000001";
            else
                counter_wait <= (others => '0');
            end if;
        end if;
    end process;

    -- Output
    process(clk) -- change this clock to change the LED blinking period
    begin
        if (rising_edge(clk)) then
            case (current_state) is
                when IDLE =>
                    green_tmp <= '0';
                    red_tmp <= '0';
                    HEX_1 <= "1111111"; -- off
                
                when WAIT_PASSWORD =>
                    green_tmp <= '0';
                    red_tmp <= '1';
                    HEX_1 <= "0000110"; -- E (Input Password)
                    
                when WRONG_PASS =>
                    green_tmp <= '0';
                    red_tmp <= not red_tmp;
                    HEX_1 <= "0000110"; -- E (Input Password)
                    
                when RIGHT_PASS =>
                    green_tmp <= not green_tmp;
                    red_tmp <= '0';
                    HEX_1 <= "0000010"; -- 6 (Go)
                    
                when STOP =>
                    green_tmp <= '0';
                    red_tmp <= not red_tmp;
                    HEX_1 <= "0010010"; -- 5 (Stop)
                    
                when others =>
                    green_tmp <= '0';
                    red_tmp <= '0';
                    HEX_1 <= "1111111"; -- off
            end case;
        end if;
    end process;

    RED_LED <= red_tmp;
    GREEN_LED <= green_tmp;

end Behavioral;