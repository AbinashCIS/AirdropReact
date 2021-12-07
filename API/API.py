import os
from pymerkle import MerkleTree, validateProof
from pymerkle.hashing import HashMachine
from fastapi import FastAPI
from fastapi.responses import Response, PlainTextResponse
from starlette.responses import HTMLResponse, RedirectResponse

app = FastAPI()


@app.get("/", response_class=RedirectResponse)
async def docs():
    return RedirectResponse(url="/docs")


@app.post("/make", response_class=PlainTextResponse)
async def makeTree(data: list):
    '''Make a Merkle tree based on data provided
       
       Args:
       - data: list [
        "0x09750ad360fdb7a2ee23669c4503c974d86d8694",
        "0xc915eC7f4CFD1C0A8Aba090F03BfaAb588aEF9B4",
        "0xecb6ffaC05D8b4660b99B475B359FE454c77D153"
    ]
        Returns: 
        - root of the Merkle Tree
    '''
    try:
        tree = MerkleTree()
        for i in data:
            tree.encryptRecord(i)
        try:
            filepath = os.path.abspath(os.path.join("Data"))
            if not os.path.exists(filepath):
                os.mkdir(filepath)
                await tree.export(f'{filepath}/backup.json')
            else:
                await tree.export(f'{filepath}/backup.json')
        except:
            pass
    except Exception:
        raise
    return PlainTextResponse(tree.rootHash, status_code=200)


@app.post("/verify", response_class=PlainTextResponse)
async def verify(addr: str):
    try:
        filepath = os.path.abspath(os.path.join("Data"))
        if os.path.exists(filepath):

            tree = await MerkleTree.loadFromFile(f'{filepath}/backup.json')
            hasher = HashMachine()
            checksum = hasher.hash(addr)
            challenge = {'checksum': checksum}
            merkle_proof = tree.merkleProof(challenge)
            flag = validateProof(merkle_proof)
            if flag:
                return PlainTextResponse(f"{addr} Exists in tree",
                                         status_code=200)
            else:
                return PlainTextResponse(f"{addr} Doesn't exist in tree",
                                         status_code=404)
        else:
            return ValueError("NO data found")
    except Exception:
        raise


@app.post("/transact", response_class=PlainTextResponse)
async def transact(addr: str, anount: float):
    try:
        filepath = os.path.abspath(os.path.join("Data"))
        if os.path.exists(filepath):

            tree = await MerkleTree.loadFromFile(f'{filepath}/backup.json')
            hasher = HashMachine()
            checksum = hasher.hash(addr)
            challenge = {'checksum': checksum}
            merkle_proof = tree.merkleProof(challenge)
            flag = validateProof(merkle_proof)
            if flag:

                return PlainTextResponse(f"{addr} Exists in tree",
                                         status_code=200)
            else:
                return PlainTextResponse(f"{addr} Doesn't exist in tree",
                                         status_code=404)
        else:
            return ValueError("NO data found")
    except Exception:
        raise
