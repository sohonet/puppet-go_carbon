# == Resource: go_carbon::service
# == Description: Installs an upstart / systemd service definition.
define go_carbon::service(
  $service_name = $title,
  $service_ensure = 'running',
  $service_enable = true)
{
  file { "${::go_carbon::systemd_service_folder}/go-carbon_${service_name}.service":
    ensure  => $go_carbon::ensure,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/systemd.go-carbon.conf.erb")
  } ~>

  Exec['systemctl-daemon-reload']

  service { "go-carbon_${service_name}":
    ensure    => $service_ensure,
    enable    => $service_enable,
   provider  => systemd,
   subscribe => [ File["${go_carbon::systemd_service_folder}/go-carbon_${service_name}.service"], File["${go_carbon::config_dir}/${service_name}.conf"] ]
  }
}
