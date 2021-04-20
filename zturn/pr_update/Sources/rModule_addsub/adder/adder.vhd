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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rModule_addsub is
    Port (            clk : in std_logic;
           instruction_in : in std_logic_vector(1 downto 0);
                  data_in : in std_logic_vector(3 downto 0);
                 data_out : out signed(7 downto 0);
                       id : out std_logic);
end rModule_addsub;

architecture Behavioral of rModule_addsub is


begin

id <= '0';  -- signalizes that this is the adder

adder_process : process(clk)
variable operand_1, operand_2, result : integer;
begin
	if clk'event and clk = '1' then
   	result := operand_1 + operand_2;		  
      data_out <= CONV_SIGNED(result, 8);

      if instruction_in(0) = '1' then      -- load first operand
      	operand_1 := CONV_INTEGER(data_in);
      elsif instruction_in(1) = '1' then	-- load second operand
			operand_2 := CONV_INTEGER(data_in);
      end if;
   end if;
end process;


end Behavioral;
