-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
-- Date        : Wed May 31 15:07:54 2023
-- Host        : ST-84TTYR2 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/ST/Desktop/myVivado/project_12/project_12.gen/sources_1/bd/design_1/ip/design_1_andgate_0_0/design_1_andgate_0_0_stub.vhdl
-- Design      : design_1_andgate_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_andgate_0_0 is
  Port ( 
    a : in STD_LOGIC;
    b : in STD_LOGIC;
    y1 : out STD_LOGIC
  );

end design_1_andgate_0_0;

architecture stub of design_1_andgate_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "a,b,y1";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "andgate,Vivado 2023.1";
begin
end;
