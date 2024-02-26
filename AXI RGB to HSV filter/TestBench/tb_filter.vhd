library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filter_tb is
end filter_tb;

architecture Behavioral of filter_tb is
    component filter is
        Port (
            s_axis_aclk     : in  STD_LOGIC;        -- Clock
            s_axis_aresetn  : in  STD_LOGIC;        -- Reset (active low)
            s_axis_tdata    : in  STD_LOGIC_VECTOR(23 downto 0);  -- 24-bit input data
            s_axis_tvalid   : in  STD_LOGIC;        -- Data valid signal
            s_axis_tready   : out STD_LOGIC;       -- Data ready signal
            s_axis_tlast    : in  STD_LOGIC;        -- Last data in frame
            s_axis_tuser    : in  STD_LOGIC;        -- User signal (if used)
            m_axis_tdata    : out STD_LOGIC_VECTOR(23 downto 0);  -- 24-bit output data
            m_axis_tvalid   : out STD_LOGIC;        -- Data valid signal
            m_axis_tready   : in  STD_LOGIC;        -- Data ready signal
            m_axis_tlast    : out STD_LOGIC;       -- Last data in frame
            m_axis_tuser    : out STD_LOGIC         -- User signal (if used)
        );
    end component;

    -- Inputs
    signal s_axis_aclk     : STD_LOGIC := '0';
    signal s_axis_aresetn  : STD_LOGIC := '1';
    signal s_axis_tdata    : STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
    signal s_axis_tvalid   : STD_LOGIC := '0';
    signal s_axis_tlast    : STD_LOGIC := '0';
    signal s_axis_tuser    : STD_LOGIC := '0';
    signal m_axis_tready   : STD_LOGIC := '0';
    -- Outputs
    signal m_axis_tdata    : STD_LOGIC_VECTOR(23 downto 0);
    signal m_axis_tvalid   : STD_LOGIC;
    signal s_axis_tready   : STD_LOGIC;
    signal m_axis_tlast    : STD_LOGIC;
    signal m_axis_tuser    : STD_LOGIC;

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the filter
    uut: filter port map (
        s_axis_aclk     => s_axis_aclk,
        s_axis_aresetn  => s_axis_aresetn,
        s_axis_tdata    => s_axis_tdata,
        s_axis_tvalid   => s_axis_tvalid,
        s_axis_tready   => s_axis_tready,
        s_axis_tlast    => s_axis_tlast,
        s_axis_tuser    => s_axis_tuser,
        m_axis_tdata    => m_axis_tdata,
        m_axis_tvalid   => m_axis_tvalid,
        m_axis_tready   => m_axis_tready,
        m_axis_tlast    => m_axis_tlast,
        m_axis_tuser    => m_axis_tuser
    );

    -- Clock process
    process
    begin
        while now < 10000 ms loop
            s_axis_aclk <= not s_axis_aclk;
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    process
    begin
        -- Apply your input stimulus here
        s_axis_tuser <= '1';
        s_axis_tdata <= "111111110000000000000000";
       s_axis_tvalid <= '1';
       wait for 50 ms;
       s_axis_tlast <='1';
        -- Add more stimulus as needed
        s_axis_tuser <= '1';
        s_axis_tdata <= "111111111111111100000000";
       s_axis_tvalid <= '1';
            wait for 50 ms;
       s_axis_tlast <='1';
        s_axis_tuser <= '1';
       s_axis_tdata <= "000000001111111100000000";
       s_axis_tvalid <= '1';
       wait for 50 ms;
       s_axis_tlast <='1';
       s_axis_tuser <= '0';
       s_axis_tvalid <= '0';
        -- Stop the simulation after a certain time
        wait for 50 ms;
        --report "Simulation finished" severity note;
        wait;
    end process;

end Behavioral;
