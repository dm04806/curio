# Curio - 库里奥 [![repo dependency](https://david-dm.org/CuriousityChina/curio.png)](https://david-dm.org/CuriousityChina/curio)

微信公共号管理后台

## 基本架构

这是一个使用 [brunch](http://brunch.io/) 构建的 Web App 。
后端数据接口部分，分离在 [curio-api](https://github.com/CuriosityChina/curio-api) 。

需要 node 0.11.3 以上版本或者 [gnode](https://github.com/TooTallNate/gnode)。

## 开始开发

```
npm install brunch -g
npm install
make
```

同时，你还需要启动 curio-api 服务。


consts.js 里面写的默认配置本地域名是 `www.curio.com` ，所以你可能需要在 nginx 里面配一下代理。
