namespace :images do
  # ex: rails images:process[Post]
  task :process, [:model] => [:environnement] do |task, args|
    args[:model].constantize.find_each do |item|
      item.update(image: item.image[:original]) if item.image_attacher.stored?
    end
  end
end