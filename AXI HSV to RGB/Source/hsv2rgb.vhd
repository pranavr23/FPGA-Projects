----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/12/2023 11:13:34 AM
-- Design Name: 
-- Module Name: hsv2rgb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/12/2023 10:36:54 AM
-- Design Name: 
-- Module Name: hsv2rgb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hsv2rgb is
    Port (
        s_axis_aclk     : in  STD_LOGIC; --clk
        s_axis_aresetn  : in  STD_LOGIC; --reset(active low)
        s_axis_tdata    : in  STD_LOGIC_VECTOR(23 downto 0);  -- 24-bit input tdatain
        s_axis_tvalid   : in  STD_LOGIC; --tvalidin
        s_axis_tready   : out STD_LOGIC; --treadyout
        s_axis_tlast    : in  STD_LOGIC; --tlastin
        s_axis_tuser    : in  STD_LOGIC; --tuserin
        m_axis_tdata    : out STD_LOGIC_VECTOR(23 downto 0);  -- 24-bit output tdataout
        m_axis_tvalid   : out STD_LOGIC; --tvalodout
        m_axis_tready   : in  STD_LOGIC; --treadyin
        m_axis_tlast    : out STD_LOGIC; --tlastout
        m_axis_tuser    : out STD_LOGIC -- tuserout
    );
end hsv2rgb;

architecture Behavioral of hsv2rgb is
    signal H, S, V : STD_LOGIC_VECTOR(7 downto 0);
    signal C, Z, M : STD_LOGIC_VECTOR(7 downto 0):="00000000";
    signal Ctemp : STD_LOGIC_VECTOR(15 downto 0);
    signal R, G, B : STD_LOGIC_VECTOR(7 downto 0);
    signal temp : STD_LOGIC_VECTOR(7 downto 0);
   signal data_valid      : STD_LOGIC := '0';
    signal R1, G1, B1 : STD_LOGIC_VECTOR(7 downto 0);
    signal R2, G2, B2 : STD_LOGIC_VECTOR(7 downto 0);
    signal R1_reg, G1_reg, B1_reg : STD_LOGIC_VECTOR(7 downto 0);
    signal stream_counter : std_logic;
    type state is (IDLE, ACQUIRE, STREAM);
    signal current_state : state;
begin
process (s_axis_tdata,H,S,V,R,G,B,C,M,Z,temp)
    begin
        H <= s_axis_tdata(23 downto 16);
        S <= std_logic_vector(resize(unsigned(s_axis_tdata(15 downto 8)) * 255 / 100, 8));
        V <= s_axis_tdata(7 downto 0);
        temp <= std_logic_vector(1 - abs(signed((unsigned(H) / "00111100") mod 2 - 1)));
        Z<= "00000000";
        Ctemp <= std_logic_vector((unsigned(V) * unsigned(S)));
        if unsigned(Ctemp)> 255 then
            C <= Ctemp(15 downto 8);
            if (C >= "11111110")then
                C<="11111111";
            end if;
         else
            C <= Ctemp(7 downto 0);   
        end if;
        if (temp ="00000001" )then
        Z<= "11111111";
        elsif (temp ="00000000") then
        Z<= "00000000";
       
        --X <= std_logic_vector((unsigned(C) * unsigned(temp)));
        end if;
        M <= std_logic_vector(unsigned(V) - unsigned(C));

        -- Range-based color mapping
        if (H>="00000000" and H<"00111100") then
            R <= std_logic_vector(unsigned(C) + unsigned(M));
            G <= std_logic_vector(unsigned(Z) + unsigned(M));
            B <= M;
        elsif (H>="00111100" and H<"01111000") then
            R <= std_logic_vector(unsigned(Z) + unsigned(M));
            G <= std_logic_vector(unsigned(C) + unsigned(M));
            B <= M;
        elsif (H>="01111000" and H<"10110100") then
            R <= M;
            G <= std_logic_vector(unsigned(C) + unsigned(M));
            B <= std_logic_vector(unsigned(Z) + unsigned(M));
       elsif (H>="10110100" and H<"11110000") then
            R <= M;
            G <= std_logic_vector(unsigned(Z) + unsigned(M));
            B <= std_logic_vector(unsigned(C) + unsigned(M));
       elsif (H>="11110000" and H<="11111111") then
            R <= std_logic_vector(unsigned(Z) + unsigned(M));
            G <= M;
            B <= std_logic_vector(unsigned(C) + unsigned(M));
        else
            R <= std_logic_vector(unsigned(C) + unsigned(M));
            G <= M;
            B <= std_logic_vector(unsigned(Z) + unsigned(M));
        end if;
end process;

process (s_axis_aclk)
begin
if (rising_edge(s_axis_aclk))then
    if (s_axis_aresetn = '0') then
   
        current_state <=IDLE;
        stream_counter <='0';
    else
    case(current_state) is
        when IDLE =>
            stream_counter <= '0';
            m_axis_tvalid <= '0';
           
            if (s_axis_tvalid = '1') then
                s_axis_tready <= '1';
                current_state <= ACQUIRE;
                m_axis_tvalid <= '0';
                R1 <= R;
                G1 <= G;
                B1 <= B;
            end if;
               
        when ACQUIRE =>
            R1 <= R1_reg;
            G1 <= G1_reg;
            B1 <= B1_reg;
--            s_axis_tuser <= '0'; -- Set tuser if needed for user-defined purposes
            if (s_axis_tvalid = '1')then
                R2 <= R;
                G2 <= G;
                B2 <= B;
                m_axis_tvalid <= '1';
                current_state <= STREAM;
                stream_counter <= '0';
                   
            end if;
               
        when STREAM =>
            m_axis_tdata <= (R2 & G2 & B2);
            -- Set tlast when you are about to output the last data word
            if stream_counter = '1' then
                m_axis_tlast <= '1';
            else
                m_axis_tlast <= '0';
            end if;
   
            m_axis_tuser <= '0'; -- Set tuser if needed for user-defined purposes
            if (m_axis_tready = '1') then
                current_state <= IDLE;
                m_axis_tvalid <= '0';
                s_axis_tready <= '1';
                R1_reg <= R;
                G1_reg <= G;
                B1_reg <= B;
                           
            end if;
        when others =>
            current_state <= IDLE;        
           
    end case;
    end if;
end if;
end process;

end Behavioral;

