require 'redis'
require 'json'
class Task

  def redis()
    @redis ||= Redis.new
  end

  def token()
    @token ||= '0djlk3ldkl2'
  end

  def submit()
    status = {'status' => 'PENDING'}.to_json
    self.redis.set("job:#{self.token}",status)
    self.redis.rpush("jobs",self.token)
  end

  def status()
    status = JSON.load(self.redis.get("job:#{self.token}",'status'))
    # convert to hash

    if status.nil?
      raise Error('bad status')
    end


    case status['status']
    when nil
      puts "you got some nil stuff"
      raise Error('you have a nil status')
    when 'PENDING'
      return 0.0
    when 'RUNNING'
      return status['percent'] || 0.0
    when 'COMPLETE'
      self.tidyup(status)
      return 1.0
    end
  end

  def tidyup(status)
    # do something with the status
    
    # delete the item from redis
  end

end
