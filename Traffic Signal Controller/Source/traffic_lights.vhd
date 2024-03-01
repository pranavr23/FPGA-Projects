library  IEEE ;
use  IEEE.STD_LOGIC_1164.ALL ;
use  IEEE.STD_LOGIC_UNSIGNED.ALL ;  
-- Traffic light system for an intersection between highway and farm way 
-- There is a sensor on the farm way side, when there are vehicles, 
-- Traffic light turns to YELLOW, then GREEN to let the vehicles cross the highway 
-- Otherwise , always green light on Highway and Red light on farm way 
entity  traffic_lights  is 
 port ( sensor   :  in  STD_LOGIC ; -- Sensor 
        clk   :  in  STD_LOGIC ; -- clock 
        rst_n :  in  STD_LOGIC ; -- reset active low 
        highway_signal   :  out  STD_LOGIC_VECTOR ( 2  downto  0 ); -- light outputs of high way 
        farm_signal :     out  STD_LOGIC_VECTOR ( 2  downto  0 ) -- light outputs of farm way 
     --RED_YELLOW_GREEN
   );
end  traffic_lights ;

architecture  traffic_light  of  traffic_lights  is 
signal counter_1s :  std_logic_vector ( 27  downto  0 ) := x"0000000" ;
signal delay_count : std_logic_vector ( 3  downto  0 ) :=  x"0" ;
signal delay_10s, delay_3s_F,delay_3s_H, red_enable, yellow1_enable,yellow2_enable :  std_logic := '0' ;
signal clk_1s_enable :  std_logic ; -- 1s clock enable 
type FSM_States is (HG_FR, HY_FR, HR_FG, HR_FY);
-- HG_FR : Highway green and farm red 
-- HY_FR : Highway yellow and farm red 
-- HR_FG : Highway red and farm green 
-- HR_FY : Highway red and farm yellow 

signal current_state, next_state : FSM_States;
begin 
-- next state FSM sequential logic 
    process (clk,rst_n) 
     begin 
        if (rst_n = '0' ) then 
            current_state <= HG_FR;
        elsif (rising_edge(clk)) then  
            current_state <= next_state; 
        end  if ; 
    end  process ;
-- FSM combinational logic 
    process (current_state,sensor,delay_3s_F,delay_3s_H,delay_10s)
     begin 
     
        case current_state is  
            when HG_FR =>  -- When Green light on Highway and Red light on Farm way 
            red_enable <=  '0' ; -- disable RED light delay counting 
            yellow1_enable <=  '0' ; -- disable YELLOW light Highway delay counting 
            yellow2_enable <=  '0' ; -- disable YELLOW light Farmway delay counting 
            highway_signal <=  "001" ; -- Green light on Highway 
            farm_signal <=  "100" ; -- Red light on Farm way 
            if (sensor =  '1' )then  -- if vehicle is detected on farm way by sensors 
                next_state <= HY_FR; 
                -- High way turns to Yellow light 
            else  
                next_state <= HG_FR; 
             -- Otherwise, remains GREEN ON highway and RED on Farm way 
            end  if ;
            
            when HY_FR =>  -- When Yellow light on Highway and Red light on Farm way 
            highway_signal <=  "010" ; -- Yellow light on Highway 
            farm_signal <=  "100" ; -- Red light on Farm way 
            red_enable <=  '0' ; -- disable RED light delay counting 
            yellow1_enable <=  '1' ; -- enable YELLOW light Highway delay counting 
            yellow2_enable <=  '0' ; -- disable YELLOW light Farmway delay counting 
            if (delay_3s_H = '1' ) then  
                -- if Yellow light delay counts to 3s, 
                -- turn Highway to RED, 
                -- Farm way to green light 
                next_state <= HR_FG; 
            else  
                next_state <= HY_FR; 
                -- Remains Yellow on highway and Red on Farm way 
                -- if Yellow light not yet in 3s 
            end  if ;
            
            when HR_FG =>  
            highway_signal <=  "100" ; -- RED light on Highway 
            farm_signal <=  "001" ; -- GREEN light on Farm way 
            red_enable <=  '1' ; -- enable RED light delay counting 
            yellow1_enable <=  '0' ; -- disable YELLOW light Highway delay counting 
            yellow2_enable <=  '0' ; -- disable YELLOW light Farmway delay counting 
            if (delay_10s = '1' ) then 
            -- if RED light on highway is 10s,  Farm way turns to Yellow
                next_state <= HR_FY;
            else  
                next_state <= HR_FG; 
            -- Remains if delay counts for RED light on highway not enough 10s 
            end  if ;
            
            when HR_FY => 
            highway_signal <=  "100" ;-- RED light on Highway 
            farm_signal <=  "010" ; -- Yellow light on Farm way 
            red_enable <=  '0' ; -- disable RED light delay counting 
            yellow1_enable <=  '0' ; -- disable YELLOW light Highway delay counting 
            yellow2_enable <=  '1' ; -- enable YELLOW light Farmway delay counting 
            if (delay_3s_F = '1' ) then  
            -- if delay for Yellow light is 3s, 
            -- turn highway to GREEN light 
            -- Farm way to RED Light 
                next_state <= HG_FR;
            else  
                next_state <= HR_FY;
            -- if not enough 3s, remain the same state 
            end  if ;
            
            when  others  => next_state <= HG_FR; -- Green on highway, red on farm way 
        end  case ;
end  process ;
-- Delay counts for Yellow and RED light   
    process (clk)
        begin 
            if (rising_edge(clk)) then  
                if (clk_1s_enable = '1' ) then 
                    if (red_enable = '1'  or yellow1_enable = '1'  or yellow2_enable = '1' ) then 
                        delay_count <= delay_count +  "1" ;
                        if ((delay_count =  x"9" ) and red_enable = '1' ) then  
                            delay_10s <=  '1' ;
                            delay_3s_H <=  '0' ;
                            delay_3s_F <=  '0' ;
                            delay_count <=  x"0" ;
                        elsif ((delay_count =  x"2" ) and yellow1_enable =  '1' ) then 
                            delay_10s <=  '0' ;
                            delay_3s_H <=  '1' ;
                            delay_3s_F <=  '0' ;
                            delay_count <= x"0" ;
                        elsif ((delay_count = x"2" ) and yellow2_enable =  '1' ) then 
                            delay_10s <=  '0' ;
                            delay_3s_H <=  '0' ;
                            delay_3s_F <=  '1' ;
                            delay_count <=  x"0" ;
                        else 
                            delay_10s <=  '0' ;
                            delay_3s_H <=  '0' ;
                            delay_3s_F <=  '0' ;
                        end  if ;
                    end  if ;
                end  if ;
            end  if ;
    end  process ;
-- create delay 1s 
process (clk)
 begin 
    if (rising_edge(clk)) then  
        counter_1s <= counter_1s +  x"0000001" ;
        if (counter_1s >= x"0004") then -- x"0004"  is  for simulation
  -- change to x"01FC9350" for 33.33 MHz clock running real FPGA 
        counter_1s <= x"0000000" ;
        end  if ;
    end  if ;
end  process ;

clk_1s_enable <=  '1'  when counter_1s = x"0002" else '0'; -- x"0002"  is  for simulation
 -- x"01FC9350" for 33.33 MHz clock on FPGA 
end  traffic_light ;