project('slaby-scripts')

perllibdir = get_option('perllibdir')
if perllibdir == ''
  r = run_command('sh', '-c', 'eval `perl -V:installsitelib`; echo $installsitelib', check: true)
  perllibdir = r.stdout().strip()
endif

install_subdir('bin', install_dir : 'bin', strip_directory : true)
install_subdir('data', install_dir : 'share/slaby-scripts', strip_directory : true)
install_subdir('perl', install_dir : perllibdir, strip_directory : true)
