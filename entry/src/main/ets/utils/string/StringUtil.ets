/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : StringUtil
 * @Author : KEVIN XU
 * @Time : 2026/5/29 18:52
 * @Description : 描述
 */

export class StringUtil {
  public static isEmpty(value: string | undefined | null): boolean {
    if (!value) {
      return true
    }
    const trimStr = value.trim()
    if (trimStr.length === 0) {
      return true
    }
    if (trimStr === 'null' || trimStr === 'NULL' || trimStr === '<null>' || trimStr === '(null)') {
      return true
    }
    return false
  }

  public static isEmail(value?: string): boolean {
    if (value) {
      return false
    }
    return /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$/.test(value!)
  }

  public static isMobile(value?: string): boolean {
    if (!value) {
      return false
    }
    return /^1[3-9]\d{9}$/.test(value)
  }

  public static isUrl(value?: string): boolean {
    if (!value) {
      return false
    }
    return /^(https?:\/\/)(([\w-]+\.)+[\w-]+)(:\d+)?(\/.*)?$/.test(value)
  }

  public isIpV4(value?: string): boolean {
    if (!value) {
      return false
    }
    return /^(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}$/.test(value)
  }

  public isIpV6(value?: string): boolean {
    if (!value) {
      return false
    }
    return /^((?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|(?:[0-9a-fA-F]{1,4}:){1,7}:|:(?::[0-9a-fA-F]{1,4}){1,7}|(?:[0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4})$/.test(
      value)
  }

  public isIdCard(value?: string): boolean {
    if (!value) {
      return false
    }
    return /^[1-9]\d{5}(18|19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{3}[\dXx]$/.test(value)
  }

  public isNumber(value?: string): boolean {
    if (!value) {
      return false
    }
    return /^\d+$/.test(value)
  }

  public isBase64(value?: string): boolean {
    if (!value) {
      return false
    }
    return /^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/.test(value)
  }
}