library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ALU is

port( op1   : in std_logic_vector(7 downto 0);
		op2   : in std_logic_vector(7 downto 0);
		func  : in std_logic_vector(3 downto 0);
		res   : out std_logic_vector(7 downto 0));
end ALU;


architecture Behavioral of ALU is
	signal mult_unsigned,mult_signed : std_logic_vector(15 downto 0);
	
begin
	mult_unsigned <= std_logic_vector(unsigned(op1) * unsigned(op2));
	mult_signed   <= std_logic_vector(signed(op1) * signed(op2));
	
	process(func, op1, op2)
	begin
		case func is
			when "0000" =>
				res <= std_logic_vector(unsigned(op1) + unsigned(op2));
			when "0001" =>
				res <= std_logic_vector(unsigned(op1) - unsigned(op2));
			when "0010" =>
				res <= op1 and op2;
			when "0011" =>
				res <= op1 or op2;
			when "0100" =>
				res <= op1 xor op2;
			when "0101" =>
				res <= op1 nor op2;
			when "0110" =>
				res <= mult_unsigned(7 downto 0);
			when "0111" =>
				res <= mult_signed(7 downto 0);
			when "1000" =>
				res <= std_logic_vector(shift_left(unsigned(op1),to_integer(unsigned(op2))));
			when "1001" =>
				res <= std_logic_vector(shift_right(unsigned(op1),to_integer(unsigned(op2))));
			when "1010" =>
				res <= std_logic_vector(shift_right(signed(op1),to_integer(unsigned(op2))));
			when "1011" =>
				if(op1 = op2) then
					res <=  X"01";
				else 
					res <= X"00";
				end if;
			when "1100" =>
				if(signed(op1) < signed(op2)) then
					res <=  X"01";
				else 
					res <= X"00";
				end if;
			when "1101" =>
				if(unsigned(op1) < unsigned(op2)) then
					res <=  X"01";
				else 
					res <= X"00";
				end if;
			when "1110" =>
				if(signed(op1) > signed(op2)) then
					res <=  X"01";
				else 
					res <= X"00";
				end if;
			when others	=>
				if(unsigned(op1) > unsigned(op2)) then
					res <=  X"01";
				else 
					res <= X"00";
				end if;
		end case;
	end process;
	
end Behavioral;