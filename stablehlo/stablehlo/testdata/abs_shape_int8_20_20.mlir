// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xi8>
    %1 = call @expected() : () -> tensor<20x20xi8>
    %2 = stablehlo.abs %0 : tensor<20x20xi8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xi8>, tensor<20x20xi8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xi8> {
    %0 = stablehlo.constant dense<"0x03030100FB02FE01FEFDFFFF00FCFC00FE00000300FF00FEFFFEFE020600020100000802FB0105FCFC050300FF020100000000FFFE020002FF00FF020300FD040100FF00FD0205000000FEFE00FF0104FF02FEFE0000000307FBFB00FD02FE060100FFFFFDFDFE01FF000005FD000302FE000707FF00FF00FD00FDFB00FEFE000001FC00010402FF0001FF0104FC05000000010102000600FFFE060200FAFD04FEFE0202010001FBFDFF00FE04FE0003FC0203FC01040200FEFE000205FFFF05010100FF00030200030400FEFDFE03FE030301FFFC03FBFDFE000101FC04FF010301040000FC00FE00FE000100FD0603FD0300000001FC000201FE0203020003010603010000FE01FF03FF0000FAFF00FE0100FC00FE0005FD010601FE01F8FDFE0700FE000000FEFCFEFD0000FB05FFFDFC010000070500000100000500FF02FE00FFFC03FBFEFF0002FEFDFF0303010101FB020000FD000003FBFD000009000000FD03FCFD0400FFFD0601FB03FD03FFFE000004000402030101FE0000000204000308FEFF020000020001000300FE"> : tensor<20x20xi8>
    return %0 : tensor<20x20xi8>
  }
  func.func private @expected() -> tensor<20x20xi8> {
    %0 = stablehlo.constant dense<"0x03030100050202010203010100040400020000030001000201020202060002010000080205010504040503000102010000000001020200020100010203000304010001000302050000000202000101040102020200000003070505000302020601000101030302010100000503000302020007070100010003000305000202000001040001040201000101010404050000000101020006000102060200060304020202020100010503010002040200030402030401040200020200020501010501010001000302000304000203020302030301010403050302000101040401010301040000040002000200010003060303030000000104000201020203020003010603010000020101030100000601000201000400020005030106010201080302070002000000020402030000050501030401000007050000010000050001020200010403050201000202030103030101010502000003000003050300000900000003030403040001030601050303030102000004000402030101020000000204000308020102000002000100030002"> : tensor<20x20xi8>
    return %0 : tensor<20x20xi8>
  }
}
