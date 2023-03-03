// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xi16>
    %1 = call @expected() : () -> tensor<20x20xi16>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<20x20xi16>, tensor<20x20xi16>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xi16> {
    %0 = stablehlo.constant dense<"0x0100FCFFFEFF0000FDFF0000FFFFFAFFFFFFFEFFFFFF0100FCFF0200FEFFFDFF020000000100000003000200FCFFFFFF0500FDFF0100FBFF01000000FFFFFCFF000000000000FEFF0000FFFFFEFF0500010000000000FFFF01000000FFFF0100FEFFFFFF010001000200FEFF0000FEFF010005000100FFFF0000FEFF0400FEFF000000000000FFFF020000000200FEFF0000FFFF0000020001000000FDFFFEFF000005000100FDFFFCFFFDFF000002000300FDFF0100FEFF0200FDFF0100000003000100FFFF0000FFFF0300FDFF0400FEFFFFFFFCFFFFFF0500FBFFFBFF000005000100FEFF0200030003000400FEFF000000000200FDFFFCFFFFFF02000300FFFFFFFFFDFF0000FDFFFAFFFDFF00000700FFFF020000000200FBFFFFFF0000F9FFFDFF000002000200FAFF020002000400FDFFFCFFFBFFFFFFFFFF0000FEFFFDFFFFFFFCFFFFFFFBFFFEFFFDFF0000FBFFF9FF0000010002000100FDFF0100FFFFFDFF000003000000FCFF02000300FEFFFFFFFCFF0200FDFFFAFF0000FBFFFFFF00000500FDFF0300040001000000FEFF00000200010002000200000006000300FEFFFDFFFFFF0000FEFF040001000400FCFF010001000300FFFFFFFF00000000FEFF02000000FEFF0000040000000300FBFF0300020000000000FBFF05000300040003000100FEFFFFFF040004000400010001000000FFFF0000FCFF0000000001000200FEFF01000000020002000000000000000100FBFF03000200010003000100FAFF010003000C00FFFF050005000100000000000000FFFFF9FF0200FFFF0100FCFFFCFF0100000003000000FFFFFEFF010003000000FFFF00000400FFFF04000100FEFFFFFF04000000FFFF0000FCFFFFFF0000000002000000000002000000FBFFFBFFFCFF03000600FDFFFDFFFCFF0400FEFFFEFFFCFFFDFF01000300FCFFFAFF0300FFFFFEFFFEFF0900FDFF00000000FAFF00000100FEFF0000020000000000FEFFFFFF0200040000000000FEFF05000100FFFFFEFFFEFF0000FCFF01000100FFFF000000000000FFFF0100FDFF0000FEFF0100FEFF0000FCFF0000FEFF0800000002000000010002000100FEFFFFFF07000300000001000200"> : tensor<20x20xi16>
    return %0 : tensor<20x20xi16>
  }
  func.func private @expected() -> tensor<20x20xi16> {
    %0 = stablehlo.constant dense<"0x0100FCFFFEFF0000FDFF0000FFFFFAFFFFFFFEFFFFFF0100FCFF0200FEFFFDFF020000000100000003000200FCFFFFFF0500FDFF0100FBFF01000000FFFFFCFF000000000000FEFF0000FFFFFEFF0500010000000000FFFF01000000FFFF0100FEFFFFFF010001000200FEFF0000FEFF010005000100FFFF0000FEFF0400FEFF000000000000FFFF020000000200FEFF0000FFFF0000020001000000FDFFFEFF000005000100FDFFFCFFFDFF000002000300FDFF0100FEFF0200FDFF0100000003000100FFFF0000FFFF0300FDFF0400FEFFFFFFFCFFFFFF0500FBFFFBFF000005000100FEFF0200030003000400FEFF000000000200FDFFFCFFFFFF02000300FFFFFFFFFDFF0000FDFFFAFFFDFF00000700FFFF020000000200FBFFFFFF0000F9FFFDFF000002000200FAFF020002000400FDFFFCFFFBFFFFFFFFFF0000FEFFFDFFFFFFFCFFFFFFFBFFFEFFFDFF0000FBFFF9FF0000010002000100FDFF0100FFFFFDFF000003000000FCFF02000300FEFFFFFFFCFF0200FDFFFAFF0000FBFFFFFF00000500FDFF0300040001000000FEFF00000200010002000200000006000300FEFFFDFFFFFF0000FEFF040001000400FCFF010001000300FFFFFFFF00000000FEFF02000000FEFF0000040000000300FBFF0300020000000000FBFF05000300040003000100FEFFFFFF040004000400010001000000FFFF0000FCFF0000000001000200FEFF01000000020002000000000000000100FBFF03000200010003000100FAFF010003000C00FFFF050005000100000000000000FFFFF9FF0200FFFF0100FCFFFCFF0100000003000000FFFFFEFF010003000000FFFF00000400FFFF04000100FEFFFFFF04000000FFFF0000FCFFFFFF0000000002000000000002000000FBFFFBFFFCFF03000600FDFFFDFFFCFF0400FEFFFEFFFCFFFDFF01000300FCFFFAFF0300FFFFFEFFFEFF0900FDFF00000000FAFF00000100FEFF0000020000000000FEFFFFFF0200040000000000FEFF05000100FFFFFEFFFEFF0000FCFF01000100FFFF000000000000FFFF0100FDFF0000FEFF0100FEFF0000FCFF0000FEFF0800000002000000010002000100FEFFFFFF07000300000001000200"> : tensor<20x20xi16>
    return %0 : tensor<20x20xi16>
  }
}
