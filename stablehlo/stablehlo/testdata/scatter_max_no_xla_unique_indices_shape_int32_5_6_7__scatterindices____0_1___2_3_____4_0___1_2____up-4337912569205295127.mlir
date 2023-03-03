// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<5x2x2xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2x2xi32>, tensor<5x2x2xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<5x2x2xi32>) {
    %0 = stablehlo.constant dense<"0x0200000000000000FFFFFFFF00000000FCFFFFFF00000000FCFFFFFFFEFFFFFFFFFFFFFFFDFFFFFFFEFFFFFF01000000FFFFFFFF000000000000000000000000FDFFFFFF00000000FDFFFFFF0200000000000000FEFFFFFFFEFFFFFFFFFFFFFF02000000FFFFFFFFFFFFFFFFFEFFFFFF0000000000000000FEFFFFFF00000000000000000000000001000000FBFFFFFFFFFFFFFF0100000000000000FDFFFFFF0300000000000000FDFFFFFF02000000FFFFFFFF040000000100000003000000FDFFFFFF03000000FCFFFFFFFFFFFFFF0300000000000000FFFFFFFF02000000FEFFFFFF000000000000000003000000FFFFFFFF00000000FFFFFFFFFAFFFFFFFBFFFFFF0C00000000000000000000000100000003000000FEFFFFFF00000000020000000100000002000000FDFFFFFF000000000000000002000000FDFFFFFFFFFFFFFF0200000000000000FDFFFFFFFFFFFFFFFFFFFFFF00000000010000000000000001000000FFFFFFFF04000000FFFFFFFF00000000FEFFFFFFFFFFFFFFFFFFFFFF03000000FFFFFFFF02000000FCFFFFFF00000000FEFFFFFFFDFFFFFF05000000FEFFFFFF00000000000000000200000003000000FEFFFFFF01000000010000000000000002000000FBFFFFFFFEFFFFFF00000000FDFFFFFF0000000001000000FEFFFFFF060000000000000004000000FBFFFFFFFFFFFFFF00000000FFFFFFFFFDFFFFFF03000000FBFFFFFF020000000100000000000000FEFFFFFF00000000050000000200000000000000FDFFFFFF00000000000000000200000000000000FFFFFFFF000000000000000000000000FFFFFFFF0300000001000000FEFFFFFFFFFFFFFF02000000FFFFFFFF02000000FDFFFFFF03000000FDFFFFFF0000000000000000FCFFFFFF01000000000000000000000003000000FCFFFFFF02000000FFFFFFFF01000000000000000800000000000000000000000100000001000000000000000000000002000000FCFFFFFFFFFFFFFF00000000FDFFFFFF02000000040000000000000001000000FDFFFFFFFFFFFFFF0200000003000000FDFFFFFFFCFFFFFFFFFFFFFF040000000000000000000000FEFFFFFF0200000003000000FFFFFFFF070000000100000002000000FDFFFFFF0000000001000000FCFFFFFF00000000"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<[[[-3, 4], [0, -2]], [[-1, 0], [-5, -7]], [[3, 0], [0, 0]], [[0, 0], [0, -2]], [[0, 7], [0, -4]]]> : tensor<5x2x2xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<5x2x2xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0x0200000000000000FFFFFFFF00000000FCFFFFFF00000000FCFFFFFFFEFFFFFFFFFFFFFFFEFFFFFFFEFFFFFF01000000FFFFFFFF000000000000000000000000FDFFFFFF04000000FDFFFFFF0200000000000000FEFFFFFFFEFFFFFFFFFFFFFF02000000FFFFFFFFFFFFFFFFFEFFFFFF0000000000000000FEFFFFFF00000000000000000000000001000000FBFFFFFFFFFFFFFF0100000000000000FDFFFFFF0300000000000000FDFFFFFF02000000FFFFFFFF040000000100000003000000FDFFFFFF03000000FCFFFFFFFFFFFFFF0300000000000000FFFFFFFF02000000FEFFFFFF000000000000000003000000FFFFFFFF00000000FFFFFFFFFAFFFFFFFBFFFFFF0C00000000000000000000000100000003000000FEFFFFFF00000000020000000100000002000000FDFFFFFF000000000000000002000000FDFFFFFFFFFFFFFF0200000000000000FDFFFFFFFFFFFFFF0300000000000000010000000000000001000000FFFFFFFF04000000FFFFFFFF00000000FEFFFFFFFFFFFFFFFFFFFFFF03000000FFFFFFFF02000000FCFFFFFF00000000FEFFFFFFFDFFFFFF05000000FEFFFFFF00000000000000000200000003000000FEFFFFFF01000000010000000000000002000000FBFFFFFFFEFFFFFF00000000FDFFFFFF0000000001000000FEFFFFFF060000000000000004000000FBFFFFFFFFFFFFFF00000000FFFFFFFFFDFFFFFF03000000FBFFFFFF020000000100000000000000FEFFFFFF00000000050000000200000000000000FDFFFFFF00000000000000000200000000000000FFFFFFFF000000000000000000000000FFFFFFFF0300000001000000FEFFFFFFFFFFFFFF02000000FFFFFFFF02000000FDFFFFFF03000000FDFFFFFF0000000000000000FCFFFFFF01000000000000000000000003000000FCFFFFFF020000000000000001000000000000000800000000000000000000000100000001000000000000000000000002000000FCFFFFFFFFFFFFFF00000000FDFFFFFF02000000070000000000000001000000FDFFFFFFFFFFFFFF0200000003000000FDFFFFFFFCFFFFFFFFFFFFFF040000000000000000000000FEFFFFFF0200000003000000FFFFFFFF070000000100000002000000FDFFFFFF0000000001000000FCFFFFFF00000000"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}

