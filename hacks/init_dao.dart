import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dtim/application/chain/wetee/wetee.dart';
import 'package:dtim/application/chain/wetee/wetee_gen/types/sp_runtime/multiaddress/multi_address.dart';
import 'package:dtim/application/chain/wetee/wetee_gen/types/wetee_org/org_info.dart';
import 'package:polkadart/scale_codec.dart';

// ignore: constant_identifier_names
const DAO_ROOT_SEED = "gloom album notable jewel divorce never trouble lesson month neck sign harbor";

void main() async {
  final wetee = WeTEE.url('wss://xiaobai.asyou.me:30001');
  final chainAccount = await getSeedPhrase(seedStr: DAO_ROOT_SEED, name: '', password: '');
  await WeTEE.addKeyring(account: chainAccount, password: "");

  // 初始化资金
  final alicePair = await getFromUri(uri:'//Alice', name: '', password: '');
  await WeTEE.addKeyring(account: alicePair, password: "");
  final dest = const $MultiAddress().id(hex.decode(chainAccount.address.replaceAll("0x", "")));
  var tcall = wetee.tx.balances.transferKeepAlive(dest: dest, value: BigInt.from(1000000000000000000));
  await wetee.signAndSubmit(tcall, alicePair.address);

  sleep(const Duration(seconds: 7));

  print(chainAccount.meta["ss58Address"]);

  // 创建DAO
  var runcall = wetee.tx.weTEEMatrix.createNode(
    name: convertStringToUint8List("ProgrammingDAO"),
    bg: convertStringToUint8List(''),
    logo: convertStringToUint8List(''),
    img: convertStringToUint8List('https://wetee.app/static/web3/img/logo.png'),
    homeUrl: convertStringToUint8List('https://wetee.app/'),
    imApi: convertStringToUint8List('http://127.0.0.1:8008/'), // https://dtim-dock.gc.wetee.app/ 
    desc: convertStringToUint8List('For the freedom of programming'),
    purpose: convertStringToUint8List("For the freedom of programming"),
    metaData: convertStringToUint8List("{}"),
  );

  // 提交
  await wetee.signAndSubmit(runcall, chainAccount.address);

  sleep(const Duration(seconds: 7));
  
  final d = await wetee.query.weTEEOrg.daos(BigInt.from(5000));
  print(d!.id.toString());

  final orgs = (await wetee.queryMapList(module: 'WeteeOrg', storage: 'Daos')).map((b) {
    return OrgInfo.decode(ByteInput(b));
  }).toList();
  print(orgs);

  // 添加用户到项目
  // var rootAddress = await rustApi.addSeed(seed: DAO_ROOT_SEED);
  // var clientIndex = await rustApi.connect(url: "ws://127.0.0.1:9944");
  // rustApi.startClient(client: clientIndex).then((e) {}).catchError((e) {});

  // await Future.delayed(const Duration(seconds: 5));

  // print("Start INIT " + clientIndex.toString());
  // await rustApi.daoInitFromPair(client: clientIndex, address: rootAddress);
  // await rustApi.createDao(
  //   client: clientIndex,
  //   from: rootAddress,
  //   name: "ProgrammingDAO",
  //   purpose: "For the freedom of programming",
  //   metaData: "{}",
  //   bg: '',
  //   desc: 'For the freedom of programming',
  //   homeUrl: 'https://wetee.app/',
  //   imApi: 'https://im.tc.asyou.me/',
  //   img: 'https://wetee.app/static/web3/img/logo.png',
  //   logo: 'https://wetee.app/static/web3/img/icon.png',
  // );

  // // 初始化资产
  // await rustApi.createAsset(
  //   client: clientIndex,
  //   from: rootAddress,
  //   daoId: 5000,
  //   name: "TEST",
  //   decimals: 10000,
  //   totalSupply: 10000,
  //   symbol: 'T',
  // );

  // print("Project INIT");
  // await rustApi.createProject(
  //   from: rootAddress,
  //   client: clientIndex,
  //   daoId: 5000,
  //   name: "TEST",
  //   desc: "TEST",
  //   ext: const WithGovPs(
  //     runType: 2,
  //     amount: 100,
  //     member: MemberGroup(scope: 1, id: 0),
  //     periodIndex: 0,
  //   ),
  // );

  // print("INIT DONE");
  // exit(0);
}
// dui
// [143, 224, 218, 130, 216, 29, 255, 164, 125, 212, 95, 86, 168, 19, 136, 96, 56, 178, 125, 25, 144, 142, 115, 184, 122, 113, 48, 67, 68, 58, 75, 43, 136, 19, 0, 0, 0, 0, 0, 0]
// cuo
// [221, 1, 231, 241, 61, 218, 100, 204, 231, 45, 243, 241, 149, 0, 125, 244, 56, 178, 125, 25, 144, 142, 115, 184, 122, 113, 48, 67, 68, 58, 75, 43, 136, 19, 0, 0, 0, 0, 0, 0]

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  final Uint8List unit8List = Uint8List.fromList(codeUnits);

  return unit8List;
}

String convertUint8ListToString(Uint8List uint8list) {
  return String.fromCharCodes(uint8list);
}
