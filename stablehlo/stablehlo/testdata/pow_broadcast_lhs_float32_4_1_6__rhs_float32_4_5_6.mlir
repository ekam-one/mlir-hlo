// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<4x1x6xf32>, tensor<4x5x6xf32>)
    %1 = call @expected() : () -> tensor<4x5x6xf32>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [0, 1, 2] : (tensor<4x1x6xf32>) -> tensor<4x5x6xf32>
    %3 = stablehlo.power %2, %0#1 : tensor<4x5x6xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<4x5x6xf32>, tensor<4x5x6xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<4x1x6xf32>, tensor<4x5x6xf32>) {
    %0 = stablehlo.constant dense<[[[-4.230721, 0.0872768834, 0.688519478, -6.99539089, -4.90538406, 1.88727701]], [[-0.808088481, -0.488422722, 0.781832695, 0.555047691, 5.83162737, -2.48740673]], [[-1.61174667, 2.33822966, 0.428872168, 1.3912617, 1.76222312, 1.6553067]], [[-0.348586202, 0.224494949, 3.52406645, 4.65594769, -3.46027589, 0.0405810662]]]> : tensor<4x1x6xf32>
    %1 = stablehlo.constant dense<"0x6979B8BFE8CD7F3F3F5E13C0C6820D40556A91C0D49E9240DAADF13F635571C0D74991C0E03E20C004BC31BF4F4F4CC0AF02EB40A506E63FB51CF7BEED8AC13E9795F83FD4AEB5BFE93A334025C73F3F726D5040CE160040C4952E40DAE7833F3B2F0FC0A2FB5540F197C03FE4B1AEC0B78D4FBF893747C08F3B1BBFC7B1B3405D17664002A9753FE55989BFF66CC9404F4484C0E18C70C0052A07C03522943FF9469A3F77FC75C017479E3FD4DF61C0D19187402E9A23C0D0FBB9BFDCE920C0F3E04DBFA2B95940E415A83F36637F3F2FCD2CC0EBA8833FC694393E2D0D93BFE93667C068E84540FB0C3C409FBD89BF07265BBE2197014015BFD23FDE252B3FBFFAB73FD06708400A28C8C0DD1DF8BD70C95EBE845F7DC038B9313FF00E27C0DE0AE43F83C2BB3F612490C0735DF13F1B1187C04A35D83FF4977940DCF4B83EC10F303EC9E807BE5A4CD340A0CE04411C8779409BF061BE93F35DC083D5FCBFD73C2D4053710FBFBCC22F40CEBF49C0029CD93F7945A43F9D42AA3FC689363F6D492540394F49BF883478BFD60FB2C0C9218440CB9610C026E3004047D562BF895C8B40A46A0EC038B14ABFDD281ABFB383933FCB32D94011F724402920A63E4CE263C05FB18AC08DE993BF41E2973ECC496040786C40C0E38899C081199940"> : tensor<4x5x6xf32>
    return %0, %1 : tensor<4x1x6xf32>, tensor<4x5x6xf32>
  }
  func.func private @expected() -> tensor<4x5x6xf32> {
    %0 = stablehlo.constant dense<"0x0000C0FF9913B33D8A2517400000C0FF0000C0FF27DF92410000C0FF91FF1946B333AE400000C0FF0000C0FFACD0063E0000C0FF16B54C3C6943993F0000C0FF0000C0FF87D9CF3E0000C0FF95C6243E9ED9973E0000C0FF0000C0FF7B4CF63F0000C0FF26D49639DA00123F0000C0FF0000C0FFD4CD0D3E0000C0FF0000C0FFBE58D33EE582113FE45E1A3E0000C0FF0000C0FF0000C0FF8140D73F8186013F280106410000C0FF0000C0FF0000C0FF307CB43EE81D90405EFE9D3D0000C0FF0000C0FF0000C0FF5A4D393FE04A0E3FFD340C3C0000C0FF0000C0FF0000C0FF0BB71B401CD7253EEBDF31430000C0FF0000C0FFA6AFB2407D107E3E8C9E9F3FBE7E1040E75C3B400000C0FF6EF7663F23E3993FCE858A3E69AFBD3F2962893E0000C0FFDB7A5E40853935420994EE3FE163BB3D81EE15400000C0FFA9F7AD3F62525D3FCA05753F9B9528424F2A83420000C0FFEC3F543F96B89641BE57053FB05194408E04413F0000C0FF80F1DD42D42F08413662E6400000C0FF1A74D03D0000C0FF9A304F4098F7963EA22549390000C0FF4F2DAE440000C0FF63777040B8367143879E053D0000C0FFA764DC400000C0FF5F942538BDA7CD413ED7D23F0000C0FF335383490000C0FF465A243FAA40A54228AF203C0000C0FF85D66B34"> : tensor<4x5x6xf32>
    return %0 : tensor<4x5x6xf32>
  }
}
