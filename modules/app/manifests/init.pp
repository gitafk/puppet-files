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
		'/opt/appdir/log/app.log':
			ensure	=> 'file',
			owner	=> 'appuser',
			group	=> 'appgroup',
			mode	=> 600;
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

	exec {
		command => dd if=/dev/zero of=/opt/appdir/log/app.log count=10240 bs=10240,
		provider => shell,
		onlyif	=> '/usr/bin/test -e /opt/appdir/log';
	}

}
