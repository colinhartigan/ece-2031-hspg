-- IO DECODER for SCOMP
-- This eliminates the need for a lot of AND decoders or Comparators 
--    that would otherwise be spread around the top-level BDF

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY IO_DECODER IS

  PORT
  (
    IO_ADDR         : IN  STD_LOGIC_VECTOR(10 downto 0);
    IO_CYCLE        : IN  STD_LOGIC;
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

    SWITCH_EN <= '1' WHEN (ADDR_INT = 16#000#) AND (IO_CYCLE = '1') ELSE '0';
    LED_EN    <= '1' WHEN (ADDR_INT = 16#001#) AND (IO_CYCLE = '1') ELSE '0';
    TIMER_EN  <= '1' WHEN (ADDR_INT = 16#002#) AND (IO_CYCLE = '1') ELSE '0';
    HEX0_EN   <= '1' WHEN (ADDR_INT = 16#004#) AND (IO_CYCLE = '1') ELSE '0';
    HEX1_EN   <= '1' WHEN (ADDR_INT = 16#005#) AND (IO_CYCLE = '1') ELSE '0';

    HSPG_SEL <= "0001" when (ADDR_INT = 16#050#) AND (IO_CYCLE = '1') else
                "0010" when (ADDR_INT = 16#051#) AND (IO_CYCLE = '1') else
                "0011" when (ADDR_INT = 16#052#) AND (IO_CYCLE = '1') else
                "0100" when (ADDR_INT = 16#053#) AND (IO_CYCLE = '1') else
                "0101" when (ADDR_INT = 16#054#) AND (IO_CYCLE = '1') else
                "0110" when (ADDR_INT = 16#055#) AND (IO_CYCLE = '1') else
                "0111" when (ADDR_INT = 16#056#) AND (IO_CYCLE = '1') else
                "1000" when (ADDR_INT = 16#057#) AND (IO_CYCLE = '1') else
                "1001" when (ADDR_INT = 16#058#) AND (IO_CYCLE = '1') else
                "1010" when (ADDR_INT = 16#059#) AND (IO_CYCLE = '1') else
                "1011" when (ADDR_INT = 16#05A#) AND (IO_CYCLE = '1') else
                "1100" when (ADDR_INT = 16#05B#) AND (IO_CYCLE = '1') else
                "1101" when (ADDR_INT = 16#05C#) AND (IO_CYCLE = '1') else
                "1110" when (ADDR_INT = 16#05D#) AND (IO_CYCLE = '1') else
                "1111" when (ADDR_INT = 16#05E#) AND (IO_CYCLE = '1') else
                "0000";

END a;