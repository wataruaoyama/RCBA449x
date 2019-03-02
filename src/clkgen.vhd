Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY clkgen IS
PORT(
		RESET : IN std_logic;
		MCLKA : IN std_logic;
		CLK_MSEC : OUT std_logic;
		CLK_FIL : OUT std_logic;
		CLK_10M : OUT std_logic);
END clkgen;

ARCHITECTURE RTL OF clkgen IS

--signal counter_msec : std_logic_vector(19 downto 0);
signal counter_msec : std_logic_vector(21 downto 0);

constant sim : integer := 0;

BEGIN

--Generate 100msec timer
--process(RESET,CLK) BEGIN
--	if(RESET = '0') then
--		counter_msec <= "00000000000000000000";
--	elsif(CLK'event and CLK='1') then
--		counter_msec <= counter_msec + '1';
--	end if;
--end process;
--
--COMPILE : if sim /= 1 generate
--CLK_MSEC <= counter_msec(19);	-- about 100msec. 
--end generate;

process(RESET,MCLKA) BEGIN
	if(RESET = '0') then
		counter_msec <= "0000000000000000000000";
	elsif(MCLKA'event and MCLKA='1') then
		counter_msec <= counter_msec + '1';
	end if;
end process;

COMPILE : if sim /= 1 generate
CLK_MSEC <= counter_msec(21);	-- about 100msec. 
end generate;

SIMULATION : if sim = 1 generate
CLK_MSEC <= counter_msec(13);	
end generate;

--CLK_FIL <= counter_msec(17);	-- Clock for chattering canceller: about 25ms
--ENDIVCLK <= counter_msec(14);	-- about 610Hz

CLK_FIL <= counter_msec(19);	-- Clock for chattering canceller: about 40ms

CLK_10M <= counter_msec(2);	-- about 6MHz clodk at 24/22MHz MCLK

end RTL;