----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/12/2024 05:39:24 PM
-- Design Name: 
-- Module Name: timer_v1 - Behavioral
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
use IEEE.std_logic_unsigned.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timer_v1 is
    Port ( 
            clk_in : in std_logic;          -- clock ul placii
            EN: in std_logic;               -- enable
            btnClkEx: in std_logic;         -- clock extern
            btn_reset: in std_logic;        -- buton reset
            sel_clk: in std_logic;          -- clock selectie
            TMRIF: out std_logic;           -- flag
            TMR0 : out std_logic_vector (7 downto 0);       -- registru pe 8 biti
            DATA_init: in STD_LOGIC_VECTOR(7 downto 0)      -- vector mapat la switch-uri
         );
end timer_v1;

architecture Behavioral of timer_v1 is
    
    signal TMR0_v: std_logic_vector(7 downto 0);        -- registru temporar pt afisare
    signal TMRIF_flag: std_logic := '0';                -- semnalul de flag
    signal clk_div: std_logic;                          -- semnalul de clock de la iesirea divizorului de frecventa
    signal clk_temp: std_logic;                         -- semnal de clock temporar
   
begin
    
    --          Divizor de frecventa a clock-ului intern
    process (clk_in)            
    variable n: integer range 0 to 100000000;
    begin
        if clk_in' event and clk_in = '1' then
            if n < 50000000 then
                n := n+1;
            else
                n := 0;
            end if;
            
            if n < 25000000 then
                clk_div <= '1';
            else
                clk_div <= '0';
            end if;
        end if;
    end process;
    
    --          MUX 2:1
    process(EN, btn_reset, btnClkEx, TMR0_v, clk_div, TMRIF_flag, sel_clk) 
    begin
        case sel_clk is     
            when '0' => clk_temp <= clk_div;
            when '1' => clk_temp <= btnClkEx;
        end case;

    --          Timer/Numarator
    if EN = '1' then
        if btn_reset = '1' then
            TMR0_v <= DATA_init;
            TMRIF_flag <= '0';
        else
            TMR0_v <= DATA_init;
            if clk_temp' event and clk_temp = '1' then
            
                if TMR0_v = "11111111" then
                    TMRIF_flag <= '1';
                else
                    TMR0_v <= TMR0_v + 1;
                end if;
                
            end if;
        end if;
    end if;
    
    if btn_reset = '1' then
        TMR0_v <= DATA_init;
        TMRIF_flag <= '0';
    end if;
    end process;

    TMR0<= TMR0_v;
    TMRIF <= TMRIF_flag;

end Behavioral;


