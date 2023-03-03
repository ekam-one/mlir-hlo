// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<2x7xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2xi32>, tensor<2x7xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<2x7xui16>) {
    %0 = stablehlo.constant dense<"0x020003000100030001000300000000000100020002000100010004000200010000000000000002000600020003000300020001000200000003000500030004000000050000000100010005000800000001000200070004000200010008000100020000000100030003000000000000000200010001000500010000000000050003000500010001000400000003000100020001000300010000000100020001000400020001000100000000000200050004000600010003000000030004000200030003000200020001000100050000000000040002000100010000000400010002000000010002000100030002000500010002000100010002000000020002000300010001000100000004000300000001000000000002000100010003000000000006000100020000000000010004000100000004000300040002000300060004000200000000000100010002000300020001000300020002000300040003000100030000000000000001000000010000000000070001000100020002000100000000000200010001000200000000000300000001000700030001000100000000000100"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<[[2, 6, 4, 2, 3, 6, 2], [3, 1, 5, 0, 0, 0, 3]]> : tensor<2x7xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<2x7xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x0200030001000300010003000000000006000800040003000600080002000100000000000000020006000200030003000200010002000000030005000300040000000500000001000100050008000000010002000700040002000100080001000200000001000300030000000000000002000100010005000100000000000500030005000100010004000000030001000200010003000100000001000200010004000200010001000000000002000500040006000100030000000300040002000300030002000200010001000500000000000C0002000500000000000000030002000000010002000100030002000500010002000100010002000000020002000300010001000100000004000300000001000000000002000100010003000000000006000100020000000000010004000100000004000300040002000300060004000200000000000100010002000300020001000300020002000300040003000100030000000000000001000000010000000000070001000100020002000100000000000200010001000200000000000300000001000700030001000100000000000100"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}

