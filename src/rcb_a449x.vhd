Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY rcb_a449x IS
PORT(RESET,DSDON,DEM0,DEM1 : IN std_logic;
		SD,SLOW,MONO,DSDSEL0,DSDSEL1,DSDF : IN std_logic;
		SSLOW,DSDD,SC0,SC1,SC2,AK4497,AK4499 : IN std_logic;
		I2SDATA_DSDR,I2SLRCK_DSDL,I2SBCK_DSDCLK : IN std_logic;
		MCLKA,PLUG,MUTE_IN,DSD : IN std_logic;
		PHA : IN std_logic;
		PHB : IN std_logic;
		CSN,CCLK,CDTI : OUT std_logic;
		MCLK,BCLK_DSDCLK,DATA_DSDL,LRCK_DSDR : OUT std_logic;
		LED_DSD : OUT std_logic);
END rcb_a449x;

ARCHITECTURE RTL OF rcb_a449x IS

component regctr
	PORT(
		RESET : IN std_logic;
		CLK : IN std_logic;
		CLK_MSEC : IN std_logic;
		XDSD : IN std_logic;
		SMUTE : IN std_logic;
		DEM0 : IN std_logic;
		DEM1 : IN std_logic;
		SD : IN std_logic;
		SLOW : IN std_logic;
		MONO : IN std_logic;
		DSDSEL0 : IN std_logic;
		DSDSEL1 : IN std_logic;
		DSDF : IN std_logic;
		SSLOW : IN std_logic;
		DSDD : IN std_logic;
		SC0 : IN std_logic;
		SC1 : IN std_logic;
		SC2 : IN std_logic;
		AK4490 : IN std_logic;
		AK4499 : IN std_logic;
		ATTCOUNT : IN std_logic_vector(7 downto 0);
		CSN : OUT std_logic;
		CCLK : OUT std_logic;
		CDTI : OUT std_logic);
end component;

component clkgen 
	PORT(
			RESET : IN std_logic;
			MCLKA : IN std_logic;
			CLK_MSEC : OUT std_logic;
			CLK_FIL : OUT std_logic;
			CLK_10M : OUT std_logic);
end component;

component attcnt
	port(
			CLK : IN std_logic;
			RESET_N : IN std_logic;
			A : IN std_logic;
			B : IN std_logic;
			CNTUP : OUT std_logic;
			CNTDWN : OUT std_logic;
			Q : OUT std_logic_vector(7 downto 0));
end component;

signal xdsd,imono,ii2sdata_dsdr,ii2slrck_dsdl,smute: std_logic;
signal chat_clk,attdwn,attup : std_logic;
signal clk_10m,clk_msec : std_logic;
signal attcount : std_logic_vector(7 downto 0);
signal xak4490 : std_logic;

begin

	R1 : regctr port map (RESET => reset,CLK => CLK_10M,CLK_MSEC => clk_msec,XDSD => xdsd,SMUTE => smute,
								DEM0 => dem0,DEM1 => dem1,SD => sd,SLOW => slow,MONO => imono,
								DSDSEL0 => dsdsel0,DSDSEL1 => dsdsel1,DSDF => dsdf,
								SSLOW => sslow,DSDD => dsdd,SC0 => sc0,SC1 => sc1,SC2 => sc2,
								AK4490 => xak4490,AK4499 => ak4499, ATTCOUNT => attcount,CSN => csn,CCLK => cclk,CDTI => cdti); 

	C1 : clkgen port map (RESET => reset,MCLKA => mclka,CLK_MSEC=>clk_msec,
								CLK_FIL => chat_clk,CLK_10M => clk_10m);
								
	A1 : attcnt port map (CLK => CLK_10M,RESET_N => reset,A => PHA, B => PHB,CNTUP => attup,CNTDWN => attdwn,
								Q => attcount);
		
	xak4490 <= not ak4497;
	imono <= not MONO;
	xdsd <= not DSDON;
--	smute <= '0' when EMUTE = '1' else MUTE_IN;
	smute <= '0';

	DATA_DSDL <= iI2SLRCK_DSDL;
	LRCK_DSDR <= iI2SDATA_DSDR;
	ii2sdata_dsdr <= I2SLRCK_DSDL when DSDON = '0' else I2SDATA_DSDR;
	ii2slrck_dsdl <= I2SDATA_DSDR when DSDON = '0' else I2SLRCK_DSDL;
	BCLK_DSDCLK <= I2SBCK_DSDCLK;
	MCLK <= mclka;

	LED_DSD <= DSDON when reset = '1' else '0';

end RTL;