    spi_slave __(.spi1_miso_io( ),
        .spi1_mosi_io( ),
        .spi1_sck_io( ),
        .spi1_scs_n_i( ),
        .spi1_mcs_n_o( ),
        .rst_i( ),
        .ipload_i( ),
        .ipdone_o( ),
        .sb_clk_i( ),
        .sb_wr_i( ),
        .sb_stb_i( ),
        .sb_adr_i( ),
        .sb_dat_i( ),
        .sb_dat_o( ),
        .sb_ack_o( ),
        .spi_pirq_o( ),
        .spi_pwkup_o( ));
