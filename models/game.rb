require 'json'

class Game < Sequel::Model
  plugin :validation_helpers
  def validate
    super
    email_regexp = /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
    validates_format email_regexp, :email
    validates_presence :firstname
  end

  def before_create
    self.token = (0...16).map { (65 + rand(26)).chr }.join
    self.created_at ||= Time.now

    FileUtils.mkdir_p self.rundir
    super
  end

  def adisk=(locations)
    @locations = locations
    File.open("#{self.rundir}/adisk.txt","w") do |f|
      @locations.each do |loc|
        f.write("#{loc['x']} #{loc['y']}\n")
      end
    end
  end

  def rundir()
    @rundir ||= File.absolute_path("tmp/#{self.token}")
    return @rundir
  end

  def bindir()
    @bindir ||= File.absolute_path("bin")
    @bindir
  end

  def pubdir()
    @pubdir ||= File.absolute_path("public/game/#{self.token}")
  end

  def run()
    # Fork off the processes
    fork do
      rundir = self.rundir
      bindir = self.bindir
      pubdir = self.pubdir

      Dir.chdir self.rundir

      FileUtils.mkdir_p "#{rundir}/data"

      ## run the fortran code
      puts "Starting the fortran"
      cmd = "#{bindir}/cfd"
      value = `#{cmd}`
      puts "Fortran returned. Response:"
      puts value

      cmd = "cp #{rundir}/data/power.txt #{rundir}/power.txt"
      value = `#{cmd}`

      cmd = "cp #{rundir}/data/parameters.json #{rundir}/parameters.json"
      value = `#{cmd}`

      ## run the python
      cmd = "python #{bindir}/plotdata.py latest"
      value = `#{cmd}`

      cmd = "mkdir -p #{pubdir}"
      value = `#{cmd}`

      cmd = "cp #{rundir}/data/plots/latest.png #{pubdir}/latest.png"
      value = `#{cmd}`
      
      ## run the python
      cmd = "python #{bindir}/plotdata.py"
      value = `#{cmd}`

      ## make the video
      cmd = "avconv -i ./data/plots/%05d.png -s hd720 -c:v libx264 ./data/result.mp4"
      value = `#{cmd}`

      cmd = "cp #{rundir}/data/result.mp4 #{rundir}/result.mp4"
      value = `#{cmd}`

      ## remove the directory
      FileUtils.rm_rf("#{rundir}/data")

    end
    return true
  end

  def parameters()
    if @parameters.nil?
      raw = ""
      
      fname1 = "#{self.rundir}/data/parameters.json"
      fname2 = "#{self.rundir}/parameters.json"
      if File.file?(fname1)
        File.open(fname1,'r') do |f|
          raw = f.read()
        end
      elsif File.file?(fname2)
        File.open(fname2,'r') do |f|
          raw = f.read()
        end
      end
      @parameters = JSON.parse(raw)
    end
    @parameters
  end


  def status()
    # Parse the pars

    # check how many fortran files have been created
    maxcode = 0
    if File.exist?("#{self.rundir}/data")
      Dir["#{self.rundir}/data/*.raw"].select do |f|
        if f=~/data\/([\d]*).raw/
          num = /data\/([\d]*).raw/.match(f)[1].to_i
          maxcode = num if num > maxcode
        end
      end

      maxplot = 0
      Dir["#{self.rundir}/data/plots/*.png"].select do |f|
        if f=~/plots\/([\d]*).png/
          num = /plots\/([\d]*).png/.match(f)[1].to_i
          maxplot = num if num > maxplot
        end
      end

      codeprogress = maxcode*1.0 / self.parameters["nts"]
      plotprogress = (maxplot+1)*10.0/ self.parameters["nts"]
      movieprogress = 0.0
    else
      codeprogress = 1.0
      plotprogress = 1.0
      movieprogress = 1.0
    end

    rhash ={:code => codeprogress,
           :plot => plotprogress,
           :movie => movieprogress}
  end

  def totalpower()
    if self.power.nil?
      powerfile = "#{self.rundir}/power.txt"
      tp = 0
      if File.file?(powerfile)
        File.foreach(powerfile).with_index do |line,line_num|
          num = line.nil? ? 0 : line.to_f
          tp = tp + num
        end
      end
      tp = tp*self.parameters["dt"]*10
      self.power = tp
      res = self.save()
      raise 'hell' if res == false
    end
    self.power
  end


end

