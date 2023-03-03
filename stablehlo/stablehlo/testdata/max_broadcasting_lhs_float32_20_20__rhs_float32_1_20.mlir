// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xf32>, tensor<1x20xf32>)
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.broadcast_in_dim %0#1, dims = [0, 1] : (tensor<1x20xf32>) -> tensor<20x20xf32>
    %3 = stablehlo.maximum %0#0, %2 : tensor<20x20xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xf32>, tensor<1x20xf32>) {
    %0 = stablehlo.constant dense<"0xA13EB2C07F231740BCB96F3F0686B73FE7788CBFBB646F40BD859FC0E7C646C0C110133FF40F08C0C0C734401A9099C0AC6208C0257FB93EB75B50BCCC87EE3D612BFA3EE8E39740D3CA43408EC98B3F296C8FBFC0291440CD6C9E405E2D523F7BA48FC04728BBBFB51C48C0173D6DBFDC3F873FB1B2A140E716113FD1FF1F4048C49A3F5ACC81BF47371740C4B4F240ACEFCF3F581626400C3630408E9FDB3F44BC9C408B6CCBC07FD9A1C0D4C9A3C0140EF33ECF668DBE4F93C23FA22DB4C08E3767404366CBBE9CE7303FAEF732C06FCD36BD5FAB413F32731ABFABCB1F3E0B32CC3FBD3A80BFA5C5B33FD5CEE7BEBB2363C0E55ABDBF976BF03EF9EB593E56D603BF73571ABE78A4A5C0D3D3DB3EED86F5BF326940C044AC75401FB79140D1E9EA3F241ABFC0E198CC3E5FEE693F9C612AC0887009C130008F40A0CB223E3C73AB3E6F720A400A911ABE335FEB40209BDF3FE64A24C0875A5340AFA40BC0750C9EC0CEABB23F5570713F9A5816BF6D0B35C091D4DC3F326287C0EDB95A3ED958823FDA9477C0E5786C408AA2BA409BEDDC3F21F0E7BE196F16BF4E7B13400C2533406A513240886090BFCADB26C00B06AF40B59A76BF5CC9CB3F99D82BC03BE8AFBF3A2E9BC0C1FE7840BBEE9340CF5E82C0218DFFBF11CE933EBFEA87C03FCC3BBF87095FC0BA4D37BF4DA711C0FD735DC00AC174C0D8F1483F790A96BFF96042403D143040F9A894BF006D37C038F8BE3F5311513FE17301BFAAF80740796442C039E6F7BF3CE795BFF423654043DF42C0EE292C3E6339B03F53904BC05055254066BA18C08687A8C08574EF3D04BEB43EA83D673FEFA769C0535B06BD9023ABC0EAF98BC0A9583E3F5160843E525F6C3E52239EBE38A472C06D844940BC4EB3BF9522D1C0346A6A40521C4CC04BCA45C030ABA83CDE3ABD3F97C83BBF29278BC0A659353F2396D6C0599235BE3BD8FBBF8E7F2CBF2952B73F8BF701C033A3AFC0918DBB3EF68751C07D542340B0DF4DBFD1782BC01D810EC0D3BA38408975B03F5D65153F4B24274007E987BF687B9DBD6070BB3F8E9181C05E48DEBF6EED6FBED694DA3F63C22CBF2090E93F4DBEDD3FBEADAEC01BAFDBBF52BD29C0A28A8F3F91E8504031BC0740CF1B42C0B1F190BE7BF7CD3F0C4F5EBFB6A292BF157840C0104D2340291161BFF44567BF48398C3FD1BC34C04A7830408D3CB53D2AF28FBF667480BF5B67B0BFA705E7BF560430BF65D7233F0A1E34C0A9283DC0C6550540438EEDBF7CA2ED3FBB98F33F3896923FC59037C0D44B92BF2424CFC01CFD9340E9338EC09638504011B72741D0AE64C00505213F945E60405D22443FB518C2407CDF81C00E125F3F750CB7BFD73A01C19DD2A3BF4CE45D3F00BB3B3D6A98C3C096E1AAC0C5F05EBE65510140912C8D407EE093BF9F313FBF26C590C0DAB2B5BF26F49DC04CD5A940960DBE3F882205405A8C94BFD733804050256440249FB1C0A0E1BA3DF9D94440F2E2BFBFEFACFDBF26B19E3F65DDE1BEF6C17940AD6C09407F45F33EBAC413C0BE0DB1402BE14DBF8ADDE6BF9DF2B0C03BE58AC0663A20C02392DB3F67B1FE401A08E53FF218A63FB9516ABFE0F6D2BF8C0887BE183EADC0339B89BF1D21804092592640264A4D3EC3D00640508CE7408201B6BE83E9F43F9A6DA2C0A84A67C05F817240949B37C11FD19DBF86AF89BF2F35A0C0AB120DC0AFD746C00A64F3BFCBC4013FD42BBC40CB960A40CFAE9440DC1AA4BF4AB4BF3FDD3895BC1C6A9BBF71AA2640349D83C0FE7BBB3D5813FA3F34E3B040E7BEBD3EAFE80CC027BE8E3F8359A93F67D75040207A45BECD3D3FC0C6B589BFDEAB08BF419A943FC9EB5C40E193CCBE36F22FC0CD2EC6BC1EACB040CE5C0CC0DABD30C0573682C04B4DD4BF149A4BBF23D3B13FF369E5BE202A7FBE41C5FD3FDE8DB43FF3FA0E40EA4A0CC0BA93B2C0D04C17BF408F84C0E6A73EBFEA64B33F6C789AC0E4D1CD3F08125340BBDCEFBF16D1374066DF3F40B2E44CC0DA9C64407B4196C00C0EE43F49F62440AB3D90BF88B731C053B61DC0D9A2D7C03F66A1BF14FA73C02FC98ABE73DFF6C0178F07BF12F68DC034C60140E9AB5F3E6610E2BFB0B19C40625099C0CEE0F03F74F33440B5C2A4BE973AE73F00271240F85737C09A676E405EADA5BECAD4ECC0F1B4DC3F70E136C034645FC0C0EC26C054945DBF702D80BE3AC09CC0AC60EA3FEF950D40F058ADC0F08613C060FE08C0EF45203F"> : tensor<20x20xf32>
    %1 = stablehlo.constant dense<[[-3.17403936, -7.59059858, 0.84063077, -1.09313357, -0.96021521, 4.93427706, 2.56029844, 3.56642127, 1.01271558, -0.455085367, 3.52074981, 6.38165045, -0.356096476, -1.33793724, 2.51948714, -0.494770288, -3.20866251, 0.299662471, 3.39117241, -4.52386761]]> : tensor<1x20xf32>
    return %0, %1 : tensor<20x20xf32>, tensor<1x20xf32>
  }
  func.func private @expected() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0x76234BC07F231740BCB96F3F0686B73FAAD075BF99E59D40EEDB23403F406440AAA0813FF300E9BEF75361407B36CC404752B6BE257FB93E473F2140CC87EE3D612BFA3EE8E39740F80859408EC98B3F296C8FBFC0291440CD6C9E405E2D523FAAD075BF99E59D40EEDB23403F406440DC3F873FB1B2A140F75361407B36CC4048C49A3F5ACC81BF473F2140C4B4F240ACEFCF3F58162640F80859408E9FDB3F44BC9C408B6CCBC09433573FCDEB8BBF140EF33E99E59D40EEDB23403F4064408E3767404366CBBEF75361407B36CC406FCD36BD5FAB413F473F2140ABCB1F3E0B32CC3F5C6D993EF8085940D5CEE7BE76234BC0E55ABDBF9433573FF9EB593E56D603BF99E59D40EEDB23403F406440AAA0813FF300E9BE44AC75407B36CC40D1E9EA3F8741ABBF473F21405FEE693F9C612AC05C6D993E30008F40A0CB223E3C73AB3E6F720A409433573F335FEB40209BDF3F99E59D40875A53403F406440AAA0813FCEABB23FF75361407B36CC404752B6BE91D4DC3F473F2140EDB95A3ED958823F5C6D993EE5786C408AA2BA409BEDDC3F21F0E7BE9433573F4E7B13400C25334099E59D40EEDB23403F4064400B06AF40F300E9BEF75361407B36CC404752B6BE8741ABBFC1FE7840BBEE9340BA5A4DC05C6D993EF8085940BFEA87C03FCC3BBF87095FC09433573FCDEB8BBFAAD075BF99E59D40EEDB23403F406440F96042403D143040F75361407B36CC4038F8BE3F5311513F473F2140AAF80740796442C05C6D993EF8085940F423654043DF42C0EE292C3E6339B03FCDEB8BBF5055254099E59D40EEDB23403F406440AAA0813FA83D673FF75361407B36CC404752B6BE8741ABBF473F21405160843E525F6C3E5C6D993EF80859406D844940BC4EB3BF9522D1C0346A6A40CDEB8BBFAAD075BF99E59D40EEDB23403F406440AAA0813FA659353FF75361407B36CC404752B6BE8E7F2CBF473F21408852FDBEBA5A4DC0918DBB3EF80859407D542340B0DF4DBFD1782BC09433573FD3BA38408975B03F99E59D404B2427403F406440AAA0813F6070BB3FF75361407B36CC406EED6FBED694DA3F473F21402090E93F4DBEDD3F5C6D993EF808594052BD29C0A28A8F3F91E8504031BC0740CDEB8BBFB1F190BE99E59D40EEDB23403F406440AAA0813F104D2340F75361407B36CC4048398C3F8741ABBF4A7830408D3CB53D2AF28FBF5C6D993EF8085940A705E7BF560430BF65D7233F9433573FCDEB8BBFC655054099E59D40EEDB23403F4064403896923FF300E9BEF75361407B36CC401CFD93408741ABBF9638504011B72741BA5A4DC00505213F945E60405D22443FB518C2407CDF81C00E125F3FCDEB8BBFAAD075BF99E59D40EEDB23403F406440AAA0813FF300E9BEF75361407B36CC40912C8D407EE093BF473F21408852FDBEDAB2B5BF5C6D993E4CD5A940960DBE3F882205405A8C94BFD733804050256440AAD075BF99E59D40F9D944403F406440AAA0813F26B19E3FF75361407B36CC40AD6C09407F45F33E473F2140BE0DB1402BE14DBF5C6D993EF80859403BE58AC0663A20C02392DB3F67B1FE401A08E53FF218A63F99E59D40EEDB23403F406440AAA0813FF300E9BE1D2180407B36CC40264A4D3EC3D00640508CE7408201B6BE83E9F43F5C6D993EF80859405F81724076234BC01FD19DBF9433573FCDEB8BBFAAD075BF99E59D40EEDB23403F406440D42BBC40CB960A40CFAE94407B36CC404AB4BF3FDD3895BC473F214071AA2640BA5A4DC05C6D993EF808594034E3B040E7BEBD3EAFE80CC027BE8E3F8359A93F67D7504099E59D40EEDB23403F406440AAA0813F419A943FF75361407B36CC404752B6BECD2EC6BC1EACB0408852FDBEDABD30C05C6D993EF8085940149A4BBF23D3B13FF369E5BE9433573F41C5FD3FDE8DB43F99E59D40EEDB23403F406440AAA0813FF300E9BEF75361407B36CC404752B6BEE4D1CD3F081253408852FDBE16D1374066DF3F40F8085940DA9C644076234BC00C0EE43F49F62440CDEB8BBFAAD075BF99E59D40EEDB23403F406440AAA0813F2FC98ABEF75361407B36CC404752B6BE34C60140473F21408852FDBEB0B19C405C6D993EF808594074F33440B5C2A4BE973AE73F00271240CDEB8BBF9A676E4099E59D40EEDB23403F406440AAA0813FF300E9BEF75361407B36CC40702D80BE8741ABBF473F2140EF950D40BA5A4DC05C6D993EF8085940EF45203F"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
}
