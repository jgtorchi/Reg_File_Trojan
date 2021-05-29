----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/28/2021 03:15:08 PM
-- Design Name: 
-- Module Name: Trojan_TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Trojan_TB is
--  Port ( );
end Trojan_TB;

architecture Behavioral of Trojan_TB is
    
    component RegFileBasys3Wrappper is
    Port ( CLK      : in STD_LOGIC;
           BTNL     : in std_logic;
           BTNR     : in std_logic;
           BTNC     : in std_logic;
           BTNU     : in std_logic;
           BTND     : in std_logic;
           SWITCHE  : in std_logic_vector(15 downto 0);
           LEDS     : out std_logic_vector(15 downto 0);
           DISP_EN  : out std_logic_vector(3 downto 0);
           SEGMENTS : out std_logic_vector(6 downto 0));
    end component;
    
    signal CLK      : STD_LOGIC := '0';
    signal BTNL     : std_logic := '0';
    signal BTNR     : std_logic := '0';
    signal BTNC     : std_logic := '0';
    signal BTNU     : std_logic := '0';
    signal BTND     : std_logic := '0';
    signal SWITCHES : std_logic_vector(15 downto 0) := (others => '0');
    signal LEDS     : std_logic_vector(15 downto 0) := (others => '0');
    signal DISP_EN  : std_logic_vector(3  downto 0) := (others => '0');
    signal SEGMENTS : std_logic_vector(6  downto 0) := (others => '0');
    
    constant PERIOD : time := 10 ns;
    
begin

    uut: RegFileBasys3Wrappper
        Port Map(    
            CLK      => CLK,      
            BTNL     => BTNL,
            BTNR     => BTNR,
            BTNC     => BTNC,
            BTNU     => BTNU,
            BTND     => BTND,
            SWITCHE  => SWITCHES,
            LEDS     => LEDS,
            DISP_EN  => DISP_EN,
            SEGMENTS => SEGMENTS);
 
    CLK <= not CLK after PERIOD/2;           
    
    stimulus: process
    begin
        wait for PERIOD;
        SWITCHES(3  downto 0) <= "0001";
        SWITCHES(7  downto 4) <= "0001";
        SWITCHES(11 downto 8) <= "0001";
        BTNC <= '1';
        wait for PERIOD;
        BTNC <= '0';
        BTND <= '1';
        wait for PERIOD;
        BTND <= '0';
        BTNL <= '1';
        wait for PERIOD;
        BTNL <= '0';
        wait for PERIOD;
        SWITCHES <= x"AAAA";
        wait for PERIOD;
        BTND <= '1';
        wait for PERIOD;
        BTND <= '0';
        wait for PERIOD;
        BTNU <= '1';
        wait for PERIOD;
        BTNU <= '0';
        wait;
    end process;

end Behavioral;
