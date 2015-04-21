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


  if "x${package_dir}x" == 'xx' {
    $source_dir = 'C:\Windows\Temp'
    if $ensure == 'present' {
      download_file { "download-dotnet-${version}" :
        url                   => $url,
        destination_directory => $source_dir
      }
    } else {
      file { "C:/Windows/Temp/${exe}":
        ensure => absent
      }
    }
  } else {
    $source_dir = $package_dir
  }

  if $ensure == 'present' {
    # exec { "install-dotnet-${version}":
    #   path      => $::path,
    #   command   => "& \"${source_dir}\\${exe}\" /q /norestart",
    #   provider  => powershell,
    #   logoutput => true,
    #   unless    => "if ((Get-Item -LiteralPath \'${key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }"
    # }
    package { "dotnet-${version}":
      ensure          => installed,
      source          => "${source_dir}\\${exe}",
      install_options => ['/norestart'],
    }
  } else {
    # exec { "uninstall-dotnet-${version}":
    #   path      => $::path,
    #   command   => "& \"${source_dir}\\${exe}\" /x /q /norestart",
    #   provider  => powershell,
    #   logoutput => true,
    #   unless    => "if ((Get-Item -LiteralPath \'${key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }"
    # }
    package { "dotnet-${version}":
      ensure          => absent,
      source          => "${source_dir}\\${exe}",
      install_options => ['/norestart'],
    }
  }

}
