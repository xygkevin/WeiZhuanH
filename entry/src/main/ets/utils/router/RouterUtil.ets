/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : RouterUtil
 * @Author : KEVIN XU
 * @Time : 2026/5/29 18:51
 * @Description : 描述
 */

/**
 * PUSH 参数
 */
export interface RouterPushOptions {
  name: string
  param?: Object
  onPop?: (info: PopInfo) => void
  animated?: boolean
}

/**
 * REPLACE参数
 */
export interface RouterReplaceOptions {
  name: string
  param?: Object
  animated?: boolean
}

/**
 * POP参数
 */
export interface RouterPopOptions {
  name?: string
  index?: number
  result?: Object
  animated?: boolean
}

export class RouterUtil {
  /**
   * 导航堆栈
   */
  static readonly navPathStack: NavPathStack = new NavPathStack()

  /**
   * 跳转
   */
  public static async push(options: RouterPushOptions) {
    try {
      if (options.onPop) {
        await RouterUtil.navPathStack.pushDestinationByName(options.name, options.param, options.onPop,
          options.animated)
      } else {
        await RouterUtil.navPathStack.pushDestinationByName(options.name, options.param, options.animated)
      }
      console.log(`路由 跳转 ${options.name} 成功`)
    } catch (err) {
      console.error(`路由 跳转 ${options.name} 失败: ${err}`)
    }
  }

  public static async replace(options: RouterReplaceOptions) {
    try {
      RouterUtil.navPathStack.replacePathByName(options.name, options.param, options.animated)
      console.log(`路由 替换 ${options.name} 成功`)
    } catch (err) {
      console.error(`路由 替换 ${options.name} 失败: ${err}`)
    }
  }

  /**
   * 返回
   */
  public static async pop(options: RouterPopOptions) {
    try {
      if (options.name) {
        if (options.result) {
          RouterUtil.navPathStack.popToName(options.name, options.result, options.animated)
        } else {
          RouterUtil.navPathStack.popToName(options.name, options.animated)
        }
      } else if (options.index !== undefined) {
        if (options.result) {
          RouterUtil.navPathStack.popToIndex(options.index, options.result, options.animated)
        } else {
          RouterUtil.navPathStack.popToIndex(options.index, options.animated)
        }
      } else {
        if (options.result) {
          RouterUtil.navPathStack.pop(options.result, options.animated)
        } else {
          RouterUtil.navPathStack.pop(options.animated)
        }
      }
      console.log(`路由 返回 ${options.name ?? ''} 成功`)
    } catch (err) {
      console.error(`路由 返回 ${options.name} 失败: ${err}`)
    }
  }
}