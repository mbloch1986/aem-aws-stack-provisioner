File {
  backup => false,
}

class config_scheduled_jobs (
  $base_dir,
  $env_path                                  = $::cron_env_path,
  $https_proxy                               = $::cron_https_proxy,
  $cron_offline_compaction_snapshot_enable   = undef,
  $cron_offline_snapshot_enable              = undef,
  $cron_export_enable                        = undef,
  $cron_live_snapshot_enable                 = undef,
  $cron_export_hour                          = '2',
  $cron_export_minute                        = '0',
  $cron_export_weekday                       = '0-7',
  $cron_live_snapshot_hour                   = '*',
  $cron_live_snapshot_minute                 = '0',
  $cron_live_snapshot_weekday                = '0-7',
  $cron_offline_compaction_snapshot_hour          = '1',
  $cron_offline_compaction_snapshot_minute        = '15',
  $cron_offline_compaction_snapshot_weekday       = '1',
  $cron_offline_snapshot_hour                     = '1',
  $cron_offline_snapshot_minute                   = '15',
  $cron_offline_snapshot_weekday                  = '2-7',
) {

  if $cron_offline_snapshot_enable == 'true' {
    cron { 'stack-offline-snapshot':
      ensure      => present,
      command     => "cd ${base_dir}/aem-tools && ./stack-offline-snapshot.sh >/var/log/stack-offline-snapshot.log 2>&1",
      user        => 'root',
      hour        => $cron_offline_snapshot_hour,
      minute      => $cron_offline_snapshot_minute,
      weekday     => $cron_offline_snapshot_weekday,
      environment => ["PATH=${env_path}", "https_proxy=\"${https_proxy}\""],
    }
  } else {
    cron { 'stack-offline-snapshot':
      ensure      => absent,
      command     => "cd ${base_dir}/aem-tools && ./stack-offline-snapshot.sh >/var/log/stack-offline-snapshot.log 2>&1",
      user        => 'root',
      environment => ["PATH=${env_path}", "https_proxy=\"${https_proxy}\""]
    }
  }

  if $cron_offline_compaction_snapshot_enable == 'true' {
    cron { 'stack-offline-compaction-snapshot':
      ensure      => present,
      command     => "cd ${base_dir}/aem-tools && ./stack-offline-compaction-snapshot.sh >/var/log/stack-offline-compaction-snapshot.log 2>&1",
      user        => 'root',
      hour        => $cron_offline_compaction_snapshot_hour,
      minute      => $cron_offline_compaction_snapshot_minute,
      weekday     => $cron_offline_compaction_snapshot_weekday,
      environment => ["PATH=${env_path}", "https_proxy=\"${https_proxy}\""],
    }
  } else {
    cron { 'stack-offline-compaction-snapshot':
      ensure      => absent,
      command     => "cd ${base_dir}/aem-tools && ./stack-offline-compaction-snapshot.sh >/var/log/stack-offline-compaction-snapshot.log 2>&1",
      user        => 'root',
      environment => ["PATH=${env_path}", "https_proxy=\"${https_proxy}\""]
    }
  }

  if $cron_live_snapshot_enable == 'true' {
    cron { 'live-snapshot-backup':
      ensure      => present,
      command     => "${base_dir}/aem-tools/live-snapshot-backup.sh >>/var/log/live-snapshot-backup.log 2>&1",
      user        => 'root',
      hour        => $cron_live_snapshot_hour,
      minute      => $cron_live_snapshot_minute,
      weekday     => $cron_live_snapshot_weekday,
      environment => ["PATH=${env_path}", "https_proxy=\"${https_proxy}\""],
    }
  } else {
    cron { 'live-snapshot-backup':
    ensure      => absent,
    command     => "${base_dir}/aem-tools/live-snapshot-backup.sh >>/var/log/live-snapshot-backup.log 2>&1",
    user        => 'root',
    environment => ["PATH=${env_path}", "https_proxy=\"${https_proxy}\""]
    }
  }

  if $cron_export_enable == 'true' {
    cron { 'export-backups':
      ensure      => present,
      command     => "${base_dir}/aem-tools/export-backups.sh export-backups-descriptor.json >>/var/log/export-backups.log 2>&1",
      user        => 'root',
      hour        => $cron_export_hour,
      minute      => $cron_export_minute,
      weekday     => $cron_export_weekday,
      environment => ["PATH=${env_path}", "https_proxy=\"${https_proxy}\""],
    }
  } else {
    cron { 'export-backups':
      ensure      => absent,
      command     => "${base_dir}/aem-tools/export-backups.sh export-backups-descriptor.json >>/var/log/export-backups.log 2>&1",
      user        => 'root',
      environment => ["PATH=${env_path}", "https_proxy=\"${https_proxy}\""]
    }
  }
}

include config_scheduled_jobs
