library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_uart is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           led: out std_logic_vector(3 downto 0);
           led_r : out STD_LOGIC;
           led_g : out STD_LOGIC;
           led_b : out STD_LOGIC;
           tx : out STD_LOGIC;
           rx : in STD_LOGIC);
end top_uart;

architecture Behavioral of top_uart is

    component uart is
        generic(
            DBIT    : integer := 8;   -- # data bits
            SB_TICK : integer := 16;  -- # ticks for stop bits, 16 per bit
            FIFO_W  : integer := 0    -- # FIFO addr bits (depth: 2^FIFO_W)
        );
        port(
            clk, reset : in  std_logic;
            rd_uart    : in  std_logic;
            wr_uart    : in  std_logic;
            dvsr       : in  std_logic_vector(10 downto 0);
            rx         : in  std_logic;
            w_data     : in  std_logic_vector(7 downto 0);
            tx_full    : out std_logic;
            rx_empty   : out std_logic;
            r_data     : out std_logic_vector(7 downto 0);
            tx         : out std_logic
        );
        end component;
        
     constant dvsr: std_logic_vector(10 downto 0) := std_logic_vector(to_unsigned(68, 11));  -- dvsr = SYS_CLK_FREQ *1000000 / 16 / baud - 1; roundup(125 * 1_000_000)/16/(115200-1);

    signal wr_en    : std_logic;
    signal wr_uart  : std_logic;
    signal rd_uart  : std_logic;
    signal wr_dvsr  : std_logic;
    signal tx_full  : std_logic;
    signal rx_empty : std_logic;
    signal r_data   : std_logic_vector(7 downto 0);
    signal w_data   : std_logic_vector(7 downto 0);
    signal dvsr_reg : std_logic_vector(10 downto 0);
    
begin

    uart_i: uart port map (
        clk => clk,
        reset => rst,
        rd_uart    => rd_uart,
        wr_uart    => wr_uart,
        dvsr       => dvsr,
        rx         => rx,
        w_data     => w_data,
        tx_full    => tx_full,
        rx_empty   => rx_empty,
        r_data     => r_data,
        tx         => tx
    );
    
    led <= r_data(3 downto 0);
    process(r_data)
    begin
    if (r_data = "01101111") then --when O is received

        led_r <= '1';
    else
        led_r <= '0';
    end if;
    end process;
    wr_uart <= '1';
    rd_uart <= '1';
    -- w_data
    
end Behavioral;