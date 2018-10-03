class app {
	user { 
		'appuser':
			ensure	=> 'present',
			gid	=> '10100',
			home	=> '/opt/appdir',
			shell	=> '/bin/false',
			uid	=> '10100';
	}

	group {
	    'appgroup':
			ensure	=> present,
			gid	=> 10100;
	}

	file {
		'/opt/appdir':
			ensure	=> directory,
			owner	=> 'appuser',
			group	=> 'appgroup',
			mode	=> 750;
	}

	file {
		'/opt/appdir/log':
			ensure	=> 'directory',
			owner	=> 'appuser',
			group	=> 'appgroup',
			mode	=> 750;
	}

	file {
		'/etc/logrotate.d/app-log-rotation.conf':
			ensure	=> 'file',
			owner	=> root,
			group	=> root,
			source	=> [ 'puppet:///modules/app/app-log-rotation.conf' ];
	}

	cron {
		'app_logrotate':
			command => '/usr/sbin/logrotate /etc/logrotate.d/app-log-rotation.conf',
			user	=> root,
			minute	=> '*/30',
			hour	=> '*';
	}
}
