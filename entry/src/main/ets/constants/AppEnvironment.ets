/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : AppEnvironment
 * @Author : KEVIN XU
 * @Time : 2026/6/1 14:37
 * @Description : 描述
 */

/**
 * 开发环境
 */
export enum AppEnv {
  /**
   * 开发
   */
  DEVELOPING = 'DEVELOPING',
  /**
   * 测试
   */
  DEBUG = 'DEBUG',
  /**
   * 发布
   */
  PRERELEASE = 'PRERELEASE',
  /**
   * 生产
   */
  PRODUCTION = 'PRODUCTION'
}

/**
 * 配置数据
 */
export class AppOptions {
  // 环境
  env: AppEnv = AppEnv.DEBUG
  // api地址
  api_host: string = ''
  // h5地址
  h5_host: string = ''

  constructor(env: AppEnv, api: string, h5: string) {
    this.env = env
    this.api_host = api
    this.h5_host = h5
  }
}


export class AppEnvironment {
  /**
   * 当前环境
   */
  static readonly env: AppEnv = AppEnv.DEVELOPING
  /**
   * 配置列表
   */
  private static readonly configs: Map<AppEnv, AppOptions> = new Map([
    [
      AppEnv.DEVELOPING,
      new AppOptions(
        AppEnv.DEBUG,
        'https://test-api.weizhuan365.com',
        'https://h5-test.weizhuan365.com'
      )
    ],
    [
      AppEnv.DEBUG,
      new AppOptions(
        AppEnv.DEBUG,
        'https://test-api.weizhuan365.com',
        'https://h5-test.weizhuan365.com'
      )
    ],
    [
      AppEnv.PRERELEASE,
      new AppOptions(
        AppEnv.DEBUG,
        'https://test-api.weizhuan365.com',
        'https://h5-test.weizhuan365.com'
      )
    ],
    [
      AppEnv.PRODUCTION,
      new AppOptions(
        AppEnv.DEBUG,
        'https://test-api.weizhuan365.com',
        'https://h5-test.weizhuan365.com'
      )
    ]
  ])

  /**
   * 环境描述
   */
  static getEnvDesc(env?: AppEnv): string {
    let currentEnv = env ?? AppEnvironment.env
    switch (currentEnv) {
      case AppEnv.DEVELOPING:
        return '开发环境';
      case AppEnv.DEBUG:
        return '测试环境';
      case AppEnv.PRERELEASE:
        return '预发布环境';
      case AppEnv.PRODUCTION:
        return '生产环境';
    }
  }

  /**
   * 获取当前API根地址
   */
  static getApiHost(env?: AppEnv): string {
    let options = AppEnvironment.configs.get(env ?? AppEnvironment.env)
    return options!.api_host
  }

  /**
   * 获取当前H5根地址
   */
  static getH5Host(env?: AppEnv): string {
    let options = AppEnvironment.configs.get(env ?? AppEnvironment.env)
    return options!.h5_host
  }

  /**
   * 是否是开发环境
   */
  static isDevelopingEnv(): boolean {
    return AppEnvironment.env === AppEnv.DEVELOPING
  }

  /**
   * 是否是测试环境
   */
  static isDebugEnv(): boolean {
    return AppEnvironment.env === AppEnv.DEBUG
  }

  /**
   * 是否是预发布环境
   */
  static isPreReleaseEnv(): boolean {
    return AppEnvironment.env === AppEnv.PRERELEASE
  }

  /**
   * 是否是生产环境
   */
  static isProductEnv(): boolean {
    return AppEnvironment.env === AppEnv.PRODUCTION
  }
}