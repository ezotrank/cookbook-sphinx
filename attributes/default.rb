default[:sphinx][:version]      = '2.0.6-release'
default[:sphinx][:url]          = "http://sphinxsearch.com/files/sphinx-#{sphinx[:version]}.tar.gz"
default[:sphinx][:checksum]     = "de943c397efda706661b3a12e12e9f8cc8a03bf6c02c5a6ba967a06384feede2"

default[:sphinx][:configure_flags] = [
  "#{node[:sphinx][:use_mysql] ? '--with-mysql' : '--without-mysql'}",
  "#{node[:sphinx][:use_postgres] ? '--with-pgsql' : '--without-pgsql'}"
]


