Sprinkle::Installers::Source.extend Module.new do
  def custom_dir(dir)
    @custom_dir = dir
  end
  
  def base_dir
    if @custom_dir
      return @custom_dir
    elsif @source.split('/').last =~ /(.*)\.(tar\.gz|tgz|tar\.bz2|tb2)/
      return $1
    end
    raise "Unknown base path for source archive: #{@source}, please update code knowledge"
  end  
end  
Sprinkle::Installers::Gem.extend Module.new do
  def platform(platform=nil)
    @platform ||= platform
  end
  protected
    def install_sequence
      cmd = "gem install -y #{gem}"
      cmd << " --version '#{version}'" if version
      cmd << " --source #{source}" if source
      cmd << " --platform #{platform}" if platform
      cmd
    end
end