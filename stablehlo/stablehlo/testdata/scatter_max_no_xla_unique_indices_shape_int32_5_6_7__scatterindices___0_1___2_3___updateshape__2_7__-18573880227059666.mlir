// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<2x7xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2xi32>, tensor<2x7xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<2x7xi32>) {
    %0 = stablehlo.constant dense<"0xFFFFFFFFFDFFFFFF04000000080000000000000003000000FDFFFFFF0100000002000000FFFFFFFFFFFFFFFF00000000FEFFFFFF02000000FEFFFFFF00000000FFFFFFFF01000000000000000000000000000000FCFFFFFFFEFFFFFF000000000600000005000000FCFFFFFF02000000FFFFFFFFFEFFFFFFFFFFFFFF01000000FFFFFFFF03000000FDFFFFFFFFFFFFFF010000000300000003000000000000000000000002000000FDFFFFFF00000000000000000000000000000000FAFFFFFFFDFFFFFF0200000001000000FEFFFFFFF8FFFFFF0000000000000000FEFFFFFFFEFFFFFF06000000030000000000000004000000FFFFFFFF040000000100000000000000FDFFFFFFFEFFFFFF02000000020000000400000008000000000000000000000001000000090000000200000001000000000000000000000006000000000000000100000000000000FCFFFFFFFFFFFFFFFDFFFFFF03000000FFFFFFFF01000000000000000000000002000000FEFFFFFF01000000FDFFFFFF01000000040000000000000006000000FCFFFFFF0100000001000000FEFFFFFFFCFFFFFFFEFFFFFF0100000000000000000000000000000000000000FEFFFFFF030000000600000004000000FEFFFFFF0500000000000000FEFFFFFF010000000100000000000000FFFFFFFFFBFFFFFF0100000004000000FEFFFFFFFFFFFFFF0800000000000000FEFFFFFFFDFFFFFF01000000FEFFFFFF0000000000000000FFFFFFFF01000000FFFFFFFFFAFFFFFFFAFFFFFF04000000000000000300000002000000FDFFFFFF00000000020000000100000006000000FEFFFFFF0800000000000000FDFFFFFFFEFFFFFFFEFFFFFF000000000300000000000000FFFFFFFF0000000002000000000000000000000001000000FDFFFFFF03000000FDFFFFFF0400000001000000FFFFFFFFFEFFFFFFFEFFFFFF00000000000000000100000000000000FBFFFFFF000000000000000000000000FEFFFFFF00000000FEFFFFFFFEFFFFFF030000000000000000000000000000000100000003000000FFFFFFFFFEFFFFFFFCFFFFFF02000000FEFFFFFFFCFFFFFFFAFFFFFF01000000FFFFFFFF03000000FDFFFFFF0300000000000000020000000100000000000000FDFFFFFF0100000000000000FDFFFFFF"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<[[1, 4, -6, -4, 7, -1, 0], [1, 4, -3, 1, -4, 0, -6]]> : tensor<2x7xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<2x7xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0xFFFFFFFFFDFFFFFF04000000080000000000000003000000FDFFFFFF0100000004000000FFFFFFFFFFFFFFFF07000000FFFFFFFF02000000FEFFFFFF00000000FFFFFFFF01000000000000000000000000000000FCFFFFFFFEFFFFFF000000000600000005000000FCFFFFFF02000000FFFFFFFFFEFFFFFFFFFFFFFF01000000FFFFFFFF03000000FDFFFFFFFFFFFFFF010000000300000003000000000000000000000002000000FDFFFFFF00000000000000000000000000000000FAFFFFFFFDFFFFFF0200000001000000FEFFFFFFF8FFFFFF0000000000000000FEFFFFFFFEFFFFFF06000000030000000000000004000000FFFFFFFF040000000100000000000000FDFFFFFFFEFFFFFF02000000020000000400000008000000000000000000000001000000090000000200000001000000000000000000000006000000000000000100000000000000FCFFFFFFFFFFFFFFFDFFFFFF03000000FFFFFFFF01000000000000000000000002000000FEFFFFFF01000000FDFFFFFF01000000040000000000000006000000FCFFFFFF0100000001000000FEFFFFFFFCFFFFFFFEFFFFFF010000000400000000000000010000000000000000000000030000000600000004000000FEFFFFFF0500000000000000FEFFFFFF010000000100000000000000FFFFFFFFFBFFFFFF0100000004000000FEFFFFFFFFFFFFFF0800000000000000FEFFFFFFFDFFFFFF01000000FEFFFFFF0000000000000000FFFFFFFF01000000FFFFFFFFFAFFFFFFFAFFFFFF04000000000000000300000002000000FDFFFFFF00000000020000000100000006000000FEFFFFFF0800000000000000FDFFFFFFFEFFFFFFFEFFFFFF000000000300000000000000FFFFFFFF0000000002000000000000000000000001000000FDFFFFFF03000000FDFFFFFF0400000001000000FFFFFFFFFEFFFFFFFEFFFFFF00000000000000000100000000000000FBFFFFFF000000000000000000000000FEFFFFFF00000000FEFFFFFFFEFFFFFF030000000000000000000000000000000100000003000000FFFFFFFFFEFFFFFFFCFFFFFF02000000FEFFFFFFFCFFFFFFFAFFFFFF01000000FFFFFFFF03000000FDFFFFFF0300000000000000020000000100000000000000FDFFFFFF0100000000000000FDFFFFFF"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}

