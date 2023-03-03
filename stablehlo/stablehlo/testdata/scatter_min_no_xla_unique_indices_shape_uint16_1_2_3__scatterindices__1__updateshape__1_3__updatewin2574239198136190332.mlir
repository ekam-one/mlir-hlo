// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x2x3xui16>, tensor<1x3xui16>)
    %2 = call @expected() : () -> tensor<1x2x3xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x2x3xui16>, tensor<1xi32>, tensor<1x3xui16>) -> tensor<1x2x3xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x2x3xui16>, tensor<1x2x3xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x2x3xui16>, tensor<1x3xui16>) {
    %0 = stablehlo.constant dense<[[[5, 6, 2], [1, 5, 2]]]> : tensor<1x2x3xui16>
    %1 = stablehlo.constant dense<[[2, 4, 0]]> : tensor<1x3xui16>
    return %0, %1 : tensor<1x2x3xui16>, tensor<1x3xui16>
  }
  func.func private @expected() -> tensor<1x2x3xui16> {
    %0 = stablehlo.constant dense<[[[5, 6, 2], [1, 4, 0]]]> : tensor<1x2x3xui16>
    return %0 : tensor<1x2x3xui16>
  }
}

