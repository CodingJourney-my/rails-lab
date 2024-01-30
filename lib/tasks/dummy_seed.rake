namespace :db do
  namespace :seed do
    namespace :dummy do
      Dir[Rails.root.join('db', 'seeds', 'dummy', '**', '*.rb')].each do |filename|
        # task_name = File.basename(filename, '.rb')
        _, task_name = filename.sub(/\.rb$/, '').split('db/seeds/dummy/')
        if task_name.include?('/')
          ns, task_name = task_name.split('/')
          namespace ns.to_sym do
            desc "Seed " + task_name + ", based on the file with the same name in `db/seeds/dummy/#{ns}/*.rb`"
            task task_name.to_sym => :environment do
              load(filename) if File.exist?(filename)
            end
          end
        else
          desc "Seed " + task_name + ", based on the file with the same name in `db/seeds/dummy/*.rb`"
          task task_name.to_sym => :environment do
            load(filename) if File.exist?(filename)
          end
        end
      end
    end
  end
end
