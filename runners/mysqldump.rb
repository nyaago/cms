# mysqldump でのバックアップを実行
# 
# ruby <this script> <user> <password> <database> <output path>
# 
  
require 'date'
cmds = ['/usr/bin/mysqldump', '/usr/local/mysql/bin/mysqldump','/usr/local/bin/mysqldump']
cmd = nil
cmds.each do |p|
  if File.exists?(p) then
    cmd = p
    break
  end
end
exit(-1) if cmd.nil? 
path = "#{ARGV[3]}/#{ARGV[2]}_#{DateTime.now.strftime('%w')}.dump"
output = File.open(path, "w")
puts "#{cmd} --user=#{ARGV[0]} --password=#{ARGV[1]} #{ARGV[2]} "
IO.popen("#{cmd} --user=#{ARGV[0]} --password=#{ARGV[1]} #{ARGV[2]} ", "r+") do |input|
  input.each { |line| 
    output.puts(line)
  }
end
output.close