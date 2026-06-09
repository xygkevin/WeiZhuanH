/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : RcpOptions
 * @Author : KEVIN XU
 * @Time : 2026/5/29 16:11
 * @Description : 描述
 */
import { RcpHeaders, RcpParams } from "./RcpConstants"
import { RcpMethod } from "./RcpMethod"

/**
 * Rcp请求参数
 */
export class RcpOptions {
  /**
   * 请求路径
   */
  path: string = ''
  /**
   * 请求方式
   */
  method: RcpMethod = RcpMethod.GET
  /**
   * 请求头
   */
  headers?: RcpHeaders
  /**
   * 请求参数
   */
  params?: RcpParams
  /**
   * 请求超时
   */
  timeout?: number = 60000
  /**
   * 跳过登录认证
   */
  skipAuth?: boolean = false
  /**
   * 错误重试次数(默认0, 不重试)
   */
  retryCount?: number = 0
  /**
   * 是否打印日志
   */
  enableLog?: boolean = true
}