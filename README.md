# README

## Node script
When deploying to AWS, Node modules need to be installed.
`app/services/submit_sui_transaction` uses `node/submit_transaction.js` script, so during deploy run following command:

```
cd /path/to/your/rails/project/node
npm install
```
