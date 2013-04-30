require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../support", __FILE__)

  def run_blacklight_generator
    say_status("warning", "GENERATING BL", :yellow)       

    generate 'blacklight', '--devise'
  end

  def run_hydra_head_generator
    say_status("warning", "GENERATING HH", :yellow)       

    generate 'hydra:head', '-f'
  end
  
  def run_migrations
    rake("db:migrate")
  end

  # Inject call to Hydra::Collections.add_routes in config/routes.rb
  def inject_routes
    insert_into_file "config/routes.rb", :after => '.draw do' do
      "\n  # Add Collections routes."
      "\n  mount Hydra::Collections::Engine => '/'"
    end
  end

  def copy_rspec_rake_task
    copy_file "lib/tasks/rspec.rake"
  end

  def copy_hydra_config
    copy_file "config/initializers/hydra_config.rb"
  end
  
  def delete_generated_noise
    remove_file("public/index.html")
    remove_file("spec/models/user_spec.rb")
  end
  
  def copy_view_overrides
    directory("app/views/catalog")
  end
end