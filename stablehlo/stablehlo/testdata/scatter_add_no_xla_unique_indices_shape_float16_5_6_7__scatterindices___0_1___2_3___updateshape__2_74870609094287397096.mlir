// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<2x7xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.add %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2xi32>, tensor<2x7xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<2x7xf16>) {
    %0 = stablehlo.constant dense<"0xA4418F3EA33A55C354C440333E440EC6CF3E74BD9FBA2EB60BC9D8C214BB59BEC5C49D3E5DC688BF1CBAD0C438C2EA40E8C00FC2A2C4573E4EC1FDBC3B38343DFFC4BBC1BFBDAB41793F6C44543F59C3813755405CC5054603BEA4BEDD3D433CDCC416C39E3DDF4625BE8B3F0FC5E042B53D9BC1FF4445BBBDA9D8A9CE41873DCF3F83B83247CFBCDAB90F3DA3BB12B8F5BECCBB0F3A5A41D83D7038DE42EE445B4249B5F7C79CBE8AB86F4064BF7C398E44B2BD864016456EBCD5429F3DD540FE43F5BD65342E3C883C5DB60CC27BC2C9BA75C0BA320348A04148B537412541834202C67BC13CBF7D2F1DC2343591A9B2BE52418244E8B1B3BCDCA99ABBE3445DBFB83E834033C403C0C325233D4EC0423F05C4DDC045469BACB542BA3D273AD3C4A344F1A5BA3868BDFB400CB10ABF77C575BA1EA9CDB74AC569448841D1C7C6C5CC3A0C358AC12CC562C27BC332BE9FBEBFC11241F940274438C0F8455ABD3D394A4141BA6DC4933F7BBBCFB957BE5634CC3EC2BDED3D07C527BB623994B7904272C4ECC02B431D420DBD0844DD45AC32CD3942447CBFBC3EED429ABB363F873A7B41"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<[[-4.787600e-01, -5.312500e-01, -3.513180e-01, 2.961730e-02, -1.333980e+00, -3.037110e+00, 1.900630e-01], [-4.871090e+00, 2.183590e+00, 1.451170e+00, -1.994140e+00, -1.268550e+00, -4.988280e+00, -1.076170e+00]]> : tensor<2x7xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<2x7xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0xA4418F3EA33A55C354C440333E4489C6AF3CDCBE62BAE2BE90CA77C214BB59BEC5C49D3E5DC688BF1CBAD0C438C2EA40E8C00FC2A2C4573E4EC1FDBC3B38343DFFC4BBC1BFBDAB41793F6C44543F59C3813755405CC5054603BEA4BEDD3D433CDCC416C39E3DDF4625BE8B3F0FC5E042B53D9BC1FF4445BBBDA9D8A9CE41873DCF3F83B83247CFBCDAB90F3DA3BB12B8F5BECCBB0F3A5A41D83D7038DE42EE445B4249B5F7C79CBE8AB86F4064BF7C398E44B2BD864016456EBCD5429F3DD540FE43F5BD65342E3C883C5DB60CC27BC2C9BA1AC7CA40BD488C3A65BEC3C0FC3D834202C67BC13CBF7D2F1DC2343591A9B2BE52418244E8B1B3BCDCA99ABBE3445DBFB83E834033C403C0C325233D4EC0423F05C4DDC045469BACB542BA3D273AD3C4A344F1A5BA3868BDFB400CB10ABF77C575BA1EA9CDB74AC569448841D1C7C6C5CC3A0C358AC12CC562C27BC332BE9FBEBFC11241F940274438C0F8455ABD3D394A4141BA6DC4933F7BBBCFB957BE5634CC3EC2BDED3D07C527BB623994B7904272C4ECC02B431D420DBD0844DD45AC32CD3942447CBFBC3EED429ABB363F873A7B41"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}

