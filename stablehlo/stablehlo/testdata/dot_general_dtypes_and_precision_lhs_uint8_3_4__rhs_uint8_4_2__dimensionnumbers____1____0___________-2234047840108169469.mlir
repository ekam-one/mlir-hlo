// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<3x4xui8>, tensor<4x2xui8>)
    %1 = call @expected() : () -> tensor<3x2xui8>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_contracting_dimensions = [1], rhs_contracting_dimensions = [0]>} : (tensor<3x4xui8>, tensor<4x2xui8>) -> tensor<3x2xui8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<3x2xui8>, tensor<3x2xui8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x4xui8>, tensor<4x2xui8>) {
    %0 = stablehlo.constant dense<[[0, 1, 1, 3], [2, 0, 0, 1], [1, 4, 2, 1]]> : tensor<3x4xui8>
    %1 = stablehlo.constant dense<[[2, 3], [3, 1], [2, 3], [0, 4]]> : tensor<4x2xui8>
    return %0, %1 : tensor<3x4xui8>, tensor<4x2xui8>
  }
  func.func private @expected() -> tensor<3x2xui8> {
    %0 = stablehlo.constant dense<[[5, 16], [4, 10], [18, 17]]> : tensor<3x2xui8>
    return %0 : tensor<3x2xui8>
  }
}

