project('slaby-scripts', meson_version: '>= 1.1', version: '1.0')

if not get_option('non_python_skip')
  install_subdir('bin', install_dir : 'bin', strip_directory : true)
  install_subdir('data', install_dir : 'share/slaby-scripts', strip_directory : true)
  install_subdir('unit', install_dir : get_option('unitdir'), strip_directory : true)
endif

if not get_option('python_skip')
  subdir('python')
endif
