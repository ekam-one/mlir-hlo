// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<5x2x2xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2x2xi32>, tensor<5x2x2xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<5x2x2xi32>) {
    %0 = stablehlo.constant dense<"0x0000000000000000F9FFFFFF010000000100000000000000FFFFFFFF0000000000000000FFFFFFFFFEFFFFFFFFFFFFFF0000000000000000FDFFFFFF04000000FEFFFFFF03000000FBFFFFFFFFFFFFFFFFFFFFFFFBFFFFFF00000000FCFFFFFF010000000400000002000000FFFFFFFFFDFFFFFFFDFFFFFF00000000010000000100000002000000FBFFFFFF000000000000000001000000FBFFFFFF030000000300000000000000FAFFFFFFFFFFFFFFFCFFFFFF00000000FFFFFFFFFFFFFFFFFDFFFFFF04000000000000000600000000000000FDFFFFFF00000000000000000300000000000000FBFFFFFF02000000FDFFFFFF000000000200000003000000030000000200000003000000FDFFFFFFFDFFFFFF04000000060000000100000000000000010000000100000000000000FDFFFFFFFAFFFFFF09000000FFFFFFFFFEFFFFFF0000000000000000FDFFFFFF0000000000000000FEFFFFFF00000000FDFFFFFF02000000FBFFFFFF00000000FEFFFFFF00000000000000000000000001000000FCFFFFFFFEFFFFFF0500000001000000FFFFFFFF04000000010000000000000000000000FCFFFFFFFFFFFFFF01000000FDFFFFFF00000000000000000500000009000000000000000300000000000000020000000000000003000000FAFFFFFFFEFFFFFFFEFFFFFFFFFFFFFF0100000002000000FEFFFFFF0000000000000000000000000200000004000000FFFFFFFFFEFFFFFFFFFFFFFFFDFFFFFF00000000FFFFFFFFFDFFFFFFFFFFFFFFFAFFFFFF02000000FBFFFFFFFFFFFFFF08000000030000000400000001000000FEFFFFFFFAFFFFFF0200000002000000FFFFFFFFFAFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF070000000000000006000000FAFFFFFFFFFFFFFF00000000FEFFFFFF05000000FFFFFFFFFCFFFFFF02000000050000000200000001000000040000000000000000000000FCFFFFFF0000000000000000FCFFFFFF04000000FCFFFFFFFEFFFFFF000000000200000000000000FDFFFFFF02000000FBFFFFFFFFFFFFFF04000000FFFFFFFFFEFFFFFFFEFFFFFFFDFFFFFF03000000FEFFFFFFFCFFFFFFFFFFFFFFFEFFFFFF040000000400000003000000FDFFFFFF00000000050000000400000000000000FEFFFFFF020000000000000004000000"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<[[[0, 0], [4, 0]], [[4, 0], [-1, 2]], [[-2, -2], [1, 0]], [[0, -1], [3, -3]], [[0, -2], [-2, 1]]]> : tensor<5x2x2xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<5x2x2xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0x0000000000000000F9FFFFFF010000000100000000000000FFFFFFFF0000000000000000FFFFFFFFFEFFFFFFFFFFFFFF0000000000000000FDFFFFFF04000000FEFFFFFF03000000FBFFFFFFFFFFFFFFFFFFFFFFFBFFFFFF00000000FCFFFFFF010000000400000002000000FFFFFFFF01000000FDFFFFFF00000000010000000100000002000000FBFFFFFF000000000000000001000000FBFFFFFF030000000300000000000000FAFFFFFF03000000FCFFFFFF00000000FFFFFFFFFFFFFFFFFDFFFFFF04000000000000000800000000000000FDFFFFFF00000000000000000300000000000000FBFFFFFF02000000FDFFFFFF000000000200000003000000030000000200000003000000FDFFFFFFFDFFFFFF04000000050000000100000000000000010000000100000000000000FDFFFFFFFAFFFFFF09000000FFFFFFFFFEFFFFFF0000000000000000FDFFFFFF00000000FEFFFFFFFEFFFFFF00000000FDFFFFFF02000000FBFFFFFF00000000FEFFFFFF00000000000000000000000001000000FCFFFFFFFEFFFFFF0500000001000000FDFFFFFF04000000010000000000000000000000FCFFFFFFFFFFFFFF01000000FDFFFFFF00000000000000000600000009000000000000000300000000000000020000000000000003000000FAFFFFFFFEFFFFFFFEFFFFFFFFFFFFFF0100000002000000FEFFFFFF0000000000000000000000000200000004000000FFFFFFFFFEFFFFFFFFFFFFFFFAFFFFFF00000000FFFFFFFFFDFFFFFFFFFFFFFFFAFFFFFF02000000FBFFFFFFFEFFFFFF08000000030000000400000001000000FEFFFFFFFAFFFFFF0200000002000000FFFFFFFFFAFFFFFF01000000FFFFFFFFFFFFFFFF070000000000000006000000FAFFFFFFFFFFFFFF00000000FEFFFFFF05000000FFFFFFFFFCFFFFFF02000000050000000200000001000000040000000000000000000000FCFFFFFF0000000000000000FDFFFFFF04000000FCFFFFFFFEFFFFFF000000000200000000000000FDFFFFFF00000000FBFFFFFFFFFFFFFF04000000FFFFFFFFFEFFFFFFFEFFFFFFFDFFFFFF03000000FEFFFFFFFCFFFFFFFDFFFFFFFEFFFFFF040000000400000003000000FDFFFFFF00000000050000000400000000000000FEFFFFFF020000000000000004000000"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}

