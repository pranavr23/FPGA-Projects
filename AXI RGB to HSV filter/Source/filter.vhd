library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filter is
    Port (
        s_axis_aclk     : in  STD_LOGIC;            -- Clock
        s_axis_aresetn  : in  STD_LOGIC;            -- Reset (active low)
        s_axis_tdata    : in  STD_LOGIC_VECTOR(23 downto 0);  -- 24-bit input data
        s_axis_tvalid   : in  STD_LOGIC;            -- Data valid signal
        s_axis_tready   : out STD_LOGIC;           -- Data ready signal
        s_axis_tlast    : in  STD_LOGIC;            -- Last data in frame
        s_axis_tuser    : in  STD_LOGIC;            -- Start of frame indicator
        m_axis_tdata    : out STD_LOGIC_VECTOR(23 downto 0);  -- 24-bit output data
        m_axis_tvalid   : out STD_LOGIC;            -- Data valid signal
        m_axis_tready   : in  STD_LOGIC;            -- Data ready signal
        m_axis_tlast    : out STD_LOGIC;           -- End of frame indicator
        m_axis_tuser    : out STD_LOGIC             -- User signal (if used)
    );
end filter;

architecture Behavioral of filter is
    signal Rint, Gint, Bint : STD_LOGIC_VECTOR(7 downto 0);
    signal Cmax, Cmin, delta: STD_LOGIC_VECTOR(7 downto 0);
    signal H, S         : STD_LOGIC_VECTOR(7 downto 0);
    signal data_valid      : STD_LOGIC := '0';
    signal H1, S1, Cmax1 : STD_LOGIC_VECTOR(7 downto 0);
    signal H2, S2, Cmax2 : STD_LOGIC_VECTOR(7 downto 0);
    signal H1_reg, S1_reg, Cmax1_reg : STD_LOGIC_VECTOR(7 downto 0);
    signal hsv_out : std_logic_vector(23 downto 0);
    signal stream_counter : std_logic;
    constant LowerLimit : std_logic_vector(23 downto 0) := "001100100110010011111111"; -- (50, 100, 255)
    constant UpperLimit : std_logic_vector(23 downto 0) := "010001100110010011111111"; -- (70, 100, 255)
    type state is (IDLE, FRAME_START, ACQUIRE, STREAM);
    signal current_state : state;

begin
    Rint <= s_axis_tdata(23 downto 16);
    Gint <= s_axis_tdata(15 downto 8);
    Bint <= s_axis_tdata(7 downto 0);

    process (Rint, Gint, Bint, Cmax, Cmin, delta, hsv_out, H, S)
    begin
        -- Calculate Cmax: Cmax = Max(R, G, B)
        if ((Rint >= Gint) and (Rint >= Bint)) then
            Cmax <= Rint;
        elsif ((Gint >= Rint) and (Gint >= Bint)) then
            Cmax <= Gint;
        elsif ((Bint >= Rint) and (Bint >= Gint)) then
            Cmax <= Bint;
        end if;

        -- Calculate Cmin: Cmin = Min(R, G, B)
        if ((Rint <= Gint) and (Rint <= Bint)) then
            Cmin <= Rint;
        elsif ((Gint <= Rint) and (Gint <= Bint)) then
            Cmin <= Gint;
        elsif ((Bint <= Rint) and (Bint <= Gint)) then
            Cmin <= Bint;
        end if;

        -- Calculate delta
        delta <= std_logic_vector(unsigned(Cmax) - unsigned(Cmin));

        -- Calculate Saturation (S)
        if (Cmax = "0") then
            S <= "0";
        elsif (delta = "00000000") then
            S <= "00000000";
        else
            S <= std_logic_vector((unsigned(delta) / unsigned(cmax)) + 99);
        end if;

        -- Calculate Hue (H)
        if (delta = "00000000") then
            H <= "00000000";
        elsif (delta /= "0") then
            if (Cmax = Rint) then
                H <= std_logic_vector(resize((unsigned(60 * (((unsigned(Gint) - unsigned(Bint)) / unsigned(delta)) mod 6))), H'length));
            elsif (Cmax = Gint) then
                H <= std_logic_vector(resize((unsigned(60 * (((unsigned(Bint) - unsigned(Rint)) / unsigned(delta)) + 2))), H'length));
            elsif (Cmax = Bint) then
                H <= std_logic_vector(resize((unsigned(60 * (((unsigned(Rint) - unsigned(Gint)) / unsigned(delta)) + 4))), H'length));
            end if;
        end if;

        if (H >= LowerLimit(23 downto 16) and H <= UpperLimit(23 downto 16) and
            S >= LowerLimit(15 downto 8) and S <= UpperLimit(15 downto 8) and
            Cmax >= LowerLimit(7 downto 0) and Cmax <= UpperLimit(7 downto 0)) then
            -- Values are within the specified range, output is white
            hsv_out <= "111111111111111111111111";
        else
            -- Values are outside the specified range, output 0
            hsv_out <= (others => '0');
        end if;
    end process;

    process (s_axis_aclk)
    begin
        if (rising_edge(s_axis_aclk)) then
            if (s_axis_aresetn = '0') then
                current_state <= IDLE;
                stream_counter <= '0';
            else
                case current_state is
                    when IDLE =>
                        stream_counter <= '0';
                        m_axis_tvalid <= '0';
                        s_axis_tready <= '0';

                        if (s_axis_tvalid = '1' and s_axis_tuser = '1') then
                            s_axis_tready <= '1';
                            current_state <= ACQUIRE;
                            m_axis_tvalid <= '0';
                            H1 <= hsv_out(23 downto 16);
                            S1 <= hsv_out(15 downto 8);
                            Cmax1 <= hsv_out(7 downto 0);
                        end if;

                    when ACQUIRE =>
                        H1 <= H1_reg;
                        S1 <= S1_reg;
                        Cmax1 <= Cmax1_reg;
                        -- s_axis_tlast <= '0'; -- Set tuser if needed for user-defined purposes

                        if (s_axis_tvalid = '1') then
                            H2 <= hsv_out(23 downto 16);
                            S2 <= hsv_out(15 downto 8);
                            Cmax2 <= hsv_out(7 downto 0);
                            m_axis_tvalid <= '1';
                            current_state <= STREAM;
                            stream_counter <= '0';
                        end if;

                    when STREAM =>
                        m_axis_tdata <= (H2 & S2 & Cmax2);

                        -- Check s_axis_tlast to detect the end of a frame or burst
                        if s_axis_tlast = '1' then
                            -- Actions when a frame or burst is completed
                            -- For example, reset internal state
                            H1_reg <= (others => '0');
                            S1_reg <= (others => '0');
                            Cmax1_reg <= (others => '0');
                            -- Additional actions if needed

                            -- Reset tlast for the output
                            m_axis_tlast <= '1';
                            current_state <= FRAME_START; -- Transition to start of next frame
                        else
                            -- Set tlast when you are about to output the last data word
                            if stream_counter = '1' then
                                m_axis_tlast <= '1';
                            else
                                m_axis_tlast <= '0';
                            end if;
                        end if;

                        m_axis_tuser <= '0';

                        if (m_axis_tready = '1') then
                            current_state <= IDLE;
                            m_axis_tvalid <= '0';
                            s_axis_tready <= '1';
                            H1_reg <= hsv_out(23 downto 16);
                            S1_reg <= hsv_out(15 downto 8);
                            Cmax1_reg <= hsv_out(7 downto 0);
                        end if;

                    when others =>
                        current_state <= IDLE;
                end case;
            end if;
        end if;
    end process;
end Behavioral;
