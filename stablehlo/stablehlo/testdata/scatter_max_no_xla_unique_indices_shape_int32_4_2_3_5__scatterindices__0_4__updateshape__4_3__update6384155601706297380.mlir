// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[0, 4]> : tensor<2xi32>
    %1:2 = call @inputs() : () -> (tensor<4x2x3x5xi32>, tensor<4x3xi32>)
    %2 = call @expected() : () -> tensor<4x2x3x5xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1, 3], scatter_dims_to_operand_dims = [1, 3]>, unique_indices = true} : (tensor<4x2x3x5xi32>, tensor<2xi32>, tensor<4x3xi32>) -> tensor<4x2x3x5xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<4x2x3x5xi32>, tensor<4x2x3x5xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<4x2x3x5xi32>, tensor<4x3xi32>) {
    %0 = stablehlo.constant dense<"0xFEFFFFFFFFFFFFFF040000000000000000000000FEFFFFFF01000000060000000300000000000000F9FFFFFF03000000FDFFFFFF00000000010000000000000001000000FEFFFFFF0100000003000000FFFFFFFF0000000001000000FFFFFFFF030000000500000000000000FDFFFFFF0200000003000000040000000300000004000000FCFFFFFF0500000008000000FFFFFFFF0400000001000000000000000000000001000000020000000300000000000000FEFFFFFF0200000000000000000000000000000004000000FFFFFFFFFEFFFFFF040000000000000000000000FDFFFFFF00000000FEFFFFFF01000000020000000300000000000000FFFFFFFF0100000001000000FBFFFFFF01000000FFFFFFFF0200000004000000FFFFFFFFFFFFFFFFFDFFFFFFFEFFFFFFFAFFFFFF0100000003000000FEFFFFFF0200000000000000FFFFFFFF050000000000000001000000FDFFFFFF03000000FEFFFFFF02000000010000000400000000000000FFFFFFFF00000000FFFFFFFFFEFFFFFF0200000003000000030000000200000000000000FFFFFFFFFDFFFFFF000000000300000000000000FFFFFFFF0000000000000000FEFFFFFF0000000002000000FBFFFFFF020000000100000000000000020000000000000001000000FFFFFFFF"> : tensor<4x2x3x5xi32>
    %1 = stablehlo.constant dense<[[0, 5, 0], [-1, -3, 0], [-2, -4, 0], [-4, -3, 6]]> : tensor<4x3xi32>
    return %0, %1 : tensor<4x2x3x5xi32>, tensor<4x3xi32>
  }
  func.func private @expected() -> tensor<4x2x3x5xi32> {
    %0 = stablehlo.constant dense<"0xFEFFFFFFFFFFFFFF040000000000000000000000FEFFFFFF01000000060000000300000005000000F9FFFFFF03000000FDFFFFFF00000000010000000000000001000000FEFFFFFF0100000003000000FFFFFFFF0000000001000000FFFFFFFF030000000500000000000000FDFFFFFF0200000003000000040000000300000004000000FCFFFFFF0500000008000000FFFFFFFF0400000001000000000000000000000001000000020000000300000000000000FEFFFFFF0200000000000000000000000000000004000000FFFFFFFFFEFFFFFF040000000000000000000000FDFFFFFF00000000FEFFFFFF01000000020000000300000000000000FFFFFFFF0100000001000000FBFFFFFF01000000FFFFFFFF0200000004000000FFFFFFFFFFFFFFFFFDFFFFFF00000000FAFFFFFF0100000003000000FEFFFFFF0200000000000000FFFFFFFF050000000000000001000000FDFFFFFF03000000FEFFFFFF02000000010000000400000000000000FFFFFFFF00000000FFFFFFFFFEFFFFFF0200000003000000030000000200000000000000FFFFFFFFFDFFFFFF000000000600000000000000FFFFFFFF0000000000000000FEFFFFFF0000000002000000FBFFFFFF020000000100000000000000020000000000000001000000FFFFFFFF"> : tensor<4x2x3x5xi32>
    return %0 : tensor<4x2x3x5xi32>
  }
}

