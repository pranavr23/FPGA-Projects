LIBRARY  ieee ;
USE  ieee.std_logic_1164.ALL ;
-- Testbench code 
ENTITY  traffic_lights_tb  IS 
END  traffic_lights_tb ;

ARCHITECTURE  behavior  OF  traffic_lights_tb  IS  
    -- Component Declaration 
    COMPONENT  traffic_lights 
    PORT (
         sensor :  IN   std_logic ;
         clk :  IN   std_logic ;
         rst_n :  IN   std_logic ;
         highway_signal :  OUT   std_logic_vector ( 2  downto  0 );
         farm_signal :  OUT   std_logic_vector ( 2  downto  0 )
        );
    END  COMPONENT ;
    
--Inputs    
signal sensor :  std_logic  :=  '0' ;   
signal clk :  std_logic  :=  '0' ;
signal rst_n :  std_logic  :=  '0' ;
  --Outputs 
signal highway_signal :  std_logic_vector ( 2  downto  0 );
signal farm_signal :  std_logic_vector ( 2  downto  0 );
constant clk_period :  time  :=  30 ns;

BEGIN 
 -- Instantiate the traffic light controller 
   trafficlights : traffic_lights PORT  MAP (
          sensor => sensor,
          clk => clk,
          rst_n => rst_n,
          highway_signal => highway_signal,
          farm_signal => farm_signal
        );
   -- Clock process definitions 
   clk_process : process 
   begin 
        clk <=  '0' ;
        wait  for clk_period / 2 ;
        clk <=  '1' ;
        wait  for clk_period / 2 ;
   end  process ;
   
   stim_proc :  process 
   begin     
        rst_n <=  '0' ;
        sensor <=  '0' ;
        wait  for clk_period * 10 ;
        rst_n <=  '1' ;
        wait  for clk_period * 20 ;
        sensor <=  '1' ;
        wait  for clk_period * 100 ;
        sensor <=  '0' ;
        wait ;
   end  process ;

END ;