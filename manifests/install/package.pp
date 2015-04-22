#
define dotnet::install::package(
  $ensure = 'present',
  $version = '',
  $package_dir = ''
) {

  include dotnet::params

  $url = $dotnet::params::version[$version]['url']
  $exe = $dotnet::params::version[$version]['exe']
  $key = $dotnet::params::version[$version]['key']
  $packages = $dotnet::params::version[$version]['packages']


  if "x${package_dir}x" == 'xx' {
    $source_dir = 'C:\Windows\Temp'
    download_file { "download-dotnet-${version}" :
      url                   => $url,
      destination_directory => $source_dir
    }
  } else {
    $source_dir = $package_dir
  }

  # if $ensure == 'present' {
  #   package { "dotnet-${version}":
  #     ensure          => installed,
  #     source          => "${source_dir}\\${exe}",
  #     install_options => ['/norestart','/q'],
  #   }
  # } else {
  #   package { "dotnet-${version}":
  #     ensure            => absent,
  #     source            => "${source_dir}\\${exe}",
  #     uninstall_options => ['/norestart','/q','/x'],
  #   }
  # }
  $defaults = {
    ensure            => $ensure,
    source            => "${source_dir}\\${exe}",
    install_options   => ['/norestart','/q'],
    uninstall_options => ['/norestart','/q','/x'],
  }
  create_resources('package',$packages,$defaults)

  # package { $displayName :
  #   ensure            => $ensure,
  #   source            => "${source_dir}\\${exe}",
  #   install_options   => ['/norestart','/q'],
  #   uninstall_options => ['/norestart','/q','/x'],
  # }
}
