defmodule Moonbeam do
  require Logger

  # https://github.com/moonbeam-foundation/moonbeam/blob/master/precompiles/call-permit/CallPermit.sol
  @default_endpoint "https://moonbeam-alpha.api.onfinality.io/public"
  @fallback "https://moonbase.unitedbloc.com"
  # @endpoint "https://rpc.api.moonbase.moonbeam.network"
  def endpoint() do
    case :persistent_term.get({__MODULE__, :endpoint}, nil) do
      nil ->
        endpoint = default_endpoint()
        :persistent_term.put({__MODULE__, :endpoint}, endpoint)
        endpoint

      endpoint ->
        endpoint
    end
  end

  def default_endpoint() do
    case System.get_env("MOONBEAM_ENDPOINT") do
      nil -> @default_endpoint
      endpoint -> endpoint
    end
  end

  def swap_endpoint() do
    if endpoint() == default_endpoint() do
      :persistent_term.put({__MODULE__, :endpoint}, @fallback)
    else
      :persistent_term.put({__MODULE__, :endpoint}, default_endpoint())
    end
  end

  def epoch() do
    0
  end

  def peak() do
    1000
  end

  def genesis_hash() do
    # https://moonbase.moonscan.io/block/0
    0x33638DDE636F9264B6472B9D976D58E757FE88BADAC53F204F3F530ECC5AACFA
  end

  def get_proof(address, keys, block \\ "latest") do
    # requires https://eips.ethereum.org/EIPS/eip-1186
    rpc!("eth_getProof", [address, keys, block])
  end

  def block_number() do
    rpc!("eth_blockNumber")
  end

  def get_block_by_number(block \\ "latest", with_transactions \\ false) do
    rpc!("eth_getBlockByNumber", [block, with_transactions])
  end

  def get_storage_at(address, slot, block \\ "latest") do
    rpc!("eth_getStorageAt", [address, slot, block])
  end

  def get_code(address, block \\ "latest") do
    rpc!("eth_getCode", [address, block])
  end

  def get_transaction_count(address, block \\ "latest") do
    rpc!("eth_getTransactionCount", [address, block])
  end

  def get_balance(address, block \\ "latest") do
    rpc!("eth_getBalance", [address, block])
  end

  def send_raw_transaction(tx) do
    case rpc("eth_sendRawTransaction", [tx]) do
      {:ok, tx_hash} -> tx_hash
      {:error, %{"code" => -32603, "message" => "already known"}} -> :already_known
      {:error, error} -> raise "RPC error: #{inspect(error)}"
    end
  end

  def gas_price() do
    rpc!("eth_gasPrice")
  end

  def rpc(method, params \\ []) do
    request = %{
      jsonrpc: "2.0",
      method: method,
      params: params,
      id: 1
    }

    case post(request) do
      %{"result" => result} -> {:ok, result}
      %{"error" => error} -> {:error, error}
    end
  end

  @dialyzer {:nowarn_function, post: 1, post: 2}
  defp post(request, retry \\ true) do
    url = endpoint()

    case HTTPoison.post(url, Poison.encode!(request), [
           {"Content-Type", "application/json"}
         ]) do
      {:ok, %{body: body}} ->
        case Poison.decode(body) do
          {:ok, response} ->
            response

          {:error, error} ->
            maybe_retry(
              retry,
              "Poison error: #{inspect(error)} @ #{url} in #{inspect(body)}",
              request
            )
        end

      {:error, error} ->
        maybe_retry(retry, "HTTPoison error: #{inspect(error)} @ #{url}", request)
    end
  end

  defp maybe_retry(retry, error, request) do
    if retry do
      Logger.error("#{error} swapping endpoint() once")
      swap_endpoint()
      post(request, false)
    else
      raise error
    end
  end

  def rpc!(method, params \\ []) do
    case rpc(method, params) do
      {:ok, result} -> result
      {:error, error} -> raise "RPC error: #{inspect(error)}"
    end
  end

  def call(to, from, data, block \\ "latest") do
    rpc("eth_call", [%{to: to, data: data, from: from}, block])
  end

  def call!(to, from, data, block \\ "latest") do
    {:ok, ret} = call(to, from, data, block)
    ret
  end

  def estimate_gas(to, data, block \\ "latest") do
    rpc!("eth_estimateGas", [%{to: to, data: data}, block])
  end

  def chain_id() do
    # Moonbase Alpha (0x507)
    1287
  end
end
