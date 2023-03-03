// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.cbrt %0 : tensor<20x20xbf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0x644093C02AC044404140C23F28C0633F443F3EBFDDC0BCBF92BF80BF83C0443FE03E0CC09A3F7DC0503F3EC0CD401E3EB2BF8FC082BFA340AABF40BD03C054BF7EC06CBE3E3F52BD95BFD3BE81407B40E43F4640934094408B3F8C3F873F07BD86BFB2BF69C0F23FEE409F3EB7C0ACBF18C096BE70C01CC0853D193F424007C077405FBF93C0BFBFE4BFD7BF4D4010C0CB3F833F2AC05040513E8BBE7740963F953FF4BFA240163F0F4055BEE2C023C0243FC2BF583FA93E0F4007C010C082BF09C0F7BE31C0A04097405EC0763FD73DDDBF91BEB7BF00C0AA3CA3C0CEBFD6402D4089C0664096C0ACBFA2C02DBF793F623F67BF8B4046C1C23F84BFA540A0BF0AC0CB3F1A3E00C0C2BED4BF72BE36BFC33FE5BF37C0A23F7FBFCF4032BF0A3F06BF0140EF3F98C007402B400640993F93408CC0E0BFC1C0964056C08BBF64C0B6C02F3EA0BF18C099C0523F0FBF933FDABF93C04C40A0BF6A40A5BFD83E2CC003BF84C0B34078C0F23F03BF1A40874018C0C6BF513FD43F6740453F0A3F2740AB3FB3BF57BF8740263FB23FF4BECDC0B6BFA2C03CBFD53FBFBFB63F8F3F42C0603DFEBF98BF80C017BF344003403EBF5040A9C01540184029BFA9C031BCAA3E8B3F613E91BF9140E0C0B1BF90BEA940584016BF63C073408D3F5DC0E33F844007C075C0D83F37C0154016C0C8BF08C0043F023FA9C031BE16403E3F7540A3C0433FA3402F400F40C83F584092C01140F4BF72BFD63F80402D4054C0F5BF0C40E6BFC1C0AF4008408FBE36C0EE3F3A40EFBFCFC08DC0393DA93FCB3FA53F293F8DC001408540F3BF054094C0D7BF4FC0494010408740B4BEA43E1A4071C0D63F94C0F1BF79BF03C0A3C02FBFA13FC8BEAB3FA83E29BE00C0A13F31C081C0B1BF9C3F59C091400FC0FE3EBB3F34409040813ECB3FB1BFDF3D9A40D3C06CC03040C8BF0D401DC01EBE10C00DC0953E8240FCBF82C0E33F1840ED3F7DBE923FF63F28BDE8BFB9BFECBF5A40394096403DBE3E4067403BC01D40B2BF21401DC0C03F4EC00BC00A407C3F8A4094BE19BE563E34C11D3FC7BF93402940823E653F7440F53FC13FDABF45C0D8BE2DC0D2BF5FBF244031C091C0A1BF0CC094C0B63FA6BE"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
  func.func private @expected() -> tensor<20x20xbf16> {
    %0 = stablehlo.constant dense<"0xC33FD5BFB1BFBA3FB93F933FB1BF763F6A3F68BFF4BF91BF86BF80BFCDBF6A3F423FA6BF883FCABF6F3FB8BFEE3F093F8FBFD3BF81BFDC3F8DBFB9BEA3BF70BFCBBF1DBF683FBEBE87BF3FBFCC3FCA3F9B3FBB3FD53FD53F843F843F823FA4BE82BF8FBFC5BF9E3FFA3F2D3FE5BF8DBFABBF2ABFC7BFACBFCE3E583FB93FA4BFC93F74BFD5BF92BF9BBF98BFBD3FA8BF953F813FB1BFBE3F173F26BFC93F873F873F9FBFDC3F563FA73F18BFF6BFAFBF5D3F93BF723F313FA73FA4BFA8BF81BFA5BF49BFB4BFDB3FD73FC2BF7D3FF23E9ABF28BF90BFA1BF8D3EDCBF96BFF13FB23FD0BFC43FD6BF8DBFDCBF61BF7E3F763F77BFD13F14C0933F81BFDD3F8ABFA5BF953F083FA1BF39BF97BF1EBF64BF933F9BBFB6BF8A3F80BFEE3F63BF503F4EBFA23F9E3FD7BFA43FB23FA43F883FD53FD1BF9ABFE9BFD63FBFBF84BFC3BFE4BF0E3F8ABFABBFD8BF703F53BF863F99BFD5BFBC3F8ABFC53F8BBF403FB2BF4DBFCDBFE33FC9BF9E3F4DBFAC3FCF3FABBF94BF6F3F973FC43F6B3F503FB03F8D3F8FBF72BFCF3F5E3F8F3F48BFEEBF90BFDCBF67BF983F92BF903F853FB9BFC23EA1BF88BFCBBF57BFB53FA33F68BFBE3FDFBFAA3FAB3F5FBFDFBF62BE313F843F1A3F85BFD43FF5BF8FBF28BFDF3FC03F56BFC3BFC83F843FC1BF9B3FCD3FA4BFC8BF983FB6BFAA3FAABF95BFA5BF4D3F4C3FDFBF0FBFAA3F683FC83FDCBF6A3FDC3FB33FA73F953FC03FD4BFA83F9FBF7BBF983FCB3FB23FBFBF9FBFA63F9CBFE9BFE23FA53F27BFB5BF9D3FB73F9EBFEEBFD2BFB63E8C3F953F8B3F5F3FD2BFA23FCE3F9EBFA33FD5BF98BFBDBFBB3FA83FCF3F35BF2F3FAC3FC7BF983FD5BF9EBF7EBFA3BFDCBF62BF8A3F3BBF8D3F313F0CBFA1BF8A3FB4BFCCBF8FBF893FC0BFD43FA7BF4B3F913FB53FD33F223F953F8FBFF43ED83FF0BFC6BFB33F95BFA73FADBF09BFA8BFA7BF2A3FCC3FA0BFCCBF9B3FAB3F9D3F21BF863F9F3FB1BE9CBF91BF9DBFC13FB63FD63F12BFB83FC43FB7BFAD3F8FBFAE3FADBF933FBDBFA6BFA53F7F3FD03F29BF08BF183F0FC05A3F94BFD53FB13F223F773FC83F9F3F933F99BFBABF40BFB2BF97BF74BFAF3FB4BFD4BF8ABFA6BFD5BF903F30BF"> : tensor<20x20xbf16>
    return %0 : tensor<20x20xbf16>
  }
}
