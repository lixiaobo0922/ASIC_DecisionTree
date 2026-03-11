import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_decision_tree(dut):
    # 1. 启动时钟 (10MHz)
    clock = Clock(dut.clk, 100, units="ns")
    cocotb.start_soon(clock.start())

    # 2. 复位电路
    dut._log.info("Resetting DUT...")
    dut.rst_n.value = 0
    await Timer(200, units="ns")
    dut.rst_n.value = 1
    dut.ena.value = 1

    # 3. 定义测试用例 (输入: [湿度4位, 温度4位])
    # 示例: 温度=12 (0xC), 湿度=5 (0x5) -> 输入 = 0x5C (即 92)
    test_cases = [
        {"input": (5 << 4) | 12, "expected": 1, "desc": "Comfortable"},
        {"input": (5 << 4) | 5,  "expected": 0, "desc": "Too Cold"},
        {"input": (10 << 4) | 12, "expected": 0, "desc": "Too Humid"}
    ]

    for tc in test_cases:
        dut.ui_in.value = tc["input"]
        await Timer(100, units="ns")
        actual = int(dut.uo_out.value) & 0x01
        
        if actual == tc["expected"]:
            dut._log.info(f"PASS: {tc['desc']} - Input: {hex(tc['input'])}, Expected: {tc['expected']}")
        else:
            raise Exception(f"FAIL: {tc['desc']} - Input: {hex(tc['input'])}, Expected: {tc['expected']}, Got: {actual}")

    dut._log.info("All Decision Tree tests passed!")