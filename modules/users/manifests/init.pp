class users {
	user { 
		'appuser':
			ensure           => 'present',
			gid              => '10100',
			home             => '/home/appuser',
			uid              => '10100';
	}

	group {
	    'appgroup':
	            ensure  => present,
	            gid     => 10100;
	    }

	file {
		'/home/appuser':
			ensure	=> directory,
			owner	=> 'appuser',
			group	=> 'appgroup',
			mode	=> 750;
	}
}