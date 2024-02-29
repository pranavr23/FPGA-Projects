library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hsv2rgb_tb is
end hsv2rgb_tb;

architecture Behavioral of hsv2rgb_tb is
    -- Constants
    constant CLOCK_PERIOD: time := 30 ns;
    
    -- Signals
    signal s_axis_aclk:     std_logic := '0';
    signal s_axis_aresetn:  std_logic := '0';
    signal s_axis_tdata:    std_logic_vector(23 downto 0) := (others => '0');
    signal s_axis_tvalid:   std_logic := '0';
    signal s_axis_tlast:    std_logic := '0';
    signal s_axis_tuser:    std_logic := '0';
    signal m_axis_tready:   std_logic := '0';
    signal m_axis_tdata:    std_logic_vector(23 downto 0);
    signal m_axis_tvalid:   std_logic;
    signal m_axis_tlast:    std_logic;
    signal m_axis_tuser:    std_logic;

begin
    -- DUT instance
    dut_hsv2rgb: entity work.hsv2rgb
        port map (
            s_axis_aclk    => s_axis_aclk,
            s_axis_aresetn => s_axis_aresetn,
            s_axis_tdata   => s_axis_tdata,
            s_axis_tvalid  => s_axis_tvalid,
            s_axis_tready  => m_axis_tready,
            s_axis_tlast   => s_axis_tlast,
            s_axis_tuser   => s_axis_tuser,
            m_axis_tdata   => m_axis_tdata,
            m_axis_tvalid  => m_axis_tvalid,
            m_axis_tready  => m_axis_tready,
            m_axis_tlast   => m_axis_tlast,
            m_axis_tuser   => m_axis_tuser
        );

    -- Clock process
    process
    begin
        while true loop
            s_axis_aclk <= '0';
            wait for CLOCK_PERIOD / 2;
            s_axis_aclk <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin
        -- Reset
        s_axis_aresetn <= '0';
        wait for 10 ns;
        s_axis_aresetn <= '1';
        wait for 10 ns;

        -- Example input data
        s_axis_tdata <= X"FFFFFF";  -- Hue = 0xFF (red), Saturation = 0x00, Value = 0x7F
        s_axis_tvalid <= '1';
        wait until s_axis_tvalid = '0';
        wait for 100 ns;

        s_axis_tdata <= X"00FF7F";  -- Hue = 0x00 (green), Saturation = 0xFF, Value = 0x7F
        s_axis_tvalid <= '1';
        wait until s_axis_tvalid = '0';
        wait for 100 ns;

        -- Add more test cases as needed

        -- End of simulation
        wait;
    end process;

end Behavioral;
