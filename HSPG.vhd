-- HSPG.vhd (hobby servo pulse generator)
-- This starting point generates a pulse between 100 us and something much longer than 2.5 ms.

library IEEE;
library lpm;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use lpm.lpm_components.all;

entity HSPG is
    port(
        CS          	: in  std_logic;

        IO_SEL    	    : in  std_logic_vector(3 downto 0);
        IO_DATA     	: in  std_logic_vector(15 downto 0);

        CLOCK       	: in  std_logic;
        RESETN      	: in  std_logic;

        PULSE      	    : out std_logic;
--      PULSE2			: out std_logic
--		PULSE3			: out std_logic;
--	    PULSE4			: out std_logic
    );
end HSPG;

architecture a of HSPG is

    signal command	: std_logic_vector(15 downto 0);  -- command sent from SCOMP
    signal count   	: std_logic_vector(15 downto 0);  -- internal counter
	 
    signal servo1_speed     : std_logic_vector(3 downto 0);
    signal servo1_angle		: std_logic_vector(7 downto 0);
    signal servo1_target	: std_logic_vector(7 downto 0);
    signal servo1_timer		: std_logic_vector(15 downto 0);
    signal servo1_pulsetime : std_logic_vector(7 downto 0);

begin

    -- Latch data on rising edge of CS
    process (RESETN, CS) begin
        if RESETN = '0' then
            command <= x"0000";
			servo1_target <= x"00";
				
        elsif IO_SEL = b"0001" and rising_edge(CS) then
		  
            -- command <= IO_DATA;
            -- servo1_speed <= command(3 downto 0);
            -- servo1_target <= command(11 downto 4)
            servo1_target <= command(7 downto 0);
				
        end if;
    end process;


    process (RESETN, CLOCK)
    begin
        if (RESETN = '0') then
            count <= x"0000";
            servo1_timer <= x"0000";
            -- servo1_angle <= x"00";
				
        elsif rising_edge(CLOCK) then
            -- each clock cycle, a counter is incremented.
				
				count <= count + 1;
				
				-- clamp angles (this range should be customizable)
				if servo1_angle > 180 then
					servo1_angle <= x"B4";
				end if;
				
				-- sets servo angles
				if servo1_angle /= servo1_target then
					servo1_timer <= servo1_timer + 1;
				
					if servo1_timer = x"0100" then -- every X cycles (for now, this will be customizable)
						if servo1_angle > servo1_target then
							servo1_angle <= servo1_angle - x"01";
							
						else
							servo1_angle <= servo1_angle + x"01";
							
						end if;
						
						servo1_timer <= x"0000";
					end if;
				end if;
				
				-- once the counter reaches the high time for the desired angle (angle + .6ms), set pulse low
				if count = servo1_angle + 60 then
					PULSE <= '0';
				end if;
				
            -- 20ms fixed period then reset for next clock cycle
            if count = x"07D0" then  -- 20ms has elapsed
                -- reset the counter and set the output high
                count <= x"0000";
                PULSE <= '1';
				end if;
					 
				
        end if;
    end process;

end a;