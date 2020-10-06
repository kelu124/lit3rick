module memory_mux(
        input  [13:0] addr_i_0,
        input         we_i_0,
        input  [15:0] data_i_0,
        output [15:0] data_o_0,

        input  [13:0] addr_i_1,
        input         we_i_1,
        input  [15:0] data_i_1,
        output [15:0] data_o_1,

        input  [13:0] addr_i_2,
        input         we_i_2,
        input  [15:0] data_i_2,
        output [15:0] data_o_2,

        input  [13:0] addr_i_3,
        input         we_i_3,
        input  [15:0] data_i_3,
        output [15:0] data_o_3,

        input  [13:0] addr_i_4,
        input         we_i_4,
        input  [15:0] data_i_4,
        output [15:0] data_o_4,


        output [13:0] addr_mem,
        output        we_mem,
        output [15:0] data_i_mem,
        input  [15:0] data_o_mem,

        input   [2:0] sel
    );

    assign addr_mem =   (sel == 0) ?    addr_i_0 : 
                        (sel == 1) ?    addr_i_1 : 
                        (sel == 2) ?    addr_i_2 : 
                        (sel == 3) ?    addr_i_3 : 
                                        addr_i_4 ;

    assign we_mem =     (sel == 0) ?    we_i_0 : 
                        (sel == 1) ?    we_i_1 : 
                        (sel == 2) ?    we_i_2 : 
                        (sel == 3) ?    we_i_3 : 
                                        we_i_4 ;

    assign data_i_mem = (sel == 0) ?    data_i_0 : 
                        (sel == 1) ?    data_i_1 : 
                        (sel == 2) ?    data_i_2 : 
                        (sel == 3) ?    data_i_3 : 
                                        data_i_4 ;
    
    assign data_o_0 = data_o_mem;
    assign data_o_1 = data_o_mem;
    assign data_o_2 = data_o_mem;
    assign data_o_3 = data_o_mem;
    assign data_o_4 = data_o_mem;
    

endmodule
