// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xui8>
    %1 = call @expected() : () -> tensor<20x30xui8>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xui8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x30xui8>, tensor<20x30xui8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xui8> {
    %0 = stablehlo.constant dense<"0x020001000303020502030009030101010207020300020005020204060200000200000101060501000207010400020001000204020000040100020305000101010301040A02010100030002030200020201040501010001010302040201000002000400010002000404030101020201020001000301000502020302060302000303000007020204010001000200010503000102040400000103030300040401030200000500000201050500020304030100000604030100020104030400000100040604000102020104000503020100000101040000000202020103030100030306010004040202000100050502040203000101000101030002010102020100010304020300030002020400000404010001040000030105020201000400050300000100010202000202020400010101000501010801000204010000020101060004020602000100010103050100000205010303010103000002010100000102060304010100030104000203050200010604020200000000000101010100010400010606010400020001030402010000000104040404030103070104000104020102060002000001010101010003030305040201000102010503050201030006010000010002030203000002030300020004040104060201010600010000000004000004000101020101080004000201050002000407060002000401020003070201000200020206020203010303030203010003010002000100030102040201000100020500000500000102050101020200010305030201020003000600030100020001000203000403000000010103010102000102000600"> : tensor<20x30xui8>
    return %0 : tensor<20x30xui8>
  }
  func.func private @expected() -> tensor<20x30xui8> {
    %0 = stablehlo.constant dense<"0x040001000909041904090051090101010431040900040019040410240400000400000101241901000431011000040001000410040000100100040919000101010901106404010100090004090400040401101901010001010904100401000004001000010004001010090101040401040001000901001904040904240904000909000031040410010001000400011909000104101000000109090900101001090400001900000401191900040910090100002410090100040110091000000100102410000104040110001909040100000101100000000404040109090100090924010010100404000100191904100409000101000101090004010104040100010910040900090004041000001010010001100000090119040401001000190900000100010404000404041000010101001901014001000410010000040101240010042404000100010109190100000419010909010109000004010100000104240910010100090110000409190400012410040400000000000101010100011000012424011000040001091004010000000110101010090109310110000110040104240004000001010101010009090919100401000104011909190401090024010000010004090409000004090900040010100110240401012400010000000010000010000101040101400010000401190004001031240004001001040009310401000400040424040409010909090409010009010004000100090104100401000100041900001900000104190101040400010919090401040009002400090100040001000409001009000000010109010104000104002400"> : tensor<20x30xui8>
    return %0 : tensor<20x30xui8>
  }
}
