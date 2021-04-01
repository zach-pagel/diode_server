# Diode Server
# Copyright 2021 Diode
# Licensed under the Diode License, Version 1.1
defmodule Contract.Fleet do
  @moduledoc """
    Wrapper for the FleetRegistry contract functions
    as needed by the tests
  """

  def deploy_new(operator, accountant) do
    Shell.constructor(
      Diode.miner(),
      deployment_code(),
      ["address", "address", "address"],
      [Diode.registry_address(), operator, accountant]
    )
  end

  @spec set_device_allowlist(any, any, boolean) :: Chain.Transaction.t()
  def set_device_allowlist(fleet \\ Diode.fleet_address(), address, bool) when is_boolean(bool) do
    Shell.transaction(
      Diode.miner(),
      fleet,
      "SetDeviceAllowlist",
      ["address", "bool"],
      [address, bool]
    )
  end

  @spec device_allowlisted?(any, any) :: boolean
  def device_allowlisted?(fleet \\ Diode.fleet_address(), address) do
    ret = call(fleet, "DeviceAllowlist", ["address"], [address], "latest")

    case :binary.decode_unsigned(ret) do
      1 -> true
      0 -> false
    end
  end

  def accountant(fleet \\ Diode.fleet_address()) do
    call(fleet, "Accountant", [], [], "latest")
    |> Hash.to_address()
  end

  def operator(fleet \\ Diode.fleet_address()) do
    call(fleet, "Operator", [], [], "latest")
    |> Hash.to_address()
  end

  defp call(fleet, name, types, values, blockRef) do
    {ret, _gas} = Shell.call(fleet, name, types, values, blockRef: blockRef)
    ret
  end

  def code() do
    "0x608060405234801561001057600080fd5b50600436106100885760003560e01c806350f171161161005b57806350f1711614610117578063570ca73514610151578063bcea317f14610159578063d90bd6511461016157610088565b8063205548a41461008d5780632dd07fbc146100bd5780633c5f7d46146100e15780634fb3ccc51461010f575b600080fd5b6100bb600480360360408110156100a357600080fd5b506001600160a01b0381351690602001351515610187565b005b6100c56101fb565b604080516001600160a01b039092168252519081900360200190f35b6100bb600480360360408110156100f757600080fd5b506001600160a01b038135169060200135151561020a565b6100c5610218565b61013d6004803603602081101561012d57600080fd5b50356001600160a01b0316610227565b604080519115158252519081900360200190f35b6100c561022d565b6100c561023c565b61013d6004803603602081101561017757600080fd5b50356001600160a01b031661024b565b6001546001600160a01b031633146101d05760405162461bcd60e51b815260040180806020018281038252602681526020018061025d6026913960400191505060405180910390fd5b6001600160a01b03919091166000908152600660205260409020805460ff1916911515919091179055565b6001546001600160a01b031690565b6102148282610187565b5050565b6002546001600160a01b031681565b50600190565b6001546001600160a01b031681565b6002546001600160a01b031690565b600061025682610227565b9291505056fe4f6e6c7920746865206f70657261746f722063616e2063616c6c2074686973206d6574686f64a264697066735822122028f75e16358c346eb903ac939a9c00e86c46612c54d1dc073719dcad326fcfcb64736f6c63430006050033"
    |> Base16.decode()
  end

  def deployment_code() do
    "0x60806040526040516103d13803806103d18339818101604052606081101561002657600080fd5b5080516020820151604090920151600080546001600160a01b038085166001600160a01b03199283161790925560018054838716908316179055600280549284169290911691909117905590919034156100ef57826001600160a01b031663534a2422345a90306040518463ffffffff1660e01b815260040180826001600160a01b03166001600160a01b031681526020019150506000604051808303818589803b1580156100d457600080fd5b5088f11580156100e8573d6000803e3d6000fd5b5050505050505b5050506102d0806101016000396000f3fe608060405234801561001057600080fd5b50600436106100885760003560e01c806350f171161161005b57806350f1711614610117578063570ca73514610151578063bcea317f14610159578063d90bd6511461016157610088565b8063205548a41461008d5780632dd07fbc146100bd5780633c5f7d46146100e15780634fb3ccc51461010f575b600080fd5b6100bb600480360360408110156100a357600080fd5b506001600160a01b0381351690602001351515610187565b005b6100c56101fb565b604080516001600160a01b039092168252519081900360200190f35b6100bb600480360360408110156100f757600080fd5b506001600160a01b038135169060200135151561020a565b6100c5610218565b61013d6004803603602081101561012d57600080fd5b50356001600160a01b0316610227565b604080519115158252519081900360200190f35b6100c5610245565b6100c5610254565b61013d6004803603602081101561017757600080fd5b50356001600160a01b0316610263565b6001546001600160a01b031633146101d05760405162461bcd60e51b81526004018080602001828103825260268152602001806102756026913960400191505060405180910390fd5b6001600160a01b03919091166000908152600660205260409020805460ff1916911515919091179055565b6001546001600160a01b031690565b6102148282610187565b5050565b6002546001600160a01b031681565b6001600160a01b031660009081526006602052604090205460ff1690565b6001546001600160a01b031681565b6002546001600160a01b031690565b600061026e82610227565b9291505056fe4f6e6c7920746865206f70657261746f722063616e2063616c6c2074686973206d6574686f64a2646970667358221220db75c3da48a73305c6dcbbbe1e070b9092ce3e58463f4d2f0f3fe7ad273e28da64736f6c63430006050033"
    |> Base16.decode()
  end
end
