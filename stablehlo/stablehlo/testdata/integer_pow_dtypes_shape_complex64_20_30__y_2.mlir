// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x30xcomplex<f32>>
    %1 = call @expected() : () -> tensor<20x30xcomplex<f32>>
    %2 = stablehlo.multiply %0, %0 : tensor<20x30xcomplex<f32>>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x30xcomplex<f32>>, tensor<20x30xcomplex<f32>>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x30xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x003B1C4006AC91C0F10B9FBF71A63AC08CEBAC4038A3B3C0A44FB440D92AAA3E5D866340AE8050C0C46FBFBFDE5F33C042E19DBFC4D68940CAB4183F24A29240E681BB404CDB003F9D8DF5BE375F133FB4EA65C069B032402BBD26BF47BC164072D49EC03BBBEDBFB75E21BDC7BD25404B8FC33F8FB2F0BFF7C5DEBEF13691401388054026B6E2BDA3BB2D40F5FEFE3F4FC79340BE982040CB3EA6BFDBE3A240E2C5D03E4EA190BFCDE87DC0CD921B3FD60CC73FBF5CF53F8C4EB5BF5EFE69C0319493404379B0C0BB15504098BEA8BE73CCB6BF00C17640A7A2B8C071C6F0BFD28C6CC0D5BC753F63AB79BF8BEA2AC0ED24DCBF937F2ABF6B4ADD40AC9F38C0CE9304C0A5FD7E3F50BC823FB623D2BEC6BB05407CC756C0EA16F93F191843BFF5D3964095CBA3C0DA113440B007FB3F8B13973EEFCD62C0AC3153400DABEC3FB97B4AC03B676F4001B27BBFC82B5CC0F62AA03EA88A353F956FD8BEC9A14A40241E89401E9E14C0C5821C4083DB75BF6DE25D40B005893FD6A8F33FFA1640C0783C9E3EACA52B4024FCF33E1BD5F0BE158547C04D33E3407E0426409AA54CC0D04E00C053F8C73D5FEB524015FC9B40E958F2BF9F57EB3F60AE164035E18BBF3FF779C0FA82B3C0C86B3940BF8505C03DD88E40E6F91E40BB0DABBEEF7B4B40385FC2BDFD8087C0AD464940D576FDBE17777E3F8B7E50C0B942B2BF0FCA2A3E7B108940C2F3044037EB103FE43844401E6E4C40726D4DBFE6A289BFDDC56AC0BDC6CE40AD3E3EC08F941AC089695EBE96AFF0403E487CBFB45F923ED8FB3540759980C0007733C06FC9C23F0F09F83EB949FA3F03DC4AC040002ABFB8EF03BFC6605E40B7BFDA3FA9B9C03F44627F40F03745BF2D13BC3DAB7E61BF74EFBE3E5FC49AC03494CE3F19BEA24043F9B8BF24E504C0F9499E3FF6DFAA408C13B13F88D8413F39D05E4057DBA0C0D7B55C40704BC6BF1AEB34C028CF1EBF6A206E3FF3567BBFEA62C2BF4F340CC08EA681C0BFCAC63F8BDDF43FB6A28E3FB6E2B7C091C470405038874036C765406169A43FA5C8C4BF1D8B93BED8B0684092E624C0CED00BC040A88C4018BC7C4021AE7740FA32ACC0C9135EC07E2946BFB9E65A3F87CA0C3F9BF13340C95C4E3FB27121BF4F1AA9C0C7C1C240E7209F3FE8FA4D40B8506240FC4486C0EEB5594094674C4055943E40874303C0C4B30B4009B921406DC0693FBD0DCA3FB9E564BF8E3042BEBED07FC06BE05C40E8BAD13FAE1933C06F4B01419B5A873F664870C060009B3F8AC535C08D3C41C0B3DEA3BF7B2646BF77AE3940E7AA80406F854C403FFE81C0D8F6674045C4AABF0FB550C0A7571CC03715AA40C044B63F373998C0730F62406F3084BFB3AB56408B8412BD65DD95C0FC347F3D04967C3FA7F82840E56457C098ADE5BFA9D8DDBF59E58DBEADA823C08643803FA07E44BF8E985BC03D00C43C94C07D3F2BA6A6BF6741DDBE93C474C02A9BA1C01E421840A1326FBF805B9ABF964C8B3EC57409C02E2863404DA57A40F5AAAF3F90BEB1BE95CA79BEE867FABE68B1A43FCD0330C0759D5340D473AAC06D873E40D4E2E0BF206A5EC074238AC091A6D140F08A5AC01AC22A40A6D4B8BF4CB7FABF1597BB3D79238140858FA03F6EFFFDBF4045E0BF51687940631E693FF63E79C0A8EBA83F6BA10A40B6E5FBBF6502A1405745C23FAB9B683D15B2DF3F8F5E54BF7EF7753EEFB2883F7E0E553F4EED2CBFD854E33D422F9E3F907B85C0379C6D40D66DA6BF424C9EBEADD40BBFE95C00403A769DBFBE321E40FD3B264058AA9E3F30641BC08BC03FBF31511E40D4532FC0BCB2C4BF5D2814C188EEB53F24E557BFB98BA44002C9C33F5399D83F89986DBFC49EFCBFFCB6903F065051C0E95EB0BEAEA1F2BEFF9EC7BF3043D2405F40C6BF008120C04E137BC01CE11740DC339740CB16853F19630DBEF5C36C40FCC15AC0175240C0F8C2613FED7635BF7BE52DBF17E8FF40BCFA17C08CFCFEBE8D50D93F3441C6BE371E87403DC6CCBFEF99344079CD87C0EEF53D408AFA9F3CC165473F4BBF763FD13F02C0072C86BEF13D053E6768D33FDF914D401BBFB5BF3DFEBD3FCD7F523F0BD8D2C05EF195BED38AC7BF9A0D0E40FF41CBBFE11DF03F1CFB17C014DC973FD6E74E3EC6FFAABD914DA3BD62228140D31E123F9E4E2BC0543723409758203F6A0217404F85B93F82B68FBFF2AFD23F33AD73C03DFB44BF2D5109C01BF52A40998A83BF1F6662C0D135034074D100C08B7D693D7E7F5B3FC9A25240276FF03CE60197C042264040B7A0BE3F24122CC0976D0FC01E275CBF449F1AC06E356640A20246C0CA3291408A66DB3F0F164FBFDAD19E3F1874F73FBDB548405A90DFBE46185A405FEE28409271AD3FB56D4E401231843FF6D069BF391B5CBF6BFE0E40EDA8413E03681B40B567BC4027A2FE3FF8A1A2BFA1C3CCBF468730BECDAF23C0DC680A40F03203BFFA3C3F402053E64027EEDABD86A31AC06CDD81C0F8E302C052EEAFBFFEEEFBBEF76F12C0B8E8A63FB7CD513F1DA14A40F98A8EBFFE06DBBFAA1A99C0418986C05B407CC0B77C3340EE6505C1D946A3405809EA4086A469C021D08B4048FF15406760BA3EA5C55CC0996A07407A84E1BFDB1F95C0D9EF5A3FB1E847409BE6013F6581A5BF103378403C2EC34008ED83C0FFAEA1403C3EA8BFCB56BEBE8BC77540CFF475BFA521EF3F4F9211C03DAB353F20BA09C046133DBF67A1EFBF62B5B4BFABEA0DC0F91992BE3AF919408635C3BF090F1B40C6F218C08047DFBFCD3F883F324A67C0018D924085730BC0B7263E400318B0C0484F5840B43F0F4052FDCABFCC2D5FC027EE773E9D28D7BFEB125B3E2F0ECD40D2319D3E0FF9233EA8AE17BF75F82840C2835EC023B9503FA07E2FC0740124409A37D7BD772BD1C0EA29963DF6F22040E5DB0D3ED5E89ABFE828273FFD121440B0F092407B4CC0BFB8060AC08CD35F3FA9F6F2BF824633BF03181D40976F9EBF3FFAE83F118E02C0E8DB39C0803D4AC09F8A21C0E62E824066F5FDBFCDFB56C01A7E06BF76702640FC5B183FBBC8A5BF81E02E40306A81BDA13D8F3FC8EF0C41F9A587C0CDC4FDBF079FA03F2BA9784074C7F9C0AB9420C04AE27340AC79FC3FCEDF1C3FC254AB403CF95CC0646309C0AFA2943FD5B924C0D5820FBF9F55CC40244A93C0DF525CBF5EE93ABF5C76963FF12F03C0522DF9BEA06088BF6C98B23F31B7B03FFADD16408C6D9EBF46476BBF012EB93F4751AF3FF8442A3E8874DDC0111DE9C0F41D1E4057A4AE3F72397F40C13505410CD232C0EF3EDC3DE9255C40D7162240592A72401BF52340EDAF9ABE15D8943F63E29EBF055A5DBF942E1F3F0C16E43FEEA21BBEC5728EBFD0827E3F56E0EEBF7AA1B0C0AAC4853FC0E6DC3F03F815BFC2157A3FAB0A11405AC63240E73F51C0E9A8B040F33E773F1CB72BC08D3082BFC22B69C0360EBEBF6D0BBDBFD71940C0E92040BFCD6606C1035599BF983C2CC0355AC03E3FCAF33F5A62FA3F8937D1C0F993F4BEF344593ED5012440EB6405BFEABE8DBEDD67C53F4714FE3FF9140DC0DC11194072D40FC034AA1A40C8EF25C076800BC0AAB934BF7A470EC01063CE3FDEC8974004F3C0BF818BB13F78977C3ED6A8B0C0520C9BC0673558C01D37093EF8FCC84080CBFABB978A8A3F444CC73FB6C4ABC0A25D51BF9059BD3FFCC45940B13BD4BF0D9A73409C6DC5C0E8C2A7C0106B0A3F5A1E5CC0310DFC4090A70141D60222404C248EC04AADAD3E94F3AFC01893FF3EAEE3A4BFC5F520C0286C78C0FF1034BE667D18C0E1C1B1C0F00123BF93A2A24018E1D93FB51E15BEC39700BF117545C0A8AB3AC031EA3A403BAB26C0C447CFBE3B03A63F4913BCBEA0D3BB408A91753F81309DBED5872240021565C013DDDD3D54CFBEC0AB55B6C06ED577401ECD41BFDA4A503F1F5B9CBF25123FBF3FFF993E8646CF40C2A92A40CD924A3F633CE33EFA546A4012D5A4BF5FAF9C3F1C670240328031BFB64B9140EF748CC0E3A9444067A2C6C0E44D97C08F915E3FAF00693F0EDE1DC0135EEFBD4B960D4185A5C1BFDA2AFFBF0B4E753FCB986840EF928EBFE302F7BE9C87C8BF201530C0B7660640DFE69BC001464BBE3FB1A33EF67840400FF5393F3BA00940BDEC5D40E8B343406556D93F6767ABC0CA37F1C01741A2BFA20A38C0BBD690BF9B4B2E404F6D5DC06CF9D33FCCEBC740D30D8DC01E1C993FB76C173E35A671403B03ACBE265D4540F139E63E135BB7BF7B1123BF623DD3BF645239C075E614401B989140A3F3FEBF2B008FC0DF5933C0DA780741A145773F4639423FA9B34D40BD59FA3E415F813F83DDE9BF0CDE53C06B27CBBFE7EF793E73A4E9BF80459FBF9129923F5774E9C0CBDB0A409862B8BF67A10AC0675B983E9B47FB3F015597BFA41997407D908D3FBFF297C006BDCABFFE7A9ABF41F080C057A811C0A12330C093842CBF8712FFBD3435FA3F519C113FB2A7D8C02F6306C0A5A6F23FD20DE4BFE8FB163F186F0D406E8252BF5FA873402C2E063EEC3603C18DAA4540A5ED10C0E80C43C0176FAFC0326987402A5FB3BF3FDD083E076016403F95833E0F1988BF99CFC8408EA277C0FCE697401103D4BFCC1AD0BF6E44BF40D31AD1BFA36F49401A8CF3BD0AA6D73F7002DEBFD4CE7BC0EF6CB5BE27E2F63F4CFEF03F61F5EE3F9B3109BFE59C1A40DD4E044093D957BF4E9D09C0015E35BE953A664043A79940975E9EBEFB4C84C02C9B08BFD1912F408C6D2DBF147111BFC6DFA7C0493DC13EC57A583F6EFF213D95871C40F0B536C030B1773FD5223FC00979DFBFB73B92BF249084C0B99FF23E3AB8693F4BD726C0497A6D4059A044BF37FD77BFCF3651C0D18135C0250792BE63E2F53EC05B4A3F407A98C063373F40A18930C0B3911BC06016453E747C63400C9FC83E789C293F5B5979408538EABFDC25D4BF5FBD293EFDD3863FC8B8193FB07F9A3FED76ED4000BB4D402FADC93F3742F9BF209A3740B5F8683F3D4D8EC0789C29BF94EA87C07C87494026A046C0F61197BF5EDE63BFEB1B2840CDCE4F40FA384840E4269A407F42133E482B023F682C223FBB85923FE3632D3F24191340A948F03E1EE0FDBF4B276BBDAF9BBABF77A78EC04FFF0BBF44513E402BBA95C010FA4BC0AAC2E9BFB57B43C075AD2A40DFEE443F83E22FC0D4D1C43F417B6A40F3B73D3EFE2711BFA75997406430A4BF1FA02DBFF9C28040489CC43F4D6FCBBF08F85CC002D190BFEF60E440684C4BC011308B40D4841440F5F8183D0C8EBCBF1866D8BFFC6426BF414ECF405C5192C0707316400C9BCFC07CF765BFD7F8CC3ED77808409830653FF0FA30C0029FF43E651819BFDE8E98C0D27959400C69E3BF10C66640E242D0BF7B230A4072C158C0C7B5F93F29BAF43F8A7BF63B69CC57C0EF17993FF26F27406F5735BF45D6B63FC85D3E3EBEB3ABC0F2720241E78EADC051D21DC0E7B82A40E750BB3F5EB64FBFD67B2540304D2B3FF02E3D3F09C8D73FBC81F0BE322117403DD0024002B0EBBE843CCD3F141F96BDECA69AC0C06286C018E06ABFF2134DC09021333FC46E814070A24FBF502B03BF7A2320C0E0EF244050990C406F1DD53F51BC55C0C6101940AC576CC037794C404BC21A400CB235BFCF3ACDBF0CB45C3F6E80B6BED59FB040A01E673FB22793BFE870123FCAE9CABFB8B280406ADBD53F44D6A63FBAE07340C8C2DF3F5E8003402DA9BABE3065D03F591929C0669FF23F79597440A96B60C0477BB4BF48D107C0D63E27409AFE8EBF7D430D40C97C4ABF0400F03F68E58D40398E4EC0F67A9B3F591F14C08295AF3E3FF28940EC5C8CC0678FD2BF2B099B3E0A3EB9C05ECF71BE6AEE5240EC1C2440510144406E7311C0486C09401C978E40EE2DF4BFF6EB8D3FCBAE8340D1BD22406629EA3F78D98F3D4B1CDEC008759A3F47A2D4C0CA5A393F4AD0B6BE2C4C3E3F2027603E62916BC06BEBB5C01CCA70C06A473F3F4A1580BFDCCF5B40A8F473BFBF8D2F40B2720740FB0D88C04E54C4C049F6FD3F76EFD73FE8BEB4BDBBBF15401A3161C02EED6A401D7949408304393F1C3BDB3F50DA4B406E997340E426104051702F40DDD14AC049CBA140796FA8C065032E40126A15C083B52E40FEC1D1406B9410C0D9D7133FAC5DF83F5FD132C0F5BD563F3E3DCEBF4C9DE9BFDE27673F64161640459C2940EEB0363EF94015C074CCBABFE17B10BFE1D0C4409CD9B9C0B846693FA7671C40B9B924C030BBC63F8C3D96C034F5183F29C83E400D07D43F4D9C80C05EE883BEEE31873F3460083E9649843D6A6A4D3F23468540289A753FD7C5D73FD785833F4FE9213E07DC553F9438463F9E6082404724E83F1CEDBCBE5D46183F8D7855402679E1BE83CE003F5A3AA2BF5E85AD3E3675B33F632247C00BB28840776F983F84C474BF219E3DC0983E1ABD39BB43C0DBEC41C02D85BE3F794304C1F8538BC0EF41CC3FE112C240BF39F53FB5F63AC0BF6181BE25AEA83F14A8CDC02F2097C07C5C25404C7DCDBF8F960C40344F7540ED61893F4BAE65BF55E1CCC0237D3CC0F615C0C0387BEEBDAC150AC0648FE93F0FF12FC065C39F3D912285C02F1849C02D8B6DC0FA32AB40706E5240E34039BE3C053A4074D532C0DEB3B03F505DC63F5685833EA2DA22C05A99DC3F8B08D1BF9F6C723F26FAB8407D61CFBFB2FA22C07097983FA1DD9CBF84031BC0678BD6BE6403E93F155D2CC0A8AEC840DC29C5BFD36DF9BFB02B0FBFA18A5B3F"> : tensor<20x30xcomplex<f32>>
    return %0 : tensor<20x30xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x30xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x54396CC1CDCCB1C1A5C4DEC02AECE740BA0414C0E5AD72C2F51DFD4122B66F40D2980140894FB9C16DCAB3C0D7220641624388C1FF032AC1F721A5C1A6EFAE409853084226C3BC402AA3CFBDA55B0DBFE387A340A17BA0C11FEFA3C0F15A44C0547DA941D77E9341A78FD6C059F350BE59D799BFBDDEB7C0DA3AA3C1E1BB7CC0F5E88A404782ECBEA39D5940320D2D41B77A70417B69B941A8CBC1C1698F53C176238EBFB6E56BBF47ED75418E4D9AC063CBA0BF66C7BE40F9C635C1A4B82541BE4D12C193774BC2676627412E2909C0A8354DC1473230C1D805EE419CA7AD41C1D54B414111E3C0D4C8C5C08EB0A64011EC20403A9E124018001E4283971FC2F3235340020E84C088EF5F3F6DA156BFF3AADCC05B6660C127324D40E7D33DC0EEFC7EC0CE0141C22E3E8240E9923041A08B47C1C8D805C0ED0FEF40E73E4341B9E97EC0285BBDC1DEE32DC10478D840DD5FCFBE402AE33EC5871DC1D4502BC0E47D4F413B349FC189DBA1405A4F96C0F3FA2D413586ED40F74FACC07FD436C1081FE3C09731D43F160CBF3B7C87E5BEFAC322C2FD1231C216BA5FC0F9B684C1B74F80407373C8BEE6654EC134840042B023513E91CADEC0742A8B4079AAA4C066B781C1C5472F426B518140BC6B41C1FE185C41CD69B1419CF41FC1B3F607C025608FC14CC44D3F3F541A41474847C0D7FE19C18B3ECFC02DB2F43F04DAEDBE4B7E6041045E8E41934611C195285E4028F21841940BA4C061CE44C18F72FC402CAC034220AA19C2AE2BB9408E4C863F38675E42C3306DC1520F00C1531BD03FA2970441284EB441D230054008BABC3FDB25C7C0465546C17894333EA23A2F3F37711241F2043E41287F5AC1EA42404173C6153FDAE310BED305233FEE2E28BF574BA6413BC779C16135BE412F2E6BC104153240A657A4C0ECCCD441CA636C4149C138C171B7A84097025641C1AE0AC286EAB2C026230C41D8F7F5BEB3B893BF53D2ABBF01D93E40DDDB39C127038E41A2B19FBF4725BE40B53CFEC142E94CC175026DC03D59FE4136D833413492134149F311404CD4623F8E91D240DEE295C168C568C129A499C1F7151E3F6485F441EB55874184611542352607BEEE71A9BFC249F3C0F9EC45408112813E012482BF14DA11C1F0A580C254010DC14F090041173DA3C07966EDC18685AF3F10D5AD41AC2495405A7043C16F6CCFBF10823041723BD4BF617E38402675433F80A1AD3E0F1E8240A5B7DCC17CB0A4C0BABA12C1B35D804215B9884177114A41307C11C1685B86BFEB348941ED1A853FC0ADFD3F8AFFF7C062A6BA41E447C9C0B7B4CFC118B53541C3BB1AC18D57954096EB7E41A3C7D14185317241B0702241B26B06C203F322C14BB2DDC04F74AFC1B68BAB3E453978BFB5CDFB3DA7668BC06D2B8EC1CA035D3E3E09C74043CBCEC00C6DB53F7678D43E48E6C4BF065C3C41012128BE796936BF952F25C0670A67C13B8C5340C7C19E41BC3BC0C147C914BFF3391040FE3D91C00C9795BFF45B2FC0EA67DE4138A9E13FEEEF73BF2D0038BE3855743E9010BDC0D378E2C09C858BC14FE60CC2BDD3B840515F27C179D9D1C00508F041541AFA41A0F932C28C13A140B492F6C00E017540DBB7B7BE26666B4123FD21416C265E3F3684DE4093B765418C1DE34001CE5641C27624C1CCB5513FA96808C1611AB841DA5E7441E54243C069414B3E8567213FCF0BCCBE9C52E53E3C89E33F7D50E33EBC8F19BEE6F67DC1CEF524C1F57D41413E791AC15AA04FBED4EDAC3EF199204086E89DC0D7F222BFF2734D4198798BC0779EC0C088DCB1C04D2B6DC05896A44097B606410A73A7422C95D2C10ED6CDC1A0C40AC1041D06BFDCA6A540022842C081756A402BB016C141A5ECC0DFE6D8BD1C29A73EC3F722C2D1F4A3C161FE78C04498F84087231C412AF594C15AF6A941CF361D41CCAB5AC195C382BFDCCE2940A357A441D4ED8C3EBA07A0BFB0F77DC23DD52DC1AE83AC40B460174019E12E40A74BA8BF635074416B2958C195C020C1439CBFC17EF30C414F6BED3DB109A5BEC730C03F2F5782409C87883FDE7F2DC0C910DC3E00D1044198F111C1CF77C33F67391C40564F2D4212FD76403FC31FC03673DDC036597FBF98A5BEC0B46987408A4FB4C0C2AB0A3DAD340ABD523A82C10AC024BF58D7DAC0ED8E43C02691C34020764C4072DD5D40C3DEDA40756FB9BFF98C6CC029795E41C07FBB40DA0922C0C26637C1AE5237C1A8A9E840EE7F1B3E860C04C16B5E3BBFAE32C83DF24B2D4111D4453E8C135441FBAFE2C14857A0C07D2100C1D30C894031B076401840E3C05D0B8BC1394230C18D9DE0C16E271240D17A31C086A90CC07F849940854F1A417C472FC03EA7944001EB8F41121409C1B7DB0B4117F26D3E2179F1BF9D1688C0B1E375C03C89BBC0ED1F6B3F32A8F5413C66BB41E7DB71BF591582403B5FD0C0B7BE613FCB428D4066DE0DC075822BC2E10E2C42AE74BAC01C3F043F469744412CCC844193D1D23FE922AD3FF93C624072F3BEC08EA315C15D10A640FF0CD8BF8FE9734044E7A64016EC20423E6EF540E3DBB0C1FCE82D42A329AAC2DCA52042EA9855C28C8B59411ED7A3418B453CC1BDBA20C088B8AF3F8895EEC047E2A741AF11FFC0F4FC1741ABE04A40F6E255C15D7620C10DA6A141C12A49C2F168BE414B8454C178C169C16DBD36C0374C24C0E0BF65C0AF709540A39B4EC0CCBC824090714B40637EC13F4527A940A2BD9A4077FCA13FD3945D4011D2EAC01281223EF34739C19773F43F43AB6DC0213BFDC0B56704C2AD8D82C0A7294FC11CDF9641CBCA14C22CAC1F40082CE3C0B4A04141CE24D8BF59E73140A51F38BF32DF234235D37B40209EA6BE8D4F42BE7BC3A3C06DDE92C10F57DBC0CC158FC042C9D140D7E009BF7EE22A426E6375BFFCC3C9402360323FB6E6843F474DCABFB6B77BC118FCA9412B3A19C08D5CCF40B6AA35C0A36D54C0761BB1C01D065CC030F1E3BF013090C0F4B588C0A0913D41D8556740613C7F41EAD24941242581C16E1F304166E361406916CD40281D4640B93DB9C0A57FE2C0F9C89FBFF1D210BE157C6E42A45B95C269C71640A4389FC08E5337C2479E72C2359D03C110FB98C163F76040DEB61A4005F68541A4E313C29DA1504089899FC0D2EEC940FBAF3840AEB49C41B0206BC2649A543E0EDDA03F7B7934C07D359AC0EEF865BF20BE843F9CFA263D2F9176400FCC80401FBBBAC015C99FBFC9302AC07496EC3F6936E93E219CA5C035A8C94211C08740BABBD740B9A655C270CE8442CC72F94078D819BF8860AD40A2638B411824F840D3189B411966A1BF8CE033BF5E0C4B3F4E6109408E7832C031D30D4016929BBF4D34AD3EEEA31FC0A57C6DC01D00EB412B9738C1C1A62840506801C05CD085C0BFB08D40E1C338C0902092C10B5BEC41699E2A419941C5401AA7AE40681A31416C1B2D419A80DAC0A7DB0D412DFF8BC2C2BC494198D7B9C0D252CE401C215FC0972DB73F76AD1BC29DA0CCC1EA903B3E4E934FBE7174C94036EB2AC0465113C0D89A5ABFC6506BBFFC050CC12B752B3F02002CC10CDC61BF228148C1CE168840FFF64440E9E915402569E5C079CFA14179CD64C1947AEE3F5F2E2F3F4D05E04074FD55429D50364140C667BF2ECC1D42CFE6C4BDE45BA0BF03B65740F526E1416C7A0C41343C16C19E12214116D13BC160F449C108482941D1608142B49638C1D6086EC0AEF367C0404FFF428F2955C116E9B3C131F2F0C16BBD6EC03784B4BF899DA4BF99DD0BC118329C41FDACB4C09784563FFC9CF341955FE2406676B741CF6A8A4143A96CBE82CF153EF67B813F75FB8F4114B5DF3FC36173C1BD55C2BF276B86BFAF4409C290FD89C0C36E533FC9C816BFCB9CCBC0D87091C1652C0EC2C35DA5BF12C58B41AC8430C26316B6BD53AF9DBFA5606F3F2266E93F7D7627C2A15F79404C82CF40D10B8740A45853C1A0005040C8B7233E84C549C0E7EE6A402FD534C0F0D7AC3F8B6F1FC2F2B4E8C1289818C2EFCDAC41938B03C1F431A8C087AF8FC0CF969CC2586304C0CFB6D7BF4A04C14063A444C123E1DE40D903813F6091893F05B0A3C0C7ED0941EC9A9AC1CCB2A3C156A280BD50FA01BE69440841A9CF8B406BCBECC0319D6E415AF5CE408B252641910DE1C1B281A1425933D5C00C4BE940975CC4C07339C5C0A2A41341D55837C16BD09C41564F5CC2B258B43F3621B53E0A4C6241B85E22C04EEC14415C7E314009B7D23F0497E93F3F29B5C058EB18415D9B74C1025EA941540580C1436A8E4109597FC21FD23DC229F9B63E169ABB3FED7521418E294940D54314C0475F6CC0E6090741B3212841B16C51C0E71B64BF803F7A3EFFDE35C08E1042424D42FDC1C47B27C0CCB2C740B3FA70C03C8C953FD82FA7C198A432C17897AAC1EC0C28C149AD863F3AAE744068E43041BDB99241B7D9E3404F666D40CF8D73C01A4DF9BE201036C28D76F6C0CAC1503F7BC2FEC094E53440818006C0D9A38640629A68C0BFA26741286C7F3F0ADD66425DA14AC2E82085C0A6D85C41CF634241589739C21213F93F27CBBFBE488CAE409D959A3F5DFF18C2E38355C142FCF1C052F012C2C630CD3DAF58AC40613A0442E83A9CC192461E4135A33FBF98FE2DBE0A04BBC0EEAC754162743240009A333E4269E840A4AB4C409F0F00C0BCFDC73F0FD11F412C677AC024106840D38C4EC1F61BA3BFC5AEB741031C3EC0CA7786412D328D40B621E24057E16DC06696D9C1CCBFBE40099812BF6268233F3B5EBFC0E61A463E78D9E64001C8B0C0F2DFBB40B6D92641CFB17DC14172174147E41BBFF9815D3F771FDFC003C59AC15D69B2BE3379BE3FDB262940D8559441F4DE18BEF9418CBE26A3B0C1390EF1C052B1A83FE1DC83C10CE4BB406F896FBF0FB1474190463240F3D86BC16434A54096F2193F7219C240DC808ABF5DCBB23E8D548CBFA98BB93F28F03242B2D53E42EEA0A7BF9D5DC4C0F7DAEC400C16A7408EB09A41EE8FBC40F4FE014139FED5C193D20341CC6CEA40CC6EC3C0C7A295C04070413FD087A241467BB941BF58B13FFC3012BEF0EB243F15035A3F167BC63F81FFA14052110A40BF8E7B40B333693E98FB8DC1DBF84F41C7B308C1DB2750C06CC23B41C399EE416DD1BFC03D803241D5A5D040104C8340F305A640963907C1F53856417CC5AD3F5263B0C1D9A2ABC02CBB973FCBB6DE3F4A4E5D41C3C74541D15016C1C0982F41119E46C2FB3081C1AA420DC15111DDC14748AC40997E313E022E30BF0C639F40092F26C285BE06C1201876414DFBABC1C9212542657E3A414F608CC0E689DA3F010EDBC011729EC02D7904BE584A12BF1EE83241B39901C2A0871DC152004DC155BC00C0D6C1E0C07744F540116E53C178F26940FDA0EB3C94051F41580D01C1E5F7CA40AB366DC0205F004002F6073F28BA16C2BEFCAEC216AFBA4174FED5418B2C9F4009D6F940AEE0C0C0054586C00D71C9BDCA2E7D3F63C22740E3B8CABF2E00B33F95731A4130FA16C0A8F3BCBF81CFBAC12961353F1B5B8641CD97F64074731C41D57F8FC0C43C7B4162F5D1C010F2BFC07F1A24406261E83FEB2B3541691806C142EE31C16A59FDC0E24F8DC127868B4036387741ED4904C051A911403CBF1D3FB9561DBF0F33ED415A751F4178957E3F145BA8BF62975AC11B054CC18DD88B3F455F8B402B6F3741512A55416FD8824056C4BFBFA9928AC06FA709C13EBE2FC1B99467412FED2441C5371E4196D214C0B87531C136EE67C0DBCF9DC0BDF538C000D53DC0D6F01341DDFAE4C1E96278C040ECB3C07EB993C1523A3D4095458441B4E56641D5AC05C2655E60C09CE72CC14E3DC7BFC97333C0F94D7B413BEE0D3F97281CC106BB81419C0188C1FA457BC14C01124170A34740D2DB144108B040C2F89C79BF1CCA2AC2D44A80C14722CB3E5B5D04BFE030013FBC9FA63E5E2B96C16B662742DA8C5941F7E9B3C0F8B72CC16BF4DBC0E7B6D3C0534BA7C0439159C1A8F88FC127D2064232C4C2C17BA43540667598BE33FDDCC03CBA83C12C1C64405EE3B8414F501AC094711E405CF18AC067FAC141E63B1CC0A99345416F5578C10A2F00C2B080A24100FCE4C1681A00C011F04BC18074174275EDECC13A9D5BC0336F0F40624BE340B5FF95C05A243CBF7634BC405FE595C094858740A5BADF40A414723F0DC55340D1D0D940550A16C27829DEC0F5990342665A29C1E8FF26BFBE4749C19B0F9DC1EB4269C1777708C129FB6340C78B56C1F50955C1724C86BF87520BBF763D5E3C9CF18C3C4A9D85C121E1D54099EBF5BF45024F4046F1833F135EA63E7E62C93D7197A53FA2F8544112746C416BE15EBE6CC1E0BE7AE72E41FA033CC03934ADBF1640A3BF8DE6ECBF6747733F231009C186A9D4C1050B013F41BF11C00F6D0C41F97E643E31F12F3E3E459441FD3C84C2C4DDC4C17149834198555EC125720442D8E7B941DE85074168FBBC3F4E441EC2338287C1940B7A41AE3CC3C12BE20FC0C0B2E1C035A2584139A50341A1BF20C20ED13741E2DDDAC1066E0D42AA8794C09DA2003FC14B87C0F38420C1686D8AC12C2C26BF04D079C0B798BA41997D8E41ACB90C428CA506C1EF9C86BF27DFBC40CCE0F6C05E7B154022D24B3FD04D604071550CC12195E23FC5F245C03C51F641B6D895C1670AA240864AC2C016AB8BC0B0F8BD4056DA48C0B847C3BF104E00C2511E07C2C25AB6BF4C1AC0404A69D8BECE8F75BF"> : tensor<20x30xcomplex<f32>>
    return %0 : tensor<20x30xcomplex<f32>>
  }
}
