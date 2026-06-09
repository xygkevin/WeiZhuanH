/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : RcpUtil
 * @Author : KEVIN XU
 * @Time : 2026/5/29 16:09
 * @Description : 描述
 */
import url from "@ohos.url"
import rcp from "@hms.collaboration.rcp"
import { RcpResponse } from "./RcpResponse"
import { RcpOptions } from "./RcpOptions"
import { RcpConstants, RcpParams } from "./RcpConstants"
import { RcpError } from "./RcpError"
import { JSON, util } from "@kit.ArkTS"
import { emitter } from "@kit.BasicServicesKit"
import { RcpEventId } from "./RcpEventId"
import { RcpMethod } from "./RcpMethod"
import { AppUtil } from "../app/AppUtil"
import { LogUtil } from "../log/LogUtil"


/**
 * Rcp请求工具
 */
export class RcpUtil {
  /**
   * 单例
   */
  private static instance: RcpUtil = new RcpUtil()
  private rcpSession?: rcp.Session

  /**
   * 外部获取单例静态方法
   */
  public static shared() {
    let instance = RcpUtil.instance
    if (!instance.rcpSession) {
      try {
        let configuration: rcp.SessionConfiguration = {
          baseAddress: RcpConstants.BASE_URL_DEBUG,
          requestConfiguration: {
            tracing: {
              verbose: true,
              infoToCollect: {
                redirectCount: true
              },
              collectTimeInfo: true
            },
            transfer: {
              timeout: {
                connectMs: 60000,
                transferMs: 60000
              }
            }
          },
          interceptors: [
            // new RcpRequestInterceptor(),
            // new RcpResponseInterceptor(),
            new RcpLogInterceptor()
          ]
        }
        instance.rcpSession = rcp.createSession(configuration)
      } catch (err) {
        const error = err as BusinessError
        console.error(`RcpUtil 创建 rcp.Session 失败: ${error.message}`)
      }
    }
    return instance
  }

  public static async get<T = void>(path: string, params?: RcpParams): Promise<RcpResponse<T>> {
    let options = new RcpOptions()
    options.method = RcpMethod.GET
    options.params = params
    options.path = path
    return RcpUtil.fetchRequest<T>(options)
  }

  public static async post<T = void>(path: string, params?: RcpParams): Promise<RcpResponse<T>> {
    let options = new RcpOptions()
    options.method = RcpMethod.POST
    options.params = params
    options.path = path
    return RcpUtil.fetchRequest<T>(options)
  }

  public static async put<T = void>(path: string, params?: RcpParams): Promise<RcpResponse<T>> {
    let options = new RcpOptions()
    options.method = RcpMethod.PUT
    options.params = params
    options.path = path
    return RcpUtil.fetchRequest<T>(options)
  }

  public static async delete<T = void>(path: string, params?: RcpParams): Promise<RcpResponse<T>> {
    let options = new RcpOptions()
    options.method = RcpMethod.DELETE
    options.params = params
    options.path = path
    return RcpUtil.fetchRequest<T>(options)
  }

  public static async patch<T = void>(path: string, params?: RcpParams): Promise<RcpResponse<T>> {
    let options = new RcpOptions()
    options.method = RcpMethod.PATCH
    options.params = params
    options.path = path
    return RcpUtil.fetchRequest<T>(options)
  }

  public static async head<T = void>(path: string, params?: RcpParams): Promise<RcpResponse<T>> {
    let options = new RcpOptions()
    options.method = RcpMethod.HEAD
    options.params = params
    options.path = path
    return RcpUtil.fetchRequest<T>(options)
  }

  public static async fetchRequest<T = void>(options: RcpOptions): Promise<RcpResponse<T>> {
    let rcpSession = RcpUtil.shared().rcpSession
    if (!rcpSession) {
      throw new RcpError(-1, 'rcpSession 初始化失败')
    }
    if (!options.method || !options.path) {
      throw new RcpError(-1, '必要参数缺失')
    }
    try {
      let request: rcp.Request = await RcpUtil.buildRequest(options)
      let response = await rcpSession.fetch(request)
      let respJson = response.toJSON()
      if (respJson) {
        let respObject = respJson as RcpResponse<T>
        if (!respObject) {
          throw new RcpError(-1, '数据转换失败', respJson)
        }
        if (respObject.code !== 200) {
          if (respObject.code === 401) {
            emitter.emit(RcpEventId.UNAUTHORIZED, { data: { 'message': respObject.msg, 'code': respObject.code } })
          }
          throw new RcpError(respObject.code, respObject.msg, respJson)
        }
        return respObject
      } else {
        throw new RcpError(-1, '未获取响应数据或数据格式错误', response)
      }
    } catch (err) {
      const busErr = err as BusinessError
      if (busErr.code === 401) {
        emitter.emit(RcpEventId.UNAUTHORIZED, { data: { 'message': '认证失败', 'code': busErr.code } })
      }
      throw new RcpError(busErr.code, busErr.message, err)
    }
  }

  /**
   * 构建Rcp请求
   */
  private static async buildRequest(options: RcpOptions): Promise<rcp.Request> {
    try {
      let method = options.method
      let buildUrl = await RcpUtil.buildURL(options)
      let headers = await RcpUtil.buildHeaders(options)
      let content = await RcpUtil.buildContent(options)
      let configuration = await RcpUtil.buildConfiguration(options)
      let cookies = undefined
      let transferRange = undefined
      let request: rcp.Request = new rcp.Request(
        buildUrl,
        method,
        headers,
        content,
        cookies,
        transferRange,
        configuration
      )
      return request
    } catch (err) {
      let busErr = err as BusinessError
      throw new RcpError(busErr.code, busErr.message, busErr.stack) as Error
    }
  }

  /**
   * 构建请求连接
   */
  private static async buildURL(options: RcpOptions): Promise<rcp.URLOrString> {
    try {
      if (options.path!.startsWith('https://') || options.path!.startsWith('http://')) {
        return url.URL.parseURL(options.path)
      }
      let result = url.URL.parseURL(options.path, RcpConstants.BASE_URL_DEBUG)
      if (RcpConstants.BODY_METHODS.includes(options.method!)) {
        return result
      } else {
        if (options.params) {
          Object.keys(options.params).forEach((key: string) => {
            let value = options.params![key]
            if (typeof value === 'object') {
              value = JSON.stringify(value)
            } else {
              value = value.toString()
            }
            result.params.set(key, value)
          })
        }
        return result
      }
    } catch (err) {
      throw new Error(err)
    }
  }

  private static async buildHeaders(options: RcpOptions): Promise<rcp.RequestHeaders | undefined> {
    let headers: Record<string, string> = {}
    headers['content-type'] = 'application/json'
    headers['accept'] = 'application/json'
    headers['z-version'] = AppUtil.versionName()
    if (!options.skipAuth) {
      let token: string | undefined = ''
      if (!token) {
        throw new RcpError(401, '未登录')
      }
      headers['authorization'] = `Bearer ${token}`
      headers['z-token'] = `Bearer ${token}`
    }
    return headers
  }

  private static async buildContent(options: RcpOptions): Promise<rcp.RequestContent | undefined> {
    return options.params
  }

  private static async buildConfiguration(options: RcpOptions): Promise<rcp.Configuration | undefined> {
    let config: rcp.Configuration = {
      transfer: {
        timeout: {
          transferMs: options.timeout
        }
      }
    }
    return config
  }
}

/**
 * 请求参数拦截
 */
class RcpRequestInterceptor implements rcp.Interceptor {
  async intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    return next.handle(context)
  }
}

/**
 * 请求结果拦截
 */
class RcpResponseInterceptor implements rcp.Interceptor {
  async intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    const response = await next.handle(context);

    return response
  }
}

/**
 * 请求日志
 */
class RcpLogInterceptor implements rcp.Interceptor {
  async intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    // 1.记录请求信息
    // this.logRequest(context.request)
    LogUtil.logRcpRequest(context.request)
    // 2.调用下一个请求处理器
    const response = await next.handle(context);
    // 3.记录响应信息
    // this.logResponse(response)
    LogUtil.logRcpResponse(response)
    // 4.返回数据
    return response
  }

  private logRequest(request: rcp.Request) {
    const method = request.method;
    const url = request.url.href;
    const headers = request.headers;
    const body = request.content;

    console.info(`[请求] ${method} ${url}`);
    console.info(`[请求头] ${JSON.stringify(headers, null, 2)}`);

    if (body instanceof rcp.Form) {
      console.info(`[请求体] ${JSON.stringify(body, null, 2)}`);
    } else {
      console.info(`[请求体] ${body}`);
    }
  }

  private logResponse(response: rcp.Response) {
    const statusCode = response.statusCode;
    const headers = response.headers;
    const body = response.body;
    const time = response.timeInfo?.totalTimeMs

    console.info(`[响应] 状态码: ${statusCode}`);
    if (time) {
      console.info(`[耗时] ${time}ms`)
    }
    console.info(`[响应头] ${JSON.stringify(headers, null, 2)}`);
    if (body) {
      try {
        const uint8Array = new Uint8Array(body);
        // 将 ArrayBuffer 转换为字符串
        const decoder = new util.TextDecoder();
        const bodyString = decoder.decodeToString(uint8Array);
        // 尝试解析为 JSON
        console.log(`[响应头] ${JSON.stringify(JSON.parse(bodyString), null, 2)}`)

      } catch (error) {
        console.log(`[响应体] ${body}`);
      }
    }
  }
}