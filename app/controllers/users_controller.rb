class UsersController < ApplicationController
  before_action only: %i(edit update destroy) do check_user params[:id] end

  # def index
  #   binding.pry
  #   @users = $redis.hgetall("users")
  # end

  # def new
  # end

  # def create
  #   user = params[:user].to_json
  #   id = $redis.hlen("users")+1
  #   $redis.hset("users", "#{id}", user)
  #   redirect_to users_url
  # end

  # def edit
  #   user = JSON.parse($redis.hget("users", "#{params[:id]}"))
  # end

  # def update
  #   $redis.hset("users", "#{params[:id]}", params[:user].to_json)
  # end

  # def destroy
  #   $redis.hdel("users", "#{params[:id]}")
  # end
  def index
    users = $redis.zrange("users", 0, -1)
    @users = []
    users.each do |u|
      user = $redis.hgetall(u)
      user["id"] = u
      @users << user
    end
  end

  def new
  end

  def create
    user = params[:user]
    id = $redis.zcard("users") + 1
    $redis.hmset("#{id}", "name", user[:name], "email", user[:email],
      "age", user[:age])
    $redis.zadd("users", user[:age].to_i, "#{id}")
    redirect_to users_url
  end

  def edit
  end

  def update
    user = params[:user]
    $redis.hmset(params[:id], "name", user[:name], "email", user[:email],
      "age", user[:age])
  end

  def destroy
    $redis.del(params[:id])
    $redis.zrem("users", params[:id])
    redirect_to users_url
  end

  private

  def check_user id
    user = $redis.hgetall(id)
    return unless user.empty?
    #flash danger
  end
end
