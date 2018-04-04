module Jmessage
  class User
    class << self
      # 注册单个用户
      def register(params)
        params = Array.new.push params
        Jmessage::Http.new.post('/v1/users/', params)
      end

      # 注册多用户
      def batch_register(params)
        Jmessage::Http.new.post('/v1/users/', params)
      end

      # 获取用户列表
      def user_list
        start = params[:start] || 0
        count = params[:count] || 10
        Jmessage::Http.new.get("/v1/users?start=#{start}&count=#{count}")
      end

      # 注册管理员
      def admin_register(params)
        Jmessage::Http.new.post('/v1/admins/', params)
      end

      # 获取管理员列表
      def admin_list(params = {})
        start = params[:start] || 0
        count = params[:count] || 10
        Jmessage::Http.new.get("/v1/admins?start=#{start}&count=#{count}")
      end

      # 获取用户信息
      def user_info(username)
        Jmessage::Http.new.get("/v1/users/#{username}")
      end

      # 更新用户信息
      def update_user_info(username, params)
        Jmessage::Http.new.put("/v1/users/#{username}", params)
      end

      # 用户在线状态查询
      def userstat(username)
        Jmessage::Http.new.get("/v1/users/#{username}/userstat")
      end

      # 批量用户在线查询
      def batch_userstat(params)
        Jmessage::Http.new.post('/v1/users/userstat', params)
      end

      # 修改密码
      def update_pwd(username)
        Jmessage::Http.new.put("/v1/users/#{username}/password", params)
      end

      # 删除用户
      def delete_user(username)
        Jmessage::Http.new.delete("/v1/users/#{username}")
      end

      # 批量删除用户
      def batch_delete_user(params)
        Jmessage::Http.new.delete("/v1/users/", params)
      end

      # 添加黑名单
      def add_black_list(username)
        Jmessage::Http.new.put("/v1/users/#{username}/blacklist", Array.new.push(username))
      end

      # 移除黑名单
      def remove_black_list(username)
        Jmessage::Http.new.delete("/v1/users/#{username}/blacklist", Array.new.push(username))
      end

      # 黑名单列表
      def black_list
        Jmessage::Http.new.get("/v1/users/#{username}/blacklist")
      end

      # 文件上传
      def upload_image(type, filename)
        Jmessage::Http.new.post("/v1/resource?type=#{type}", { image: filename }, true)
      end
    end
  end
end