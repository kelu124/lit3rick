component spi_slave is
    port(
        spi1_miso_io: inout std_logic;
        spi1_mosi_io: inout std_logic;
        spi1_sck_io: inout std_logic;
        spi1_scs_n_i: in std_logic;
        spi1_mcs_n_o: out std_logic_vector(3 downto 0);
        rst_i: in std_logic;
        ipload_i: in std_logic;
        ipdone_o: out std_logic;
        sb_clk_i: in std_logic;
        sb_wr_i: in std_logic;
        sb_stb_i: in std_logic;
        sb_adr_i: in std_logic_vector(7 downto 0);
        sb_dat_i: in std_logic_vector(7 downto 0);
        sb_dat_o: out std_logic_vector(7 downto 0);
        sb_ack_o: out std_logic;
        spi_pirq_o: out std_logic_vector(1 downto 0);
        spi_pwkup_o: out std_logic_vector(1 downto 0)
    );
end component;

__: spi_slave port map(
    spi1_miso_io=>,
    spi1_mosi_io=>,
    spi1_sck_io=>,
    spi1_scs_n_i=>,
    spi1_mcs_n_o=>,
    rst_i=>,
    ipload_i=>,
    ipdone_o=>,
    sb_clk_i=>,
    sb_wr_i=>,
    sb_stb_i=>,
    sb_adr_i=>,
    sb_dat_i=>,
    sb_dat_o=>,
    sb_ack_o=>,
    spi_pirq_o=>,
    spi_pwkup_o=>
);
