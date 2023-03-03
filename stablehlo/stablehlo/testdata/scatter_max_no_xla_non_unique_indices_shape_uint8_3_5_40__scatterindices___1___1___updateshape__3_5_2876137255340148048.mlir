// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x40xui8>, tensor<3x5x2xui8>)
    %2 = call @expected() : () -> tensor<3x5x40xui8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui8>, %arg1: tensor<ui8>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<ui8>
      stablehlo.return %5 : tensor<ui8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>} : (tensor<3x5x40xui8>, tensor<2x1xi32>, tensor<3x5x2xui8>) -> tensor<3x5x40xui8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x40xui8>, tensor<3x5x40xui8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x40xui8>, tensor<3x5x2xui8>) {
    %0 = stablehlo.constant dense<"0x03040201010003010404000304010202050505010002020200010304010401010201030203010101020201040505020000020103000000010500010602030201050400010305020302000305000202050603000000000100010202010400030301030301050001000200050205010200020501030005080105030300000003060306030300000203020503030101060101040104040200010400000506010201010302040302050400030101040003030300000100080B010101010101040100040502050102000300000201020500040103000003040203050100040604030404000301010103030102020100010102000300000303000501010601010003000302050200040504000000030301020002020002030100010600030200000100000000030001000300050100030003010400000202000000030101040202010301030000040302020700040003010000040000040302020004000001050202030002010302030102020100040001010200060101040400000100020103050002030301030202010001030000020000020002000304000000030301000101020300010701030102010302020401030303020302010402010002010001020003040401030303030002050300020000010402050800000101020002000002030001050202050201000201010000000803070305020404030400000500030202020203020100010600040200000202010301000004000000000200000200010501000301020204030203000103010001000003000100010301020304010200020204000004010302020101020101010004040101030104010005"> : tensor<3x5x40xui8>
    %1 = stablehlo.constant dense<[[[0, 1], [1, 3], [0, 1], [1, 2], [4, 2]], [[2, 5], [4, 4], [5, 1], [3, 2], [5, 1]], [[0, 0], [0, 0], [1, 1], [1, 0], [5, 1]]]> : tensor<3x5x2xui8>
    return %0, %1 : tensor<3x5x40xui8>, tensor<3x5x2xui8>
  }
  func.func private @expected() -> tensor<3x5x40xui8> {
    %0 = stablehlo.constant dense<"0x03040201010003010404000304010202050505010002020200010304010401010201030203010101020301040505020000020103000000010500010602030201050400010305020302000305000202050603000000000100010202010400030301030301050001000200050205010200020501030005080105030300000003060306030300000203020503030101060101040104040200010400000506010201010402040302050400030101040003030300000100080B010101010101040100040502050102000300050201020500040103000003040203050100040604030404000301010103030102020100010102000400000303000501010601010003000302050200040504000000030301020002020002030100010605030200000100000000030001000300050100030003010400000202000000030101040202010301030000040302020700040003010000040000040302020004000001050202030002010302030102020500040001010200060101040400000100020103050002030301030202010001030000020000020002000304000000030301000101020300010701030102010302020401030303020302010402010002010001020003040401030303030002050300020000010402050800000101020002000002030001050202050201000201010000000803070305020404030400000500030202020203020100010600040201000202010301000004000000000200000200010501000301020204030203000103010001000003050100010301020304010200020204000004010302020101020101010004040101030104010005"> : tensor<3x5x40xui8>
    return %0 : tensor<3x5x40xui8>
  }
}

