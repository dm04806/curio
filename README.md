# Curio - 库里奥 [![repo dependency](https://david-dm.org/CuriousityChina/curio.png)](https://david-dm.org/CuriousityChina/curio)

微信公共号管理后台

## 基本架构

这是一个使用 [brunch](http://brunch.io/) 构建的 Web App 。
后端数据接口部分，分离在 [curio-api](https://github.com/CuriosityChina/curio-api) 。

需要使用 [gnode](https://github.com/TooTallNate/gnode)。


## 开始开发

```
npm install gnode -g
npm install brunch -g
npm install
make
```

同时，你还需要启动 curio-api 服务。


consts.js 里面写的默认配置本地域名是 `www.curio.com` ，所以你还需要在 nginx 里面配一下代理。
API需要挂在在 /api/ 目录下。

```nginx
    server {
      listen 80;
      server_name curio.com *.curio.com;
      root /Users/jesse/projects/curio/public/;

      index index.html;

      location /api/ {
        proxy_pass http://127.0.0.1:3301;
        proxy_set_header Host $http_host;
        proxy_set_header  X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      }

      try_files $uri @curio_www;

      location @curio_www {
        proxy_pass http://127.0.0.1:3333;
        proxy_set_header Host $http_host;
      }
    }
```

## 风格约定

1. js events 总是绑定到 `.to-xxx` 上，带语义的表单按钮除外
