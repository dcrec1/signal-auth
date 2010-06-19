def copy(ext, dest = ".")
  file = file_name(ext)
  src = File.join(File.dirname(__FILE__) , file)
  dest = config_file(dest, file)

  FileUtils.cp src, dest
end

def config_file(folder, file)
  File.join(Rails.root, "config", folder, file)
end

def file_name(ext)
  "signal-auth.#{ext}"
end

def exists(ext)
  File.exists? config_file(".", file_name(ext))
end

copy "yml" unless exists 'yml'
copy "rb", "initializers"
