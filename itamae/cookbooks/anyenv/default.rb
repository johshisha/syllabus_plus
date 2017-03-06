execute 'apt-get update' do
  command 'apt-get update'
  command 'apt-get upgrade -y'
end

package "software-properties-common"
package "nginx"
package "git"
package "ruby2.2"
package "ruby-dev"
package "ruby2.2-dev"
package "gcc"
package "build-essential"
package "libmysqlclient-dev"
package "libssl-dev"
package "libreadline-dev"
