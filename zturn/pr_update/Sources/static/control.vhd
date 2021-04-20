-- #####################################################
-- #
-- #  Partition-based Partial Reconfiguration Reference Design
-- #
-- #  Parimal Patel, Xilinx University Program, San Jose
-- #  August 10, 2010
-- #
-- #  Targeted for XUPV5 Development Board
-- #
-- #####################################################

-- 
--	There is receive UART connected to a keyboard and a transmit
-- UART connected to a display.  Simple command structure as follows:
--		Typed    | Action
--    'a',#,\n | save 4 bit # in a
--    'b',#,\n | save 4 bit # in b
--		'?',\n   | send '-' ('+') to display if subtractor (addr) loaded
--    '=',\n   | tell rModule to execute

-- commands to the rModule (which can either be an addr or subtractor)
--	 data_to_op | 4 bits of data, instruction tells which
--  instruction_to_op | 2 bit  opcode which is :
--                  0 |
--                  1 | data_to_op contains first operand
--                  2 | data_to_op contains second operand


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

-- This is the static module of control logic.  It parses keyboard input and
-- sends it out to the rx/tx.  A single instance of it	is instanciated below
entity control is
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
end control;

architecture Behavioral of control is

-- the following function calculates the first decimal power of the result
-- example: calc_ones(15) = 5
-- Only works for 2 digit numbers <= 19
function calc_ones (signal data_in : signed(7 downto 0)) return std_logic_vector is
variable tmp1, tmp2 : integer;
variable ones : std_logic_vector(3 downto 0);
begin
   tmp1 := CONV_INTEGER(data_in); 
   if abs(tmp1) > 9 then
                tmp2 := abs(tmp1) - 10;
        else
                tmp2 := abs(tmp1);
        end if;
        ones := CONV_STD_LOGIC_VECTOR(tmp2, 4);
        return ones;
end;

-- the following function calculates the second decimal power of the result
-- example: calc_tens(15) = 1
-- Only works for 2 digit numbers <= 19
function calc_tens (signal data_in : signed(7 downto 0)) return std_logic_vector is
variable tmp1, tmp2 : integer;
variable tens : std_logic_vector(3 downto 0);
begin
   tmp1 := CONV_INTEGER(data_in);
   if abs(tmp1) > 9 then
                tmp2 := 1;
        else
                tmp2 := 0;
        end if;
        tens := CONV_STD_LOGIC_VECTOR(tmp2, 4);
        return tens;
end;

-- the following function calculates the sign of the result
-- example: calc_sign(-5) = 1
function calc_sign (signal data_in : signed(7 downto 0)) return std_logic is
variable tmp : integer;
variable sign : std_logic;
begin
   tmp := CONV_INTEGER(data_in);
   if tmp < 0 then
                sign := '1';
        else
                sign := '0';
        end if;
        return sign;
end;


-- data avail from receive UART and the  last 2 values
signal data_present_1, data_present_last : std_logic;

-- last 3 bytes read, used in state machine, 0 is most recent
signal byte_2, byte_1, byte_0 : std_logic_vector(7 downto 0);

-- 4 bit numbers from keyboard
signal a, b : std_logic_vector(3 downto 0);

-- state machine used to control device
type control is (state_0, state_1, state_2, state_3, state_4, state_5, state_6, 
                                                state_7, state_8, state_9, state_10, state_11, state_12, 
                                                state_13, state_14, state_15, state_16, state_17, state_18, 
                                                state_19, state_20, state_21);
signal control_state : control := state_0;

begin

-- This FSM tracks keyboard entries in the terminal, communicates with the reconfigurable 
-- module and send messages to the terminal.

control_process : process(clk)
begin
    --	Wait for a rising clock edge
    if clk'event and clk = '1' then

    -- Save last receive signal as  _1, one before that as _last
    data_present_last <= data_present_1;	
    data_present_1 <= data_present_rx;

    -- state machine
    case control_state is
        -- get a byte from uart
        when state_0 =>     -- wait for keyboard entry
            -- No date to write to display
            write_tx <= '0';

            -- see if data_present has risen from 0 to 1
            -- rising edge of data_present signal
            -- new data in output buffer of UART_RX block
            if data_present_1 = '1' and data_present_last = '0' then
                -- Something is available, assert signal to read from uart and
                -- write to uart, then save previous chars in FIFO, get char
                -- and put it into UART write buf
                read_rx <= '1';     -- read from UART_RX
                write_tx <= '1';    -- write to UART_TX (echo the typed chr)
                byte_2 <= byte_1;   -- store the last two characters
                byte_1 <= byte_0;
                byte_0 <= dout_rx;  -- store the actual character
                din_tx <= dout_rx;  -- echo the actual character

                -- move to state to analyze what we got
                control_state <= state_1;

            end if;

        -- analyzes the past 3 bytes read to determine what to do
        when state_1 =>         -- analyze the actual string
            -- nothing to read from or write to UART
            write_tx <= '0';
            read_rx <= '0';

            -- analyze character
            if byte_0 = x"0d" then  -- ascii: carriage return
                if byte_1 = x"61" then      -- 'a''\n' - echo what is in a
                    write_tx <= '1';
                    din_tx <= x"0a";	-- ascii: new line
                    control_state <= state_20;
                elsif byte_1 = x"62" then   -- 'b''\n' - echo what is in b
                    write_tx <= '1';
                    din_tx <= x"0a";	-- ascii: new line
                    control_state <= state_21;
                elsif byte_2 = x"61" then   -- ascii: a ; store first operand from byte_1
                    a <= byte_1(3 downto 0);
                    control_state <= state_18;
                elsif byte_2 = x"62" then   -- ascii: b ; store second operand from byte_1
                    b <= byte_1(3 downto 0);
                    control_state <= state_18;
                elsif byte_1 = x"3f" then   -- ascii: ? ; report type of reconfigurable module
                    -- send \r\n'rType'\r\n
                    control_state <= state_2;
                elsif byte_1 = x"3d" then   -- ascii: = ; execute operation and send result to UART_TX
                    -- have rModule start executing
                    control_state <= state_5;
                else
                       -- unknown input - send and error and try again
                       control_state <= state_12;
                end if;
            else
                -- not a \n so do not change states
              	control_state <= state_0;
            end if;

        -- state_2-5,18,19 sends - or + to display according to which
        -- rModule is loaded, send \m\n[-+]\m\n
        when state_2 =>	-- send new line character to UART_TX
            write_tx <= '1';
            din_tx <= x"0a";	-- ascii: new line
            control_state <= state_3;

        when state_3 =>	-- send carriage return character to UART_TX
            write_tx <= '1';
            din_tx <= x"0d";	-- ascii: carriage return
            control_state <= state_4;

        when state_4 =>	-- report type of reconfigurable module
            --	send '-' ('+') to display if subtractor (addr) loaded
            write_tx <= '1';
            if op_id = '0' then
                din_tx <= x"2b";    -- ascii: + ; adder is loaded
            else
                din_tx <= x"2d";    -- ascii: -	; subtractor is loaded
            end if;
            control_state <= state_18;

         -- state_5,6 send commands to the rModule
         when state_5 =>	-- send first operand to reconfigurable module
                 -- nothing goes to UART, put op a into data, set instruction
                 -- to 01 to say data_to_op has first operand
                 write_tx <= '0';
                 data_to_op <= a;
                 instruction_to_op <= "01";
                 control_state <= state_6;

         when state_6 =>	-- send second operand to reconfigurable module
            -- nothing goes to UART, put op b into data, set instruction
            -- to 10 to say data_to_op has second operand
            write_tx <= '0';
            data_to_op <= b;
            instruction_to_op <= "10";
            control_state <= state_7;

         -- write a newline, carriage return to UART
         when state_7 =>		-- send new line character to UART_TX
            -- put the new line into din_tx AND tell  rModule to execute
            write_tx <= '1';
            instruction_to_op <= "00";
            din_tx <= x"0a";	-- ascii: new line
            control_state <= state_8;
         when state_8 =>		-- send carriage return character to UART_TX
            write_tx <= '1';
            din_tx <= x"0d";	-- ascii: carriage return
            control_state <= state_9;


         -- state_9-11 write the result (possible 3 characters)
         -- from the rModule to the UART_TX
         when state_9 =>	-- send sign of the result to UART_TX
                 -- get result from rModule, if it is negative then 
                 -- put a '-' character to UART, otherwise nothing to UART
                 if calc_sign(data_from_op) = '1' then
                    write_tx <= '1';
                    din_tx <= x"2d";	-- ascii: -
                 else
               write_tx <= '0';
                 end if;
                 control_state <= state_10;

         when state_10 =>	-- send first cipher of result to UART_TX
                 -- calc_tens will leave the value of tens digit in din_tx
                 if	calc_tens(data_from_op) /= "0000" then
                    write_tx <= '1';
                    din_tx <= x"3" & calc_tens(data_from_op);
                 else
                    -- no 10s digit, nothing to uart
                    write_tx <= '0';
                 end if;
                 control_state <= state_11;

         when state_11 =>	-- send second cipher of result to UART_TX		
            write_tx <= '1';
            din_tx <= x"3"&calc_ones(data_from_op);		
            control_state <= state_18;

         -- state 12-19, send \nerror\d\n to display and read again
         when state_12 =>	-- send string "error" to UART_TX, staring with new \m\r
            write_tx <= '1';
            din_tx <= x"0a";	-- ascii: new line
            control_state <= state_13;	
         when state_13 =>	-- send character "e" to UART_TX
            write_tx <= '1';
            din_tx <= x"65";	-- ascii: e
            control_state <= state_14;
         when state_14 =>	-- send character "r" to UART_TX
            write_tx <= '1';
            din_tx <= x"72";	-- ascii: r
            control_state <= state_15;
         when state_15 =>	-- send character "r" to UART_TX
            write_tx <= '1';
            din_tx <= x"72";	-- ascii: r
            control_state <= state_16;
         when state_16 =>	-- send character "o" to UART_TX
            write_tx <= '1';
            din_tx <= x"6f";	-- ascii: o
            control_state <= state_17;
         when state_17 =>	-- send character "r" to UART_TX
            write_tx <= '1';
            din_tx <= x"72";	-- ascii: r
            control_state <= state_18;

         -- send carriage return, newline to UART and start reading chars again
         when state_18 =>	-- send new line character to UART_TX
            write_tx <= '1';
            din_tx <= x"0a";	-- ascii: new line
            control_state <= state_19;

         when state_19 =>	-- send carriage return character to UART_TX
            write_tx <= '1';
            din_tx <= x"0d";	-- ascii: carriage return
            control_state <= state_0;
         when state_20 =>	-- send value of a to UART_TX
            write_tx <= '1';
            din_tx <= std_logic_vector(a) + x"30";            -- a register
            control_state <= state_18;
         when state_21 =>	-- send value of b to UART_TX
            write_tx <= '1';
            din_tx <= std_logic_vector(b) + x"30";            -- b register
            control_state <= state_18;
         end case;
        end if;			
end process;

end Behavioral;
