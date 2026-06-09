/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : ConvertUtil
 * @Author : KEVIN XU
 * @Time : 2026/6/1 10:28
 * @Description : 描述
 */
import { util } from "@kit.ArkTS"

export class ConvertUtil {
  /**
   * UTF8编码器
   */
  private static readonly encoder = new util.TextEncoder()
  /**
   * UTF8解码器
   */
  private static readonly decoder = new util.TextDecoder()
  /**
   * base64编解码器
   */
  private static readonly base64Helper = new util.Base64Helper()

  /**
   * Uint8Array -> Hex
   */
  public static uint8ArrayToHex(value: Uint8Array, upperCase: boolean = false): string {
    let result = ''
    for (let i = 0; i < value.length; i++) {
      result += value[i].toString(16).padStart(2, '0')
    }
    return upperCase ? result.toUpperCase() : result
  }

  /**
   * Hex -> Uint8Array
   */
  public static hexToUint8Array(hex: string): Uint8Array {
    const cleanHex = hex.trim()
    if (cleanHex.length % 2 !== 0) {
      return new Uint8Array(0)
    }
    const result = new Uint8Array(cleanHex.length / 2)
    for (let i = 0; i < result.length; i++) {
      result[i] = parseInt(cleanHex.substring(i * 2, i * 2 + 2), 16)
    }
    return result
  }

  /**
   * String -> Hex
   */
  public static stringToHex(value: string): string {
    return ConvertUtil.uint8ArrayToHex(ConvertUtil.stringToUint8Array(value))
  }

  /**
   * Hex -> String
   */
  public static hexToString(hex: string): string {
    return ConvertUtil.uint8ArrayToString(ConvertUtil.hexToUint8Array(hex))
  }

  /**
   * String -> Uint8Array
   */
  public static stringToUint8Array(value: string): Uint8Array {
    return ConvertUtil.encoder.encodeInto(value)
  }

  /**
   * Uint8Array -> String
   */
  public static uint8ArrayToString(data: Uint8Array): string {
    return ConvertUtil.decoder.decodeToString(data)
  }

  /**
   * Base64 -> Uint8Array
   */
  public static base64ToUint8Array(base64: string): Uint8Array {
    return ConvertUtil.base64Helper.decodeSync(base64)
  }

  /**
   * Uint8Array -> Base64
   */
  public static uint8ArrayToBase64(data: Uint8Array): string {
    return ConvertUtil.base64Helper.encodeToStringSync(data)
  }

  /**
   * Base64 -> String
   */
  public static base64ToString(base64: string): string {
    return ConvertUtil.decoder.decodeToString(ConvertUtil.base64Helper.decodeSync(base64))
  }

  /**
   * String -> Base64
   */
  public static stringToBase64(value: string): string {
    return ConvertUtil.base64Helper.encodeToStringSync(ConvertUtil.encoder.encodeInto(value))
  }

  /**
   * Uint8Array判空
   */
  public static isEmptyUint8Array(data: Uint8Array | undefined | null): boolean {
    return !data || data.length === 0
  }

  /**
   * 深拷贝Uint8Array
   */
  public static deepCopyUint8Array(data: Uint8Array): Uint8Array {
    return new Uint8Array(data)
  }

  /**
   * 合并Uint8Array
   */
  public static concatUint8Array(values: Uint8Array[]): Uint8Array {
    let totalLength = 0
    for (const item of values) {
      totalLength += item.length
    }
    const result = new Uint8Array(totalLength)
    let offset = 0
    for (const item of values) {
      result.set(item, offset)
      offset += item.length
    }
    return result
  }
}