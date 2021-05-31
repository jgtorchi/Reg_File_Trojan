----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2021 09:15:30 PM
-- Design Name: 
-- Module Name: RegFileBasys3Wrappper - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegFileBasys3Wrappper is
    Port ( CLK      : in STD_LOGIC;
           BTNL     : in std_logic;
           BTNR     : in std_logic;
           BTNC     : in std_logic;
           BTNU     : in std_logic;
           BTND     : in std_logic;
           SWITCHES : in std_logic_vector(15 downto 0);
           LEDS     : out std_logic_vector(15 downto 0);
           DISP_EN  : out std_logic_vector(3 downto 0);
           SEGMENTS : out std_logic_vector(6 downto 0));
end RegFileBasys3Wrappper;

architecture Behavioral of RegFileBasys3Wrappper is

    component sseg_des is
        Port (COUNT    : in std_logic_vector(15 downto 0); 				  
              CLK      : in std_logic;
              VALID    : in std_logic;
              DISP_EN  : out std_logic_vector(3  downto 0);
              SEGMENTS : out std_logic_vector(6  downto 0)); -- Decimal Point is never used
    end component;
    
    component reg_file is
        Port (RF_ADR1, RF_ADR2, RF_WA : in  std_logic_vector(3 downto 0);
              RF_EN, CLK              : in  std_logic;
              RF_WD, U_ID             : in  std_logic_vector(15 downto 0);
              RF_RS1, RF_RS2          : out std_logic_vector(15 downto 0));
    end component;    
    
    signal RF_ADR1  : std_logic_vector(3  downto 0);
    signal RF_ADR2  : std_logic_vector(3  downto 0);
    signal RF_WA    : std_logic_vector(3  downto 0);
    signal RF_WD    : std_logic_vector(15 downto 0);
    signal U_ID     : std_logic_vector(15 downto 0);
    signal COUNT    : std_logic_vector(15 downto 0);
    
    TYPE STATE_TYPE IS (enterAdr,enterData,enterKey,enterSwitching);
    SIGNAL state   : STATE_TYPE := enterAdr;
    signal stateCondition1, stateCondition2, stateCondition3, stateCondition4 : std_logic := '0';
begin
    stateCondition1 <= BTNC and not BTNL and not BTNR;
    stateCondition2 <= not BTNC and BTNL and not BTNR;
    stateCondition3 <= not BTNC and not BTNL and BTNR;
    stateCondition4 <= BTNC and BTNL and not BTNR;
    
    selectState : Process(CLK,BTNC,BTNL,BTNR)
    begin
        if rising_edge(clk) then
            if(stateCondition1 ='1')then
                state <= enterAdr;
            elsif(stateCondition2='1')then
                state <= enterData;
            elsif(stateCondition3='1')then
                state <= enterKey;
            elsif(stateCondition4='1') then
                state <= enterSwitching;
            end if;
        end if;
    end process; 
    
    writeData: Process(CLK,BTND,state,SWITCHES)
    begin
        if rising_edge(clk) then
            if(BTND='1')then
                if (state=enterAdr) then
                    RF_ADR1 <= SWITCHES(3 downto 0);
                    RF_ADR2 <= SWITCHES(7 downto 4);
                    RF_WA   <= SWITCHES(11 downto 8);
                elsif (state=enterData) then
                    RF_WD   <= SWITCHES;
                elsif (state=enterKey) then
                    U_ID   <= SWITCHES;
                elsif (state=enterSwitching) then
                    RF_WA   <= SWITCHES(3 downto 0);
                    U_ID   <= SWITCHES;
                    RF_WD   <= SWITCHES;
                end if;
            end if;
        end if;
    end process;
    

    myReg: reg_file 
        Port Map(
            RF_ADR1 => RF_ADR1,
            RF_ADR2 => RF_ADR2,
            RF_WA   => RF_WA,
            RF_EN   => BTNU,
            CLK     => CLK,
            RF_WD   => RF_WD,
            U_ID    => U_ID,
            RF_RS1  => COUNT,
            RF_RS2  => LEDS);

    mySSEG : sseg_des
        Port Map(
            COUNT    => COUNT,
            CLK      => CLK,
            VALID    => '1',
            DISP_EN  => DISP_EN,
            SEGMENTS => SEGMENTS);
    
end Behavioral;