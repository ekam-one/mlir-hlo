// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xi32>, tensor<1x20xi32>)
    %1 = call @expected() : () -> tensor<20x20xi32>
    %2 = stablehlo.broadcast_in_dim %0#1, dims = [0, 1] : (tensor<1x20xi32>) -> tensor<20x20xi32>
    %3 = stablehlo.shift_left %0#0, %2 : tensor<20x20xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x20xi32>, tensor<20x20xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xi32>, tensor<1x20xi32>) {
    %0 = stablehlo.constant dense<"0xFBFFFFFFFEFFFFFFFFFFFFFF05000000FDFFFFFFFCFFFFFFFCFFFFFF000000000500000000000000020000000000000003000000020000000100000000000000FCFFFFFF03000000FCFFFFFF00000000FDFFFFFF0100000005000000030000000000000000000000FBFFFFFF03000000FBFFFFFF000000000500000002000000FDFFFFFFFCFFFFFF03000000FFFFFFFF0200000001000000FDFFFFFF0400000000000000FEFFFFFFFDFFFFFFFDFFFFFFFEFFFFFF010000000000000000000000FBFFFFFF00000000000000000000000001000000FDFFFFFFFFFFFFFFFCFFFFFF0000000002000000FEFFFFFF05000000020000000000000002000000FFFFFFFFFDFFFFFF000000000100000002000000FEFFFFFF01000000FEFFFFFFFEFFFFFFFFFFFFFF000000000000000005000000000000000200000005000000FDFFFFFF02000000020000000000000000000000FCFFFFFF0800000000000000000000000000000000000000FDFFFFFF0000000001000000FDFFFFFF020000000000000001000000FEFFFFFF0000000000000000FDFFFFFF0000000004000000FAFFFFFFFDFFFFFF00000000010000000100000000000000FDFFFFFF0400000000000000FFFFFFFF04000000FDFFFFFF0000000001000000FFFFFFFF02000000FEFFFFFFFDFFFFFF000000000100000003000000030000000200000003000000FDFFFFFF00000000FFFFFFFF03000000000000000000000005000000FFFFFFFFFBFFFFFF00000000FCFFFFFFFFFFFFFF02000000FCFFFFFF00000000FCFFFFFF04000000000000000200000002000000000000000000000000000000FDFFFFFF02000000040000000000000000000000FEFFFFFF030000000000000007000000FDFFFFFF000000000000000001000000020000000300000001000000FEFFFFFF000000000400000000000000FEFFFFFFFEFFFFFFFFFFFFFF010000000200000003000000FDFFFFFF0000000000000000FCFFFFFFFEFFFFFF060000000300000000000000060000000000000008000000FEFFFFFFFEFFFFFF00000000FEFFFFFF00000000FCFFFFFFFEFFFFFFFFFFFFFFFAFFFFFFFFFFFFFF0000000000000000FCFFFFFFFFFFFFFF05000000FFFFFFFF01000000010000000400000000000000FDFFFFFF00000000FDFFFFFF00000000FFFFFFFFFCFFFFFFF9FFFFFFFCFFFFFF01000000030000000000000001000000FEFFFFFFFEFFFFFF01000000010000000400000002000000FEFFFFFF0300000000000000FEFFFFFF0000000000000000FEFFFFFFFBFFFFFFFEFFFFFFFFFFFFFF000000000000000006000000FDFFFFFF03000000FCFFFFFFFEFFFFFFFCFFFFFF03000000FCFFFFFF000000000000000003000000000000000200000001000000FFFFFFFF0100000003000000FEFFFFFFFCFFFFFF03000000040000000000000000000000F8FFFFFFFEFFFFFF0100000000000000FDFFFFFF000000000000000000000000FAFFFFFFFEFFFFFFFDFFFFFF0000000000000000FCFFFFFFFCFFFFFF00000000FBFFFFFF01000000FFFFFFFF00000000FBFFFFFFFEFFFFFFFDFFFFFF070000000000000001000000FFFFFFFF0000000003000000040000000200000004000000000000000000000001000000FEFFFFFF01000000000000000100000001000000010000000100000000000000FDFFFFFFFEFFFFFF0200000002000000FFFFFFFF03000000FFFFFFFF0400000000000000000000000100000003000000F8FFFFFFFCFFFFFF0200000003000000FFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF00000000000000000100000003000000050000000100000003000000FEFFFFFFFDFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFF0000000005000000010000000400000000000000010000000000000000000000FDFFFFFF02000000FCFFFFFF0200000000000000FFFFFFFF00000000FDFFFFFF01000000FDFFFFFF000000000300000003000000FCFFFFFF00000000FFFFFFFFFBFFFFFF00000000FEFFFFFF01000000010000000000000005000000FFFFFFFF00000000FFFFFFFF00000000FBFFFFFFFDFFFFFFFAFFFFFF010000000200000002000000050000000000000000000000000000000000000000000000FFFFFFFF010000000000000004000000010000000300000000000000000000000100000000000000FDFFFFFF0000000002000000000000000500000000000000"> : tensor<20x20xi32>
    %1 = stablehlo.constant dense<[[-2, -5, 0, 0, 1, 3, -3, 0, -4, -1, -2, -2, 0, 0, 3, 0, 2, 0, 0, -1]]> : tensor<1x20xi32>
    return %0, %1 : tensor<20x20xi32>, tensor<1x20xi32>
  }
  func.func private @expected() -> tensor<20x20xi32> {
    %0 = stablehlo.constant dense<"0x0000000000000000FFFFFFFF05000000FAFFFFFFE0FFFFFF00000000000000000000000000000000000000000000000003000000020000000800000000000000F0FFFFFF03000000FCFFFFFF00000000000000000000000005000000030000000000000000000000000000000300000000000000000000000000000000000000FDFFFFFFFCFFFFFF18000000FFFFFFFF0800000001000000FDFFFFFF000000000000000000000000FDFFFFFFFDFFFFFFFCFFFFFF0800000000000000000000000000000000000000000000000000000001000000FDFFFFFFF8FFFFFFFCFFFFFF0000000002000000FEFFFFFF00000000000000000000000002000000FFFFFFFFFAFFFFFF00000000000000000200000000000000000000000000000000000000FFFFFFFF0000000000000000050000000000000002000000050000000000000000000000000000000000000000000000F8FFFFFF4000000000000000000000000000000000000000000000000000000001000000FDFFFFFF100000000000000004000000FEFFFFFF0000000000000000000000000000000004000000FAFFFFFFFAFFFFFF00000000000000000100000000000000000000000000000000000000FFFFFFFF04000000E8FFFFFF0000000004000000FFFFFFFF020000000000000000000000000000000100000003000000060000001000000000000000FDFFFFFF000000000000000000000000000000000000000005000000F8FFFFFFFBFFFFFF00000000FCFFFFFFFFFFFFFF000000000000000000000000FCFFFFFF040000000000000010000000000000000000000000000000000000000000000000000000040000000000000000000000FEFFFFFF0C000000000000000700000000000000000000000000000001000000020000000600000008000000000000000000000000000000000000000000000000000000FFFFFFFF010000001000000003000000F4FFFFFF000000000000000000000000000000000000000003000000000000000C0000000000000000000000FEFFFFFF00000000000000000000000000000000FCFFFFFFFEFFFFFFF8FFFFFFFAFFFFFFFCFFFFFF0000000000000000000000000000000000000000FFFFFFFF01000000020000002000000000000000FDFFFFFF00000000000000000000000000000000FCFFFFFFF9FFFFFFE0FFFFFF010000000C0000000000000001000000000000000000000000000000010000000400000004000000F0FFFFFF000000000000000000000000000000000000000000000000FBFFFFFFFEFFFFFFF8FFFFFF000000000000000006000000FDFFFFFF000000000000000000000000FCFFFFFF03000000F8FFFFFF000000000000000003000000000000000000000000000000000000000100000003000000F0FFFFFFFCFFFFFF0C00000004000000000000000000000000000000000000000100000000000000FAFFFFFF0000000000000000000000000000000000000000000000000000000000000000FCFFFFFFE0FFFFFF00000000ECFFFFFF01000000FFFFFFFF000000000000000000000000FDFFFFFF070000000000000008000000000000000000000000000000000000000000000000000000000000000000000008000000FEFFFFFF04000000000000000100000000000000000000000000000000000000FDFFFFFFFCFFFFFF1000000000000000FFFFFFFF00000000000000000000000000000000000000000100000018000000F8FFFFFFF0FFFFFF0200000003000000000000000000000000000000FFFFFFFF000000000000000008000000000000000500000000000000000000000000000000000000FEFFFFFFFFFFFFFFF8FFFFFF00000000FCFFFFFF0000000005000000000000000000000000000000010000000000000000000000E8FFFFFF00000000FCFFFFFF00000000000000000000000000000000FDFFFFFF01000000E8FFFFFF000000000C00000003000000FCFFFFFF00000000000000000000000000000000FEFFFFFF0200000008000000000000000500000000000000000000000000000000000000FBFFFFFFFDFFFFFFD0FFFFFF010000000800000002000000050000000000000000000000000000000000000000000000FEFFFFFF080000000000000004000000000000000000000000000000000000000100000000000000E8FFFFFF0000000008000000000000000500000000000000"> : tensor<20x20xi32>
    return %0 : tensor<20x20xi32>
  }
}
