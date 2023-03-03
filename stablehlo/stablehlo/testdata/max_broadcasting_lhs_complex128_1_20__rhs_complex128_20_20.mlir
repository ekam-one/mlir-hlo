// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<1x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>)
    %1 = call @expected() : () -> tensor<20x20xcomplex<f32>>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [0, 1] : (tensor<1x20xcomplex<f32>>) -> tensor<20x20xcomplex<f32>>
    %3 = stablehlo.real %2 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %4 = stablehlo.real %0#1 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %5 = stablehlo.compare  EQ, %3, %4,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %6 = stablehlo.compare  GT, %3, %4,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %7 = stablehlo.imag %2 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %8 = stablehlo.imag %0#1 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %9 = stablehlo.compare  GT, %7, %8,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %10 = stablehlo.select %5, %9, %6 : tensor<20x20xi1>, tensor<20x20xi1>
    %11 = stablehlo.select %10, %2, %0#1 : tensor<20x20xi1>, tensor<20x20xcomplex<f32>>
    %12 = stablehlo.custom_call @check.eq(%11, %1) : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> tensor<i1>
    return %12 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) {
    %0 = stablehlo.constant dense<[[(4.4008894,1.62958848), (-2.71019077,-3.47844529), (1.41369176,-0.255804479), (3.99455571,1.85710227), (-1.22476614,-0.999708414), (0.126792625,3.38013506), (-6.68718958,-1.84189034), (-4.90058565,-5.12460566), (4.52055645,-7.33628702), (8.56081295,1.41118491), (1.15490448,-1.15321386), (2.83915496,2.0834496), (0.416047633,-1.83317709), (3.69193745,3.87218022), (5.012815,-1.75233424), (-5.15036535,3.16913176), (0.343374252,1.83211374), (0.994424521,0.675028801), (4.809165,0.744970679), (0.429733038,0.144609153)]]> : tensor<1x20xcomplex<f32>>
    %1 = stablehlo.constant dense<"0x75ACA3BFA371C63FE4CC3740A924F8C0C5AB0E40C6E427BF6FDCBBBFBAE4AABD40BE48BD963987406866B13F2947FF3FC936FCBFA43DE140155C72BF77DA514016E6793DD0A018C0816B9ABF94500EC09B982940DE72F7BDA84A993FE5CB64400D44F4C0E741443FFD0D8F40F75BE5BF3AECACBF06849440F26A004041A90DC0057E1AC0A36281C0278591C06098904049E477C082B215C067260FBFD011173FF981343F5495344003B6CF3FCFEE5940AF5934C0C0183F3EF8794D3F74B492C040138DC099DDE33F4D2DD3BFC11AC8408F02EC3E0C91C44051E3CE3F730D2E3FBD49BE40743528BF1A13B1BF74004ABFE55EEF3F88E323BFD49B25C0BD1704C00BB154C08FEC22C0625114BE12E85CBF54C12C3F6E558B40E30DFABFEE7CD1BF9BCB9740EFD31D40CCE5ABBFAA361C3F6730793F3E2B1640F9EBDF3F714E353F8CA124C04FFCA13E319B7340C6761DC0B416AEBF5A21E6BFAC3B9EBE81E10EC0BEF61FC0E8651D40E5CCB04092D567C0928D6540BEC74FBF0EF019C062D6BFBF5E47863F56A0B63F61B3BABF14ED4D3F0F6416BF305ABEBF5EDD2F3F6450ECBFBBE7A03FEF1FC7C00C6F833F779F53C00AF13FBFAF6EAD406572EFBFC4F681C0760E63C0F9E5873FBB1C7240BDCDA64074F82840A33EE0BF159BF43D3677453F3E6D9DBF6D4B2C4064A3B6BFBC8C7AC02A00D13F280DF8BF70A082C0027D45404C1AE8BF65C996BE4126EABE6CDFCABF0ECEE4BE46488ABE8A5903C022BD05C03FEDE6BF94902E4076D51140A38AFFBE75BE7140CC35214069E8DB3C41AF543FDD4555BFEE10B0BE17B230C0B6D696C02726AAC0945621C07C80B6BFAFD2853E861220C0D69615BF884CD13FF06A59407620B6BFDC6AB240F2A56640B1CCC53F355230BFEBB20140795CE5BFA71936408113C63E3D765D403ADE0FBEEB357E4002769ABF2B24163FC39FE5BF929723C0C7AFC4C0599082C0321A16402379A64058F7113EC93CA7BD9E8BD53FA5D536C0BFB24EBF981C48C04FA8A2BD78FBE53F5EDB9EBFCACDC03D9CEA1BC0C8DF5ABF51F13040E788FE3F7513AC3F051D11C06843D140D09F863F557BC03FED84363F4963A13FBCF84240552B6140D6B8A9BFF4C71B3EFF72D4BFD70733C0539E1EC048CE0DC0E986B5407DC5F63ED6E4873F25FC8440BDFF95BEA156E440C9BFAFBE130CEE3F064D9540B6F99EBFE7B5343F2F6CCA3FB8820F3FE3B06BBF9EBFA13DF37448BFBE3563409551873F753C57BF255A24BED074CC3D5252814011A80B3F6B319840A390A4BFA49A0DC0623BD03E1853A83F67650CC0AD6386C0D80A8A400FBCE3BF8FA77FBF22C9D0404A4F89C019B5DCBF142D19C078FE2440C23C6E402798B83FF6A9B33E6C528540CD132BC0E98087403EB9BF3F3F79DEC0B3BC944023E680C03FD40941F45AC3BED8E36CC02D2470401BA84E4024D7583FDDA622C0B7ED30BFD61D47BFF99B8740865770C06022A03FDE6F56BFE191114084FB863F87E537C0BD37873F921BDEBFD4CD02C0940A4640CA4AB73F4A933AC037295FC0780A7D3E8AE41F40CF0CDD3FDD1C64C03D8459C089A764C0E979AEBF8B7EE9BFEF620C40D3D837C05966A33F004C10409E4CFD3F947BCB40CCC10FBF03CD8E40158B00C0095626BF5B6544BF09486840B24EAA3E3E2F2E3FA4E60D40BD3347400FF5643F78EE0FC0DA6C1C415FCBB33EA40E9E40FE29AE3F3805F4C0760B92C02FA595C0F5B850400EF0E6C0A6E9513F6E6C8940748AC93F1FD46740605883BF0A85A040BA4761C0217C2F40D46474C0BAED1EC162C9E43FECE4A03F5EEEE2BEA9592FBF6956A5BE4A6D2AC088F2F13F28AE85C0C940BABF7862A53CA5789D40BE9C27405A9181C07FAFAD409B9F23C0C3C499C0349CA74039178A4062EDDC3FA822FFBF4FAF0D40C4FEC5BF79E0E2BF727EA23FDC5A7A3F0B08DDC073BE46C080CBA93F8596F4BB277AB2C0B0D13F3EE273223F38982540F25B35C0BDA17EC0E630C63F213583BF4383FD402327C7C05FBD023F92ED17C0193AE5C00B5FFCBF631FC04077E7FB3F5AB3C83F419AAE3DC47D683FC5534DC0141F57403D00DE3F94762CC05DF067BE9DF61241A8BB163F13F3F1BDE83352C07C052BC083A1FEC032989EC016BBE2BEC8F533C06E8DE4BE45511E40AD2181C09D422D3FD64CAAC0CF9C7D3FF6CCA33E0D7C1ABF6F8668BFB421D33F10C4D43F9FC88EBF194911405C7A16C01257BCC064F76A3F8951C0BF06CC6540FE54F6BF407297C0EBC7C540809422BF3C0E763F5A823C40D9A290404508073EA458E8BF1AFE71BF4E708D40769ECCBDF16C8B40CEF50240453B6640374751C0366EC140309473C079C08A40240330C0A2D03EBF9B3DC0C0CE1378C004FECD3E3B5969C0B9AE17C001293640CF9DA3C0A798F5BF750902BFE6F365409A1DC7BFAC66CF3E1F4A074002ACFF3C1AB12DBF401FAAC05D4E01C0BE50D1C0A8A15CC0766625C07B5724402F2445C00EDA1940ABC461C07EFB32400D1C8E3F96653BBFC05EF8BF9F4E1CC0555478BED36736C03374C33F7B0CAEC0EB6FFFBF296AEF3F8F7C244026B27040E2EA82C0611D88401962E0BF24CF0AC0A5958C3FD316D2C002AF4EC0911E82BE711938408AB35F40E0CBD43FAEE0B53FDB53913EBEF02DC06E58A3BF8716003E873863405F125FC0F398AF400F30C73F910968C02CFBAB3F3148393F84BFEDBF39D0B8BF8EDA80C0E1EA8EBF5326954041DA0540915DAEBF9891F4BF166424BF29EC9840DB10C13F5BCB02C06F370140367EAFC0EA1B25BF1FD7B8BFA50404409E6242BF63070E4091DD7F3F09C262400A91F4BFF77C2FC0C97223C059382340F297C1BF888BE83E89E81B3F77B5BCC08BE79CBE78809B4041A8A2BF35949FBE84E8C3BF41ABB8BEF317014097A373BFBE616E3FFD2FC4BF9EE500C1F0390341985635C0F73E00C0BA7DDF3F1E435FC089F8C23F74312BC03D0BFEBF0B7A1040CD98C8BC73E9513E0C431140B328853FABB57EBF74061D3FCBAA993F4A18EFBFB3D94C3F20DF83BEC0AD3EBF1859ECBFB67383BF5B355DC0EA79DFBEE342ECBFAB979C3EE384EDC0A9C032C0A9E2B3C0D33C95C0E15D3CC05DBBFEBF5AEB283F5BE83940C47830C0720900C052C282C0F00BC6BF079AB5C052A0E4C06C4C3A40C9881DC094686DBFD47A9FBF6AB92840324087BF51665A3FC3346D3FA76D7E4031C6C5BFCEFAD93FCC0737C0697FD83BECA0DB3DCF8A2AC06BD1DD3F674389C0C5A3763FD53E9DC05062424004D82D40795CE3C030AC0040227ACFC00D342A40F24407C001664740D4033D40D3DB0940A8BEBE40FBF1154060580D4095015D409C8A164032250C3F7479B5BF20385BC0C37006C054F7FABF6C315F40AE5E393FDEC9FBBE2F9AE7BFDB2909C06DB059C008D895404344463EED5871C069D514BFC082DABFD0CF1DBF109C8DC0365726C0A16782BF21CE85C09C80943FB529E640C0CAE3C0E1C085BFA4FBCBBF6752FDBF752D9CBC14A314BFEE4608C0B3598FBFE60D823FD4463BC05045A6C05D72803EE1765AC096390DBFCC8181C0F52756C0002D3C4086584D3F60D0D6BF89A4C840BCC6F8BD8131B63FC0F19D3F2B0202C0482B8A40B364B0402AA6734084C5E03F271FA2BE002ADC3FFE66CFBF4586F23E12BBF140F455B63FECC90740BAC0BF3EB1F86EBD05889E3F7D754DBFF49B95BFD462DDC04C3B2BC09DDA3240F0C646C0F2A99740EDD037401FF6273FD9EB79C044D48740662AA6407650883F3BDF8D3E85400540BFC25F3ED6761CC0ABFE79406CCB8AC0B2D371BED00C86BFAB698F407058B2BFC14F30C0162BC23F07CFD2BF27A8C23F499CA8BBBB431AC07A2C2DC053A4C4BE15DC4F40B21613C0EE3EA9C012A0E5BF14E4A54008001F40317098402CDAC73E578667C0FBD078BD8ABFA9400BD6B1BFB3EA3F40E8079140549B2E3DA77103403AB081BFDC3C133F0DA06A408C36A140D461703F3021BB409829694070063AC00A4764BD45130A40610CB73F2BB216C01F7A4BBEA4E798BFE15C02408D2928C04515E4BF45958EBF19158940320DF13F50F68BBA569367BFAEDFC5BEA7CCA4C0CB076C408344B7C0BAF435402AB04A40039F4A40DBD38CBDC304A440901F4B3F14ECA23FD8593EC070C1E8BF61BBBC3D20068A3FBC2A0940ED1F9B40A1089C40B0C5B13FA86BB73FB7715EC08EAA21C0934CEE3FA37301404A4314C0518523BFD442ADC0E49485404A67B6BF974D7A3E876F863F4F7203BE3F2AA03F5E0ADD3F82DC8040F8E1B840922203BE20D9314044CE40C0859C4A3FAD56244012D5BDBF31585C3E33D0C23F22D7C93EE824F4BF5EE79C40E4EC35C0319E2540621D9B404BE19CBFC9ED773EE81BFD3FFF2A3E407A65424008B02B403B6DA03FCF3796407B1BCA3FBD1B95C0C40189C0CFC650BF66AD33BF26D21340845CB4BF064E5040AA6192BFA19822C06E8412C07121D640B270F4BE3A010B409E4C5F40776F18C0"> : tensor<20x20xcomplex<f32>>
    return %0, %1 : tensor<1x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>
  }
  func.func private @expected() -> tensor<20x20xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x16D48C405B96D03FE4CC3740A924F8C0C5AB0E40C6E427BFCDA67F4087B5ED3F40BE48BD963987406866B13F2947FF3FC936FCBFA43DE140155C72BF77DA514066A89040DDC2EAC017F90841B5A1B43F9B982940DE72F7BDB7B435403D5705403204D53E8CA5EABFFD0D8F40F75BE5BFFB68A0407D4CE0BFF26A004041A90DC0C0CEAF3EB482EA3F9B927E3FB0CE2C3FAEE4994066B63E3FF805DC3E6C14143E16D48C405B96D03F03B6CF3FCFEE5940DAF3B43FCEF882BECDA67F4087B5ED3F23C59CBFE4EC7FBFEDD5013E225458408F02EC3E0C91C44051E3CE3F730D2E3FBD49BE40743528BF17F90841B5A1B43FE55EEF3F88E323BFB7B435403D5705403204D53E8CA5EABFB4486C40CDD17740FB68A0407D4CE0BFE30DFABFEE7CD1BF9BCB9740EFD31D409B927E3FB0CE2C3FAEE4994066B63E3FF9EBDF3F714E353F16D48C405B96D03F319B7340C6761DC0DAF3B43FCEF882BECDA67F4087B5ED3F23C59CBFE4EC7FBFE5CCB04092D567C0928D6540BEC74FBF0EF019C062D6BFBF66A89040DDC2EAC017F90841B5A1B43FE9D3933F839C93BFB7B435403D570540BBE7A03FEF1FC7C0B4486C40CDD17740FB68A0407D4CE0BF6572EFBFC4F681C0C0CEAF3EB482EA3FBB1C7240BDCDA640AEE4994066B63E3FF805DC3E6C14143E16D48C405B96D03F64A3B6BFBC8C7AC02A00D13F280DF8BFCDA67F4087B5ED3F23C59CBFE4EC7FBFEDD5013E225458400ECEE4BE46488ABE8A5903C022BD05C066A89040DDC2EAC017F90841B5A1B43F75BE7140CC352140B7B435403D5705403204D53E8CA5EABFB4486C40CDD17740FB68A0407D4CE0BF7C80B6BFAFD2853EC0CEAF3EB482EA3F884CD13FF06A5940AEE4994066B63E3FF2A56640B1CCC53F16D48C405B96D03F795CE5BFA7193640DAF3B43FCEF882BECDA67F4087B5ED3F02769ABF2B24163FEDD5013E22545840C7AFC4C0599082C0321A16402379A64066A89040DDC2EAC017F90841B5A1B43FE9D3933F839C93BFB7B435403D5705403204D53E8CA5EABFB4486C40CDD17740FB68A0407D4CE0BF7513AC3F051D11C06843D140D09F863F557BC03FED84363FAEE4994066B63E3F552B6140D6B8A9BF16D48C405B96D03FC4732DC0D99E5EC0DAF3B43FCEF882BECDA67F4087B5ED3F25FC8440BDFF95BEA156E440C9BFAFBE130CEE3F064D9540B6F99EBFE7B5343F66A89040DDC2EAC017F90841B5A1B43FE9D3933F839C93BFB7B435403D5705403204D53E8CA5EABF5252814011A80B3FFB68A0407D4CE0BFA49A0DC0623BD03E1853A83F67650CC09B927E3FB0CE2C3FAEE4994066B63E3F22C9D0404A4F89C016D48C405B96D03F78FE2440C23C6E402798B83FF6A9B33E6C528540CD132BC0E98087403EB9BF3FEDD5013E2254584023E680C03FD40941F45AC3BED8E36CC066A89040DDC2EAC017F90841B5A1B43FE9D3933F839C93BFF99B8740865770C06022A03FDE6F56BFB4486C40CDD17740FB68A0407D4CE0BF921BDEBFD4CD02C0940A4640CA4AB73F9B927E3FB0CE2C3FAEE4994066B63E3FCF0CDD3FDD1C64C016D48C405B96D03FE979AEBF8B7EE9BFEF620C40D3D837C0CDA67F4087B5ED3F9E4CFD3F947BCB40EDD5013E22545840158B00C0095626BF5B6544BF0948684066A89040DDC2EAC017F90841B5A1B43FE9D3933F839C93BFDA6C1C415FCBB33EA40E9E40FE29AE3FB4486C40CDD17740FB68A0407D4CE0BFCBCFA4C00ED34A406E6C8940748AC93F1FD46740605883BF0A85A040BA4761C0217C2F40D46474C016D48C405B96D03FECE4A03F5EEEE2BEDAF3B43FCEF882BECDA67F4087B5ED3F23C59CBFE4EC7FBFEDD5013E22545840BE9C27405A9181C07FAFAD409B9F23C066A89040DDC2EAC017F90841B5A1B43FE9D3933F839C93BFB7B435403D570540727EA23FDC5A7A3FB4486C40CDD17740FB68A0407D4CE0BFCBCFA4C00ED34A40E273223F389825409B927E3FB0CE2C3FAEE4994066B63E3F4383FD402327C7C016D48C405B96D03FC4732DC0D99E5EC0631FC04077E7FB3FCDA67F4087B5ED3FC47D683FC5534DC0141F57403D00DE3F94762CC05DF067BE9DF61241A8BB163F66A89040DDC2EAC017F90841B5A1B43FE9D3933F839C93BFB7B435403D57054045511E40AD2181C0B4486C40CDD17740FB68A0407D4CE0BF0D7C1ABF6F8668BFB421D33F10C4D43F9B927E3FB0CE2C3FAEE4994066B63E3F64F76A3F8951C0BF16D48C405B96D03FC4732DC0D99E5EC0DAF3B43FCEF882BECDA67F4087B5ED3F4508073EA458E8BFEDD5013E22545840769ECCBDF16C8B40CEF50240453B664066A89040DDC2EAC017F90841B5A1B43FE9D3933F839C93BFB7B435403D5705403204D53E8CA5EABFB4486C40CDD17740FB68A0407D4CE0BF750902BFE6F36540C0CEAF3EB482EA3F1F4A074002ACFF3CAEE4994066B63E3FF805DC3E6C14143E16D48C405B96D03F7B5724402F2445C00EDA1940ABC461C0CDA67F4087B5ED3F96653BBFC05EF8BFEDD5013E22545840D36736C03374C33F99D19CC0C5FCA3C066A89040DDC2EAC017F90841B5A1B43F611D88401962E0BFB7B435403D5705403204D53E8CA5EABFB4486C40CDD17740FB68A0407D4CE0BFAEE0B53FDB53913EC0CEAF3EB482EA3F9B927E3FB0CE2C3FAEE4994066B63E3F0F30C73F910968C016D48C405B96D03F84BFEDBF39D0B8BFDAF3B43FCEF882BE5326954041DA054023C59CBFE4EC7FBFEDD5013E22545840DB10C13F5BCB02C06F370140367EAFC066A89040DDC2EAC017F90841B5A1B43F63070E4091DD7F3F09C262400A91F4BF3204D53E8CA5EABFB4486C40CDD17740FB68A0407D4CE0BFCBCFA4C00ED34A4078809B4041A8A2BF9B927E3FB0CE2C3FAEE4994066B63E3FF805DC3E6C14143E16D48C405B96D03FF0390341985635C0DAF3B43FCEF882BECDA67F4087B5ED3F23C59CBFE4EC7FBF0B7A1040CD98C8BC73E9513E0C431140B328853FABB57EBF66A89040DDC2EAC017F90841B5A1B43FE9D3933F839C93BFB7B435403D5705403204D53E8CA5EABFB4486C40CDD17740FB68A0407D4CE0BFCBCFA4C00ED34A40C0CEAF3EB482EA3F9B927E3FB0CE2C3FAEE4994066B63E3FF805DC3E6C14143E16D48C405B96D03F6C4C3A40C9881DC0DAF3B43FCEF882BECDA67F4087B5ED3F51665A3FC3346D3FA76D7E4031C6C5BFCEFAD93FCC0737C0697FD83BECA0DB3D66A89040DDC2EAC017F90841B5A1B43FE9D3933F839C93BFB7B435403D57054030AC0040227ACFC0B4486C40CDD17740FB68A0407D4CE0BFD3DB0940A8BEBE40FBF1154060580D4095015D409C8A1640AEE4994066B63E3FF805DC3E6C14143E16D48C405B96D03FAE5E393FDEC9FBBEDAF3B43FCEF882BECDA67F4087B5ED3F4344463EED5871C0EDD5013E22545840D0CF1DBF109C8DC0365726C0A16782BF66A89040DDC2EAC017F90841B5A1B43FE9D3933F839C93BFB7B435403D5705403204D53E8CA5EABFB4486C40CDD17740FB68A0407D4CE0BF5D72803EE1765AC0C0CEAF3EB482EA3F9B927E3FB0CE2C3FAEE4994066B63E3F89A4C840BCC6F8BD16D48C405B96D03F2B0202C0482B8A40B364B0402AA67340CDA67F4087B5ED3F002ADC3FFE66CFBF4586F23E12BBF140F455B63FECC90740BAC0BF3EB1F86EBD66A89040DDC2EAC017F90841B5A1B43FE9D3933F839C93BFB7B435403D570540EDD037401FF6273FB4486C40CDD17740662AA6407650883F3BDF8D3E85400540C0CEAF3EB482EA3FABFE79406CCB8AC0AEE4994066B63E3FAB698F407058B2BF16D48C405B96D03F07CFD2BF27A8C23FDAF3B43FCEF882BECDA67F4087B5ED3F15DC4F40B21613C0EDD5013E2254584014E4A54008001F40317098402CDAC73E66A89040DDC2EAC017F90841B5A1B43FB3EA3F40E8079140B7B435403D5705403204D53E8CA5EABFB4486C40CDD17740FB68A0407D4CE0BF9829694070063AC0C0CEAF3EB482EA3F610CB73F2BB216C0AEE4994066B63E3FE15C02408D2928C016D48C405B96D03F19158940320DF13FDAF3B43FCEF882BECDA67F4087B5ED3FCB076C408344B7C0BAF435402AB04A40039F4A40DBD38CBDC304A440901F4B3F66A89040DDC2EAC017F90841B5A1B43FE9D3933F839C93BFED1F9B40A1089C40B0C5B13FA86BB73FB4486C40CDD17740FB68A0407D4CE0BF4A4314C0518523BFC0CEAF3EB482EA3F9B927E3FB0CE2C3FAEE4994066B63E3F3F2AA03F5E0ADD3F16D48C405B96D03F922203BE20D93140DAF3B43FCEF882BECDA67F4087B5ED3F31585C3E33D0C23F22D7C93EE824F4BF5EE79C40E4EC35C0319E2540621D9B4066A89040DDC2EAC017F90841B5A1B43F7A65424008B02B40B7B435403D5705407B1BCA3FBD1B95C0B4486C40CDD17740FB68A0407D4CE0BF845CB4BF064E5040C0CEAF3EB482EA3F9B927E3FB0CE2C3FAEE4994066B63E3F9E4C5F40776F18C0"> : tensor<20x20xcomplex<f32>>
    return %0 : tensor<20x20xcomplex<f32>>
  }
}
