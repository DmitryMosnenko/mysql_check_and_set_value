define checkandset ($property, $value) {

$cmdTestProperty = "test `mysql -u ${openfire::params::mysqluser} -p${openfire::params::mysqlpass} -h ${openfire::params::mysqlhost} -sse 'select propValue from ${openfire::params::dbname}.ofProperty where name=\"$property\" ;'` = '$value'"

$cmdSetProperty = "mysql -u ${openfire::params::mysqluser} -p${openfire::params::mysqlpass} -h ${openfire::params::mysqlhost} -sse 'UPDATE ${openfire::params::dbname}.ofProperty SET propValue=\"$value\" WHERE name=\"$property\"'"

	exec { "test ${property}":
		path    	=> '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
		unless 		=> $cmdTestProperty,
		command 	=> $cmdSetProperty,
		notify 		=> Service["openfire"],
		logoutput 	=> true,
	}
}

class openfire::mysqlserver {

	# Create Database for openfire
	#
	exec { "create-openfire-db":
		path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
		command	=> "mysql -u ${openfire::params::mysqluser} -p${openfire::params::mysqlpass} -h ${openfire::params::mysqlhost} -e 'create database ${openfire::params::dbname}'",
		unless  => "mysql -u ${openfire::params::mysqluser} -p${openfire::params::mysqlpass} -h ${openfire::params::mysqlhost} -e 'use ${openfire::params::dbname}'",
		notify  => Service["openfire"],
		require => Class["mysql"],
	}

	# Import db structure content into openfire database
	#
	exec { "create-openfire-db-content":
		path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
		command	=>	"mysql -u ${openfire::params::mysqluser} -p${openfire::params::mysqlpass} -h ${openfire::params::mysqlhost} ${openfire::params::dbname} < /opt/openfire/resources/database/${openfire::params::openfiredbschema}",
		onlyif 	=>	"test -e /opt/openfire/resources/database/${openfire::params::openfiredbschema}",
		require => [ Class["mysql"], File["/opt/openfire/resources/database/${openfire::params::openfiredbschema}"], Exec["create-openfire-db"] ],
	}

	create_resources(checkandset, $openfire::params::neededproperties)

}
