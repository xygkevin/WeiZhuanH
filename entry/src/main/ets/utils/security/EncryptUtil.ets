/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : EncryptUtil
 * @Author : KEVIN XU
 * @Time : 2026/5/29 18:52
 * @Description : 描述
 */
import cryptoFramework from "@ohos.security.cryptoFramework"
import util from "@ohos.util"
import { buffer } from "@kit.ArkTS";

/**
 * 加密工具
 */
export class EncryptUtil {
  private static stringToUint8Array(str: string): Uint8Array {
    return new util.TextEncoder().encodeInto(str)
  }


  private static uint8ArrayToHex(data: Uint8Array): string {
    let result = ''
    for (let i = 0; i < data.length; i++) {
      const hex = data[i].toString(16).padStart(2, '0')
      result += hex
    }
    return result
  }

  /**
   * MD5
   */
  public static async md5(plaintext: string): Promise<string> {
    return EncryptUtil.digest('MD5', plaintext)
  }

  /**
   * SHA256
   */
  public static async sha256(plaintext: string): Promise<string> {
    return EncryptUtil.digest('SHA256', plaintext)
  }

  /**
   * AES加密
   * @param plaintext 明文
   * @param key 秘钥
   * @param iv:偏移向量 有值CBC, 无值ECB
   */
  public static async aesEncrypt(plaintext: string, key: string, iv?: string): Promise<string> {
    try {
      const dataBlob: cryptoFramework.DataBlob = EncryptUtil.fetchAesDataBlob(plaintext)
      const ivSpec: cryptoFramework.IvParamsSpec = EncryptUtil.fetchAesIvParamsSpec(iv)
      const symKey = await EncryptUtil.fetchAesSymKey(key)
      const cipher = cryptoFramework.createCipher('AES256|CBC|PKCS5')
      await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, ivSpec)
      const encryptBlob = await cipher.doFinal(dataBlob)
      const base64Helper = new util.Base64Helper()
      return base64Helper.encodeToStringSync(encryptBlob.data).replace(/[\n\r]/g, '')
    } catch (err) {
      throw new Error(err)
    }
  }

  /**
   * AES解密
   * @param plaintext 明文
   * @param key 秘钥
   * @param iv:偏移向量 有值CBC, 无值ECB
   */
  public static async aesDecrypt(ciphertext: string, key: string, iv?: string): Promise<string> {
    try {
      const dataBlob: cryptoFramework.DataBlob = EncryptUtil.fetchAesBase64DataBlob(ciphertext)
      const ivSpec: cryptoFramework.IvParamsSpec = EncryptUtil.fetchAesIvParamsSpec(iv)
      const symKey = await EncryptUtil.fetchAesSymKey(key)
      const cipher = cryptoFramework.createCipher('AES256|CBC|PKCS5')
      await cipher.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, ivSpec)
      const decryptBlob = await cipher.doFinal(dataBlob)
      const textDecoder: util.TextDecoder = new util.TextDecoder()
      return textDecoder.decodeToString(decryptBlob.data)
    } catch (err) {
      throw new Error(err)
    }
  }

  /**
   * 创建 RSA 秘钥对
   * @param algName 算法(RSA1204 / RSA2048 / RSA4096)
   */
  static async createRsaKeyPair(algName: string): Promise<cryptoFramework.KeyPair> {
    try {
      let rsaGenerator = cryptoFramework.createAsyKeyGenerator(algName);
      return rsaGenerator.generateKeyPairSync()
    } catch (err) {
      throw new Error(err)
    }
  }

  /**
   * RSA 加密
   * @param plaintext 明文
   * @param publicKey 公钥(Base64编码)
   * @param algName 算法(RSA1204 / RSA2048 / RSA4096)
   * @returns 密文(Base64编码)
   */
  public static async rsaEncrypt(plaintext: string, publicKey: string): Promise<string> {
    try {
      // 1.明文处理
      let textEncoder = new util.TextEncoder()
      let data = textEncoder.encodeInto(plaintext)
      let dataBlob: cryptoFramework.DataBlob = { data }

      // 2.公钥
      let pubKey = await EncryptUtil.buildPublicKey(publicKey)

      // 3.创建加密器
      let cipher = cryptoFramework.createCipher(`RSA1024|PKCS1`);
      await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, pubKey, null);

      // 4.分段加密
      let keySize = 1024
      let splitLen = keySize / 8 - 11;
      let cipherText = new Uint8Array();
      for (let i = 0; i < dataBlob.data.length; i += splitLen) {
        let subText = dataBlob.data.subarray(i, i + splitLen);
        let subTextBlob: cryptoFramework.DataBlob = { data: subText };
        let updateOutput = await cipher.doFinal(subTextBlob);
        let mergeText = new Uint8Array(cipherText.length + updateOutput.data.length);
        mergeText.set(cipherText);
        mergeText.set(updateOutput.data, cipherText.length);
        cipherText = mergeText;
      }
      let cipherBlob: cryptoFramework.DataBlob = {
        data: cipherText
      };
      // 5.转为Base64字符串
      let base64Helper = new util.Base64Helper();
      return base64Helper.encodeToStringSync(cipherBlob.data);
    } catch (err) {
      throw new Error(err)
    }
  }

  /**
   * RSA 解密
   * @param ciphertext 密文(Base64编码)
   * @param privateKey 私钥(Base64编码)
   * @param algName 算法(RSA1204 / RSA2048 / RSA4096)
   * @returns 明文
   */
  public static async rsaDecrypt(ciphertext: string, privateKey: string): Promise<string> {
    try {
      let base64 = new util.Base64Helper();
      let decoded = base64.decodeSync(ciphertext, null);

      // 1.分段解密（分段长度=密钥长度/8，密文分段）
      let keySize = 1024
      let splitLen = keySize / 8;
      let plainBytes = new Uint8Array();
      let priKey = await EncryptUtil.buildPrivateKey(privateKey);
      let decoder = cryptoFramework.createCipher('RSA1024|PKCS1');
      await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, priKey, null);

      for (let i = 0; i < decoded.length; i += splitLen) {
        let subCipher = decoded.subarray(i, i + splitLen);
        let cipherData: cryptoFramework.DataBlob = { data: subCipher };
        let decryptOutput = await decoder.doFinal(cipherData);
        // 合并明文
        let mergeText = new Uint8Array(plainBytes.length + decryptOutput.data.length);
        mergeText.set(plainBytes);
        mergeText.set(decryptOutput.data, plainBytes.length);
        plainBytes = mergeText;
      }

      // 2.转明文字符串
      const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
      return textDecoder.decodeToString(plainBytes);
    } catch (err) {
      throw new Error(err)
    }
  }

  /**
   * RSA 公钥格式转换
   * @param key 公钥(Base64编码)
   * @param algName 算法(RSA1204 / RSA2048 / RSA4096)
   * @returns RSA公钥
   */
  private static async buildPublicKey(pubKeyStr: string): Promise<cryptoFramework.PubKey> {
    try {
      let base64Helper = new util.Base64Helper();
      let pubKeyBlob: cryptoFramework.DataBlob = { data: base64Helper.decodeSync(pubKeyStr) };
      let rsaGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
      let keyPair = await rsaGenerator.convertKey(pubKeyBlob, null);
      return keyPair.pubKey
    } catch (err) {
      throw new Error(err)
    }
  }

  /**
   * RSA 私钥格式转换
   * @param key 私钥(Base64编码)
   * @param algName 算法(RSA1204 / RSA2048 / RSA4096)
   * @returns RSA私钥
   */
  private static async buildPrivateKey(pubKeyStr: string): Promise<cryptoFramework.PriKey> {
    try {
      let base64Helper = new util.Base64Helper();
      let pubKeyBlob: cryptoFramework.DataBlob = { data: base64Helper.decodeSync(pubKeyStr) };
      let rsaGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
      let keyPair = await rsaGenerator.convertKey(pubKeyBlob, null);
      return keyPair.priKey
    } catch (err) {
      throw new Error(err)
    }
  }

  /**
   * 摘要
   * @param algorithm 算法: MD5、SM3、SHA256、SHA384、SHA512SHA1、SHA224
   * @param value 原始值
   */
  private static async digest(algorithm: string, value: string): Promise<string> {
    try {
      const data = EncryptUtil.stringToUint8Array(value)
      const md = cryptoFramework.createMd(algorithm)
      await md.update({ data: data })
      const result = await md.digest()
      return EncryptUtil.uint8ArrayToHex(result.data)
    } catch (err) {
      throw new Error(err)
    }
  }

  /**
   *
   * @param str
   * @returns
   */
  private static fetchAesDataBlob(str: string): cryptoFramework.DataBlob {
    const textEncoder: util.TextEncoder = new util.TextEncoder()
    const data = textEncoder.encodeInto(str)
    const dataBlob: cryptoFramework.DataBlob = {
      data: data
    }
    return dataBlob
  }

  /**
   * 获取 Base64 Data
   * @param str
   * @returns
   */
  private static fetchAesBase64DataBlob(str: string): cryptoFramework.DataBlob {
    const base64Helper = new util.Base64Helper()
    const data = base64Helper.decodeSync(str)
    const dataBlob: cryptoFramework.DataBlob = {
      data: data
    }
    return dataBlob
  }

  /**
   * 获取 IV Data
   * @param iv 偏移向量
   */
  private static fetchAesIvParamsSpec(iv?: string): cryptoFramework.IvParamsSpec {
    const textEncoder: util.TextEncoder = new util.TextEncoder()
    const ivData = iv ? textEncoder.encodeInto(iv) : new Uint8Array(16)
    const ivSpec: cryptoFramework.IvParamsSpec = {
      algName: 'IvParamsSpec',
      iv: { data: ivData }
    }
    return ivSpec
  }

  /**
   * 获取 AES SymKey
   * @param key 秘钥字符串
   */
  private static async fetchAesSymKey(key: string): Promise<cryptoFramework.SymKey> {
    try {
      const textEncoder: util.TextEncoder = new util.TextEncoder()
      const keyData = textEncoder.encodeInto(key)
      const keyBlob: cryptoFramework.DataBlob = {
        data: keyData
      }
      const symKeyGenerator = cryptoFramework.createSymKeyGenerator('AES256')
      return symKeyGenerator.convertKeySync(keyBlob)
    } catch (error) {
      throw new Error(`AES 解密秘钥创建错误:${error}`)
    }
  }
}