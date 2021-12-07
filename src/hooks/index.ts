import { ethers } from "ethers";
import { Contract } from "@ethersproject/contracts";
import { useContractCall, useContractFunction } from "@usedapp/core";
import simpleContractAbi from "../abi/Airdrop.json";
import { ContractAddress } from "../contracts";

const simpleContractInterface = new ethers.utils.Interface(simpleContractAbi);
const contract = new Contract(ContractAddress, simpleContractInterface);

export function useCount() {
  const [count]: any = useContractCall({
    abi: simpleContractInterface,
    address: ContractAddress,
    method: "count",
    args: [],
  }) ?? [];
  return count;
}

export function useIncrement() {
  const { state, send } = useContractFunction(contract, "incrementCount", {});
  return { state, send };
}