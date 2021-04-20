-- #####################################################
-- #
-- #  Partition-based Partial Reconfiguration Reference Design
-- #
-- #  Parimal Patel, Xilinx University Program, San Jose
-- #  August 10, 2010
-- #
-- #####################################################


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- design for XUP board talking to a UART and the SVGA display
entity top is
    Port ( clk   	    : in std_logic;		-- 100MHz system clock
           reset        : in std_logic;
           rx		    : in std_logic;		-- serial data from UART
           tx   		: out std_logic;		-- serial data to UART
           button_start  : in std_logic;    -- BTNL
           button_stop : in std_logic;      -- BTNR
           led_reset    : in std_logic;     -- BTNC
           led          : out std_logic_vector(3 downto 0)
        );	
end top;

architecture Behavioral of top is
-- This is a static module of control logic.  It parses keyboard input and
-- sends it out to the rx/tx.  There will be a single instance of it
component control is
    Port (               clk : in std_logic;
                  data_to_op : out std_logic_vector(3 downto 0);
           instruction_to_op : out std_logic_vector(1 downto 0);
                data_from_op : in signed(7 downto 0);
                       op_id : in std_logic;
                    write_tx : out std_logic;
                      din_tx : out std_logic_vector(7 downto 0);
             data_present_rx : in std_logic;
                     read_rx : out std_logic;
                     dout_rx : in std_logic_vector(7 downto 0)
          );
end component;

-- A reconfigurable module area.  The control module speaks to it on data_in and gets 
--     answers back on data_out.  Id is  used to signal  the control module which flavor
--	    of the reconfig module is loaded and running
component rModule_addsub  is
    Port (            clk : in std_logic;
                  data_in : in std_logic_vector(3 downto 0);
           instruction_in : in std_logic_vector(1 downto 0);
                 data_out : out signed(7 downto 0);
                       id : out std_logic
                    );
end component;

component meta_harden  is
    Port (        clk_dst : in std_logic;
                  rst_dst : in std_logic;
               signal_src : in std_logic;
               signal_dst : out std_logic
         );
end component;

component uart_tx is
  port ( char_fifo_dout : in STD_LOGIC_VECTOR (7 downto 0);
         rst_clk_tx : in  STD_LOGIC;
         char_fifo_empty : in STD_LOGIC;
         clk_tx : in  STD_LOGIC;
         txd_tx : out STD_LOGIC;
         char_fifo_rd_en : out STD_LOGIC
     );
end component;

component uart_rx is
  port (      rxd_i : in  STD_LOGIC;
              rst_clk_rx : in  STD_LOGIC;
              clk_rx : in  STD_LOGIC;
              rxd_clk_rx : out STD_LOGIC;
              rx_data : out STD_LOGIC_VECTOR (7 downto 0);
              rx_data_rdy : out STD_LOGIC;
              frm_err : out STD_LOGIC
           );
end component;

component char_fifo is
  port  (
   rst : in  STD_LOGIC;       
   wr_clk : in  STD_LOGIC;  
   rd_clk : in  STD_LOGIC;  
   din : in STD_LOGIC_VECTOR (7 downto 0);        
   wr_en : in  STD_LOGIC;    
   rd_en : in  STD_LOGIC;    
   dout : out STD_LOGIC_VECTOR (7 downto 0);     
   full : out STD_LOGIC;      
   empty : out STD_LOGIC    
);
end component;

-- reconfigurable module.  Controls LEDs
component rModule_leds is
   Port	(
      clk : in std_logic;
      reset : in std_logic;
      en : in std_logic;
      led : out std_logic_vector(3 downto 0)
   );
end component;


component led_control is
   Port	(
      clk : in std_logic;
      reset : in std_logic;
      button_start : in std_logic;
      button_stop : in std_logic;
      rst : out std_logic;
      en : out std_logic
   );
end component;

-- signals used in context logic
signal                  clk_int : std_logic;
signal               data_to_op : std_logic_vector(3 downto 0);
signal             data_from_op : signed(7 downto 0);
signal          data_to_control : signed(7 downto 0);
signal        data_from_control : std_logic_vector(3 downto 0);
signal instruction_from_control : std_logic_vector(1 downto 0);
signal        instruction_to_op : std_logic_vector(1 downto 0);
signal                    op_id : std_logic;
signal                       id : std_logic;

-- data to (from) the send (receive) UART
signal          din_tx, dout_rx : std_logic_vector(7 downto 0);

-- baud rate clock for transmit and receive UARTs
signal                 baud_clk : std_logic;

-- data avail from receive UART and the  last 2 values
signal          data_present_rx : std_logic;
-- signal          rx_data_ready_rxclk : std_logic;

-- tell UART to write or read
signal                 write_tx : std_logic;
signal                  read_rx : std_logic;

signal synced_rst : std_logic;  -- reset input synchronized to clk
signal rd_en : std_logic;
signal tx_buffer_empty : std_logic;
signal tx_data : std_logic_vector(7 downto 0);

signal rst : std_logic;
signal en : std_logic;

begin
-- fixed control module.  This is the logic to receive data from off chip, process it
--	possibly using current flavor of  rModule in place and send data off chip
control_inst : control
	port map (               clk => clk,
                      data_to_op => data_to_op,
               instruction_to_op => instruction_to_op,
                    data_from_op => data_from_op,
                           op_id => op_id,
                        write_tx => write_tx,
                          din_tx => din_tx,
                 data_present_rx => data_present_rx, -- rx_data_ready_rxclk, -- data_present_rx,
                         read_rx => read_rx,
                         dout_rx => dout_rx
              );


-- reconfigurable module.  This can be loaded dynamically with any flavor as long
--	as it speaks to this interface
reconfig_addsub : rModule_addsub  
    port map (        clk => clk,
                  data_in => data_to_op,
           instruction_in => instruction_to_op,
                 data_out => data_from_op,
                       id => op_id
              );
				 
-- UART used to transmit data to off chip.  
--     uart_tx_inst : transmit data out UART port
--     uart_rx_inst : receive data from UART port
uart_tx_inst : uart_tx 
  port map (  char_fifo_dout => tx_data, --dout_rx, -- din_tx,
              rst_clk_tx => synced_rst,
              char_fifo_empty => tx_buffer_empty, -- data_present_rx, --  write_tx,
              clk_tx => clk,
              txd_tx => tx,
              char_fifo_rd_en => rd_en
           );

char_fifo_i : char_fifo 
  port map (
              rst => synced_rst,       
              wr_clk => clk,  
              rd_clk => clk,  
              din => din_tx,        
              wr_en=> write_tx,    
              rd_en => rd_en,    
              dout => tx_data,     
              full => open,      
              empty => tx_buffer_empty    
            );

uart_rx_inst : uart_rx 
  port map (   rxd_i => rx,
               rst_clk_rx => synced_rst,
               rxd_clk_rx => open,
               clk_rx => clk,
               rx_data => dout_rx,
               rx_data_rdy => data_present_rx,
               frm_err => open
           );

meta_harden_rst_i0 :  meta_harden 
  port map (
               clk_dst => clk,
               rst_dst => '0', -- No reset on the hardener for reset!
               signal_src => reset,
               signal_dst => synced_rst
            );

led_control_inst : led_control
   Port	map (
     clk => clk, 
     reset => led_reset,
     button_start => button_start,
     button_stop => button_stop,
     rst => rst,
     en => en
);

reconfig_leds : rModule_leds
   Port	map (
     clk => clk, 
     reset => rst,
     en => en,
     led => led
);

end Behavioral;
