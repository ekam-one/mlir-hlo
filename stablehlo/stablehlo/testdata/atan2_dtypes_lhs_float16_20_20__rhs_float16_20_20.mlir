// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xf16>, tensor<20x20xf16>)
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = stablehlo.atan2 %0#0, %0#1 : tensor<20x20xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xf16>, tensor<20x20xf16>) {
    %0 = stablehlo.constant dense<"0xE9418C266DAEE4C3893D313E07B8673F68C295A242C8EF3D1944574004C74EBE93BF8FC140C218317342624034C4B245DA374741383C96C2B0459B3DB2C00F45083B0A367D408F40F6364E3E44B264BCE23D5A4319A957401C43164038431543A1C481C34443AD3C103CE8C0FC4488414FC1ACAFEB3D02416AC0E04501C39AC729B9134474C3CB4036BD5CC502C1BF448C3A56BA613A83C4DF3EE0B89BC00842294457C3503E134866BF0C4750C2C3C048B1C743AEBD1AC4F3BED7387C3F8AC2A7BF9643FCC0A84213BE00439B44913859C0073C19C02538D4AD73B61442AFC2C0C017C19828F7404BBE68AFB53AD4A59F42A5BAA44006BA4CC456C4A3BC923F52C2A0B4ABB80CC09FBDC53CA4418CC35BC0CC41D443A2C3073461C3E2B487BC5AB8F5B3E0434E43C03D013E7D45E2C5FC442D419342AF3D983B93C0F2428740A0BAD84305BD00C1E7C4F7C11C3EB442B13F203F563CC8384C3C7ABD8DC49CBE49BA1F432C3C2347B0BA9044A94245BB7A3F5BC4FA41B4BCCBBA8BC331BE7ABE5D425044C2C25640F83DC4B39C4054BA7F32BAC5A3C376B9CE4433B4023DB6C1763C03C564BF9A368EBD13443BBD17C4E6438BC09845C63F8DB8CDC445C0A5C04231354438B810BFC0BC1F447EBC1DBD693F9E4396B3973A263DD836923EF1B4E5C229C0D5438F41AE3A263C82C0B840303EABC1C8BE01B1F4C3A0B989BCADC284BFB5BC9FBF7AC11C3FBC3E7E4161420C36C744B1BDEC464643B9BF87C00836ADB6EB4382B049C2C03D14BE0CC268C8DCC151C001408C40C04585C1EE3C63B63D38213C4D46C6B9C539C440CFC1AD396940B4C67736292CFEBEC2365AB2E6BC46BAFEBBC63B6544CB4374C079408044713F5CB84243F0B1D23CB33DF23A4844BAB02A3414384D45753C14BCE2C95CC5B2C47D4027BE8FBAFC38EFC5F0B7C541BF3F8EC0A9C56140A8BD172671C0FF3D00BCAD33D33EDF43A640DAC17AC33743B0443CC49042FDB8363E673F99416DC3DBC4EAC2FBC46645BF42F9C412B763C045C4E9C0053B4E421C354B457E4251421A380F3BFAC15C46F845B6B90447EA43C63B8D35C04265B6F0C290BF302240C26BC302B8CDC2A5B97DC360C28D41A2B4"> : tensor<20x20xf16>
    %1 = stablehlo.constant dense<"0x9540A7C8FB40F2B937B882C1B2BECC3455C0E64474BE5DC11BB5273E0AB69D3A40C351C15238553F9043094489C1D0C559C4774218BE353F44BB9F3958C0FC447B41463C5B3E5F41163FC6C1003A86429B4050394FBC27B8FDC26BB1D2423D433B41A0B2B4BA2B44F0BEF736461E06B74F44DCC16E3DFFC1373F07420C3DB2C44FC0AAC24442DEB8DB42CA3F753810BA48BF49C2C73CECBA3EBC6BC3B3BF4523A642D8380A4181C458C17341C5B62DC39CC036C17BBC6CC3DE4131BFCCBD6F462243A1AD3542E2C50EC15B3F8DC3A6C0A6C348C1FB3D68C3BC3ED02DEC452FC36939ADC024B4DBBF4DBF134212453B42EDC03B36153D98C41940CE39C840CA381A449AB970448E3DB53DA0B6C5C2C840834131C05142783C9A443A443CC5912F8F4212C335C0004184C43CC1B0C12E34B6BCC9C244C4C546DB347C401D469BB3D3C479C54035863D08B8103899448D3B223EE5C6A13BEBBC0AB59344DABC03440740A744E8C031B4BE3F4A3423C809C681BD33C0F6C1EFC1C6BD9BC028C0783C63BF483D5F412E3ED53BA0309C448640543948371DB61B3861C474488140AC44BCC2E8C2803C0A44BC3F39C4954369C4CF2F77B74939224585BF6243E1C259417F3C36C444C1B4248FB70B430BC234C26F3F0944F132C52FF841D5BE15C20E3DE23F71414B453C460BC41AB8223B232EA043B2BE3845943183AD5CC409C011C41F44AE4165A8824453C41338F2C4AF436FC0B0BED1C58DB5E4BA743C33BD974274B83E37C8BB5A1F9DC1DF39B3BFFB3502C6E3BD1043F2C327C3C53930B55FC594C19DB7243823C0D8BD893F6F2A80400DB831BD403CF242D144873D98B54E3DA9C5413EB63CDBC5023B73BF5B436938B240B6C111C723BCBBC097451DC3A945153D8643603EBCC0C040ABC0AFC19A40084256B40CB6963897C3B9AE3F446CBDFD3D4CBEE9C20FC2C6C0C3C111B0CEC409418C48B93A9A4511C0F5BF0836D8C3CCBF673AE34038BDBD463541FB42423D59B74732CC39A5C60BC7E0C50EBC8CC434C178C554C06EB275BC51404E314A44C83F5A3E4CC4D342AD41A9B91ABF6435EC3EBF3BC93C8ABB31C02744B1C03BB429340C448DC0B63C89C307C6593DB6C4"> : tensor<20x20xf16>
    return %0, %1 : tensor<20x20xf16>, tensor<20x20xf16>
  }
  func.func private @expected() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x4A3B474228A907BFBD3F4241B3C1A43D55C0609908BF4641983EA23B80BE5ABC52C1ABC099BD8B2DA639F6374EC0BC400F427A39124148BCEB3E6D3CA2C0583AF7346F35A33BA139B533494116B432B58C38913D36C2393FB2409D3E833A323A3ABC81BE313F6034394195BD473EEA3E6BB834C2A13AE44016BB633CE6BC40C0B4C18340F9BA473FD0B5E4BC68BDEB3E7041CAC1B6380BBF3F40F5C189C0443E2C3BA1BD7A38274012C1CF3CD1BE1DC124C252407AC09DC047B8A241764086B7E1B7603E6AB9414133C1593C8440CD4140C18E4186BB0142EBAA66BD9637C9C02CBDA1C002427B40DCC0E0A83E317C9F6C4088BC483CF5C181BC9FBD39B70F3D40B980C12FB0C1BB39BA9F3FE54006BC5AB96540233B25BDFF2ABEB92BC2DEBD43B125C21F40C43BAB413E4119401BBE363FFB40F8409F320C3D5DBA2238B43EF1C10A4143BD44BCB1BE9CBD22352F3D2E3BC741CB3A61416D3FA7B453BF40B6F4B53A397B416E3E86B60C3E8541FCC169400AC0B64087C138C13DC001C1BCBB3240183D32BB9D3BEC3B22BC6B3762B5BC34F7BDAFBE69BB9F408BA70F3864B8A54159C018BC842EFCB8C04050B5CAC0293E18BFD03DCA35B2C153BB2CC1B9B9A530B740E3C13EBECCBFE93A92C180C1453A0D3AA3BAB33D8436CB414B41ACB335BC39B91939B636E0410F40C7BC1F3E2B3635C007B5D9B95FBEF7C142C1E9C0D8B649B65BBE5EB881411C3D45418B39F241A13FCEC17C3E373F31BC2FC04A2FFFC0D43DFFC146BE56417CBC47C01DBE60C157C020383E41414043BD503F23C2E8410140F53D9DC15E41373B37BEE334303F0CBFD035CB2492B5BF3440C1F7B902C28CB88539FF40663D89C05F38CC3D5C39E8C15641EEC15741FD33CE412E3968AF6C2CF434F73F053776C13BBFA9BC00BCC43E3FBFAFBBF5415BBE72AF05404D3B5AC03DC0084137C1444283BEAE410DB6C026743CE638944056C0E2BDCC40DC3F89BD723B64C13F33F2386839ECBCA9BE0EBEB5BDEB406441E1C076C162C13CC070C183418A3EBA41BC3C143E143920340F3811C1503C823CB4C0463FF23D18388135EC3C7BC13BC0D6B646429FBE01BEE2AF52C051B8B8C04FC17D3C29C2"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
}
