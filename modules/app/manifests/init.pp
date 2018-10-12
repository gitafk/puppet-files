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
		'/opt/scripts':
			ensure	=> directory,
			owner	=> 'root',
			group	=> 'root',
			mode	=> 750;
	}

	file {
		'/opt/scripts/app-log-check.sh':
			ensure	=> 'file',
			owner	=> root,
			group	=> root,
			mode	=> 700,
			source	=> [ 'puppet:///modules/app/app-log-check.sh' ];
	}

	cron {
		'app_log_check':
			command => '/opt/scripts/app-log-check.sh >> /tmp/app-log-check.log 2>&1',
			user	=> root,
			minute	=> '*/30',
			hour	=> '*';
	}
}
