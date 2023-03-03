// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>)
    %1 = call @expected() : () -> tensor<20x20xcomplex<f32>>
    %2 = stablehlo.multiply %0#0, %0#1 : tensor<20x20xcomplex<f32>>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) {
    %0 = stablehlo.constant dense<"0x32E7CC3F6E6E583E38AE2A4014710DC07A0BC63DFE26A73F8B7C8440C2828E40B92828C08AA7DC40446DA240C8A3A9BE38D64DBF9C27ECBF70F437C00B3AA9406A7C2740CF39ACBF27EB2AC052272740F24E95BF1EE956404EE937C02F7E1FC0CE5A41BE73F35DBF6E61AE3EBB5EF8BF918DA0BF02A1E5BFAEFA5A3F1B69A2C0CA5BC93F1EA08B3F8DD3AD408D65CCBD3C633240A19CEDBE1DC8DEC0CDFBCC40F27FB9C070ED73BF4F36B1C02B62D6BF950DB13F5D02BABFA41B2A4047DB9EBF718BA2403DA91E406DE81940943617403F9A4FBF36B28BC07FE27C3F54BFACBE92D676C0585F34C0104D6C3F1B72AE4056E6E73F81AA19C0013529C0903D3040A0A09EBF6538C440B463D6BF6E50E1BDB749AFBDD5B62FBF7C5ECDBFD50446400765C53F7CC9FA40EF2291C0CFFB95BF39C342BF9B101DBF3CF84B405B5F96BFC0EE79C061FF6BC0B6E4643F49CF27405A0BB9BDA37EDD3E4871883FB099A7BF3CC9B1BF6021403F707CA73C03AE80C0CD6C0DBF997C394086511DC05F72204050E8543F1544883FF008AFBF1A1400C030EB87BF65652DC0EABE3EC0041CDEBFE2D7CC3F90174B40CB7CFF3FBEA09CC0D9B460C0807727C0844C2DBFB047F23EE7119340EB842D40B5F9D4BFFC12BBBE2EB571BE07DC8140DFDA32C0D791D9BD95EC11C008787F3F3B31913E38B107401BE5F43E5A068940D768B3BF2DE5913E042B1140A49CE3BDDD834FC0B137F33FBFE68D3FF9B0D93EA589AA3F0E762DC0A47F87C06477073F743A52C0BF814040E049C540CA6A63C0F85758BF81C7DB3E5A510EC0D8E930C0F06346C031F9894051D55B403667283E38171A40BBB594C0564CC940E01FDE40F0684040D7C66B406AD4F2BE5FA01CC005B7563F6AE8C7BF07A842BF22D5D9BF869718401BFCAEBF6588C6C06DB57840099026407F23C3405DF340C0D100D93D26A08C3F6849E2BF88F061C057D1A03FF86AAD3F68255CBF49FC883F7E98C8404A61D24030C40A40A2824340855458403B0C91409DD21340F2245140A266803F448EA940F17896C044DEDE3F92E29D3F536BDDBF0F1797BF301D08C0BF6BA9BF05F19F40BB3994BFB4DFB23D91D81CBE4E35F2C01AB98040A70FC43F7446DE3F05BA3440784664401CD3283F83E211C04E5EC53F60725BC0592041C01D5C1DBF96F0D7BFD5ED4E3FD865A8409C289A3E93A09F409AFAA740C3AAA4BF66A4BC400BC1CA3F62BC5C3E2ADA73BF189DF7BFD5CF91C050C8B4BF4DD5993F298FDA3EE0A926401711E33D2424E5BFC2A48D40C921A6401A469EC0722BCC404FE75AC0696E41403D097B400895893FBDE10AC02E7010C00374CB3F226241BEAF006DC0F836AF3F52796040F64CE6BF2342B73FEFC06D40ACC6C7BE2E4F8EC05AAAF13E933A87BEC43ACEC04FFB83C09CF881BE8743E13F994C7040CD8085BFC49190C0360E32C00269BAC030D182C0275E693FC00F74402E123DC0C923034091410FC078D9E7BFBA216C3F9BC692C09CEAA5BFEB776240E342D9BFFF5B253F4902893FB9494DBF8F1331C07E3ACD3EB0B61EC0CC6B9140CC4B584083B9293F88B3123F548CD1C0D4E18E40737B3ABF91BF1040D43155C0C9F444C0B9FBBCC030093640E61BA940354B8340D146DCBEAA829340B9D79DC0F0D513BF65F125BFBD4142BF08E577C082EFA740546128C0ACF04D40CA623CC0919A1E3F7689C84072B52B400F3FD240ABD9E1BF3E67A5C0EFE31CBEE77FC9404A15D8BE5FD62841FE2D943F76768E3E7C3836C0735E3BC05B6BB9BF61CF93C09E8F58C09004723F9F2FD6401FAF9CBFA16910C0EB7811BE741E923F139F173F9DCA9CBF30D7ABC0243EC14007EA1C3E9D74A7C072A87A40C387003DCE91A73F9B1127408EDE823FA20BFAC0043B57BEDCE882C0261495C000CE703F357B39C0135337401BCE0C41C78B9D40B9A06FC04B3110401C8B05BE654D8F40E7830BC1FAD0CEC011F0663F1EB9853E02BE3DBD4D40A0BFCAE630C015D94C4053B6D43F44271EBFEC57C6BE0E2D8AC010F422C0E8BD4040AB46C0BEA1E641409B0081C07D9962BFA63BB4BEDE6541C01BBBD3C025B262BF3B6B58C0466AD9BFDFD9513F43EAA5BE4E0F57404A2BEC3F34D204BF4230ED3F38C21F3F19C7F83FC803B83F4001863FE865A93F9ADDBC3FFD809CBF4F4C2AC0AA2088C0AFF32CC0F006B03F43FC38BF8E7284C0579C11C03AC48240D948C3C09AF313C0E492D04098C037400745ACC08E59E8BE611E34C0B1A06AC0E15E1BC0C64CF83F19A2364074920340A9693B3E00EFC9BE6CD73AC0D135C5BFB46409C1D9D6D7BFACBEACC032AFC44026790140EE7514C0D6B8CD3F96BD603F7F0B863F71CEB0401847843E14860440CCC8C5BF985CE340F3D59C3F48678FC0930C1DBFC1DCDDBFC995F73FD6EDDDBFBB1EDEBF5424EC3D413D1540FC6EAFBF511AA7BEA945E3BF69A0E83EA3883140EDE2CEBFCA344C40FD577940B95D30C0F7C3C2C07E5BB7403C3F104077536B40A2E3A7400C3513C06953333F11759EBF875750C0B4DFD140267223409487D4406C6BBD40E81F4AC00C0AA93F0D87C5BB19CD31C0743897405EBAFF3D3A4ACCBFB0CFAB3F28A03A40D8C2DABEBCBCF4BE483C72C0F4A3C5BF936952C00449193F544183C0DB4C44C03AB2B4409BA504C11DAADFC0A82E1B4002FF204001573CC017693F3F20BFBB40B75884BF60A4C3C0DD561BC0D7C4663F7EB986BFF3950EBF1DE0163E86A25EC0B84F1AC01E7508400AE011BFAD20B0408528F83F91DC003F4868004034CB7F3F93221E40568F003ED22F50C0032194C05B6BF83E447382BF11BC60C0980B053F92F84C3DE644BABF105ABABF29816A400B4AC1BE25A3253FCC0376C0F57D0B402C5B7F403E41E63DC2E6833F500970BF7E6A1E40FAE220C02EACF13FA4D6A1C02685093E05CE5B40636C91BD3904584080079A3FA0AE0AC012CC90C0FAB9393D8090FCC0A8C905C0166B89BF5FC254BF0EA7AFBF72D8E5BF31D94CC0CB9C6B3E7B7E07BF8564DABDC71920403E7A513ED2020BC0162967C0F37C553FE1AF38C0830398BF67CB93BF9EA632C07C609CBF14C7F2BFC565033F608795C0001B094044987FBE91E3634029EFC440C3C04340F23FFABEB05002C0737A7BC0877855C0174AFABEABA4B6BFDB599740B23D8E401D0A4AC0FB81C33F8DBC81BF73D73BC07854B240B6C28A4098219640AA8ADBBF58C831C0BA8F9DC0A51565C0A3740BC01C917E3FA28C693F9AC4253F74F480C0CCDE63C0D6A8493F11AE65403F481CC0623000C09D083C3FF0FD1EC04A5B263FC7981BC05D67633E24901840D14DCE3FDA3FD6BF535A9640B21FD0BF239B3BC0D35F5ABFA2B55FC04F7BB5BE5E5A7CC0DB47014053B5ACBFFC76A0405F9B224032F5AC3FD20E16C0584348C075903BC0964362C023B0FE3FD184573E8C39C8BFE24D4A3FAE2EF8BFCE38E1BFD64194C0EA24854083D282BFE1A919405C069440F3727ABDE609A03FA0D2E23F3678A840596FBB4077B584408586393E3F5B42C055A21540CD6100C0529CB53FF2DA143F355B98BFCD87D5C00989694001BE0C3F402ED83FDF851240517E2B409B2CAF3F9DE44CC0CD346BC0AD9967C0637888C068E259409E2C7BBFDB51E2BD9E99384026ACB53E2D6E25407E9470BF0935BAC0AADD05C006545B4055D6113FA5D898BF5C494BBF0B8C85BF4F68DDC0CA6E40C0A8E1C140D0111AC011E520C04DAA8ABE5301FDBC3A0167C045DABBC0D27E68BE397016BF19758A40D529FC3FD0B79F3BCA4D11406410CFBE3C843AC01C7492C0245D24405E2103406B242140E8021D3E93680CBF4BB3913F600781BF96758B40F389FCBD657DF03FD58D11419E915C40873F10C0C23F53BE120540BDD4E28840454FA2C05C9784404611B1BF20B19B40149687C0D72A56BE67786BC0CBF480C082195AC076983A40A9214F3F5A740840F4CC91BF9DF51340A4084F407D0FA8C07DCE7140FF26A940764194C0812A02C0EB42704035B192BD96D445BFB825B13F142623419E799DBFD4A018C0F94289BEC06225BF47EA24BE7041E6BE1CBCF6C0E9FB0741C8E40D409DC825C0B2F7A43F803358C07833AF3F4580E13B700FEF3F502CE2BECFFD983ED1F922C0EC4D8E3E980B894043945CBF21B296BF6E263E3FBE2D46C0575C364019854DBDCC56BCC095EC5CC0787F7EBF32E6703F506697C0ED3F9A3F302B4E40FBE0ABBE8F055840B4355D3FDD535B40FF8E78C081105F3F6C9607406E3E0BC087C3B13E0EFFBFBF30F4BABF9F9C2B3E6835FABF3955AFBEC2504840104478C0A8B500C0106C233F1D9AA0BFD9B02640AF0654BFC79AACC02856473F613E7C40404E68C07AE9C63BB8AEABBFB2F94C406D1839BF6EA291BE39F824408B86A6BF332A6E401C5941C05DF2CFC07B4703C02C8A15C01A230EC09014ACC02C3099BF9EDD5EBF627811C0E4DCB1C0A03895C072B316C0003CDB4073304B4054F7C63FABA852C0"> : tensor<20x20xcomplex<f32>>
    %1 = stablehlo.constant dense<"0x2E699FBB72BFA5BF63625F40514D5D40AD1A0CC02C49983E9E45533E9D83C2C0825EA0C0CDD2363F7E92BDC0EAF336BF71D5FB3DA1E1723F8FD845BF045A11BF60A78540B757723F38D888405C5EE53F7379A3409623403FD6AB783F72D24240B2F2C3404728223FC4F63C40839FE6BFA9C64E40CBB3513FBACE83BFD5678DBF3058C33FD8467CC0D23934C0167F214095038BC04B112A40DABE12BF39C3DA3F9C22FABF84A371C07425A1C0475111408321F0BF51CD84C0A3E713BF73F8A4BF6BAB1740780C823F5DD88F3FAF80BC3EC84B9FC0A6E2DCC06016E540CC24603F64B501BE6BFDB7BD608C3140E0351DC04C1AEEBF645F5F40F0FCBEBF5CF12B4066E2D0C0989E0F4176F115C0606F93BF5CB4C2C0710BB1BE2F438C40356B06BF8A96A3BFF4720ABF6984C7BFFE09A1BF0879923FA9D174BD779D86BF4F954D40A1389A3FE9AA05BE6681AD4062408EC080B399C007070340E310463F9C508340A3C64FBEE74E843E57153D40A278304048872EC09C04A63FBA3588407FB9F13F9A1EA33F544F57BD352BE1BF7411F73FD1B1374018920BC092870CC196B31BC0077E81BF7301D2C0192BFA3E0BFA98BF58629AC07B7E2EBF4E2F1C3F30F46DBFA98132406810D03F84CC1F40B641DBBF7F180EBFA76249C0ECBED23D7C48B2BF173FFBBFB9020C3FBCB4893F4925953FD7DF54C0080D07408FFD40BE85E1B73F98181A3F11B06A3F9AA0A4408749184036264240C8E49EC0D30EF5BDFCD180BFCFA7563F92A9C5C0402CBF40FD9611C028E024BFC8A7E2C0EE9626C0255182C09A2F7FC08320434023757340EE60AB40CC519BC0716D2A3E55D60340723A7B40148807BE6E72F4BF5B812D3FB69BB6BE81D018C0F0958B3FC9254A3E883DB33F925BCDBF4CE1CCBF3211E53F9E6E5740B561753E5A2DCBBE1346DE3FA443E13F6089B9401FAE67C0ADBE51BF3C2B4EC0779D75C0F313C2BF964E2B3F998A59405FFB82C0E7BA9640EBBE7F3E29718C3FA5DF63C03BCE2E3F3FCA164020079FC0420CE53F6CCA30C03E22B8BFBA6993C0EBAAE43EC802CEBE8E9C67C0E84A6FC047D94340B462C4BE9FCA1B4096057A40A0735EBDF4F13CBF840DA7C0401ED0400173C7C0CC81A83F8EB880C0451F2D4055B5DFBF884F4AC025FA8FC0CA1B283F6FBF863FD1AF83BF572B6840E2894FC00B3D18C064C635404983DCBFC6E98FC07D1724C0666E11C0032A254092850140D8D9874021EA0040E888693DCB0AD5C0E71908C00EB83A3FC52140BF608C884011B880BEA6CD2340CF8A123E186C6FBF91608EBC4004DAC0BC473940918CA1C03477934080E7C9C09BC71D4098E085C0D18CAE407D2A0C4032447740745487C0E7C494C0BFF65ABF52463D40658D66C0D086B6BFA5EDBD40112C5140C3A2EAC0C30325BF550CB93E7EA9523FCAFCB1BF8FB6A0BF8C80013FE8AE2EC056B112BF18B4564041243CC0C6D6B4BEFFFCB8C04F0A8CBFD84E80C097C11F4069492340ED1242C03254D8BF34AAF1BE8AD67DBE5775CDBFDF49563F3359A240997F6D40426792BF5C49013D145FCBBD4A1BA33F7545763E1CE50440155677C075CDC8BFE49B193FA53303C0B6F289C0108038C0E005303F24E70340020E6A40FA24CFC0091FEFC072E137C0F8EF8CBE76A329BFFD5DBB408B498C3FF893B53FB5657A40F1467DC098B5724063D9053EE93E313F5BF472C0CAE98F40D923963FA2A3A9C0179EB04061D3273FBBCA82404AD307BFBFA3773F5D48A63EFE3D564065F53A3F40905EC07BE49C3E047896BC872A623FBCD11CBFE14FCD3ED0E8B4BF9F28893F99349F3F13F616BF07E613BED7E4A1BF087F034000CBA83F8C9D60BFE4ADC63DBA660C408B046D4006E0C23EAE7770407B2506BE9B020340AC11B840DA713BBFB8300640D226443E25C55B3EDF5B11C0116E4440EC699240C9410940A9ED21BEF5692A40A91F413F11793640D1D176C0F3C7DB40394A8B40951126BFEDFB1640E74BB340B32F16C0F1AFCD401588F63F397144C02FDA88C05946854044F2323D09D3A4C0B123B540C4CB10C0E0818340661B03C031F7EEBFA2A87340A27D35C0AEDCD9C06C5021C0E35B8CBDB6D3CC3EDFB4DF3F6BDB1AC0383C24C03495FE3FF479E7BF6687BDC0A74ED03F08ED1CC0854D75BF2D9FC2BE550102C094BA0AC0FD8489BD6EA596C0F860F3BFAB8907BF524CE6BF74976E3F6D0C7740F2D3E7BF105987C0B2801E409CE34E40B770AD3E43DF5DBF31E89AC0E309833FD76C8A3F033E5C3F59E60E3FFDF076C034AAA4C0D377863F5A62A63F40C1C340BA68A63E8320A7BFA805983E4D8367C09E7098C0B323843F930F00C08F55F43F3804A23F7854E9BFB27D323F34330F3F2BB16CC09D5B333E3CD7CE3D244F3CC0BD7AB1BE81512C40AE117D406AADE540D447AB400DDBB2C08EF594BFFC61BE40CE0778403CE0D8404DE57CBEA3A6983F99C6A93F4B57D5BFDE12043F2F56973F00C24140BCC3F7BEB5C9E83F53047FC043AA34C0441214406172ADBB18DC1540A0E59EBE075F53C024C1ACBFA344783D194CD03F58420CC0C87487BF8BB991BE3983F94087DDCA3FAEA1B9C06ED8D1C0F76D88C03DFF93C0BF3809C1BB8DF9BE30AC31408CB88B40BED5533E12C889C0C76045BFAAA19340E13202C0AE4385BE5572A63F7A52663DE0FA963FFF268140D872513FFF7E204015D9D93E9BD09840E4A5E83F538E4AC06D996A40A7E718C031EF6FBF9DE5B7BFA89BE74005D176402A8C9740316F5FC0F4A86BBE3800C5BD9C100040002672C0A256CC40FA3381BC89A8FABF2B7518BF5AC645C02E09A440096416C0E5E59DBEF1F5F3BE9A21BBC0040FF6BFD281C4C0140A41C06A96B44015898240190C053FBAC23C3F1F748BC0B19AD940ABAC864007E2C4C0C5B7923FA8ED89C088AD9D404C71BFBF47701F402F3C54BFC38F03BF1B2B8FBFCC6AC83F1E0292C0FEC2BE401A704BC0261880BF609A9940259F093F77DD6C409C07AAC04ED059BE7AF076400634FFBEFB05DDBF02738CC09B51A2BED3D897BFB6C8A8C000AD99BF72F9C83EA7646A40087968408B6D3140C691B93F19CA233FEDF99740372815BFE1E6B6BF4EF548BF3AC948C09779B7C0256714404A12DFBF4F9D63C0655C69408CB9354005BD8BBFC01F4840D3DEA8BCDDE89CBE3220F4BF0FA60641373133C06EF32CC0D9301AC07D9EB9BF498D6F403D94A0C02E11C0BD08811E4061F78A3F090573C0A7B69CC0D6A8AD3F58F5B13DA34800BFAE26943F99D329C07A50883FAEB4BCC0AF5704404919433F631D32C09F21AB40A52C84C07EA5523F266788BF97FFCABF6EED984017A2274027580F3FCC460EC0F5F025BF24C9E53F8D2AE3BF467C16BF1A8330C0A159A5401DA118C06519B9BFA2BEB73EEDBA9D403B6189BFB7F2BBC01DA1813F89C31EC109277AC00ED851C053AE04BE8C199DC0BFF085BF326C84BFC78AC3BF34BA09C0FCB962C0F7F8463F58AA9BC05DDDDD3D10D497BF9277C4BEB2C07F3E57C91DC00D7E97C04ECBAB3F073188C0C20B163FCD8C4D3FA955ABBFCCE2AFBF7D2B34C06A712340904893C0F21D0DC08B898E3FE9FBC6BF46052D40DBB73E402BF7EDBF442310BF4DC4FABF63FDB53F5CB8A93F24631040F2D29940AEBD08BF587BF43E63EBF8404ADF36C01CE2CDBEE3959B40F13E0AC0E40F7040CC9D7F3FE6975C404D2BAD40C3EAEBBF586B84C0F73E1C3D9B0FBEBFEE968F3F158575C01899C83F633BEB3F91AF943FDC3BF2BF0D53DB3F93819740C8EC25C079D982401B7443C07C1C19BFF013B6C03DDA353F119186BFDEABE5C0B0355F40A2897640A016C8C033D669403215C63FFADC473F089474C051027BC02FB8B5405C7312BD726DCC3F94E884C0B61D6CBFDE0F41C0FCE250BF809F133EF59EC1C0E63FEF4052EC32BF5C9D3BBE0B63DA3FAF8942C0C30C933E441AC83F5AEE87C0C3C495C048E8393F4C4B963F9B372DC022FD713F8D1A4CC054C49BBF71AE80C0E40C12BF1DEB8B3F67D7FF3F36AFA3C0C85DF5BF8672FDBDC7AF4EBF7F1ECCC05E0E9C3F48D2E1C00525513E5CF1833E66B18BC07E1883409C766D3E27929D3FBDD9A4BD9BC4A6BFF5E882BE1C885C40321E6440B190F2BF2C2E4A3F6B8333BF6920EA40AED1153F3AEA84C02E750D406E53C7BFC8C3C7BF6CA6C6BFF3C9C5BF5640CE3F52FBF03FD9B32F4016570DC01AEF98BE4190273FF92739C01A7DC0BF45659EC02C873CC0824143C01DE7A2BFD45D48C0C870F0BFCDAD193F862E1A40229F0D3F94CB783F5C3B43BEB32AE6BECEEDC23E308DBDBFC9E1ABC0D8343240C8CDC13D0F77833FDDD37C3FA7D057403360DABE118B60402C59A5BFA97D65C05158ADBF62B20EC076E0FC3E7B3AB93F2DE8C4C0CEEB5AC0C21080BEED956BC069149A3F73A286C04DD39E40B2F647401AA0014123A317C0142A1E40F9D7E2BFD174D33E4EF1ADC041718A407588D3BF7B74F6BF8218C83FD27158C0"> : tensor<20x20xcomplex<f32>>
    return %0, %1 : tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x4A24883E18BB04C0599A8741B500C13F62A019BF3E1E35C02266DF4135FBC1C1A9E40341A3BB11C22B74F2C1C713D5BFCB65D33FDB5D7DBFBD2AA740821F1DC07D4343418C1D49C03BCE80C1EB44CC4047AB07C1633B8241BD6E99404FB132C1F8671BBFAAB6ADC00C641FC001F8CAC0285025C0D75ADAC04E9BCFC0A6008940656BD6408C2891C079B870C1DACF5F417F012EC1CAC3164145A1DEC0832079C1E360F7405DFDBD419486FD41E37984C061030AC171E940C070A648C0C6592DC0584D1841CA9230418C93EA3F9A98624019C6D0C12BA2DA41BAC0EB403B77C6BFABFE703EB717343F193A7F41D9B14D419751A0402DA22C4117045DC0D96333C16CCE3BC2599A4CC24A08734091F70B40741D913ECD968640680EADC0E77766410D1F1140E6992DC1D70DB3406E0BF1401D4268BF5B1728BFA90AD83E5891374110F8A5C0B0B77BC0BF07844196DF23417844E7BEBAD210C0FD54C640C41D5740F5FCB33D93DE02BFF45F32417B2F3DC1952910C098EB09C19E2873C1FEEDC04015D38E3FBE0EA83F5396C8400E84613FC64C0FC194BDAEC025A5AF41A5EEB341C6A69941AD675BC17DFB9BC07DDD98C0BC7C7241ED467041B7E2DB3C5EFD6A3F509606414686704164F898C0540AF83F40684E41B13FC1BF6FFFDEBE8A6A7840C27F7B40C22B4DC05C950AC0FA20274021072AC1FBBB53C1BEAC14BEE14D04C041CEBB3F18CD0040649EA9C174D90340ED2CAF404EE086C098C638C0671E82BF9F4E90BEA8CAD441DF804CC1A189CB41581DE9C10C8525C291A97C4006C014400B5B8A4192BF87409A880BC2DE994CBE749885C1D8FB67BE949DB941FC86F9BD63C74641D8E94EC1867F56406259B63F93477340A170AA4051901640B5BD5D3FEA84C0BF32A27C4091E50D41BF88B240C9F3623D772A594004CDC6C07FB67241DBC588C137733841280BD3C000CE05C0F7407741F5F4073FBD1875407EF3804075A107C2E5F0A4C16CAD3CBF8328F84090F552C1DC2F1FC1AE43B1412CAC88C113E60941926CE7C0A645EAC1E8278DC16510A33F4E4819BE0C62EC3F18D52B417E82E0C052044FC06D868541CBA785417D3DF1BD05F865BDD29F5541BD738CC2FA533DC133E90CC10D0FA8C1A4AFD6C0FDBA05C18918F33FA0F395C006858341CEC773C06F461D406AEB5FC09072064105F855C169AF6341A9397041AED1FBC1988D8541630F43C1DEB369408AC470408AD116BE931922C16B9A1AC1390BF241E87E37C0DFA5FFBCCA5C1BC06F763041F40F2EC1313AB6C0E17F78C02306B2C0B64FBBC184A32DC2266AE4411CC579C005D10BC1814186C1C9028B3F64C45541A790E240E3E7A4C136F9A0412062F8407F6D194180BFA3C0654B19413A9568C1D4916240938BD8C1C67840C2490399C10405304026DCA9BFE169D540357F243FCB1366402AA2A4409B2D8840AAF38B413F8D30C184367141686693C18F03A8C13C7833C1808BB8C0FDFDDBC0656814C0957D3B41E0EB3A4161D205C01EAF9BBDE865F7BFF3B596BF8D5EC640861A88C182A8C2BEB4573640214098C00091AE40F0E683BF24DBC13F343F01421F74DFC0CA6186406D6D36403EA2AF40F6F4B641C2C31EC1437423C1278B37420AA299C169AC83411AD704C219A1793FD65C5B40A2AE3DC043E9A4C0AB37D0C17CB5F6C0F745E5BFAFB1B5C1244F50BF937FFABF436C0FC223FD8F4153D5D2BF579913C28A6CE3C1527E87C0751ACC41B91BA2C0D94E1D418580914079B04040033F15C1AAFF2941627E8440D0C044407B9880C03BD750C0D9256EC041BC84404051F03F3331FE3EF576C03F3D42D1BF8B7A12BF65F997C1CB6FAA403415BF3EDF669340B49C07415B2C6941AAF514C16B32BD4062C87D41C8754740A38A86C09F05BBC1DF2B1FC147398A3F4848BC40DB4EE6407D7B8F40FB805D42928EF5C02F91AD408E6F6EC070363D41EA2447C2A43773419AE2A140350EB7401AF33E4063EF333F8F3CFFC09E5CC341EBF13D41013045BF35388AC127916E4111C62BC1A1E746413E7373C130D98DC1CB214C41590869C1FF739DC0561FDB40FA9CDDC1494576416CED9541F7B2A0414E71963D1E46B33E5F652541C9FE9CC037AA16C03430B9C007202641F8BFE6C0A4029D405C1EE9BF470E35BF8C5DF5BF603052C06FE3004115FB46C1D7A9A14163D53FC06756253FC813194177A0713EE11597406EAAF7C14FAACBC0B52C05C2FAAD3141D57083C149B053C1F6599440595890BFEE65CEC01B9A9B3D8B6C62401BB2DFC0188F34C1885A5840111865C0394AD4C09F1F54C2987D73401A87D140278C49C13A6412C2633B523FFD9FC9405E53B33E980D47400F0824C19E6858404ACD91C0A95B08C11B748F3F87A46E3F54914F41F3F056408B0B45C11BACD2BFF4FC49C00CE2ADC14C6E044032AE52C16475DCC09C1BE8C03CBE3EC1A0236140D776AE40E738E03F6D7FEAC0191E9BC058B17241779F78C1B2E5DBC0F947154137D4223E2E48FAC1F82BAAC0FB00D13F302D7AC0D4A0E7C049B691C1334A8AC1B3AE13C1ECAA32412F1A0541A45BE53E254FAD41B8633E3F5A6C03414DB9D9C1B982814102B5FFBFBA3489C12743B8C1E8D82B41468F043F69F9C1C05DCA6AC1C3B2B7C09B9789416C6D2AC0F6290142C1F23341A0610FC1832C35C064184040BBD247C1D32A1C3F2573724198BFC5BD3247C6C107A0B5C1F3A9803F6156D4402401BC3F7D162E3E3A97B341ACB5ADC177BD2E41FACCFC40332796C1D28F00C1990582C06672503F93779CC1A4F73DC0FBE7CBC00B3847BE2B328840CE406041889C57C1D2AF79C192B40BBE9BB086BED1C2B64088FA3441D61DBDC1EEBC0BC1ACA79A41D56D98C15294E7BF0A916B4059EAEFC0637A6EC06B8734415B7D81410F36A84013FE4F4150C1C5C1409D03413CF407418C8C41C0C1FAC6BED1988CC0BC4FC0C190563340988BC6C137C73CC22FD9E740C65B0FC1ED3994400A1274C0E4C30D418F1C8B41BCBC1F3FDA090AC0439E3241B77F76C05F0F29C0DD4FE43EB26AA041EECD7EBD45DF4D40CF8E30C12ADA6240E67255C13FC20EBF8D0262C093DF91BE20EEB3C1F07350C0C099A9BF8BEAC041C7E41EC2ADB2C74059D7CEC06B8DAC41469BD140E11220C13A36104097A88BC06C1A6D418A42ECC0E653F0C0D24120416FE64CC187DCAA4168A2FFC087CABEC181D51641B98A05412D9B6141BAEE04C18E5E63C17C4D5241ECA5DC40543A973FA131753F0D7EC4402E5338C03F30BDC09EF10AC1C95594417462D840FE53CBC0B5FE7BC0D022D2C003F97AC1F5452E4019C7DC3F8D2DAE409DB6254169795341E560D0BF35D6BE401EF972408FEEDCC08126B240F172FC40A5FF1A41DE939F40D407E941EB1685C08C6685BF5EA56EC198834EC1F758A6416F5F8E417A5E97C192D91DC1C666A74092DB18C0A2AFF540B9AC2A41E7633241D97C314084482B41E6E9C5BF781053400666B4C150310F405342A5BF39EB5EC015C66EBF1DDE15C18DA3A0C149FEBB40438080413C2814C0D76F47BF5A7D1AC086544B3FCD7517411482DAC10FC7983F1DC50FC16FE1D640233C13BF33D75341837492C0CD6F9940F7BF0C415EEF604048BB4BC1EB9B86BF0E0B17C028E060412BF3283E1EB60841D2439D4125937C419510054177248F41474094C057EA6BC0337885C07E62074220F4EBC1D8E8F4417F3DA33F2FC874C006A25E403637D8BECB8D803FC736A440B8547DC1741BB0BFF48181BEBDE9F4BF80E3BE41A3BD14C1CBB7BBC0570802BF10461241A9BBC14141E98EC1A3AC7E41FAD18AC1977129407A3EA9BF74CC5BC036642741A1E5DA40188B4D401DFEE341FD8828C29BEC9B411FC24EC1183106BFD42E483F12F899C1079D03C1AE9D4BC08EF0DC3FF15B0F408E0D7842D22507BFEA0627407DDF89C15AEDCD40CCE2DABEEB499940293566C1BD7CA4C02BA507C0FB09A24052492A41710B73C149F7B3C1BF7A054176202541A7F95EC199AFBB3FB9E67CBF287A4741703E5BC27AF7E2BFCCEAA43F73DA1F40A8D172402A3B9D3FB901494058750C42E2650F42C4EF1A41219121C1F545A83FDC6488C0320AE4BF56C6B7BE742900415D50A440D5F1B83F83F9A1400B3BFCC1B43678BF539EACC0FAF33840168A4BC0A30300C129CB90C079008BC050826A4104CA84C0A38F8EC01D2775BF16F02C416BC29FBF4694913F6CA118C1A7784CBF290E90C1F68CAFC106347C3FF8C1B040EC92ADC0ED38784080A8FABF4B8E33C093268BC032D956BEB741F7BFCDD284BF26CAC4BF44D8A1C0B383BE4167B8F23FDFBA5BC08D8D5F400B5EDC3F82DA8EC13FA49D40EE391241599C8EC1DB49EBBF38A499404415D9C048694C4059317741495FAF402231AC406D7646C1348B97418345A2416ED1A1417750B3BE668212427C2D0BC2BD959F40511C65BF1D5CCA40FC950E419F230E420CFFEBC09EB1A6C0048193C1E93A0BC18B7026C1"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
}
