/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : RcpConstants
 * @Author : KEVIN XU
 * @Time : 2026/5/29 16:41
 * @Description : 描述
 */
import { RcpMethod } from "./RcpMethod"

/**
 * Rcp请求常量定义
 */
export class RcpConstants {
  /**
   * 根地址: 测试环境
   */
  static readonly BASE_URL_DEBUG: string = ''
  /**
   * 根地址: 生产环境
   */
  static readonly BASE_URL_RELEASE: string = ''
  /**
   * 需要Query参数的方法
   */
  static readonly QUERY_METHODS: RcpMethod[] = [RcpMethod.GET, RcpMethod.HEAD, RcpMethod.OPTIONS, RcpMethod.DELETE]
  /**
   * 需要包含参数的方法
   */
  static readonly BODY_METHODS: RcpMethod[] = [RcpMethod.POST, RcpMethod.PUT, RcpMethod.PATCH]

}

/**
 * 参数
 */
export type RcpParams = Record<string, string | number | boolean | object>

/**
 * 请求头
 */
export type RcpHeaders = Record<string, string>