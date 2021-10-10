namespace :deploy do
  namespace :assets do
    Rake::Task['deploy:assets:precompile'].clear_actions

    desc 'Precompile assets locally and upload to servers'
    task :precompile do
      on roles(fetch(:assets_roles)) do
        # Local assets precompile
        run_locally do
          with rails_env: fetch(:rails_env) do
            execute 'rm -rf public/assets'
            execute 'rm -rf public/packs'
            execute 'bin/rake assets:precompile'
          end
        end

        # Upload to server
        within release_path do
          with rails_env: fetch(:rails_env) do
            old_manifest_path = "#{shared_path}/public/assets/manifest*"
            execute :rm, old_manifest_path if test "[ -f #{old_manifest_path} ]"
            upload!('./public/assets/', "#{shared_path}/public/", recursive: true)
          end
        end

        # Install yarn
        within release_path do
          execute "cd #{release_path} && yarn install"
        end

        # Build webpack
        with rails_env: fetch(:rails_env) do
          within release_path do
            execute "$HOME/.rbenv/shims/ruby #{release_path}/bin/webpack"
          end
        end
      end
    end
  end
end
