// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = stablehlo.ceil %0 : tensor<20x20xf16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf16>, tensor<20x20xf16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0xB1BEEA3AAB3FEBC4FCC1A7C070C4714259C4B0BF9E39143956BB7641CBBFF61E4FC0A73B63C1163A0235493C9342943835C20CBF5CB2E5AB1E38F6BC1B304D343CBEBBB79CC784B4BD375834C4BFF9C07E3B65C1FCC34EC3D4C726C22CBD57BF2B46663621B8C9B7A5C3EDBE62C427C0E04032C0A147DE3F2ABC1D3C503E5D43213E46B69DC7CA40C8BE71BB7FBD844010C4D645B2C14DC0433868C03A44BF39DCC163AF4535F54003C24DC410BF8431B7BD8D43F335DCC413C34B402AC2AA42753CEA3CE0403D31DB42F0BBB3C2AE42CE44A7BB384099BC1CC2C8468CC772C2E93CDDC4D636E83BDAC1383BA83B27C0A0B939416E3AE842AF43DFAF1AC61ABD4F4251C5712CDDC3443598C15AC4B531B23EDB3EBF43B73EC539EFB852B408C10B389CC1843C12C1AE4139423938B1C57CC0A0416C340BC714BB30C431C0AFBB9DC4F34326BF413EB13EFBC34539BDC3C7C33E401343B33606C067B570C16146D2C30D3B293C3835CC3B1EC119BC00C4A8B07BC8D64192B5FB3498BDEA383FC2C8BFB2C04045C5424B4046BFF1C3A6C35744E7C05B3A983D5FC4DF420DC5AE4412C2EEBDD5BDC941A23921C554477A443F417940064030C40345D63E273BAEBDF7BC04BDE0382FB9633EE940643F30C0C44152C122BF3C35AAC22D3D7F45F8C376427E3A11B30933793694C46834CEBEEE3CBC3B40C1EA3FB0C27541B6C471C76F4321348EC4E7BE73C404C19AC0FC387EB66DC22040B8C586B4683CAB44F94021BC8C3E08C7401B7FB18040EFC506C5F63EFE2B33BE3EC55B41383DE3C1C1C40EBCD0C4F23BEF281941623C6CBEDF45C5B502BF82C318BB653C013D8CA19BC1A93F76C08DBD24C56335A74426C17A416724D23C3EBE46C0364013BCA945B54156C398C27EC446C257BAE74045BFFBB94BBC13C8EABF12C4A64059ABD23B17373FC20EA95BC62AB73D42C3C4663B90A9D6C2133B03381BBD67BBBE40B443874297376DC25742CDC61526EC3F39BB68C091C464BF3FC4AFC14C3CBCC47B3E92C5AB432BC419413EBC95440C3A0BC7764457B3EDC342341E3C1041A638143D68BC9A40713E8DB6B3B626C74FC399C7E0C2CEC3F33BBF41F34465C4E6C3C03C6245"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
  func.func private @expected() -> tensor<20x20xf16> {
    %0 = stablehlo.constant dense<"0x00BC003C004000C400C000C000C4004400C400BC003C003C0080004200BC003C00C0003C00C0003C003C00400044003C00C200BC00800080003C00BC003C003C00BC008000C70080003C003C00BC00C0003C00C000C200C200C700C200BC00BC0047003C0080008000C200BC00C400C0004200C00048004000BC0040004000440040008000C7004200BC008000BC004200C4004600C000C0003C00C00045003C00C00080003C004200C200C400BC003C00BC0044003C00C400C2004200C20044004000400042003C0044008000C2004400450080004200BC00C2004700C700C2004000C4003C003C00C0003C003C00C000800042003C00440044008000C600BC004400C5003C00C2003C00C000C4003C0040004000440040003C0080008000C0003C00C0004000C000420044003C00C500C00042003C00C7008000C400C0008000C4004400BC0040004000C2003C00C200C200420044003C00C0008000C0004700C2003C0040003C003C00C000BC00C4008000C800420080003C00BC003C00C200BC00C000460044004200BC00C200C2004500C0003C004000C4004400C5004500C200BC00BC0042003C00C50048004500420042004200C400460040003C00BC00BC00BC003C008000400042004000C0004200C000BC003C00C20040004600C20044003C0080003C003C00C4003C00BC0040003C00C0004000C2004200C400C70044003C00C400BC00C400C000C0003C008000C2004200C5008000400045004200BC004000C7003C0080004200C500C50040003C00BC00C50042004000C000C400BC00C4003C003C0042004000BC0046008000BC00C2008000400040008000C0004000C000BC00C5003C004500C00042003C004000BC00C0004200BC0046004200C200C200C400C20080004200BC008000BC00C800BC00C400420080003C003C00C2008000C60080004400C4003C008000C2003C003C00BC0080004200440044003C00C2004400C6003C0040008000C000C400BC00C400C0004000C4004000C5004400C4004200BC0045003C00C70045008000C2003C00400042003C004000BC004200400080008000C700C200C700C200C2003C0042004500C400C200400046"> : tensor<20x20xf16>
    return %0 : tensor<20x20xf16>
  }
}
