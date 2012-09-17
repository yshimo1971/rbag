define :client do
    filename = "01-" + params[:mac].gsub(":", "-")
    template "#{node.pxeroot}/#{filename}" do
        source "default.erb"
        owner "root"
        group "root"
        mode "0644"
        variables(
            :filename => filename
        )
    end

    template "/var/www/html/#{filename}.ks" do
        source "config.ks.erb"
        owner "apache"
        group "apache"
        mode "0644"
        variables(
            :hostname => params[:name],
            :password => params[:password]
        )
    end
end
