library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_fifo_top is
end tb_fifo_top;

architecture Behavioral of tb_fifo_top is
    signal clk, rst_n, wr, rd: std_logic := '0';
    signal data_in, data_out: std_logic_vector(7 downto 0);
    signal fifo_empty, fifo_full, fifo_threshold, fifo_overflow, fifo_underflow: std_logic;

    constant DELAY: time := 15 ns;
    constant ENDTIME: time := 40000 ns;

    component fifo_top
        port(
            data_out : out std_logic_vector(7 downto 0);
            fifo_full, fifo_empty, fifo_threshold, fifo_overflow, fifo_underflow: out std_logic;
            clk : in std_logic;
            rst_n: in std_logic;
            wr : in std_logic;
            rd: in std_logic;
            data_in: in std_logic_vector(7 downto 0)
        );
    end component;

    begin
        uut: fifo_top port map (
            data_out => data_out,
            fifo_full => fifo_full,
            fifo_empty => fifo_empty,
            fifo_threshold => fifo_threshold,
            fifo_overflow => fifo_overflow,
            fifo_underflow => fifo_underflow,
            clk => clk,
            rst_n => rst_n,
            wr => wr,
            rd => rd,
            data_in => data_in
        );
        
    -- Clock process
    process
    begin
      clk <= '0';
      wait for DELAY / 2;
      clk <= '1';
      wait for DELAY / 2;
      clk <= not clk;
      wait for DELAY;
    end process;

 -- begin
    -- Stimulus process
    process
    begin
      -- Initialize inputs
      rst_n <= '0';
      wr <= '0';
      rd <= '0';
      data_in <= (others => '0');

      -- Apply reset
      wait for DELAY * 2;
      rst_n <= '1';

      -- Write data to FIFO
      wait for DELAY * 5;
      wr <= '1';
      data_in <= "10101010";
      wait for DELAY * 2;
      wr <= '0';

      -- Read data from FIFO
      wait for DELAY;
      rd <= '1';
      wait for DELAY;
      rd <= '0';

      -- Additional test scenarios can be added here

      -- Finish simulation
      wait for ENDTIME;
      report "Simulation finished" severity note;
      wait;
    end process;

end Behavioral;