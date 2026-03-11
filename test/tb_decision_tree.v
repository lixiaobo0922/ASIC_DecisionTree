`timescale 1ns/1ps
`default_nettype none

module tb_decision_tree;

    // 信号定义
    reg [7:0] ui_in;
    wire [7:0] uo_out;
    reg clk;
    reg rst_n;
    reg ena;

    // 实例化你的决策树模块
    // 注意：这里的模块名必须和你 project.v 里定义的一致
    tt_um_lixiabo0922_decision_tree dut (
        .ui_in  (ui_in),
        .uo_out (uo_out),
        .uio_in (8'b0),
        .uio_out(),
        .uio_oe (),
        .ena    (ena),
        .clk    (clk),
        .rst_n  (rst_n)
    );

    // 时钟产生：100ns 周期 (10MHz)
    always #50 clk = ~clk;

    initial begin
        // 波形导出设置 (用于 GTKWave 查看)
        $dumpfile("tb_decision_tree.vcd");
        $dumpvars(0, tb_decision_tree);

        // 初始化信号
        clk = 0;
        rst_n = 0;
        ena = 1;
        ui_in = 0;

        // 复位过程
        #100 rst_n = 1;

        // --- 测试用例 1: 舒适 (温度=12, 湿度=5) ---
        // 输入: 8'b 0101_1100 (0x5C)
        ui_in = {4'd5, 4'd12}; 
        #100;
        $display("TC1: In=%h, Out=%b (Expected: 1)", ui_in, uo_out[0]);

        // --- 测试用例 2: 太冷 (温度=5, 湿度=5) ---
        ui_in = {4'd5, 4'd5}; 
        #100;
        $display("TC2: In=%h, Out=%b (Expected: 0)", ui_in, uo_out[0]);

        // --- 测试用例 3: 太湿 (温度=12, 湿度=10) ---
        ui_in = {4'd10, 4'd12}; 
        #100;
        $display("TC3: In=%h, Out=%b (Expected: 0)", ui_in, uo_out[0]);

        #100;
        $display("all test done!");
        $finish;
    end

endmodule