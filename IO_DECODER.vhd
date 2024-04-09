-- IO DECODER for SCOMP
-- This eliminates the need for a lot of AND decoders or Comparators 
--    that would otherwise be spread around the top-level BDF

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY IO_DECODER IS

  PORT
  (
    IO_ADDR         : IN STD_LOGIC_VECTOR(10 downto 0);
    IO_CYCLE        : IN STD_LOGIC;
    SWITCH_EN       : OUT STD_LOGIC;
    LED_EN          : OUT STD_LOGIC;
    TIMER_EN        : OUT STD_LOGIC;
    HEX0_EN         : OUT STD_LOGIC;
    HEX1_EN         : OUT STD_LOGIC;
	HSPG_SEL	    : OUT STD_LOGIC_VECTOR(3 downto 0)
  );

END ENTITY;

ARCHITECTURE a OF IO_DECODER IS

  SIGNAL  ADDR_INT  : INTEGER RANGE 0 TO 2047;
  
begin

  ADDR_INT <= TO_INTEGER(UNSIGNED(IO_ADDR));
        
  SWITCH_EN     <= '1' WHEN (ADDR_INT = 16#000#) and (IO_CYCLE = '1') ELSE '0';
  LED_EN        <= '1' WHEN (ADDR_INT = 16#001#) and (IO_CYCLE = '1') ELSE '0';
  TIMER_EN      <= '1' WHEN (ADDR_INT = 16#002#) and (IO_CYCLE = '1') ELSE '0';
  HEX0_EN       <= '1' WHEN (ADDR_INT = 16#004#) and (IO_CYCLE = '1') ELSE '0';
  HEX1_EN       <= '1' WHEN (ADDR_INT = 16#005#) and (IO_CYCLE = '1') ELSE '0';

  -- mapping for HSPG selection bits
  if(IO_CYCLE = '1') then
    case ADDR_INT is 
        when 16#050# => HSPG_SEL <= "0001";
        when 16#051# => HSPG_SEL <= "0010";
        when 16#052# => HSPG_SEL <= "0011";
        when 16#053# => HSPG_SEL <= "0100";
        when 16#054# => HSPG_SEL <= "0101";
        when 16#055# => HSPG_SEL <= "0110";
        when 16#056# => HSPG_SEL <= "0111";
        when 16#057# => HSPG_SEL <= "1000";
        when 16#058# => HSPG_SEL <= "1001";
        when 16#059# => HSPG_SEL <= "1010";
        when 16#05A# => HSPG_SEL <= "1011";
        when 16#05B# => HSPG_SEL <= "1100";
        when 16#05C# => HSPG_SEL <= "1101";
        when 16#05D# => HSPG_SEL <= "1110";
        when 16#05E# => HSPG_SEL <= "1111";

        when others => HSPG_SEL <= "0000"
    end case;
  end if;
  
END a;
