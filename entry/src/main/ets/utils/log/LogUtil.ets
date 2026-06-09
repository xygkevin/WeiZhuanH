/**
 * HarmonyOS ArkTS 日志工具类 - 严格类型版本
 * 基于 @ohos.hilog 封装，支持多级别日志、格式化输出、调用堆栈信息
 * 适配 HarmonyOS API 12+ 严格类型检查
 */

import { hilog } from '@kit.PerformanceAnalysisKit';

/**
 * 日志级别枚举
 */
export enum LogLevel {
  DEBUG = 0,
  INFO = 1,
  WARN = 2,
  ERROR = 3,
  FATAL = 4,
}

/**
 * 日志信息接口
 */
export interface LogInfo {
  level: LogLevel;
  tag: string;
  message: string;
  timestamp: number;
  stack: string | null;
}

/**
 * 日志参数类型 - 仅允许基本类型和对象
 */
export type LogParam = string | number | boolean | null | undefined | LogObject;

/**
 * 日志对象类型
 */
export interface LogObject {
  [key: string]: LogParam;
}

/**
 * 自定义处理器类型
 */
export type CustomLogHandler = (logInfo: LogInfo) => void;

/**
 * 日志配置接口
 */
export interface LogConfig {
  // 日志 domain（0-0xFFFF）
  domain: number;
  // 日志 tag 前缀
  tagPrefix: string;
  // 是否在开发环境启用
  enableDevLog: boolean;
  // 最小日志级别
  minLevel: LogLevel;
  // 是否显示堆栈信息
  showStack: boolean;
  // 是否显示日志分割线
  showDivider: boolean;
  // 自定义日志输出回调
  customHandler: CustomLogHandler | null;
}

/**
 * 颜色代码接口
 */
interface ColorMap {
  [key: number]: string;
}

/**
 * LogUtil 日志工具类 - 单例
 */
export class LogUtil {
  private static instance: LogUtil | null = null;

  private config: LogConfig = {
    domain: 0x0001,
    tagPrefix: 'HarmonyOS',
    enableDevLog: true,
    minLevel: LogLevel.DEBUG,
    showStack: false,
    showDivider: false,
    customHandler: null,
  };

  private readonly levelName: string[] = ['D', 'I', 'W', 'E', 'F'];

  private readonly levelColors: ColorMap = {
    [LogLevel.DEBUG]: '\x1b[36m', // Cyan
    [LogLevel.INFO]: '\x1b[32m', // Green
    [LogLevel.WARN]: '\x1b[33m', // Yellow
    [LogLevel.ERROR]: '\x1b[31m', // Red
    [LogLevel.FATAL]: '\x1b[35m', // Magenta
  };

  private readonly resetColor: string = '\x1b[0m';

  /**
   * 私有构造函数
   */
  private constructor(config: LogConfig | null) {
    if (config !== null) {
      this.config = { ...this.config, ...config };
    }
  }

  /**
   * 获取 LogUtil 单例实例
   */
  public static getInstance(config: LogConfig | null = null): LogUtil {
    if (LogUtil.instance === null) {
      LogUtil.instance = new LogUtil(config);
    }
    return LogUtil.instance;
  }

  /**
   * 初始化日志工具
   */
  public static init(config: LogConfig | null = null): void {
    LogUtil.getInstance(config);
  }

  /**
   * 获取格式化后的日期时间
   */
  private getFormattedTime(): string {
    const now: Date = new Date();
    const pad = (n: number): string => n.toString().padStart(2, '0');
    return `${pad(now.getHours())}:${pad(now.getMinutes())}:${pad(now.getSeconds())}.${now
      .getMilliseconds()
      .toString()
      .padStart(3, '0')}`;
  }

  /**
   * 获取调用堆栈信息
   */
  private getStackTrace(): string {
    const error: Error = new Error();
    const stack: string[] = (error.stack || '').split('\n');
    // 过滤掉日志工具类本身的栈信息
    const relevantStack: string[] = stack.slice(4).slice(0, 3); // 取相关的3层栈
    return relevantStack.join('\n');
  }

  /**
   * 将参数转换为字符串
   */
  private paramToString(param: LogParam): string {
    if (param === null || param === undefined) {
      return String(param);
    }
    if (typeof param === 'string') {
      return param;
    }
    if (typeof param === 'number' || typeof param === 'boolean') {
      return String(param);
    }
    // 对象类型
    try {
      return JSON.stringify(param);
    } catch (e) {
      return '[Object]';
    }
  }

  /**
   * 格式化日志消息
   */
  private formatMessage(message: string, args: LogParam[]): string {
    let formattedMsg: string = message;

    if (args.length > 0) {
      let argIndex: number = 0;
      formattedMsg = formattedMsg.replace(/%\{public\}[a-z]|%[a-z]/g, (): string => {
        if (argIndex < args.length) {
          const arg: LogParam = args[argIndex++];
          return this.paramToString(arg);
        }
        return '';
      });
    }

    return formattedMsg;
  }

  /**
   * 核心日志输出方法
   */
  private doLog(
    level: LogLevel,
    tag: string,
    message: string,
    args: LogParam[],
    error: Error | null = null
  ): void {
    // 检查日志级别
    if (level < this.config.minLevel) {
      return;
    }

    // 检查开发环境标志
    if (!this.config.enableDevLog) {
      return;
    }

    const fullTag: string = `${this.config.tagPrefix}/${tag}`;
    const formattedMsg: string = this.formatMessage(message, args);
    const timestamp: number = Date.now();

    // 构建日志信息对象
    const logInfo: LogInfo = {
      level,
      tag: fullTag,
      message: formattedMsg,
      timestamp,
      stack: this.config.showStack ? this.getStackTrace() : null,
    };

    // 调用自定义处理器
    if (this.config.customHandler !== null) {
      this.config.customHandler(logInfo);
    }

    // 输出到系统日志
    this.outputToSystemLog(level, fullTag, formattedMsg, error);

    // 输出到控制台（开发环境）
    this.outputToConsole(level, fullTag, logInfo);
  }

  /**
   * 输出到系统日志
   */
  private outputToSystemLog(
    level: LogLevel,
    tag: string,
    message: string,
    error: Error | null
  ): void {
    const msg: string = error !== null ? `${message}\n${error.message}` : message;

    try {
      switch (level) {
        case LogLevel.DEBUG:
          hilog.debug(this.config.domain, tag, '%{public}s', msg);
          break;
        case LogLevel.INFO:
          hilog.info(this.config.domain, tag, '%{public}s', msg);
          break;
        case LogLevel.WARN:
          hilog.warn(this.config.domain, tag, '%{public}s', msg);
          break;
        case LogLevel.ERROR:
          hilog.error(this.config.domain, tag, '%{public}s', msg);
          break;
        case LogLevel.FATAL:
          hilog.fatal(this.config.domain, tag, '%{public}s', msg);
          break;
        default:
          break;
      }
    } catch (e) {
      console.error('LogUtil: Failed to output to system log');
    }
  }

  /**
   * 输出到控制台
   */
  private outputToConsole(level: LogLevel, tag: string, logInfo: LogInfo): void {
    const time: string = this.getFormattedTime();
    const levelStr: string = this.levelName[level];
    const color: string = this.levelColors[level];

    let output: string = `${color}[${time}] [${levelStr}] [${tag}] ${logInfo.message}${this.resetColor}`;

    if (logInfo.stack !== null) {
      output += `\n  Stack:\n${logInfo.stack}`;
    }

    if (this.config.showDivider) {
      output = `\n${'='.repeat(80)}\n${output}\n${'='.repeat(80)}`;
    }

    // 根据级别选择输出方式
    if (level === LogLevel.ERROR || level === LogLevel.FATAL) {
      console.error(output);
    } else if (level === LogLevel.WARN) {
      console.warn(output);
    } else {
      console.log(output);
    }
  }

  /**
   * DEBUG 级别日志
   */
  public debug(tag: string, message: string, ...args: LogParam[]): void {
    this.doLog(LogLevel.DEBUG, tag, message, args, null);
  }

  /**
   * INFO 级别日志
   */
  public info(tag: string, message: string, ...args: LogParam[]): void {
    this.doLog(LogLevel.INFO, tag, message, args, null);
  }

  /**
   * WARN 级别日志
   */
  public warn(tag: string, message: string, ...args: LogParam[]): void {
    this.doLog(LogLevel.WARN, tag, message, args, null);
  }

  /**
   * ERROR 级别日志
   */
  public error(tag: string, message: string, error: Error | null = null, ...args: LogParam[]): void {
    if (error instanceof Error) {
      this.doLog(LogLevel.ERROR, tag, message, args, error);
    } else {
      this.doLog(LogLevel.ERROR, tag, message, args, null);
    }
  }

  /**
   * FATAL 级别日志
   */
  public fatal(tag: string, message: string, ...args: LogParam[]): void {
    this.doLog(LogLevel.FATAL, tag, message, args, null);
  }

  /**
   * 输出 JSON 格式的日志
   */
  public json(tag: string, obj: LogObject, level: LogLevel = LogLevel.DEBUG): void {
    try {
      const jsonStr: string = JSON.stringify(obj, null, 2);
      this.doLog(level, tag, `JSON: ${jsonStr}`, [], null);
    } catch (e) {
      this.doLog(LogLevel.WARN, tag, 'Failed to stringify object', [], null);
    }
  }

  /**
   * 输出 Map 格式的日志
   */
  public map(tag: string, map: Map<string, LogParam>, level: LogLevel = LogLevel.DEBUG): void {
    const entries: Array<[string, LogParam]> = Array.from(map.entries());
    const mapStr: string =
      `Map(${map.size}) { ` +
        entries
          .map(([k, v]: [string, LogParam]): string => `${k}: ${this.paramToString(v)}`)
          .join(', ') +
        ' }';
    this.doLog(level, tag, mapStr, [], null);
  }

  /**
   * 输出数组格式的日志
   */
  public array(tag: string, arr: LogParam[], level: LogLevel = LogLevel.DEBUG): void {
    const arrStr: string = `Array(${arr.length}) [${arr.map((item: LogParam): string => this.paramToString(item)).join(', ')}]`;
    this.doLog(level, tag, arrStr, [], null);
  }

  /**
   * 输出性能计时日志
   */
  public time(tag: string, label: string): void {
    this.info(tag, `[TIMER START] ${label}`);
  }

  /**
   * 结束性能计时
   */
  public timeEnd(tag: string, label: string): void {
    this.info(tag, `[TIMER END] ${label}`);
  }

  /**
   * 更新日志配置
   */
  public updateConfig(config: Partial<LogConfig>): void {
    this.config = { ...this.config, ...config };
  }

  /**
   * 获取当前配置
   */
  public getConfig(): LogConfig {
    return { ...this.config };
  }

  /**
   * 全局静态方法 - DEBUG
   */
  public static d(tag: string, message: string, ...args: LogParam[]): void {
    LogUtil.getInstance().debug(tag, message, ...args);
  }

  /**
   * 全局静态方法 - INFO
   */
  public static i(tag: string, message: string, ...args: LogParam[]): void {
    LogUtil.getInstance().info(tag, message, ...args);
  }

  /**
   * 全局静态方法 - WARN
   */
  public static w(tag: string, message: string, ...args: LogParam[]): void {
    LogUtil.getInstance().warn(tag, message, ...args);
  }

  /**
   * 全局静态方法 - ERROR
   */
  public static e(tag: string, message: string, error: Error | null = null, ...args: LogParam[]): void {
    LogUtil.getInstance().error(tag, message, error, ...args);
  }

  /**
   * 全局静态方法 - FATAL
   */
  public static f(tag: string, message: string, ...args: LogParam[]): void {
    LogUtil.getInstance().fatal(tag, message, ...args);
  }

  /**
   * 全局静态方法 - JSON
   */
  public static json(tag: string, obj: LogObject, level: LogLevel = LogLevel.DEBUG): void {
    LogUtil.getInstance().json(tag, obj, level);
  }

  /**
   * 全局静态方法 - Map
   */
  public static map(tag: string, map: Map<string, LogParam>, level: LogLevel = LogLevel.DEBUG): void {
    LogUtil.getInstance().map(tag, map, level);
  }

  /**
   * 全局静态方法 - Array
   */
  public static array(tag: string, arr: LogParam[], level: LogLevel = LogLevel.DEBUG): void {
    LogUtil.getInstance().array(tag, arr, level);
  }
}