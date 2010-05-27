def copy(ext, dest = ".")
  file = "signal-auth.#{ext}"
  src = File.join(File.dirname(__FILE__) , file)
  dest = File.join(Rails.root, "config", dest, file)

  FileUtils.cp src, dest
end

copy "yml"
copy "rb", "initializers"
