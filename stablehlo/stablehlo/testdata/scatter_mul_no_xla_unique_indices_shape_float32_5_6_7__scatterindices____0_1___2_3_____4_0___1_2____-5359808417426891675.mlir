// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<5x2x2xf32>)
    %2 = call @expected() : () -> tensor<5x6x7xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xf32>, tensor<2x2x2xi32>, tensor<5x2x2xf32>) -> tensor<5x6x7xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32>, tensor<5x2x2xf32>) {
    %0 = stablehlo.constant dense<"0xCBC610403B1132BFB107E2BF46BD94406713E0C048B4BFC0369C8C3E5B7967C054C054C0980C00BF2329C6BF5403F7BE942A8940B73CAEC09C92AE3FA40B1CBF95116C3FB27F08C042AFCABF5664663F8B743A403365C14000FDEBBFD29EB63FC6CCD2407E31A8BFC6769ABE06BB08C03384D9BEB99BB43F2B2C07C0697E9B3F8D55783E05ABAE3EB1CF7CC03E07F8BEF2E2A83E773AB33F5A0E643F0EED9B3FBE37A9BF975F083F36025EC0106E08C0F7331D403C5C183DD3B06DC0F3FA993E4A2D8B407E2C13403E1281C0D2D6CABE194BE33FAFC2C6C0A98E7B3F3ED904C1039361C06C1F34407DD618C0C62E7DC0C5AFE13F55A005401342B83FB153BBC0675D16C03F04D33FE79F0BBF9EF686C02B7601C08C9C1F402B3427405696C8BFB2DC12C0E3130C3F0CE27D4024410DC0DC5878400FD23840BEB8E9BF7E16D43F4F6F43BD8780C63F457EAFBF9FE910403AA7AFBF608B8E3F402602C06F0E00C0AD943ABE1BAF34C0299645BFC3CA233F863EC2BF5F01F1BF56CC51C0CD68E93F6BA3AFBBA79762C08376CDBFCBDA7140ADB0093FC348F33ED1623B3F23B594C007C2AF4035446F40DB77C53F6218093F44932440A08E153F7BB6B83EFDFE873FBA9BBBC09C06863F086B46C0D254A13E78914AC0B2B970BF83D474C0EB385840B9121EBF839126BFC8E1FC3F057561C0AAC66E40000FB73FF957F33F5F504040708C9E3E0EDE8340419CFDBFA73E23C0E3CA2DC06A8CF5BF4B4A63C018C3B03F65C9D83F9F95924021066CBE4A7CB4BFA1CAA43F144599C0547780BFD7B4BEBFF6F6AA40C053ED402CE019C0AA2307C0582B6BC0B354BC3F6E966EC0B4D6A43F16BAB0407AD31D3E970773BFFB154B40C8588C3FDD74EAC088F03140D6D369BF7CEEAC40AC53BEBEC90DA9C0E93C5BC06CD902BF77F4593DDEF23240768882C06A269BBFB5F317402A7410BF062A133F3AA7A93F07CC4040DB18F1BFA494163F1FD43140D5B392BF8BDFEF3F1770033C91F41840C823233F77218AC0353EB4C09A6024409FA7FFBF6DF7A43C733A0FBF06CE0C40DC2BC53F906870C02A0449C08F1C83C0AB9EFD3F2CE537409471CB3FF2BADFBF500A76C074A9EFBFB28500401D4296C07463E1C0F2B16840B3FC4DC00B8D02C0CF95F73F138CF33FCF904CBFA4404CC06BA65F3F"> : tensor<5x6x7xf32>
    %1 = stablehlo.constant dense<[[[1.01079035, 4.68589544], [6.76817274, -0.253328741]], [[-0.241685182, 1.80698633], [2.67375326, -3.2986064]], [[3.49861622, 0.788708686], [-0.451580346, 0.225658581]], [[3.96071196, 4.62050343], [-3.063980e-01, 5.76294041]], [[3.21282029, 0.0904229432], [2.2052834, -2.13251638]]]> : tensor<5x2x2xf32>
    return %0, %1 : tensor<5x6x7xf32>, tensor<5x2x2xf32>
  }
  func.func private @expected() -> tensor<5x6x7xf32> {
    %0 = stablehlo.constant dense<"0xCBC610401CFD33BFB107E2BF46BD94406713E0C048B4BFC0369C8C3E5B7967C054C054C011C1013E2329C6BF5403F7BE942A8940B73CAEC09C92AE3FA40B1CBF95116C3FA0E71FC142AFCABF5664663F8B743A403365C14000FDEBBFD29EB63FC6CCD2407E31A8BFC6769ABE06BB08C0090638C0B99BB43F2B2C07C0697E9B3F8D55783E05ABAE3EB1CF7CC03E07F8BEF2E2A83E773AB33F5A0E643F0EED9B3FBE37A9BF975F083F36025EC072E4033FF7331D403C5C183DD3B06DC0F3FA993E4A2D8B407E2C13403E1281C08945A73F194BE33FAFC2C6C0A98E7B3F3ED904C1039361C06C1F34407DD618C0B4BFE4C0C5AFE13F55A005401342B83FB153BBC0675D16C03F04D33FE79F0BBF9EF686C02B7601C08C9C1F40E487DF405696C8BFB2DC12C0E3130C3F0CE27D4024410DC0DC5878400FD23840BEB8E9BF7E16D43F4F6F43BD8780C63F457EAFBF9FE910403AA7AFBFA95A7940402602C06F0E00C0AD943ABE1BAF34C0299645BFC3CA233F863EC2BF2A8AD9BE56CC51C0CD68E93F6BA3AFBBA79762C08376CDBFCBDA7140ADB0093F61E1BF3ED1623B3F23B594C007C2AF4035446F40DB77C53F6218093F44932440A08E153F7BB6B83EFDFE873FC17029409C06863F086B46C0D254A13E78914AC0B2B970BF83D474C0EB385840B9121EBF839126BFC8E1FC3F057561C0AAC66E40000FB73FF957F33FCF6C3E41708C9E3E0EDE8340419CFDBFA73E23C0E3CA2DC06A8CF5BF4B4A63C0D7AAFE4065C9D83F9F95924021066CBE4A7CB4BFA1CAA43F144599C0547780BF374ADCC0F6F6AA40C053ED402CE019C0AA2307C0582B6BC0B354BC3F6E966EC0B4D6A43F16BAB0407AD31D3E77ED943EFB154B40C8588C3FDD74EAC088F03140D6D369BF7CEEAC40AC53BEBEC90DA9C0E93C5BC06CD902BF77F4593DDEF23240768882C06A269BBFE218F4402A7410BF062A133F3AA7A93F07CC4040DB18F1BFA494163F1FD43140376C1C408BDFEF3F1770033C91F41840C823233F77218AC0353EB4C09A602440BBEF38BE6DF7A43C733A0FBF06CE0C40DC2BC53F906870C02A0449C08F1C83C0AB9EFD3F2CE537409471CB3FBEB176C0500A76C074A9EFBFB28500401D4296C07463E1C0F2B16840B3FC4DC00B8D02C0CF95F73F138CF33FCF904CBFA4404CC06BA65F3F"> : tensor<5x6x7xf32>
    return %0 : tensor<5x6x7xf32>
  }
}

