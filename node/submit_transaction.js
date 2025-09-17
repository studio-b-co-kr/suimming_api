import { Ed25519Keypair } from '@mysten/sui.js/keypairs/ed25519'
import { decodeSuiPrivateKey } from '@mysten/sui.js/cryptography'
import { TransactionBlock } from '@mysten/sui.js/transactions'
import { SuiClient, getFullnodeUrl } from '@mysten/sui.js/client'

const [,, bookId, message, timestamp, privateKey, packageId] = process.argv

async function main() {
  const { schema, secretKey } = decodeSuiPrivateKey(privateKey);
  const keypair = Ed25519Keypair.fromSecretKey(secretKey)
  const client = new SuiClient({ url: getFullnodeUrl('testnet') })

  const tx = new TransactionBlock()
  tx.moveCall({
    target: `${packageId}::suimming_sui::submit_transaction`,
    arguments: [
      tx.object(bookId),
      tx.pure(message),
      tx.pure(timestamp)
    ]
  })

  const result = await client.signAndExecuteTransactionBlock({
    signer: keypair,
    transactionBlock: tx
  })

  console.log(JSON.stringify(result))
}

main().catch(err => {
  console.error('Failed:', err)
  process.exit(1)
})
