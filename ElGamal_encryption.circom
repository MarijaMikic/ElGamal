// ElGamal Encryption
include "../node_modules/circomlib/circuits/escalarmulany.circom";
include "../node_modules/circomlib/circuits/babyjub.circom";
include "../node_modules/circomlib/circuits/bitify.circom";

template ElGamalEncryption() {
// Message m maped on eliptic curve point M(m,y)
signal private input M[2];
// x random from (1,p)
signal private input x;
//public key of person B
signal input pubB[2];
// plaintext Me and X
signal output Me[2];
signal output X[2];

component xBits = Num2Bits(256);
xBits.in <== x;

// calculate x*G
component mulAny = EscalarMulAny(256);
mulAny.p[0] <== 995203441582195749578291179787384436505546430278305826713579947235728471134;
mulAny.p[1] <== 5472060717959818805561601436314318772137091100104008585924551046643952123905;
for (var i=0; i<256; i++) {
mulAny.e[i] <== xBits.out[i];
}
X[0] <== mulAny.out[0];
X[1] <== mulAny.out[1];
// calculate pub_B*x
component pubBx = EscalarMulAny(253);
for (var i = 0; i < 253; i ++) 
{
pubBx.e[i] <== xBits.out[i];
}
pubBx.p[0] <== pubB[0];
pubBx.p[1] <== pubB[1];

component EncryptedMessage = BabyAdd();
EncryptedMessage.x1 <== M[0];
EncryptedMessage.y1 <== M[1];
EncryptedMessage.x2 <== pubBx.out[0];
EncryptedMessage.y2 <== pubBx.out[1];
Me[0] <== EncryptedMessage.xout;
Me[1] <== EncryptedMessage.yout;
}