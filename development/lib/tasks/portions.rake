namespace :db do
  desc "Create Portion Model"
  task portions: :environment do

    Portion.destroy_all

    20.times do |nested|
      portion = Portion.create do |portion|
        portion.drug = FFaker::Lorem.word
        portion.dose = FFaker::Lorem.word
        portion.instruction = FFaker::Lorem.word
      end
    end

    message = "==== Portions Created: 20 Portions ====\r"
    print "\n"
    print message
    $stdout.flush
    sleep 1
  end
end
