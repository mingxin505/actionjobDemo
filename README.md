## 版本信息
rails 5.1.4  
ruby 2.5.3  
其它组件版本见Gemfile.lock  
# 说明
activeJob 的demo.  
最后一次提交是把sneakers搞定了。  
上次提交是把sidekiq搞定了。  
搞明白发现没什么难度。  
没搞成的时候感觉好复杂。  
为了后来人吧。  
```
当拿到个正常运行的东西之后再反向理解，比没个成品正向理解深入些。
```
# 动因
想让rails能接收rabbitMQ的消息。  
找到了sneakers,以为它就是个rmq的消费框架。  
但是不想自己起线程，觉得这很不rails，于是  
找到了ActiveJob.  

# 原理

sneakers 是activejob的一个后端。对rails 来说和sidekiq一样(通过 jobClass.perform_later触发;回调给ActiveJob::Base的派生类)。  
一开始以为通过rabbitmq给sneakers监听的queue发消息就能触发回调。这刚好是我要的。  
一翻折腾之后发现，消息能发了。但是参数总是空数组。  
再几经折腾才明白，要发特定格式的消息才行。  
最终达到目的。  

# 注意  
请根据自己的需要调整相关参数。
账号密码没隐藏，非安全隐患。因为服务早不存在了。
