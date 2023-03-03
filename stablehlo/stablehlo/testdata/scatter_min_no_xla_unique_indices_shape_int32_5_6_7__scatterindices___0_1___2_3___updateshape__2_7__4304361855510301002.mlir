// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<2x7xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2xi32>, tensor<2x7xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<2x7xi32>) {
    %0 = stablehlo.constant dense<"0xFAFFFFFF0200000004000000FCFFFFFFFFFFFFFF0000000000000000FCFFFFFFFDFFFFFFFCFFFFFFFCFFFFFFFEFFFFFF010000000600000005000000FDFFFFFFFFFFFFFF01000000FDFFFFFF02000000020000000200000004000000FFFFFFFF00000000FEFFFFFFFFFFFFFF00000000FDFFFFFFFEFFFFFFFDFFFFFFFEFFFFFF00000000FEFFFFFF00000000FFFFFFFF03000000FDFFFFFFFFFFFFFFFCFFFFFFFEFFFFFF02000000FFFFFFFF04000000030000000000000000000000010000000000000000000000FDFFFFFF0100000003000000FCFFFFFF0000000003000000FEFFFFFF00000000FEFFFFFF000000000100000000000000FEFFFFFF020000000300000000000000FFFFFFFFFDFFFFFF03000000F9FFFFFF030000000000000001000000FFFFFFFF01000000020000000200000004000000010000000100000004000000FEFFFFFF02000000FFFFFFFF04000000FDFFFFFFFEFFFFFFFEFFFFFF0000000002000000000000000200000002000000FDFFFFFFFCFFFFFFFEFFFFFF0300000005000000FAFFFFFF010000000300000000000000040000000000000000000000FFFFFFFFFDFFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFBFFFFFFFBFFFFFFFEFFFFFF000000000000000001000000010000000200000001000000020000000000000001000000010000000400000002000000020000000000000000000000FCFFFFFFFCFFFFFFFEFFFFFF0100000000000000000000000400000000000000FFFFFFFFFEFFFFFF0000000002000000FFFFFFFF0000000000000000FEFFFFFF03000000FFFFFFFFF6FFFFFF00000000000000000000000001000000030000000400000004000000FEFFFFFFFBFFFFFF07000000FEFFFFFF0000000002000000FDFFFFFF0400000006000000FFFFFFFF07000000FFFFFFFF020000000200000005000000000000000000000000000000FCFFFFFF06000000060000000200000000000000FCFFFFFFFCFFFFFFFDFFFFFF0100000000000000FFFFFFFFFFFFFFFF0400000000000000FEFFFFFF0400000001000000000000000000000001000000FFFFFFFFFEFFFFFFFFFFFFFF04000000FFFFFFFF00000000FFFFFFFFFCFFFFFF02000000FDFFFFFFFEFFFFFF00000000020000000000000000000000FBFFFFFF00000000FFFFFFFF"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<[[-2, -1, 0, -3, 5, 1, 5], [3, 2, 2, 1, 2, 0, 2]]> : tensor<2x7xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<2x7xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0xFAFFFFFF0200000004000000FCFFFFFFFFFFFFFF0000000000000000FCFFFFFFFDFFFFFFFCFFFFFFFCFFFFFFFEFFFFFF010000000500000005000000FDFFFFFFFFFFFFFF01000000FDFFFFFF02000000020000000200000004000000FFFFFFFF00000000FEFFFFFFFFFFFFFF00000000FDFFFFFFFEFFFFFFFDFFFFFFFEFFFFFF00000000FEFFFFFF00000000FFFFFFFF03000000FDFFFFFFFFFFFFFFFCFFFFFFFEFFFFFF02000000FFFFFFFF04000000030000000000000000000000010000000000000000000000FDFFFFFF0100000003000000FCFFFFFF0000000003000000FEFFFFFF00000000FEFFFFFF000000000100000000000000FEFFFFFF020000000300000000000000FFFFFFFFFDFFFFFF03000000F9FFFFFF030000000000000001000000FFFFFFFF01000000020000000200000004000000010000000100000004000000FEFFFFFF02000000FFFFFFFF04000000FDFFFFFFFEFFFFFFFEFFFFFF0000000002000000000000000200000002000000FDFFFFFFFCFFFFFFFEFFFFFF0300000005000000FAFFFFFF010000000300000000000000040000000000000000000000FFFFFFFFFDFFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFBFFFFFFFBFFFFFFFEFFFFFF000000000000000001000000010000000200000001000000020000000000000001000000010000000400000002000000020000000000000000000000FCFFFFFFFCFFFFFFFEFFFFFF0100000000000000000000000400000000000000FFFFFFFFFEFFFFFF0000000002000000FFFFFFFF0000000000000000FEFFFFFF03000000FFFFFFFFF6FFFFFF00000000000000000000000001000000030000000400000004000000FEFFFFFFFBFFFFFF07000000FEFFFFFF0000000002000000FDFFFFFF0400000006000000FFFFFFFF07000000FFFFFFFF020000000200000005000000000000000000000000000000FCFFFFFF06000000060000000200000000000000FCFFFFFFFCFFFFFFFDFFFFFF0100000000000000FFFFFFFFFFFFFFFF0400000000000000FEFFFFFF0400000001000000000000000000000001000000FFFFFFFFFEFFFFFFFFFFFFFF04000000FFFFFFFF00000000FFFFFFFFFCFFFFFF02000000FDFFFFFFFEFFFFFF00000000020000000000000000000000FBFFFFFF00000000FFFFFFFF"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}

