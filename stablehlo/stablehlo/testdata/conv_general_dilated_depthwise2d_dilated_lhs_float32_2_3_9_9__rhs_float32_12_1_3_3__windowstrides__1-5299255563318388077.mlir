// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<2x3x9x9xf32>, tensor<12x1x3x3xf32>)
    %1 = call @expected() : () -> tensor<2x12x5x7xf32>
    %2 = stablehlo.convolution(%0#0, %0#1) dim_numbers = [b, f, 0, 1]x[o, i, 0, 1]->[b, f, 0, 1], window = {rhs_dilate = [2, 1]} {batch_group_count = 1 : i64, feature_group_count = 3 : i64} : (tensor<2x3x9x9xf32>, tensor<12x1x3x3xf32>) -> tensor<2x12x5x7xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<2x12x5x7xf32>, tensor<2x12x5x7xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<2x3x9x9xf32>, tensor<12x1x3x3xf32>) {
    %0 = stablehlo.constant dense<"0x34EE53401057D0BF6DB1A7BFD00AF73FBE67B9C07BD7E83F9F70AC40963EA3BFC00EB83F276D63401F088740A77D9E40CA547C3ED2D321BF2CD2323FB2BE024109FF10BF42F9D63FEDE133BF5C242F401D51B3BEAAE29FBF15398940FEA1E0BE0D299BC07B0A4BC0324ABD3F829D9DC04B2E9140DBB0C33F94C97A3D1C66C3C032A5B3C01CA861404B915EBFAD01C13F1B5A56BF21DF4140168E9FBFF8A6C83F3BD06EC070F94740E6A0E33F30BEFD3F4F1DDCBF99D423C0116FC0BFEFB077BD67DECB40D567FD3FCF6D9440F9BF603F8E4804C01F03EA3FCBDA1A3FF326003FFE5810C0612A8740D45C25403AA07040FDA0733FB9C4F0BD26211FC091EBB8C0BF5429C0D7A30C40F018B3C02C461640B287CDC0110B8640A5AB88C0E7F7F6BD916A0740E976AA3FF15E3A40ABF269C067398C4016455BC0ABFA2DC01D6A304078261A40AA1001C1069AE6BFE26D36404116A5C025696A40F6A297C042240BC057054340ED05BBBF7E298BC0DA2B034017F1E1BF846AA13F4FC60E40A9FCF0BF257DE7BFE1FB7C40675453BF94C3BD3E9625C040B1159E3E1495FAC042B13DBF591FF3C07284393FFC6784C0E0FAAFC0F525913F8EFF30405495A7C01692B440D59918C1ADD2BABF341A23BFD2348B40187890C07E1E0D40EE951F4006E74D40CBCF78C08291EBBF094F62C0245FEF3F748119C06751E4BF4E052B40B1076240871B13BF776A8C40385A1EC0582B81C068D893C04C16B93F4808C5C088ED6B406F161CBF7736D240F3182B4065B45E40BCCEECBEF9B88F3D0DBF05C0AAEBF83F881F72C0DD53B2400B2EB63FFAC3DB3E3FD446C0B1FE4B3FDC3954C06100813F978454C0D00DA640CA88B7BF10ED934061D0C0BF0E27AABFB4AE0EC028A4AFC0B12F45402F08854045E53FBF35A3C03FB7B7D73F74B359C0270A9740012C26C0B1B58A4074C18540EDF61DBF24FDF0BF95C9C8BEBAFFB4BFBDA82FC0ABF1D53F212179400F030440674EA83F048A63C08E42223F75F34D40FE39153F53418FC0D4536840E12EBE3E76E1EF3E7A7204C1A82211C06D1C903E86A984409ACA6DC0D5F3873F803B71404FABAE3EE33E5BBFB3B6A43F8A58E8C0E4AA48C0B29936C005554D40DAD8924045A549C032B84C3BD1C364BF8585D240BEF28A3F0A5B81C008D4E73F98AC8C404982C33EAE271D40BE002740FE747B40E43D79C07BCBBFBFC8908A40B279023F575002BFD5CFB7C064607FBF70ECA1C0E57062C003BDB2BED8787540D287D3BE3F1222C08AF72440AEDC2F408260F63F8D9807C0A82804BFF1D47540967EEF3E68E0C0BF087CA43D0DA43BC00BCD32400A67DABE4FF7D3C046C182BF73EFB93EB25DB6BF902EBC3E1CA73C40499C313FEE9838C0FFA1F73FE3CF03C02B3124BD6C1BADC0EA059FC0919C063F909CE43F5FCB044054E0303F0038BFBFF9EBC63F31095E40591FC93C28AEAEBDCF4CA43FD4124AC020B35EC08DDF7EC0F92C74BF496484405D84483F7436A73FCEE69440C3922040A86D843FD491F93F7ED15EC0849F16C0ABAAF33F6C49C33D6F4011C0E2A4ADC002D65040E63CBDBDCC36C53E774C86C002C23140D3EBEBC0F5140F3FD375FD40943D9D3FA2026DC082CD02C0A588813FB9088BC0DCB99FC0F14E98BF34EB3DBF25C782BFA40CB0404F99F23FF5CDD5BD43902C40F26EA43FD96ACA3F7BE24F4091751EC0A1DB81403EDA05C0A4E9E2BF104B9A405DFA55C07F04D9BF983F3340B9FD9AC05E406940B9869740C7021DBFE927BE3F65E0CAC05FD89ABF7D065A401D36D23F5DF01540907CEA3F6DFAFD3F57097D3FE8439D3D05F69E3FC5D8EBBE1575FDBF938988C03C9FBABF79254240F6B4A1C0024604C0D53D3840315F8340846A9A4082168040211C00C06BED3EC083F430405615534019761340EDAFEA3FFF420AC05C1B8040BFCACA408E40BA40D1702E3F97C45A4094291F3F4AE736407BE68D3C7B954BC0969C03BF2B8759C0E64924401561EEBF3EFD7DC0C2B2FCBFB17FD9BE834C544052323E3F7ED43FC0A697A7BE766B513EC1B24B400E152B3FF26B464049FBD4BFB68BF13E4662DEBE0A12D1C0D7DC41C077C592400EA737BF8B57CDBFB3EA4D408FF55DC0CC23ED40E31D51BFB6FD1840D6A89040CAFB86C055C906404DDD454096E7CBBEF0462C40B4158AC022D45AC0D85026C02C5D0B4032F09FBF15C0DF402CB34A402FBA98BF03ED18C06FD4DE3E50BCA1C050BCF2BFF997493F747F184072F482406018CDB9B14CD6BEAE04CD3F3D024A40ECAA82C035B29C3F3C2AEFBEDFB3A7402B3F9ABF84DC0BC0205B3D3F2BDCE4BF50A0FE3F289756BF47C334BF0D922840710508C1EB8B57BF3CDD8B40BC4B863E8EF52EC0F0BA8C3F075EC73F8F153BC0C49FEC3F2EAD693F45BCB9406B0D5ABF88A11DC038C18540A5D9DCBF83612BC0CC172D407AC3E33F613469409CAD9C4078EE00C06A0E1940BE724DC0F65843C095140CC0566BA53F89D19240D92003C0ED76FA3E56A4D33FD9BDF8BFD246D23F75A9D83F36FBD2C0C2368CC0BAA0B540CD2CB23C9CCFCB404EF8C3BF16E85B4049288240BFDCD0BF93FE8AC0A840ADBF41BA08C042E14CC0B67E8B400CA85D3F76259D3F0B1F11C06F97B9C0D4B626C00A853D3F17C64B404CDE043E0FA4E73ED3395EC070CB074088154F3F0874853F0118D03FEE171240C002C63FE09B9C4078B6A3BFC8C4B63E35A587C06255F33E"> : tensor<2x3x9x9xf32>
    %1 = stablehlo.constant dense<"0xA0371F3DF6C320C0ADFA563F7E2E94BF21E7A9401E38D640AC90AC40F98941BFB8460940EE341F3C75D2353E56DA81BF24339DBFD67D4240A42B00C0EA051940585148BF4759A93FE00FC8BF1828D23F73D0F0C0217F43C0D2836C3FD8F5A8C018C529BE545573C0996D92C023D4344053B6ADC03B792A3ECB7E09BFCCBF7E3F72D8203F33E20B3FCDCB94C01E8E603F0B35E34004FCA3C07FCD12BFFC013FBF6356033F2F155E4062D046BF649B36C00DE9CEC07111FDBF3DC793407E32923E1628E63FC367F33FFC0C3D3FC8462E40963F913F599383C0E90B633FE22F3A403A8D1EBFAE8EDBBF8D93564073243FBF209581402FBDF5BFC4596A4080C584BF7070AB40DA0FF2BFF7FF4FBF93C39FC07C9E2DC0DD52A83F6E6489BFEC4B56402D111840D8DFECBF9D2D9ABE31AAB8BF140614C09612EA3DDE1AB23FBA6702415BBD323EDB23AAC09C27EC3FD4A7C9C0D8459F3F9C4358BD72BA97C0EAC19D3FC7569EC0B849BC40F2F22F3F428AF4BE671327BFF6BC6140474AC8BFAF8A293F560BB73E1D8CF0BF4738E1BF471289BE45F4DD3F447C0440080365C0E97F15C06BCB0BBF9CE06540335EAFBF2AE06D40"> : tensor<12x1x3x3xf32>
    return %0, %1 : tensor<2x3x9x9xf32>, tensor<12x1x3x3xf32>
  }
  func.func private @expected() -> tensor<2x12x5x7xf32> {
    %0 = stablehlo.constant dense<"0xDF5FD440E896414119804CC04EA45D4263C56AC2820325C2D325F640A566A74124464CC0A1B330C2F8A4C8C10704704185B992415A3F6C41E00DE2BEDC545C41526B92C141ED874168932C4247973F426EAEBB4003B520C228594841042E7C42C3706BBFF4148F42DAA08EC22828EB41C4C3A5C0AF698B4132537C4221E97A4119ED14428F6954C1C33511C29ECD9D40D030C540C63C6EC14720BB417AA731C1572B4840C85BFBC0DF4FF040E81D904046280C4168CF3941C83AB4C1EA69E8415C9DB2C03D2A3A41FCB05DBF8C687A4003D6A8C097279F419EA100418A0A8840F6FA2EC14A58D2C116B909427E9EF1C102A4AB4179C4ADC1A400073F17596F418E20ADC1E9D4F041A012CBC18CF669417B52B2C0B61AC73DAA0E3740F83C99C15DA7154202F683C1633F0FC2C5CD4D419CD489C1C38792C1EA0A27C28B9403C1C8CB4AC1DCFBACC2F2BC3B422B1D3AC210DBE34131C2C7C1C84C11C291AB20C2FD226E41F320AFC0832F064123AA3541699983C157CE4542CD4D364195EEDDC122C0BA41457983C17B4DEE40963C1CC262EEB84115577BC29CFE4D41AF9CE4C1B4931E40F5F8A64041EC104167FAC5C1A4467B42DD9138C2A0EC0EC295295041150ACF3FDA062CC180BA9FC1C589E1C0E233C0C1ED731FC23B4D11420F8D91C16B12B0416E7743C162860FC2B4EF9540BD55BB41C4D32540CA04DBC10D63E9C08C7C1F42DFD06341BBF15242E49781C2EB610E4272F2B5C12D8995BE278A8641EF7B1F40421005C1B9B63841C839A3C199DC96C264A727C263006942ADCB29C23387484244339DC1BB240CC224CF84C285AC0341C3922AC2C6F66241C6FC9342B0AA8341ECDAC9C0E97774C28FB26DC02EF550C0248C85C22DE015424F5B39C22256604192ABDBC1C07A3142FA1D43C224369542B7335AC210CACDBFCFDEA1C1A90611C1466963413BAD76420AA1B53F4919314220DC2AC23E9E4E3FDBE28241341E3D42F80BFBC13DD2D040ACD076C2668E4CC145418841E28B0A42F1EAADC11B798E416D88BF4170B4D2C13F6FD2C1790E1F425906A4414C6422C1D75905C257B61E410F9E05C2CD34A0418A360BC2E7CE2441319490C0953D6142513074C22D831E40EA379CC1428F7B41D3403E41BBC6ED41ED842F41DD104D41870D1B41334444C144F438C2F937A841E5EC75C053D0D9C12145F43E1EFFDDC15072A4C129981E404BFB8241F9CC5B3F32EF7E41B76DC0C138FD19C19C0D67C1FC3569C1F1BC6F42F21B7341F182A0C05FEF983FB38A90C175871940D0A5CFC09C5B53BF4C3CC4C0634BE641DF34C0C18B9C31C2CF1C0DC036839740568D0A422CB36D4107C5904066592EC12F6727C2DB5C9941BFB2CDC11260D6C1F337E441815FB240D2854642B90A9941C47556C1F4915D42FFD98041A43D6941EAA2EDC0036D6042196CD3C0983991C1395849C155EC0E4241A27240EBD6D4BFC8C41A42E95FAFC11F343F41D3F339413B4664BFB40D39C216D7EF412114DFC11373AF41683CA241E073E94104EB3041018DEBC14E4236C2CF98CBC1820E1CC243C61442B5EB3AC009AF21C2B7AB8F41AE7C704204E514C241088540952AC1C1650D9342949075C072A52E4260556341062B1B3B751273410B9526420B8ACCC147A38741D082313F3CE65AC2363907C2101DF8C128EEF4C1BA5472C02807C4C11C12AD41C33CEE408F7B0A41189E73C179318EC122DCFC415D2F49C1D16F16C2E7670242A307D041B4F944C200C216C02983DFC06305B941B76945425D0BC5C25E966342522A80C2A2919C42D186D7C179793F42DB6A3ABE4E714AC12A296BC0CB65E840C6E58BC29ACF79423CFFA1C19FCF2FC27526CC400F9D0640C71792C12708E9417FB01D416046F6416E580CC2786BEAC088CAFBC14E439FC1232F02423FF83F424C56A4C1C6724C42F81789C050053BC26DDC8042283342C27CB0BFC122DCC4C0CA6DA6C09DC01341178784C16F0D6A41AA10ABC11425D4BDECC7A5C172D17041F7E983C18EC381C1E5504DBFA3229440DF0E944049E78EC09FCC8140CB6269414751C64142C4B540C63C8541004465C1C67657C11B85DCC01A975840819E77BF78EA7B41C57EC8C01E4E6441568B7B418E69E2C0817143408F0E7CC0170C69410DF58BC1656146C1BB74443F69A948C16E865540B9F1FE413963CCC12E9832426853784138D546C159CC4DC12CEA0042DE60D3409ED48441E4D8A4C0315344416AD90E4237D8DDC1026694C11E7E1BC258252640084202C2D149EFC16F92964188CFC5C1915AAA40538A0DC0C02035C108ABFDC07CBCB0C1EB58F2C15B120442D72BD53E53C49E405989A0418CB38C4151047D41C1DFEEC117495DC25C6459C0AC09A0C1811E5D4200CA9CC129043942F49655C03B481FC2017C25C2D1884DC110FE72C1994906C2B0A61FC2C79E9B41F01EA4C1A624AF411B5935C18C833EC253D1B7428B0DEB41E03DA8C1778687C0893376C2F7D82EC2DD448241AD85F1C1CAAD40425A8CD14127A3EDC050CAAC4169E81542C39DE74154CEF541C6520440832180404BF5DBBFC7C801BF98CDCEC12326C8417F23EEC094EDAEC015A838C1DCC2EBBDA966ECC057A584C1EE45D8C0445803BF6F832441FF4AC34097BA4641B77530C1E9AFF0413953E8C1A0130D414C929240C0278FC1579CF0412AF6B3C070E3B3C179369C41707592C033527AC0C6FDC0BFA43DBD3E6C4D18C1A0D4694100E378415DD6A6C1BCE5BE41DE060A418FCC7D42FCB3A6C0DEF91142A313AC41948641C1F90404C23E06D6C18F7EE64156514E422531054152FD80C04D4188416F57B63EBB11ABC002810F4212ABD1C15DEED740ED1E89C153F52DC2CFAE21C2DBDE78C1B2259B42660DB3413AD85F417B66CB414EDF41C1CA22D2C05F818F3FDC979341BB1E80C232ABEB4175C4D7C12378C2C256EE4D41AA8492C14DB6B6C000A21542928513C2DB3368429EB7D9C0D6FE4DC02482B43F4D4F84C10001444196B0F641A09CD6C001376EC13CB65141C4C4B34103B88BC0ED0FBC4034D40CC102A647C2A0FA074205758EC16B77BFC18E7FFA401B37C4412D9692C1E6FC34418D293BC1B546C1C00E5A1E420CA1B4408A8921414AAAE7C1079A2142B49EEDC1451232C2065DA441143F4042B6CAFD418C513AC1A00CF2C1A71630C2F1CB6642824B1142670BF841E92BD040BB78FD41FFB604C140A271C271FC8241535319C1C1439CC2E11CFD4090A2A8413A9987413B0C43C194027AC0A20FBB414A340EC214AA0D42A0DD9AC2382996C125F04541E4BF29C1779F4842C45B2A42A60448C27C3015C230F55CC1B7ED7841655548C16A60EE41FE964E40491497408989DFC00C349241767CA24194E404C1F49C0F42F3621F4153D314C25EACA5C11257EC4094F71BC1A02E4C4158430840B888EE3FAA8A384280F07841B73CB2C1B51E0B427C869BBE81F3C4C1BBD706C26E48DCC1BDCD5CC072CF8CC18EDE2541E0018341D5D04C417322E1C1382B3D3EA219FAC02493C241BB519F41DAFB43417A1406C10096A741671288C0D7C7994094EDB7C124CA2D42F8DACFC173DC9FC1314EA941191B633F2BC104C1C8C6B8C0AE92D5407FF363C1F4EC0042B87558400282FA4093785C42786DA140AA76B840AFCE124213DDD5C161F2AFC1AD5806C240257E42CD2785C125E028BFE0EB5741CC1CB8C0EE297CC1D5092041E99538C15472B641127FC7417F950A41D74717BFC55801C284985EC2B46330C28A7CDBC111E9AE4118DD3FC23A5CCB400790C54150A92242285DCCC1CED38B3E2D9E47427212F040F89031BF9FCC1942C429CF40ADA4FB41F668C1C19E2B5C3EF7BC67C02B1BE9C07AFC56423CD7C3C19367EF414248073FCFEA5EC1890559C1D59F24C0DBDF26C2C6BDEEC0572A9A41B45C94BFC75B8DC1F36488414C214BC1C2DB973FBC4D24427051C6C10493F63F08730141B4EE3DC1ACA712C2C63F3EC2DA97E4412AF7A74187776E41390B75C13F430942D879DDC1083A03C1FDD22CC25960E9C12463C741F58CC5415D3366412B9786C190B3354141E2B141F1E0BDC0EB8B37C1374F8FC127886ABFDB07BE413987AA41FCE89241DEB18642700473C1252E11C1C54AFAC1D18C0DC0A5931842A73FA3C2A5615241BE46D5C0D19B16C0CB93C641D13259C12FC4AC41F52E6D41B8419BBF1A0B29C17F8F2542B1AA4141D23F8941E06274C2EC906541FF7F17C025E79CC19A87913FA15649C2FA22A441522870C1E8F857C205254BC2C74653C14F0FB7C11C907D403B5E7541428B24C16A4550426D80A8C21C97F0403E4080C1E8EF5341BCB664402C0145C0D5139CC131743841144BACC06926A341D206894050A2B6417E8794C1A4B8333F206E823F94445BC1C53692412BC7B3C1ACA6AC403A9931BFEC55D93FB27665410EC59AC1931AD03FEA0D1D4157B8534195DDC6C10D1BFDC1EAB6A4412FBE83C0F16C034297AB72C1163307C1964FD1C1258363C1A7160EC0F1E085C11AD5AF41DB31FC40CC7668C1B6A41E41EE09C340AF7F7E410214D2C1AFCFD8C1BA239B41969BCA40269B22417E6650C26F991441B2CDDEC1E2C7FF415BBBF43FADCBD740324FA8C1686DB1C1A4E8614156DD68BFCB4ECB40244395C090B1ADBFC0202542047A31410E86A240D0ADBEC1629DD5C04BCD98C1D062D34116A122427EE11C427F8C44408536D24184AA21C226DE6D40"> : tensor<2x12x5x7xf32>
    return %0 : tensor<2x12x5x7xf32>
  }
}

