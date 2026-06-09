/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : RcpError
 * @Author : KEVIN XU
 * @Time : 2026/5/29 16:09
 * @Description : 描述
 */

/**
 * RCP错误描述
 */
export class RcpError extends Error {
  /**
   * 错误码
   */
  code: number = -1
  /**
   * 错误原因
   */
  message: string = ''
  /**
   * 错误数据
   */
  data?: object | string | number | boolean | null

  /**
   * 构造方法
   * @param code 错误码
   * @param message 错误原因
   * @param data 错误数据
   */
  constructor(code: number, message: string, data?: object | string | number | boolean | null) {
    super(message)
    this.code = code
    this.message = message
    this.data = data
  }

  /**
   * 是否登录失效
   */
  public isAuthError(): boolean {
    return this.code === 401
  }

  /**
   * 是否服务器错误
   */
  public isServerError(): boolean {
    return this.code >= 500
  }

  /**
   * 转字符串
   */
  public toString(): string {
    return `RcpError:(code=${this.code}, message=${this.message})`
  }
}