task :upload do
  on roles(:web) do |_host|
    execute "mkdir -p #{shared_path}/config" if test "[ ! -d #{shared_path}/config ]"
    upload!('config/master.key', "#{shared_path}/config/master.key")
  end
end
