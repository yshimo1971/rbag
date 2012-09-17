define :replace do
    execute params[:name] do
        command "/bin/sed -i -e 's/#{params[:pattern]}/#{params[:replacement]}/g' #{params[:name]}" 
        not_if "/bin/grep #{params[:pattern]} #{params[:name]}"   
    end
end
