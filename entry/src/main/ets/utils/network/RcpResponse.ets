/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : RcpResponse
 * @Author : KEVIN XU
 * @Time : 2026/5/29 16:09
 * @Description : 描述
 */

/**
 * Rcp响应结构
 */
export class RcpResponse<T = void> {
  code: number = 200
  msg: string = ''
  time: string = ''
  data?: T

  constructor(data?: Partial<RcpResponse<T>>) {
    if (data) {
      this.code = data.code ?? 200
      this.msg = data.msg ?? ''
      this.time = data.time ?? ''
      this.data = data.data
    }
  }
}