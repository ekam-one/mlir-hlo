// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xui8>, tensor<20x20xui8>)
    %1 = call @expected() : () -> tensor<20x20xui8>
    %2 = stablehlo.shift_left %0#0, %0#1 : tensor<20x20xui8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xui8>, tensor<20x20xui8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xui8>, tensor<20x20xui8>) {
    %0 = stablehlo.constant dense<"0x06050502020104020200020008000502010100040100020201040302040600000104000202010402060101060000020204020102020600010000020801010102020007030006030500010106020100010102000001000502050000010102010102060103020301030404040704010002000300000300040101010403040101010002050101020200000006010106020000050201000105000201020300080002010001030003000003040203050400030402040302020503000300020101000001020302040003010003010001020301000101020204000402020104000202000100080200000201000300030102020701030006010001010000010502010200020401030103010000010006000105010206010000020100030003060300060103010204000503020200020300020701010003000402030200010300000302030104010301000002010000020202010306040103020002020300010003050001010101010104040101000002050004000200010201000201010202020001000001000000020401050005000200030503"> : tensor<20x20xui8>
    %1 = stablehlo.constant dense<"0x07000008010107000301010400030001060103000102030001000207010106020205000705020003010200010101040004020203000002030000010006010200010203000300030205050101060302000201010103040001000003040003000105040202060001010100080102010002040205030001030105010300000000030102050603000102010100020401010402010301010000080001060000040101000605000500040304020000040102020000010300060000000103020001020100000100010500000202000504000403080201020000000003020301020300010302040104040002020103010002010202000301000100010102030103040300040401000100020101010303020200010302020407000605010500010003030101000301000000000204030000010201040405010200030003030503050202020003020402000002000102040400020207010801000206030101010002000102020101010400020303000004020104020203000203000203040103000401010202070600000400010103010003030202"> : tensor<20x20xui8>
    return %0, %1 : tensor<20x20xui8>, tensor<20x20xui8>
  }
  func.func private @expected() -> tensor<20x20xui8> {
    %0 = stablehlo.constant dense<"0x00050500040200021000040008000504400200040200100202040C00080C000004800000400404100C04010C000020024008041002060008000004084002040204003803000618140020020C80080001040400000800050405000010011001024060040C800302060804000E10020008000C00000300200220022003040101080008A0400802040000000604100C0400000A10020001050002028003008000040100200300030000301002035008000C040208180280050300060008010200000102060208000301000C010010023008000402080204000410080808001002000800800400000204000600060108041C0403000C010001020000080A101010002040020302030400000200300004050210180400000240000600030C0300300206011008000503020800100300041C02100060001002180200086000000C080C0120043004000008010000202002040C0008000602008010060002000C0500040402020210041008080000201400400008000108080008081004100200020000040000000240010A002800020018140C"> : tensor<20x20xui8>
    return %0 : tensor<20x20xui8>
  }
}
