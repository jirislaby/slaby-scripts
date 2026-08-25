project('slaby-scripts', meson_version: '>= 1.1', version: '1.0')

python_installations = []
python_import = import('python')
foreach python : get_option('python_versions')
  python_installations += python_import.find_installation(python)
endforeach

install_subdir('bin', install_dir : 'bin', strip_directory : true)
install_subdir('data', install_dir : 'share/slaby-scripts', strip_directory : true)
install_subdir('unit', install_dir : get_option('unitdir'), strip_directory : true)

subdir('python')
