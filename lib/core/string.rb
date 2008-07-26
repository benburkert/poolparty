class String
  def hasherize(format=[])
    hash = {}
    i = 0
    self.split(%r{[\n|\t|\s| ]+}).collect {|a| a.strip}.each do |f|
      break unless format[i]
      unless f == "" || f.nil?
        hash[format[i]] = f
        i+=1
      end      
    end
    hash
  end
  def ^(h={})
    self.gsub(/:([\w]+)/) {h[$1.to_sym] if h.include?($1.to_sym)}
  end
  def arrayable
    self.strip.split(/\n/)
  end
  def runnable(quite=true)
    # map {|l| l << "#{" >/dev/null 2>/dev/null" if quite}" }.
    self.strip.split(/\n/).join(" && ")
  end
  def nice_runnable(quite=true)
    self.split(/ && /).join("\n")
  end
  def classify
    self.capitalize
  end
  def collect_each_line_with_index(&block)
    returning [] do |arr|
      arr << self.split(/\n/).collect_with_index(&block)
    end.flatten
  end
  def bucket_objects
    AWS::S3::Bucket.objects(self)
  end
  def bucket_object(key)
    AWS::S3::S3Object.value key, self if bucket_object_exists?(key)
  end
  def bucket_object_exists?(key)
    AWS::S3::S3Object.exists? key, self
  end
  def store_bucket_value(key, data)
    AWS::S3::S3Object.store key, data, self unless bucket_object_exists?(key)
  end
  def delete_bucket_value(key)
    AWS::S3::S3Object.delete(key, self) if bucket_object_exists?(key)
  end
  def bucket_exists?
    begin
      AWS::S3::Bucket.find(self)
      return true
    rescue
      return false
    end        
  end
  def delete_bucket
    AWS::S3::Bucket.delete(self, :force => true) if bucket_exists?
  end
end