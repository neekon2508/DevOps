# KMS

- KMS -> Customer managed keys -> Create key
- KMS -> Customer managed keys -> Choose key -> Edit automatic key rotation

```
# encryption
aws kms encrypt --key-id alias/tutorial --plaintext fileb://ExampleSecretFile.txt --output text --query CiphertextBlob --region eu-west-2 > ExampleSecretFileEncrypted.base64

# base64 decode for Linux
cat ExampleSecretFileEncrypted.base64 | base64 --decode > ExampleSecretFileEncrypted

# decryption

aws kms decrypt --ciphertext-blob fileb://ExampleSecretFileEncrypted --output text --query Plaintext > ExampleFileDecrypted.base64 | base64 --decode > ExampleFileDecrypted.txt

```
