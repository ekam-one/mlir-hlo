// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<2x7xf32>)
    %2 = call @expected() : () -> tensor<5x6x7xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      stablehlo.return %arg1 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xf32>, tensor<2x2xi32>, tensor<2x7xf32>) -> tensor<5x6x7xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32>, tensor<2x7xf32>) {
    %0 = stablehlo.constant dense<"0x79CABE3E308D37C0BDE6883FB08B563F94E245BFB48D51401A0361C0417E97C091088040B0CC8940100A8040638E32C028DC773F046E9640520BE83E9B88ADBE9584A340913C833F313F54C0553673BE3E7995BE31E4B0C01C538340604DF23E3091B7409470CD3FF411B9C0EEEF6FC006FEBB3E3990FDBF93663CBF2C17F9BE02467E40536E53BFE6CD1E40E1089B3F67FE583F4C4D84BFA695823E665AD4BF9BEA9640549005C0EC42D040E19368401DB9AB3F8B0987407C890BBF0574D0BF97F232404199F83FDDB1204019454E3ED40F22405F88BF40D91315402525D13E4CB2383FCDB126C0A98C4F40AC2245C0587EA2C04A3CE5C08C463040051BA34021B40B4045F6714054296040C76CC33E6CAFB0BF46FB51C026684A40EC587C3F5FEF0340B3951BC009FE16C0F27E1CC0D2B6A03FCF66B93E97DA19C0FF12CDC0E3D7453FE0EA0740F359BF402AC71ABF8E6498BD6494E0BFEBE911C0E29258C0F97FC43FF10AACBDA5E3E9C070B394C0078005C0D433CDBEE9BBA2C0A7CB7EC028B052C026EC5ABFA5A2CE3F74093AC00B83E1BF8AD6F3BFF37523BDA0364E4045AFCDBF432B70BF9189ABC0D5BFAF407A3D3A3F448F26C037B84E4003C92D40EE9D5AC0BEE138405D5EBEBA9DC494C03BC8E1C0356138C0E70CD5BF3EE2043FB56A2EBC01CCC3BFD28B503F1998E3C00BA9783FEBAB41C098E8B0C0067FC43E26F79BBF9626F7BD6A967040769F29C0D63E623F39B19F40B0FD83C047F88CC0843906407B28A93E082F2ABE0E09A83E705D7F40B67E4A3FA99332407E9F19C0CC489B3F567B9F3FD4399DBF60C886BF7515F83F9DEF9140F22442C01A9692BEC79003C03E88A2BFF2C2823F33495CC0A573D3403D6B63C0A8A763BFF023084013B33D407FA410C07C2331C00F95B8BD50260A403066C13E991464BF5A401E4037E3533EAB3D54BF73925A402B572B40BA7CA0BE5BC04440202A5EC09E820B401615E5BE446B493E41A0B2C0CBC00D406FBF8FC00E8E3440D6443E400C3192BFD8ACC4BFD2369BC0BCE4B5C0D1D188406188053FC69B5840F034864009E413BFDF0C03403DF6ECBFAF64D6C022694AC095628FBF2B1CE1C001EC3C3FA05178C0225DAE40BDBCECBF77820FC0E541D640809B273FDA4D67409E74A3BF2CF6A8BD7D58E0C07E206640"> : tensor<5x6x7xf32>
    %1 = stablehlo.constant dense<[[2.77614021, -1.73843551, -0.0686655268, 0.595683873, 0.830785155, 0.720839798, -4.21543598], [1.90049899, 1.00855327, -3.55542207, 2.75239325, -1.16570818, 0.987712264, 3.57718682]]> : tensor<2x7xf32>
    return %0, %1 : tensor<5x6x7xf32>, tensor<2x7xf32>
  }
  func.func private @expected() -> tensor<5x6x7xf32> {
    %0 = stablehlo.constant dense<"0x79CABE3E308D37C0BDE6883FB08B563F94E245BFB48D51401A0361C048AC31400E85DEBF83A08CBDBD7E183F56AE543FF588383FDAE486C0520BE83E9B88ADBE9584A340913C833F313F54C0553673BE3E7995BE31E4B0C01C538340604DF23E3091B7409470CD3FF411B9C0EEEF6FC006FEBB3E3990FDBF93663CBF2C17F9BE02467E40536E53BFE6CD1E40E1089B3F67FE583F4C4D84BFA695823E665AD4BF9BEA9640549005C0EC42D040E19368401DB9AB3F8B0987407C890BBF0574D0BF97F232404199F83FDDB1204019454E3ED40F22405F88BF40D91315402525D13E4CB2383FCDB126C0A98C4F40AC2245C0587EA2C04A3CE5C08C463040051BA34021B40B4045F6714054296040C76CC33E6CAFB0BF46FB51C026684A40EC587C3F5FEF0340B3951BC009FE16C0F27E1CC0D2B6A03FCF66B93E97DA19C0FF12CDC0E3D7453FE0EA0740F359BF402AC71ABF8E6498BD6494E0BFEBE911C0E29258C0F97FC43FF10AACBDA5E3E9C070B394C0078005C0D433CDBEE9BBA2C0A7CB7EC028B052C026EC5ABFA5A2CE3F74093AC00B83E1BF8AD6F3BFF37523BDA0364E4045AFCDBF8D43F33F4618813F098C63C036273040ED3595BFB6DA7C3FA1F06440EE9D5AC0BEE138405D5EBEBA9DC494C03BC8E1C0356138C0E70CD5BF3EE2043FB56A2EBC01CCC3BFD28B503F1998E3C00BA9783FEBAB41C098E8B0C0067FC43E26F79BBF9626F7BD6A967040769F29C0D63E623F39B19F40B0FD83C047F88CC0843906407B28A93E082F2ABE0E09A83E705D7F40B67E4A3FA99332407E9F19C0CC489B3F567B9F3FD4399DBF60C886BF7515F83F9DEF9140F22442C01A9692BEC79003C03E88A2BFF2C2823F33495CC0A573D3403D6B63C0A8A763BFF023084013B33D407FA410C07C2331C00F95B8BD50260A403066C13E991464BF5A401E4037E3533EAB3D54BF73925A402B572B40BA7CA0BE5BC04440202A5EC09E820B401615E5BE446B493E41A0B2C0CBC00D406FBF8FC00E8E3440D6443E400C3192BFD8ACC4BFD2369BC0BCE4B5C0D1D188406188053FC69B5840F034864009E413BFDF0C03403DF6ECBFAF64D6C022694AC095628FBF2B1CE1C001EC3C3FA05178C0225DAE40BDBCECBF77820FC0E541D640809B273FDA4D67409E74A3BF2CF6A8BD7D58E0C07E206640"> : tensor<5x6x7xf32>
    return %0 : tensor<5x6x7xf32>
  }
}

