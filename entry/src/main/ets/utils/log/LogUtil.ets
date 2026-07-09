import { hilog } from "@kit.PerformanceAnalysisKit"
import rcp from "@hms.collaboration.rcp"
import json from "@ohos.util.json"
import { JSON, util } from "@kit.ArkTS"


export enum LogLevel {
  DEBUG = 0,
  INFO = 1,
  WARN = 2,
  ERROR = 3,
  FATAL = 4
}

export class LogUtil {
  /**
   * 日志开关
   */
  private static enable: boolean = true
  /**
   * 日志等级
   */
  private static logLevel: LogLevel = LogLevel.DEBUG
  /**
   * DOMAIN
   */
  private static domain: number = 0x0001

  /**
   * 设置日志开关
   */
  static setEnable(value: boolean) {
    LogUtil.enable = value
  }

  /**
   * 设置Domain
   */
  static setDomain(value: number) {
    LogUtil.domain = value
  }

  /**
   * 设置日志等级
   */
  static setLogLevel(value: LogLevel) {
    LogUtil.logLevel = value
  }

  /**
   * DEBUG
   */
  static debug(tag: string, content: string) {
    LogUtil.doPrint(LogLevel.DEBUG, LogUtil.domain, tag, content)
  }

  /**
   * INFO
   */
  static info(tag: string, content: string) {
    LogUtil.doPrint(LogLevel.INFO, LogUtil.domain, tag, content)
  }

  /**
   * WARN
   */
  static warn(tag: string, content: string) {
    LogUtil.doPrint(LogLevel.WARN, LogUtil.domain, tag, content)
  }

  /**
   * ERROR
   */
  static error(tag: string, content: string) {
    LogUtil.doPrint(LogLevel.ERROR, LogUtil.domain, tag, content)
  }

  /**
   * FATAL
   */
  static fatal(tag: string, content: string) {
    LogUtil.doPrint(LogLevel.FATAL, LogUtil.domain, tag, content)
  }

  /**
   * 打印网络日志: 请求
   */
  static logRcpRequest(request: rcp.Request): void {
    try {
      const method: string = request.method
      const url: string = request.url.href
      const headers: rcp.RequestHeaders | undefined = request.headers
      const content: rcp.RequestContent | undefined = request.content
      let bodyText: string = ''

      if (content !== undefined) {
        if (content instanceof rcp.Form) {
          bodyText = JSON.stringify(content, null, 2)
        } else {
          bodyText = JSON.stringify(content, null, 2)
        }
      }

      const logContent: string =
        `[请求] ${method} ${url}\n` +
          `[请求头]\n${JSON.stringify(headers ??'', null, 2)}\n` +
          `[请求体]\n${bodyText}`

      LogUtil.info('RCP_REQUEST', logContent)
    } catch (err) {
      LogUtil.error('RCP_REQUEST', '打印请求日志失败')
    }
  }

  /**
   * 打印网络日志: 响应
   */
  static logRcpResponse(response: rcp.Response): void {
    try {
      const statusCode: number = response.statusCode
      const headers: rcp.ResponseHeaders = response.headers
      const body: ArrayBuffer | undefined = response.body
      let timeText: string = ''
      let bodyText: string = ''

      if (response.timeInfo !== undefined && response.timeInfo !== null) {
        timeText = `\n[耗时] ${response.timeInfo.totalTimeMs}ms`
      }

      if (body !== undefined && body !== null) {
        try {
          const uint8Array: Uint8Array = new Uint8Array(body)
          const decoder: util.TextDecoder = new util.TextDecoder()
          const bodyString: string = decoder.decodeToString(uint8Array)
          const jsonObject: Object | null = JSON.parse(bodyString)
          if (jsonObject !== null) {
            bodyText = JSON.stringify(jsonObject, null, 2)
          } else {
            bodyText = bodyString
          }
        } catch (err) {
          bodyText = `${body}`
        }
      }

      const logContent: string =
        `[响应] 状态码: ${statusCode}` +
          `${timeText}\n` +
          `[响应头]\n${JSON.stringify(headers, null, 2)}\n` +
          `[响应体]\n${bodyText}`

      LogUtil.info('RCP_RESPONSE', logContent)
    } catch (err) {
      LogUtil.error('RCP_RESPONSE', '打印响应日志失败')
    }
  }

  /**
   * 核心方法
   */
  private static doPrint(level: LogLevel, domain: number, tag: string, content: string) {
    if (!LogUtil.shouldPrint(level)) {
      return
    }
    let output = content
    try {
      switch (level) {
        case LogLevel.DEBUG: {
          hilog.debug(domain, tag, '%{public}s', output)
          break
        }
        case LogLevel.INFO: {
          hilog.info(domain, tag, '%{public}s', output)
          break
        }
        case LogLevel.WARN: {
          hilog.warn(domain, tag, '%{public}s', output)
          break
        }
        case LogLevel.ERROR: {
          hilog.error(domain, tag, '%{public}s', output)
          break
        }
        case LogLevel.FATAL: {
          hilog.fatal(domain, tag, '%{public}s', output)
          break
        }
        default: {
          console.error('日志等级错误');
        }
      }
    } catch (err) {
      console.error('LogUtil: 日志输出错误');
    }
  }

  /**
   * 判断
   */
  private static shouldPrint(level: LogLevel): boolean {
    if (!LogUtil.enable) {
      return false
    }
    if (level < LogUtil.logLevel) {
      return false
    }
    return true
  }
}