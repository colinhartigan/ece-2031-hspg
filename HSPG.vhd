-- HSPG.vhd (hobby servo pulse generator)
-- This starting point generates a pulse between 100 us and something much longer than 2.5 ms.

library IEEE;
library lpm;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use lpm.lpm_components.all;

entity HSPG is
    port(
        CS          	: in std_logic;

        IO_WRITE     : in std_logic;
        IO_SEL    	: in std_logic_vector(3 downto 0);
        IO_DATA     	: in std_logic_vector(15 downto 0);

        CLOCK       	: in std_logic;
        RESETN      	: in std_logic;

        PULSE      	: out std_logic_vector(3 downto 0)
    );
end HSPG;

architecture a of HSPG is

    signal command	: std_logic_vector(15 downto 0);  -- command sent from SCOMP
    signal count   	: std_logic_vector(15 downto 0);  -- internal counter
	 
	 signal motor_sel	: std_logic_vector(15 downto 0);
	 
    signal servo1_speed    : std_logic_vector(3 downto 0);
    signal servo1_angle		: std_logic_vector(7 downto 0);
    signal servo1_target	: std_logic_vector(7 downto 0);
    signal servo1_timer		: std_logic_vector(15 downto 0);
	 
	 signal servo2_speed    : std_logic_vector(3 downto 0);
    signal servo2_angle		: std_logic_vector(7 downto 0);
    signal servo2_target	: std_logic_vector(7 downto 0);
    signal servo2_timer		: std_logic_vector(15 downto 0);
	 
	 signal servo3_speed    : std_logic_vector(3 downto 0);
    signal servo3_angle		: std_logic_vector(7 downto 0);
    signal servo3_target	: std_logic_vector(7 downto 0);
    signal servo3_timer		: std_logic_vector(15 downto 0);
	 
	 signal servo4_speed    : std_logic_vector(3 downto 0);
    signal servo4_angle		: std_logic_vector(7 downto 0);
    signal servo4_target	: std_logic_vector(7 downto 0);
    signal servo4_timer		: std_logic_vector(15 downto 0);

begin

    -- Latch data on rising edge of CS
    process (RESETN, CS) begin
        if RESETN = '0' then
            command <= x"0000";
				servo1_target <= x"00";
				servo2_target <= x"00";
				servo3_target <= x"00";
				servo4_target <= x"00";
				
        elsif IO_WRITE = '1' and rising_edge(CS) then

				case IO_SEL is 
					when "0001" => -- 0x050 motor select
						motor_sel <= IO_DATA;
						
					when "0010" => -- 0x051 angle set
						if motor_sel(0) = '1' then
							servo1_target <= IO_DATA(7 downto 0);
						end if;
						
						if motor_sel(1) = '1' then
							servo2_target <= IO_DATA(7 downto 0);
						end if;
						
						if motor_sel(2) = '1' then
							servo3_target <= IO_DATA(7 downto 0);
						end if;
						
						if motor_sel(3) = '1' then
							servo4_target <= IO_DATA(7 downto 0);
						end if;

					when "0011" => -- 0x052 velocity set
						if motor_sel(0) = '1' then
							servo1_speed <= IO_DATA(3 downto 0);
						end if;
						
						if motor_sel(1) = '1' then
							servo2_speed <= IO_DATA(3 downto 0);
						end if;
						
						if motor_sel(2) = '1' then
							servo3_speed <= IO_DATA(3 downto 0);
						end if;
						
						if motor_sel(3) = '1' then
							servo4_speed <= IO_DATA(3 downto 0);
						end if;

					when others => 
						
						
				
				end case;
        end if;
    end process;

    -- processing stuff
    process (RESETN, CLOCK)
    begin
        if (RESETN = '0') then
            count <= x"0000";
            servo1_timer <= x"0000";
				servo2_timer <= x"0000";
				servo3_timer <= x"0000";
				servo4_timer <= x"0000";
				
        elsif rising_edge(CLOCK) then
            -- count counts every clock tick
				count <= count + 1;
								
				-- clamp angles (this range should be customizable)
				if servo1_angle > 180 then
					servo1_angle <= x"B4";
				end if;
				
				if servo2_angle > 180 then
					servo2_angle <= x"B4";
				end if;
				
				if servo3_angle > 180 then
					servo3_angle <= x"B4";
				end if;
				
				if servo4_angle > 180 then
					servo4_angle <= x"B4";
				end if;
				
				-- sets servo angles
				if servo1_angle /= servo1_target then
					servo1_timer <= servo1_timer + 1;
				
					if servo1_timer = servo1_speed then -- every X cycles (for now, this will be customizable)
						if servo1_angle > servo1_target then
							servo1_angle <= servo1_angle - x"01"; -- move by 1 deg
							
						else
							servo1_angle <= servo1_angle + x"01";
							
						end if;
						
						servo1_timer <= x"0000";
					end if;
				end if;
				
				if servo2_angle /= servo2_target then
					servo2_timer <= servo2_timer + 1;
				
					if servo2_timer = servo2_speed then -- every X cycles (for now, this will be customizable)
						if servo2_angle > servo2_target then
							servo2_angle <= servo2_angle - x"01"; -- move by 1 deg
							
						else
							servo2_angle <= servo2_angle + x"01";
							
						end if;
						
						servo2_timer <= x"0000";
					end if;
				end if;
				
				if servo3_angle /= servo3_target then
					servo3_timer <= servo3_timer + 1;
				
					if servo3_timer = servo3_speed then -- every X cycles (for now, this will be customizable)
						if servo3_angle > servo3_target then
							servo3_angle <= servo3_angle - x"01"; -- move by 1 deg
							
						else
							servo3_angle <= servo3_angle + x"01";
							
						end if;
						
						servo3_timer <= x"0000";
					end if;
				end if;
				
				if servo4_angle /= servo4_target then
					servo4_timer <= servo4_timer + 1;
				
					if servo4_timer = servo4_speed then -- every X cycles (for now, this will be customizable)
						if servo4_angle > servo4_target then
							servo4_angle <= servo4_angle - x"01"; -- move by 1 deg
							
						else
							servo4_angle <= servo4_angle + x"01";
							
						end if;
						
						servo4_timer <= x"0000";
					end if;
				end if;
				
				-- once the counter reaches the high time for the desired angle (angle + .6ms), set pulse low
				if count = servo1_angle + 60 then
					PULSE(0) <= '0';
				end if;
				
				if count = servo2_angle + 60 then
					PULSE(1) <= '0';
				end if;
				
				if count = servo3_angle + 60 then
					PULSE(2) <= '0';
				end if;
				
				if count = servo4_angle + 60 then
					PULSE(3) <= '0';
				end if;
				
				
            -- 20ms fixed period then reset for next clock cycle
            if count = x"07D0" then  -- 20ms has elapsed
                -- reset the counter and set the output high
                count <= x"0000";
                PULSE(0) <= '1';
					 PULSE(1) <= '1';
					 PULSE(2) <= '1';
					 PULSE(3) <= '1';
				end if;
					 
        end if;
    end process;

end a;