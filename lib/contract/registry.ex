# Diode Server
# Copyright 2019 IoT Blockchain Technology Corporation LLC (IBTC)
# Licensed under the Diode License, Version 1.0
defmodule Contract.Registry do
  @moduledoc """
    Wrapper for the DiodeRegistry contract functions
    as needed by the inner workings of the chain
  """

  @spec miner_value(0 | 1 | 2 | 3, <<_::160>> | Wallet.t(), any()) :: non_neg_integer
  def miner_value(type, address, blockRef) when type >= 0 and type <= 3 do
    call("MinerValue", ["uint8", "address"], [type, address], blockRef)
    |> :binary.decode_unsigned()
  end

  @spec min_transaction_fee(any()) :: non_neg_integer
  def min_transaction_fee(blockRef) do
    call("MinTransactionFee", [], [], blockRef)
    |> :binary.decode_unsigned()
  end

  @spec epoch(any()) :: non_neg_integer
  def epoch(blockRef) do
    call("Epoch", [], [], blockRef)
    |> :binary.decode_unsigned()
  end

  @spec fee(any()) :: non_neg_integer
  def fee(blockRef) do
    call("Fee", [], [], blockRef)
    |> :binary.decode_unsigned()
  end

  @spec fee_pool(any()) :: non_neg_integer
  def fee_pool(blockRef) do
    call("FeePool", [], [], blockRef)
    |> :binary.decode_unsigned()
  end

  def submit_ticket_raw_tx(ticket) do
    Shell.transaction(Diode.miner(), Diode.registry_address(), "SubmitTicketRaw", ["bytes32[]"], [
      ticket
    ])
  end

  defp call(name, types, values, blockRef) do
    {ret, _gas} = Shell.call(Diode.registry_address(), name, types, values, blockRef: blockRef)
    ret
  end

  # This is the code for the test/dev variant of the registry contract
  # Imported on 31rd July 2020 from build/contracts/DiodeRegistry.json
  def test_code() do
    "0x6080604052600436106101355760003560e01c80638e0383a4116100ab578063c487e3f71161006f578063c487e3f71461032a578063c4a9e11614610332578063c76a117314610347578063cb106cf814610367578063f4b740161461037c578063f595416f146103a957610135565b80638e0383a41461028857806399ab110d146102b5578063b0128d92146102d5578063b540f894146102f5578063be3bb93c1461030a57610135565b8063534a2422116100fd578063534a2422146101de57806365c68de5146101f15780636f9874a41461021e5780637fca4a291461023357806383d8a80f146102535780638da085641461027357610135565b80630a938dff1461013a5780630ac168a1146101705780631b3b98c8146101875780631dd44706146101a757806345780f5f146101bc575b600080fd5b34801561014657600080fd5b5061015a610155366004612849565b6103be565b6040516101679190612dfd565b60405180910390f35b34801561017c57600080fd5b5061018561045e565b005b34801561019357600080fd5b506101856101a2366004612758565b6104cc565b3480156101b357600080fd5b506101856106ae565b3480156101c857600080fd5b506101d161081b565b6040516101679190612904565b6101856101ec366004612619565b61087e565b3480156101fd57600080fd5b5061021161020c3660046126dd565b6109de565b6040516101679190612d65565b34801561022a57600080fd5b5061015a610b7c565b34801561023f57600080fd5b5061018561024e366004612619565b610b94565b34801561025f57600080fd5b5061018561026e366004612828565b610dde565b34801561027f57600080fd5b5061015a610e4d565b34801561029457600080fd5b506102a86102a3366004612619565b610e53565b6040516101679190612cea565b3480156102c157600080fd5b506101856102d0366004612651565b610efe565b3480156102e157600080fd5b506101856102f0366004612740565b611041565b34801561030157600080fd5b5061015a611138565b34801561031657600080fd5b5061015a610325366004612849565b61113e565b610185611151565b34801561033e57600080fd5b5061015a61115b565b34801561035357600080fd5b50610185610362366004612715565b611161565b34801561037357600080fd5b5061015a6112c2565b34801561038857600080fd5b5061039c610397366004612619565b6112c8565b60405161016791906128f0565b3480156103b557600080fd5b5061015a6112e3565b600060ff83166103e0576103d96103d4836112e8565b611362565b9050610458565b8260ff16600114156103fd576103d96103f8836112e8565b611371565b8260ff166002141561041a576103d9610415836112e8565b611380565b8260ff1660031415610437576103d9610432836112e8565b61138f565b60405162461bcd60e51b815260040161044f90612a84565b60405180910390fd5b92915050565b33411480159061046d57504115155b80156104a25750336001600160a01b037f00000000000000000000000000000000000000000000000000000000000000001614155b156104bf5760405162461bcd60e51b815260040161044f90612bc8565b6104ca60008061139e565b565b864381106104ec5760405162461bcd60e51b815260040161044f90612c59565b84841761050b5760405162461bcd60e51b815260040161044f90612b70565b60408051600680825260e082019092526060916020820160c08036833701905050905088408160008151811061053d57fe5b6020026020010181815250506105528861087b565b8160018151811061055f57fe5b6020026020010181815250506105748761087b565b8160028151811061058157fe5b6020026020010181815250508560001b8160038151811061059e57fe5b6020026020010181815250508460001b816004815181106105bb57fe5b60200260200101818152505083816005815181106105d557fe5b602002602001018181525050600060016105ee83611607565b60408087015187516020808a0151845160008152909101938490526106139493612951565b6020604051602081039080840390855afa158015610635573d6000803e3d6000fd5b50505060206040510351905061064b8982611637565b6106588989838a8a6116f1565b806001600160a01b0316886001600160a01b03168a6001600160a01b03167fc21a4132cfb2e72d1dd6f45bcb2dabb1722a19b036c895975db93175b1c5c06f60405160405180910390a450505050505050505050565b336106b76124f1565b506001600160a01b0381166000908152600560208181526040808420815160a08101835281548184019081526001830154606080840191909152600284015460808401529082528351908101845260038301548152600483015481860152919094015491810191909152908201529061072f8261138f565b9050600081116107515760405162461bcd60e51b815260040161044f90612b9e565b610761828263ffffffff6118cc16565b6001600160a01b0384166000818152600560208181526040808420865180518255808401516001830155820151600282015595820151805160038801559182015160048701559081015194909101939093559151909183156108fc02918491818181858888f193505050501580156107dd573d6000803e3d6000fd5b5060405181906001600160a01b038516906000907f7f22ec7a37a3fa31352373081b22bb38e1e0abd2a05b181ee7138a360edd3e1a908290a4505050565b6060600a80548060200260200160405190810160405280929190818152602001828054801561087357602002820191906000526020600020905b81546001600160a01b03168152600190910190602001808311610855575b505050505090505b90565b8061088881611921565b6108a45760405162461bcd60e51b815260040161044f90612a4d565b6000816001600160a01b031663bcea317f6040518163ffffffff1660e01b815260040160206040518083038186803b1580156108df57600080fd5b505afa1580156108f3573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906109179190612635565b90506001600160a01b03811633146109415760405162461bcd60e51b815260040161044f906129a2565b61095a3461094e856112e8565b9063ffffffff61195d16565b6001600160a01b038416600081815260066020908152604080832085518051825580840151600180840191909155908301516002830155958301518051600383015592830151600482015591810151600590920191909155513493917fd859864511fd3f512da77fc95a8c013b3a0e49bdface8f574b2df8527cecea7191a4505050565b6109e6612516565b60006109f184611980565b6001600160a01b03841660009081526004820160205260409020600381015491925090610a1c612516565b6040518060800160405280876001600160a01b0316815260200184600101548152602001846002015481526020018367ffffffffffffffff81118015610a6157600080fd5b50604051908082528060200260200182016040528015610a9b57816020015b610a88612547565b815260200190600190039081610a805790505b509052905060005b82811015610b71576000846003018281548110610abc57fe5b6000918252602090912001546001600160a01b03169050610adb612571565b506001600160a01b03811660008181526004870160209081526040918290208251608081018452815460ff1615158152600182015481840152600282015481850190815260039092015460608083019182528551808201875296875292519386019390935291519284019290925290850151805191929185908110610b5c57fe5b60209081029190910101525050600101610aa3565b509695505050505050565b6000610b8f43600463ffffffff61199a16565b905090565b80610b9e81611921565b610bba5760405162461bcd60e51b815260040161044f90612a4d565b6000816001600160a01b031663bcea317f6040518163ffffffff1660e01b815260040160206040518083038186803b158015610bf557600080fd5b505afa158015610c09573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610c2d9190612635565b90506001600160a01b0381163314610c575760405162461bcd60e51b815260040161044f906129a2565b6000836001600160a01b031663bcea317f6040518163ffffffff1660e01b815260040160206040518083038186803b158015610c9257600080fd5b505afa158015610ca6573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610cca9190612635565b9050610cd46124f1565b610cdd856112e8565b90506000610cea8261138f565b905060008111610d0c5760405162461bcd60e51b815260040161044f90612b9e565b610d1c828263ffffffff6118cc16565b6001600160a01b038088166000908152600660209081526040808320855180518255808401516001830155820151600282015594820151805160038701559182015160048601559081015160059094019390935591519085169183156108fc02918491818181858888f19350505050158015610d9c573d6000803e3d6000fd5b5060405181906001600160a01b038816906001907f7f22ec7a37a3fa31352373081b22bb38e1e0abd2a05b181ee7138a360edd3e1a90600090a4505050505050565b334114801590610ded57504115155b8015610e225750336001600160a01b037f00000000000000000000000000000000000000000000000000000000000000001614155b15610e3f5760405162461bcd60e51b815260040161044f90612bc8565b610e49828261139e565b5050565b60075490565b610e5b612516565b6000610e6683611980565b90506040518060800160405280846001600160a01b03168152602001826001015481526020018260020154815260200182600301805480602002602001604051908101604052809291908181526020018280548015610eee57602002820191906000526020600020905b81546001600160a01b03168152600190910190602001808311610ed0575b5050505050815250915050919050565b801580610f0d57506009810615155b15610f2a5760405162461bcd60e51b815260040161044f906129e7565b60005b8181101561103c57610f3d61259b565b6040518060600160405280858585600601818110610f5757fe5b905060200201358152602001858585600701818110610f7257fe5b905060200201358152602001858585600801818110610f8d57fe5b905060200201358152509050611033848484600001818110610fab57fe5b9050602002013560001c610fd3868686600101818110610fc757fe5b9050602002013561087b565b610fe5878787600201818110610fc757fe5b878787600301818110610ff457fe5b9050602002013560001c88888860040181811061100d57fe5b9050602002013560001c89898960050181811061102657fe5b90506020020135876104cc565b50600901610f2d565b505050565b33600081815260056020818152604092839020835160a081018552815481860190815260018301546060808401919091526002840154608084015290825285519081018652600383015481526004830154818501529190930154938101939093528101919091526110b8908363ffffffff6119dc16565b6001600160a01b03821660008181526005602081815260408084208651805182558084015160018301558201516002820155958201518051600388015591820151600487015590810151949091019390935591518492907f81149c79fef0028ec92e02ee17f72b9bba024dce75220cba8d62f7bbcd0922b6908290a45050565b600d5490565b600061114a8383611a39565b9392505050565b6104ca3334611c4b565b60025481565b8161116b81611921565b6111875760405162461bcd60e51b815260040161044f90612a4d565b6000816001600160a01b031663bcea317f6040518163ffffffff1660e01b815260040160206040518083038186803b1580156111c257600080fd5b505afa1580156111d6573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906111fa9190612635565b90506001600160a01b03811633146112245760405162461bcd60e51b815260040161044f906129a2565b61123d83611231866112e8565b9063ffffffff6119dc16565b6001600160a01b038516600081815260066020908152604080832085518051825580840151600180840191909155908301516002830155958301518051600383015592830151600482015591810151600590920191909155518693917f81149c79fef0028ec92e02ee17f72b9bba024dce75220cba8d62f7bbcd0922b691a450505050565b60035481565b6004602052600090815260409020546001600160a01b031681565b600090565b6112f06124f1565b506001600160a01b0316600090815260066020908152604091829020825160a08101845281548185019081526001830154606080840191909152600284015460808401529082528451908101855260038301548152600483015481850152600590920154938201939093529082015290565b60006104588260000151611d4b565b60006104588260000151611d62565b60006104588260200151611d62565b60006104588260200151611d4b565b6113a6610b7c565b600754146113b6576113b6611d76565b600d5482028110156113da5760405162461bcd60e51b815260040161044f90612b28565b600c8054600a90830190810490819003909155670de0b6b3a76400000161140c4161140783612710611fd1565b61200b565b6001600160a01b037f0000000000000000000000000000000000000000000000000000000000000000166108fc61144a83600a63ffffffff61199a16565b6040518115909202916000818181858888f19350505050158015611472573d6000803e3d6000fd5b50506301312d0082106114975760405162461bcd60e51b815260040161044f90612c90565b6298968082106114d3576008600d54816114ad57fe5b04600d600082825401925050819055506064600d5410156114ce576064600d555b611506565b624c4b408211611506576008600d54816114e957fe5b600d8054929091049091039081905560641115611506576000600d555b60005b6008548110156115fa5760006008828154811061152257fe5b60009182526020808320909101546001600160a01b03168083526009909152604082205490925061155b9061271063ffffffff61199a16565b9050600061156a600084611a39565b905066038d7ea4c68000811015611585575066038d7ea4c680005b80821115611591578091505b81156115d8576115a183836120c0565b60405182906001600160a01b038516907fc083a1647e3ee591bf42b82564ffb4d16fdbb26068f0080da911c8d8300fd84a90600090a35b50506001600160a01b0316600090815260096020526040812055600101611509565b50610e49600860006125b9565b60008160405160200161161a919061286b565b604051602081830303815290604052805190602001209050919050565b60405163d90bd65160e01b815282906116eb906001600160a01b0383169063d90bd651906116699086906004016128f0565b60206040518083038186803b15801561168157600080fd5b505afa158015611695573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906116b991906126bd565b60405180604001604052806013815260200172556e726567697374657265642064657669636560681b81525084612195565b50505050565b60006116fc86611980565b805490915060ff1661175e578054600160ff1990911681178255600a805491820181556000527fc65a7bb8d6351c1cf70c95a316cc6a92839c986682d98bc35f958f4883f9d2a80180546001600160a01b0319166001600160a01b0388161790555b6001600160a01b03851660009081526004820160205260409020805460ff166117be578054600160ff199091168117825560038301805491820181556000908152602090200180546001600160a01b0319166001600160a01b0388161790555b6001600160a01b03851660009081526004820160205260409020805460ff1661181e578054600160ff199091168117825560038301805491820181556000908152602090200180546001600160a01b0319166001600160a01b0388161790555b8060020154851115611870576002810180549086905560018301549086039061184d908263ffffffff6121e416565b600180850191909155840154611869908263ffffffff6121e416565b6001850155505b80600301548411156118c2576003810180549085905560028301549085039061189f908263ffffffff6121e416565b6002808501919091558401546118bb908263ffffffff6121e416565b6002850155505b5050505050505050565b6118d46124f1565b816118e28460200151611d4b565b10156119005760405162461bcd60e51b815260040161044f90612cba565b6020830151611915908363ffffffff61220916565b60208401525090919050565b6000813f7fc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a47081811480159061195557508115155b949350505050565b6119656124f1565b8251611977908363ffffffff61225416565b83525090919050565b6001600160a01b03166000908152600b6020526040902090565b600061114a83836040518060400160405280601a81526020017f536166654d6174683a206469766973696f6e206279207a65726f0000000000008152506122d6565b6119e46124f1565b816119f28460000151611d4b565b1015611a105760405162461bcd60e51b815260040161044f90612c18565b8251611a22908363ffffffff61220916565b83526020830151611915908363ffffffff61225416565b600060ff8316611abc576001600160a01b038216600090815260056020818152604092839020835160a081018552815481860190815260018301546060808401919091526002840154608084015290825285519081018652600383015481526004830154818501529190930154938101939093528101919091526103d990611362565b8260ff1660011415611b41576001600160a01b038216600090815260056020818152604092839020835160a081018552815481860190815260018301546060808401919091526002840154608084015290825285519081018652600383015481526004830154818501529190930154938101939093528101919091526103d990611371565b8260ff1660021415611bc6576001600160a01b038216600090815260056020818152604092839020835160a081018552815481860190815260018301546060808401919091526002840154608084015290825285519081018652600383015481526004830154818501529190930154938101939093528101919091526103d990611380565b8260ff1660031415610437576001600160a01b038216600090815260056020818152604092839020835160a081018552815481860190815260018301546060808401919091526002840154608084015290825285519081018652600383015481526004830154818501529190930154938101939093528101919091526103d99061138f565b6001600160a01b038216600090815260056020818152604092839020835160a08101855281548186019081526001830154606080840191909152600284015460808401529082528551908101865260038301548152600483015481850152919093015493810193909352810191909152611ccb908263ffffffff61195d16565b6001600160a01b03831660008181526005602081815260408084208651805182558084015160018301558201516002820155958201518051600388015591820151600487015590810151949091019390935591518392907fd859864511fd3f512da77fc95a8c013b3a0e49bdface8f574b2df8527cecea71908290a45050565b6000611d58826000612254565b6040015192915050565b6000611d6f826000612254565b5192915050565b600080805b600a54811015611fb5576000600a8281548110611d9457fe5b60009182526020822001546001600160a01b03169150611db38261230d565b9050611dc681606463ffffffff61199a16565b93506000611dd383611980565b90506000611e04611df36104008460010154611fd190919063ffffffff16565b60028401549063ffffffff6121e416565b905060005b6003830154811015611f6657826003018181548110611e2457fe5b60009182526020808320909101546001600160a01b031680835260048601909152604082206001810154919a509190611e6990611df39061040063ffffffff611fd116565b9050611e9d84611e918b611e858561271063ffffffff611fd116565b9063ffffffff611fd116565b9063ffffffff61199a16565b9050611ea98a8261200b565b60005b6003830154811015611f1757826004016000846003018381548110611ecd57fe5b60009182526020808320909101546001600160a01b031683528201929092526040018120805460ff1916815560018181018390556002820183905560039091019190915501611eac565b506001600160a01b038a1660009081526004860160205260408120805460ff19168155600181018290556002810182905590611f5660038301826125b9565b505060019092019150611e099050565b506001600160a01b0384166000908152600b60205260408120805460ff19168155600181018290556002810182905590611fa360038301826125b9565b505060019094019350611d7b92505050565b611fc1600a60006125b9565b611fc9610b7c565b600755505050565b600082611fe057506000610458565b82820282848281611fed57fe5b041461114a5760405162461bcd60e51b815260040161044f90612ab0565b8015610e49576001600160a01b03821660009081526009602052604090205461207a57600880546001810182556000919091527ff3f7a9fe364faab93b216da50a3214154f22a0a2b415b23a84c8169e8b636ee30180546001600160a01b0319166001600160a01b0384161790555b6001600160a01b0382166000908152600960205260409020546120a3908263ffffffff6121e416565b6001600160a01b0383166000908152600960205260409020555050565b6001600160a01b038216600090815260056020818152604092839020835160a08101855281548186019081526001830154606080840191909152600284015460808401529082528551908101865260038301548152600483015481850152919093015493810193909352810191909152612140908263ffffffff61231b16565b6001600160a01b03909216600090815260056020818152604092839020855180518255808301516001830155840151600282015594810151805160038701559081015160048601559091015192019190915550565b60608361114a576060836121a884612346565b6040516020016121b99291906128a1565b60405160208183030381529060405290508060405162461bcd60e51b815260040161044f919061296f565b60008282018381101561114a5760405162461bcd60e51b815260040161044f90612a16565b6122116125da565b61221c836000612254565b905081816040015110156122425760405162461bcd60e51b815260040161044f90612af1565b60408101805192909203909152919050565b61225c6125da565b612265836124e2565b61229f576040805160608101825283815243602082015284518583015191928301916122969163ffffffff6121e416565b90529050610458565b6040805160608101909152835181906122be908563ffffffff6121e416565b81524360208201526040858101519101529050610458565b600081836122f75760405162461bcd60e51b815260040161044f919061296f565b50600083858161230357fe5b0495945050505050565b60006104586103d4836112e8565b6123236124f1565b825160400151612339908363ffffffff6121e416565b8351604001525090919050565b60408051602a808252606082810190935282919060208201818036833701905050905060008360601b9050600360fc1b8260008151811061238357fe5b60200101906001600160f81b031916908160001a905350600f60fb1b826001815181106123ac57fe5b60200101906001600160f81b031916908160001a90535060005b60148110156124d9576040518060400160405280601081526020016f181899199a1a9b1b9c1cb0b131b232b360811b815250601083836014811061240657fe5b1a8161240e57fe5b0460ff168151811061241c57fe5b602001015160f81c60f81b83826002026002018151811061243957fe5b60200101906001600160f81b031916908160001a9053506040518060400160405280601081526020016f181899199a1a9b1b9c1cb0b131b232b360811b815250601083836014811061248757fe5b1a8161248f57fe5b0660ff168151811061249d57fe5b602001015160f81c60f81b8382600202600301815181106124ba57fe5b60200101906001600160f81b031916908160001a9053506001016123c6565b50909392505050565b60200151600343919091031090565b60405180604001604052806125046125da565b81526020016125116125da565b905290565b604051806080016040528060006001600160a01b031681526020016000815260200160008152602001606081525090565b604051806060016040528060006001600160a01b0316815260200160008152602001600081525090565b60405180608001604052806000151581526020016000815260200160008152602001600081525090565b60405180606001604052806003906020820280368337509192915050565b50805460008255906000526020600020908101906125d791906125fb565b50565b60405180606001604052806000815260200160008152602001600081525090565b61087b91905b808211156126155760008155600101612601565b5090565b60006020828403121561262a578081fd5b813561114a81612e3e565b600060208284031215612646578081fd5b815161114a81612e3e565b60008060208385031215612663578081fd5b823567ffffffffffffffff8082111561267a578283fd5b81850186601f82011261268b578384fd5b803592508183111561269b578384fd5b86602080850283010111156126ae578384fd5b60200196919550909350505050565b6000602082840312156126ce578081fd5b8151801515811461114a578182fd5b600080604083850312156126ef578182fd5b82356126fa81612e3e565b9150602083013561270a81612e3e565b809150509250929050565b60008060408385031215612727578182fd5b823561273281612e3e565b946020939093013593505050565b600060208284031215612751578081fd5b5035919050565b600080600080600080600061012080898b031215612774578384fd5b883597506020808a013561278781612e3e565b975060408a013561279781612e3e565b965060608a0135955060808a0135945060a08a0135935060df8a018b136127bc578283fd5b6040516060810181811067ffffffffffffffff821117156127db578485fd5b6040528060c08c01848d018e10156127f1578586fd5b8594505b60038510156128145780358252600194909401939083019083016127f5565b505080935050505092959891949750929550565b6000806040838503121561283a578182fd5b50508035926020909101359150565b6000806040838503121561285b578182fd5b823560ff811681146126fa578283fd5b815160009082906020808601845b8381101561289557815185529382019390820190600101612879565b50929695505050505050565b600083516128b3818460208801612e12565b80830161040560f31b8152845191506128d3826002830160208801612e12565b818101602960f81b60028201526003810193505050509392505050565b6001600160a01b0391909116815260200190565b6020808252825182820181905260009190848201906040850190845b818110156129455783516001600160a01b031683529284019291840191600101612920565b50909695505050505050565b93845260ff9290921660208401526040830152606082015260800190565b600060208252825180602084015261298e816040850160208701612e12565b601f01601f19169190910160400192915050565b60208082526025908201527f4f6e6c792074686520666c656574206163636f756e74616e742063616e20646f604082015264207468697360d81b606082015260800190565b602080825260159082015274092dcecc2d8d2c840e8d2c6d6cae840d8cadccee8d605b1b604082015260600190565b6020808252601b908201527f536166654d6174683a206164646974696f6e206f766572666c6f770000000000604082015260600190565b6020808252601e908201527f496e76616c696420666c65657420636f6e747261637420616464726573730000604082015260600190565b602080825260129082015271155b9a185b991b195908185c99dd5b595b9d60721b604082015260600190565b60208082526021908201527f536166654d6174683a206d756c7469706c69636174696f6e206f766572666c6f6040820152607760f81b606082015260800190565b6020808252601b908201527f496e737566666963656e742066756e647320746f206465647563740000000000604082015260600190565b60208082526028908201527f41766572616765206761732070726963652062656c6f772063757272656e7420604082015267626173652066656560c01b606082015260800190565b602080825260149082015273496e76616c6964207469636b65742076616c756560601b604082015260600190565b60208082526010908201526f043616e277420776974686472617720360841b604082015260600190565b60208082526030908201527f4f6e6c7920746865206d696e6572206f662074686520626c6f636b2063616e2060408201526f18d85b1b081d1a1a5cc81b595d1a1bd960821b606082015260800190565b60208082526021908201527f43616e277420756e7374616b65206d6f7265207468616e206973207374616b656040820152601960fa1b606082015260800190565b60208082526017908201527f5469636b65742066726f6d20746865206675747572653f000000000000000000604082015260600190565b60208082526010908201526f426c6f636b20697320746f6f2062696760801b604082015260600190565b602080825260169082015275496e737566666963656e742066726565207374616b6560501b604082015260600190565b6000602080835260a0830160018060a01b03808651168386015282860151604086015260408601516060860152606086015160808087015282815180855260c08801915085830194508692505b80831015612d5957845184168252938501936001929092019190850190612d37565b50979650505050505050565b602080825282516001600160a01b031682820152828101516040808401919091528084015160608085019190915280850151608080860152805160a08601819052600094939184019285929160c08801905b80851015612df0578551612dcb8151612e06565b8352808801518884015284015184830152948601946001949094019390820190612db7565b5098975050505050505050565b90815260200190565b6001600160a01b031690565b60005b83811015612e2d578181015183820152602001612e15565b838111156116eb5750506000910152565b6001600160a01b03811681146125d757600080fdfea2646970667358221220427cf580096214680bae3b71ce8184b30a5fb216032b8128db8f2540ff31b1a164736f6c63430006050033"
    |> Base16.decode()
  end
end
